
variable "adot_collector_name" {
  description = "ADOT collector name"
  type        = string
  default     = null
}

variable "adot_collector_namespace" {
  description = "ADOT collector namespace"
  type        = string
  default     = null
}

variable "managed_prometheus_workspace_endpoint" {
  description = "Managed Prometheus workspace endpoint"
  type        = string
  default     = null
}

variable "managed_prometheus_workspace_region" {
  description = "Managed Prometheus workspace region"
  type        = string
  default     = null
}
variable "adot_collector_policy_arns" {
  description = "List of IAM policy ARNs to attach to the ADOT collector service account."
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonPrometheusRemoteWriteAccess",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
  ]
}

variable "prometheus_config" {
  description = "Controls default values such as scrape interval, timeouts and ports globally"
  type = object({
    global_scrape_interval = optional(string, "120s")
    global_scrape_timeout  = optional(string, "15s")
  })

  default  = {}
  nullable = false
}
variable "adot_loglevel" {
  description = "Verbosity level for ADOT collector logs. This accepts (detailed|normal|basic), see https://aws-otel.github.io/docs/components/misc-exporters for more info."
  type        = string
  default     = "normal"
}
variable "adot_collector_service_account" {
  description = "ADOT Collector Service Account"
  type        = string
}
variable "enable_java" {
  description = "Enable Java workloads monitoring, alerting and default dashboards"
  type        = bool
  default     = false
}

variable "java_config" {
  description = "Configuration object for Java/JMX monitoring"
  type = object({
    enable_alerting_rules  = bool
    enable_recording_rules = bool
    enable_dashboards      = bool
    scrape_sample_limit    = number


    flux_gitrepository_name   = string
    flux_gitrepository_url    = string
    flux_gitrepository_branch = string
    flux_kustomization_name   = string
    flux_kustomization_path   = string

    grafana_dashboard_url = string

    prometheus_metrics_endpoint = string
  })

  # defaults are pre-computed in locals.tf, provide a full definition to override
  default = null
}
variable "enable_tracing" {
  description = "Enables tracing with OTLP traces receiver to X-Ray"
  type        = bool
  default     = false
}

variable "tracing_config" {
  description = "Configuration object for traces collection to AWS X-Ray"
  type = object({
    otlp_grpc_endpoint = optional(string, "0.0.0.0:4317")
    otlp_http_endpoint = optional(string, "0.0.0.0:4318")
    send_batch_size    = optional(number, 50)
    timeout            = optional(string, "30s")
  })

  default  = {}
  nullable = false
}
variable "enable_nginx" {
  description = "Enable NGINX workloads monitoring, alerting and default dashboards"
  type        = bool
  default     = false
}

variable "nginx_config" {
  description = "Configuration object for NGINX monitoring"
  type = object({
    enable_alerting_rules  = optional(bool)
    enable_recording_rules = optional(bool)
    enable_dashboards      = optional(bool)
    scrape_sample_limit    = optional(number)

    flux_gitrepository_name   = optional(string)
    flux_gitrepository_url    = optional(string)
    flux_gitrepository_branch = optional(string)
    flux_kustomization_name   = optional(string)
    flux_kustomization_path   = optional(string)

    grafana_dashboard_url = optional(string)

    prometheus_metrics_endpoint = optional(string)
  })

  # defaults are pre-computed in locals.tf
  default = {}
}
variable "enable_istio" {
  description = "Enable ISTIO workloads monitoring, alerting and default dashboards"
  type        = bool
  default     = false
}
variable "istio_config" {
  description = "Configuration object for ISTIO monitoring"
  type = object({
    enable_alerting_rules  = bool
    enable_recording_rules = bool
    enable_dashboards      = bool
    scrape_sample_limit    = number

    flux_gitrepository_name   = string
    flux_gitrepository_url    = string
    flux_gitrepository_branch = string
    flux_kustomization_name   = string
    flux_kustomization_path   = string

    managed_prometheus_workspace_id = string
    prometheus_metrics_endpoint     = string

    dashboards = object({
      cp          = string
      mesh        = string
      performance = string
      service     = string
    })
  })

  # defaults are pre-computed in locals.tf, provide a full definition to override
  default = null
}
variable "enable_adotcollector_metrics" {
  description = "Enables collection of ADOT collector metrics"
  type        = bool
  default     = true
}
variable "enable_nvidia_monitoring" {
  description = "Enables monitoring of nvidia metrics"
  type        = bool
  default     = false
}
variable "addon_context" {
  description = "Addon context"
  type = object({
    aws_caller_identity_account_id  = optional(string)
    aws_caller_identity_arn         = optional(string)
    aws_eks_cluster_endpoint        = optional(string)
    aws_partition_id                = optional(string)
    aws_region_name                 = optional(string)
    eks_cluster_id                  = optional(string)
    eks_oidc_issuer_url             = optional(string)
    eks_oidc_provider_arn           = optional(string)
    tags                            = optional(map(string))
    irsa_iam_role_path              = optional(string)
    irsa_iam_permissions_boundary   = optional(string)
  })
  
}

variable "adot_service_telemetry_loglevel" {
  description = "Verbosity level for ADOT service telemetry logs. See https://opentelemetry.io/docs/collector/configuration/#telemetry for more info."
  type        = string
  default     = "INFO"
}
variable "enable_custom_metrics" {
  description = "Allows additional metrics collection for config elements in the `custom_metrics_config` config object. Automatic dashboards are not included"
  type        = bool
  default     = false
}

variable "custom_metrics_config" {
  description = "Configuration object to enable custom metrics collection"
  type = map(object({
    enableBasicAuth       = bool
    path                  = string
    basicAuthUsername     = string
    basicAuthPassword     = string
    ports                 = string
    droppedSeriesPrefixes = string
  }))

  default = null
}
variable "enable_apiserver_monitoring" {
  description = "Enable EKS kube-apiserver monitoring, alerting and dashboards"
  type        = bool
  default     = true
}
variable "managed_prometheus_cross_account_role" {
  description = "Amazon Managed Prometheus Workspace's Account Role Arn"
  type        = string
  default     = ""
}
variable "irsa_iam_additional_policies" {
  description = "IAM additional policies for IRSA roles"
  type        = list(string)
  default     = []
}
variable "irsa_iam_role_name" {
  description = "IAM role name for IRSA roles"
  type        = string
  default     = ""
}