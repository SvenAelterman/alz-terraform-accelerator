locals {
    pipelines = {
        ci = {
            name = "Azure Landing Zone Continuous Integration"
            yml_path = ".azuredevops/ci.yml"
        }
        cd = {
            name = "Azure Landing Zone Continuous Delivery"
            yml_path = ".azuredevops/cd.yml"
        }
    }
}

resource "azuredevops_build_definition" "alz" {
  for_each      = local.pipelines
  project_id = local.project_id
  name       = each.value.name

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.alz.id
    branch_name = azuredevops_git_repository.alz.default_branch
    yml_path    = each.value.yml_path
  }
}

resource "azuredevops_pipeline_authorization" "alz_environment" {
  for_each    = local.pipelines
  project_id  = local.project_id
  resource_id = azuredevops_environment.alz.id
  type        = "environment"
  pipeline_id = azuredevops_build_definition.alz[each.key].id
}

resource "azuredevops_pipeline_authorization" "alz_service_connection" {
  for_each    = local.pipelines
  project_id  = local.project_id
  resource_id = azuredevops_serviceendpoint_azurerm.alz.id
  type        = "endpoint"
  pipeline_id = azuredevops_build_definition.alz[each.key].id
}

resource "azuredevops_branch_policy_build_validation" "alz" {
  depends_on = [ azuredevops_git_repository_file.alz ]

  project_id = local.project_id

  enabled  = true
  blocking = true

  settings {
    display_name        = "Terraform validation policy with OpenID Connect"
    build_definition_id = azuredevops_build_definition.alz["ci"].id
    valid_duration      = 720

    scope {
      repository_id  = azuredevops_git_repository.alz.id
      repository_ref = azuredevops_git_repository.alz.default_branch
      match_type     = "Exact"
    }

    scope {
      match_type = "DefaultBranch"
    }
  }
}

