variable "version_control_system_access_token" {
  type      = string
  sensitive = true
}

variable "version_control_system_organization" {
  type = string
}

variable "template_folder_path" {
  type = string
}

variable "starter_module" {
  type = string
}

variable "ci_cd_module" {
  type = string
}

variable "starter_module_variables" {
  type = string
}

variable "azure_location" {
  type = string
}

variable "environment_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "postfix_number" {
  type = number
}

variable "resource_names" {
  type = map(string)
  default = {
    resource_group_state                                 = "rg-{{service_name}}-{{environment_name}}-state-{{azure_location}}-{{postfix_number}}"
    resource_group_identity                              = "rg-{{service_name}}-{{environment_name}}-identity-{{azure_location}}-{{postfix_number}}"
    resource_group_agents                                = "rg-{{service_name}}-{{environment_name}}-agents-{{azure_location}}-{{postfix_number}}"
    user_assigned_managed_identity                       = "id-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
    user_assigned_managed_identity_federated_credentials = "id-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
    storage_account                                      = "sto{{service_name}}{{environment_name}}{{azure_location_short}}{{postfix_number}}"
    storage_container                                    = "{{environment_name}}-tfstate"
    container_instance_01                                = "aci-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
    container_instance_02                                = "aci-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number_plus_one}}"
    agent_01                                             = "agent-{{service_name}}-{{environment_name}}-{{postfix_number}}"
    agent_02                                             = "agent-{{service_name}}-{{environment_name}}-{{postfix_number_plus_one}}"
    version_control_system_repository                    = "{{service_name}}-{{environment_name}}"
    version_control_system_service_connection            = "sc-{{service_name}}-{{environment_name}}"
    version_control_system_environment_plan              = "{{service_name}}-{{environment_name}}-plan"
    version_control_system_environment_apply             = "{{service_name}}-{{environment_name}}-apply"
    version_control_system_variable_group                = "{{service_name}}-{{environment_name}}"
    version_control_system_agent_pool                    = "{{service_name}}-{{environment_name}}"
  }
}

variable "azure_devops_use_organisation_legacy_url" {
  type = bool
}

variable "azure_devops_create_project" {
  type = bool
}

variable "azure_devops_project_name" {
  type = string
}

variable "azure_devops_authentication_scheme" {
  type = string
  validation {
    condition     = can(regex("^(ManagedServiceIdentity|WorkloadIdentityFederation)$", var.azure_devops_authentication_scheme))
    error_message = "azure_devops_authentication_scheme must be either ManagedServiceIdentity or WorkloadIdentityFederation"
  }
}

variable "agent_container_image" {
  type = string
}

variable "apply_approvers" {
  type = list(string)
}