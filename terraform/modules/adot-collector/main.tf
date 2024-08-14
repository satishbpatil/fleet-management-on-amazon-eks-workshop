
locals{
  java_pattern_config = {
      # disabled if options from module are disabled, by default
      # can be overriden by providing a config
      enable_alerting_rules  = true
      enable_recording_rules = true
      enable_dashboards      = true # disable flux kustomization if dashboards are disabled
  
      scrape_sample_limit = 1000
  
      flux_gitrepository_name   = ""
      flux_gitrepository_url    = ""
      flux_gitrepository_branch = ""
      flux_kustomization_name   = "grafana-dashboards-java"
      flux_kustomization_path   = "./artifacts/grafana-operator-manifests/eks/java"
  
      managed_prometheus_workspace_id = "sdf"
      prometheus_metrics_endpoint     = "/metrics"
  
      grafana_dashboard_url = "https://raw.githubusercontent.com/aws-observability/aws-observability-accelerator/v0.2.0/artifacts/grafana-dashboards/eks/java/default.json"
    }
  nginx_pattern_config_defaults = {
    # disabled if options from module are disabled, by default
    # can be overriden by providing a config
    enable_alerting_rules  = true
    enable_recording_rules = true
    enable_dashboards      = true

    scrape_sample_limit = 1000

    flux_gitrepository_name   = ""
    flux_gitrepository_url    = ""
    flux_gitrepository_branch = ""
    flux_kustomization_name   = "grafana-dashboards-nginx"
    flux_kustomization_path   = "./artifacts/grafana-operator-manifests/eks/nginx"

    managed_prometheus_workspace_id = "sdf"
    prometheus_metrics_endpoint     = "/metrics"

    grafana_dashboard_url = "https://raw.githubusercontent.com/aws-observability/aws-observability-accelerator/v0.2.0/artifacts/grafana-dashboards/eks/nginx/nginx.json"
  }

  nginx_pattern_config = {
    # Merge input variable with defaults and rebuild with non-null values
    for k, v in merge(local.nginx_pattern_config_defaults, var.nginx_config) : k => v != null ? v : local.nginx_pattern_config_defaults[k]
  }  
  istio_pattern_config = {
    # disabled if options from module are disabled, by default
    # can be overriden by providing a config
    enable_alerting_rules  = true
    enable_recording_rules = true
    enable_dashboards      = true

    scrape_sample_limit = 1000

    flux_gitrepository_name   = ""
    flux_gitrepository_url    = ""
    flux_gitrepository_branch = ""
    flux_kustomization_name   = "grafana-dashboards-istio"
    flux_kustomization_path   = "./artifacts/grafana-operator-manifests/eks/istio"

    managed_prometheus_workspace_id = "sdf"
    prometheus_metrics_endpoint     = "/metrics"

    dashboards = {
      cp          = "https://raw.githubusercontent.com/aws-observability/aws-observability-accelerator/v0.2.0/artifacts/grafana-dashboards/eks/istio/istio-control-plane-dashboard.json"
      mesh        = "https://raw.githubusercontent.com/aws-observability/aws-observability-accelerator/v0.2.0/artifacts/grafana-dashboards/eks/istio/istio-mesh-dashboard.json"
      performance = "https://raw.githubusercontent.com/aws-observability/aws-observability-accelerator/v0.2.0/artifacts/grafana-dashboards/eks/istio/istio-performance-dashboard.json"
      service     = "https://raw.githubusercontent.com/aws-observability/aws-observability-accelerator/v0.2.0/artifacts/grafana-dashboards/eks/istio/istio-service-dashboard.json"
    }
  }  
}

# module "helm_addon" {
#   source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons/helm-addon?ref=v4.32.1"

#   helm_config = {
#       name        = var.adot_collector_name
#       chart       = "${path.module}/../otel-config"
#       namespace   = var.adot_collector_namespace
#       description = "ADOT helm Chart deployment configuration"
#     }
  

