resource "azuredevops_environment" "alz_plan" {
  name       = var.environment_name_plan
  project_id = local.project_id
}

resource "azuredevops_environment" "alz_apply" {
  name       = var.environment_name_apply
  project_id = local.project_id
}

resource "azuredevops_check_approval" "alz" {
  project_id           = local.project_id
  target_resource_id   = azuredevops_environment.alz_apply.id
  target_resource_type = "environment"

  requester_can_approve = false
  approvers = [
    azuredevops_group.alz_approvers.origin_id
  ]

  timeout = 43200
}