#   set_values = [
#     {
#       name  = "ampurl"
#       value = "${var.managed_prometheus_workspace_endpoint}api/v1/remote_write"
#     },
#     {
#       name  = "region"
#       value = var.managed_prometheus_workspace_region
#     },
#     {
#       name  = "assumeRoleArn"
#       value = var.managed_prometheus_cross_account_role
#     },
#     {
#       name  = "ekscluster"
#       value = var.addon_context.eks_cluster_id 
#     },
#     {
#       name  = "globalScrapeInterval"
#       value = var.prometheus_config.global_scrape_interval
#     },
#     {
#       name  = "globalScrapeTimeout"
#       value = var.prometheus_config.global_scrape_timeout
#     },
#     {
#       name  = "adotLoglevel"
#       value = var.adot_loglevel
#     },
#     {
#       name  = "adotServiceTelemetryLoglevel"
#       value = var.adot_service_telemetry_loglevel
#     },
#     {
#       name  = "accountId"
#       value = var.addon_context.aws_caller_identity_account_id
#     },
#     {
#       name  = "enableTracing"
#       value = var.enable_tracing
#     },
#     {
#       name  = "otlpHttpEndpoint"
#       value = var.tracing_config.otlp_http_endpoint
#     },
#     {
#       name  = "otlpGrpcEndpoint"
#       value = var.tracing_config.otlp_grpc_endpoint
#     },
#     {
#       name  = "tracingTimeout"
#       value = var.tracing_config.timeout
#     },
#     {
#       name  = "tracingSendBatchSize"
#       value = var.tracing_config.send_batch_size
#     },
#     {
#       name  = "enableCustomMetrics"
#       value = var.enable_custom_metrics
#     },
#     {
#       name  = "customMetrics"
#       value = yamlencode(var.custom_metrics_config)
#     },
#     {
#       name  = "enableJava"
#       value = var.enable_java
#     },
#     {
#       name  = "javaScrapeSampleLimit"
#       value = try(var.java_config.scrape_sample_limit, local.java_pattern_config.scrape_sample_limit)
#     },
#     {
#       name  = "javaPrometheusMetricsEndpoint"
#       value = try(var.java_config.prometheus_metrics_endpoint, local.java_pattern_config.prometheus_metrics_endpoint)
#     },
#     {
#       name  = "enableAPIserver"
#       value = var.enable_apiserver_monitoring
#     },
#     {
#       name  = "enableNginx"
#       value = var.enable_nginx
#     },
#     {
#       name  = "nginxScrapeSampleLimit"
#       value = local.nginx_pattern_config.scrape_sample_limit
#     },
#     {
#       name  = "nginxPrometheusMetricsEndpoint"
#       value = local.nginx_pattern_config.prometheus_metrics_endpoint
#     },
#     {
#       name  = "enableIstio"
#       value = var.enable_istio
#     },
#     {
#       name  = "istioScrapeSampleLimit"
#       value = try(var.istio_config.scrape_sample_limit, local.istio_pattern_config.scrape_sample_limit)
#     },
#     {
#       name  = "istioPrometheusMetricsEndpoint"
#       value = try(var.istio_config.prometheus_metrics_endpoint, local.istio_pattern_config.prometheus_metrics_endpoint)
#     },
#     {
#       name  = "enableAdotcollectorMetrics"
#       value = var.enable_adotcollector_metrics
#     },
#     {
#       name  = "enableGpuMonitoring"
#       value = var.enable_nvidia_monitoring
#     },
#     {
#       name  = "serviceAccount"
#       value = var.adot_collector_service_account
#     },
#     {
#       name  = "namespace"
#       value = var.adot_collector_namespace
#     }
#   ]

#   irsa_iam_role_name = var.irsa_iam_role_name
#   irsa_config = {
#     create_kubernetes_namespace       = true
#     kubernetes_namespace              = var.adot_collector_namespace
#     create_kubernetes_service_account = true
#     kubernetes_service_account        = var.adot_collector_service_account
#     irsa_iam_policies = flatten([
#       "arn:aws:iam::aws:policy/AmazonPrometheusRemoteWriteAccess",
#       "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess",
#       var.irsa_iam_additional_policies,
#     ])
#   }

#   addon_context = var.addon_context

#   # depends_on = [module.operator]
# }

////Satish below is copied from main
# module "helm_addon" {
#   source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons/helm-addon?ref=v4.32.1"

#   helm_config =     {
#       name        = var.adot_collector_name
#       chart       = "../otel-config"
#       namespace   = var.adot_collector_namespace
#       description = "ADOT helm Chart deployment configuration"
#     }
#   set_values = [
#     {
#       name  = "ampurl"
#       value = "${var.managed_prometheus_workspace_endpoint}api/v1/remote_write"
#     },
#     {
#       name  = "region"
#       value = var.managed_prometheus_workspace_region
#     },
#     {
#       name  = "assumeRoleArn"
#       value = var.managed_prometheus_cross_account_role
#     },
#     {
#       name  = "ekscluster"
#       value = var.addon_context.eks_cluster_id
#     },
#     {
#       name  = "globalScrapeInterval"
#       value = var.prometheus_config.global_scrape_interval
#     },
#     {
#       name  = "globalScrapeTimeout"
#       value = var.prometheus_config.global_scrape_timeout
#     },
#     {
#       name  = "adotLoglevel"
#       value = var.adot_loglevel
#     },
#     {
#       name  = "adotServiceTelemetryLoglevel"
#       value = var.adot_service_telemetry_loglevel
#     },
#     {
#       name  = "accountId"
#       value = var.addon_context.aws_caller_identity_account_id
#     },
#     {
#       name  = "enableTracing"
#       value = var.enable_tracing
#     },
#     {
#       name  = "otlpHttpEndpoint"
#       value = var.tracing_config.otlp_http_endpoint
#     },
#     {
#       name  = "otlpGrpcEndpoint"
#       value = var.tracing_config.otlp_grpc_endpoint
#     },
#     {
#       name  = "tracingTimeout"
#       value = var.tracing_config.timeout
#     },
#     {
#       name  = "tracingSendBatchSize"
#       value = var.tracing_config.send_batch_size
#     },
#     {
#       name  = "enableCustomMetrics"
#       value = var.enable_custom_metrics
#     },
#     {
#       name  = "customMetrics"
#       value = yamlencode(var.custom_metrics_config)
#     },
#     {
#       name  = "enableJava"
#       value = var.enable_java
#     },
#     {
#       name  = "javaScrapeSampleLimit"
#       value = try(var.java_config.scrape_sample_limit, local.java_pattern_config.scrape_sample_limit)
#     },
#     {
#       name  = "javaPrometheusMetricsEndpoint"
#       value = try(var.java_config.prometheus_metrics_endpoint, local.java_pattern_config.prometheus_metrics_endpoint)
#     },
#     {
#       name  = "enableAPIserver"
#       value = var.enable_apiserver_monitoring
#     },
#     {
#       name  = "enableNginx"
#       value = var.enable_nginx
#     },
#     {
#       name  = "nginxScrapeSampleLimit"
#       value = local.nginx_pattern_config.scrape_sample_limit
#     },
#     {
#       name  = "nginxPrometheusMetricsEndpoint"
#       value = local.nginx_pattern_config.prometheus_metrics_endpoint
#     },
#     {
#       name  = "enableIstio"
#       value = var.enable_istio
#     },
#     {
#       name  = "istioScrapeSampleLimit"
#       value = try(var.istio_config.scrape_sample_limit, local.istio_pattern_config.scrape_sample_limit)
#     },
#     {
#       name  = "istioPrometheusMetricsEndpoint"
#       value = try(var.istio_config.prometheus_metrics_endpoint, local.istio_pattern_config.prometheus_metrics_endpoint)
#     },
#     {
#       name  = "enableAdotcollectorMetrics"
#       value = var.enable_adotcollector_metrics
#     },
#     {
#       name  = "enableGpuMonitoring"
#       value = var.enable_nvidia_monitoring
#     },
#     {
#       name  = "serviceAccount"
#       value =  var.adot_collector_service_account
#     },
#     {
#       name  = "namespace"
#       value = var.adot_collector_namespace
#     }
#   ]

#   irsa_iam_role_name = var.irsa_iam_role_name
#   irsa_config = {
#     create_kubernetes_namespace       = true
#     kubernetes_namespace              = var.adot_collector_namespace
#     create_kubernetes_service_account = true
#     kubernetes_service_account        = var.adot_collector_service_account
#     irsa_iam_policies = flatten([
#       "arn:aws:iam::aws:policy/AmazonPrometheusRemoteWriteAccess",
#       "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess",
#       var.irsa_iam_additional_policies,
#     ])
#   }

#   addon_context = var.addon_context

#   #depends_on = [module.operator]
# }

data "aws_iam_policy_document" "podidentity_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "adot_collector" {
  name               = "${var.addon_context.eks_cluster_id}-adot_collector"
  assume_role_policy = data.aws_iam_policy_document.podidentity_assume_role.json
}

# resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
#   for_each   = toset(var.adot_collector_policy_arns)
#   policy_arn = each.key
#   role       = aws_iam_role.adot_collector.name
# }

# resource "aws_eks_pod_identity_association" "adot_collector" {
#   cluster_name    = var.addon_context.eks_cluster_id
#   namespace       = var.adot_collector_namespace
#   service_account = var.adot_collector_service_account
#   role_arn        = aws_iam_role.adot_collector.arn
# }

output "a"{
  value = var.adot_collector_name
}
output "b"{
  value = var.adot_collector_namespace
}
output "c"{
  value = "${var.managed_prometheus_workspace_endpoint}api/v1/remote_write"
}
output "d"{
  value = var.managed_prometheus_workspace_region
}
output "e"{
  value = var.managed_prometheus_cross_account_role
}
output "f"{
  value = var.addon_context.eks_cluster_id
}
output "g"{
  value = var.prometheus_config.global_scrape_interval
}
output "h"{
  value = var.prometheus_config.global_scrape_timeout
}
output "i"{
  value = var.adot_loglevel
}
output "j"{
  value = var.adot_service_telemetry_loglevel
}
output "k"{
  value = var.addon_context.aws_caller_identity_account_id
}
output "l"{
  value = var.enable_tracing
}
output "m"{
  value = var.tracing_config.otlp_http_endpoint
}
output "n"{
  value = var.tracing_config.otlp_grpc_endpoint
}
output "o"{
  value = var.tracing_config.timeout
}
output "p"{
  value = var.tracing_config.send_batch_size
}
output "q"{
  value = var.enable_custom_metrics
}
output "r"{
  value = yamlencode(var.custom_metrics_config)
}
output "s"{
  value = var.enable_java
}
output "t"{
  value = try(var.java_config.scrape_sample_limit, local.java_pattern_config.scrape_sample_limit)
}
output "u"{
  value = try(var.java_config.prometheus_metrics_endpoint, local.java_pattern_config.prometheus_metrics_endpoint)
}
output "v"{
  value = var.enable_apiserver_monitoring
}
output "x"{
  value = var.enable_nginx
}
output "y"{
  value = local.nginx_pattern_config.scrape_sample_limit
}
output "z"{
  value = local.nginx_pattern_config.prometheus_metrics_endpoint
}
output "aa"{
  value = var.enable_istio
}
output "bb"{
  value = var.addon_context.eks_cluster_id
}
output "cc"{
  value = try(var.istio_config.scrape_sample_limit, local.istio_pattern_config.scrape_sample_limit)
}
output "dd"{
  value = try(var.istio_config.prometheus_metrics_endpoint, local.istio_pattern_config.prometheus_metrics_endpoint)
}
output "ee"{
  value = var.enable_adotcollector_metrics
}
output "ff"{
  value = var.enable_nvidia_monitoring
}
output "gg"{
  value = var.adot_collector_service_account
}
output "hh"{
  value = var.adot_collector_namespace
}
output "ii"{
  value = var.irsa_iam_role_name
}

