
################################################################################
# Observability Resources
################################################################################
locals{
    prometheus_hub = var.prometheus_hub
    context = {
        aws_caller_identity_account_id = data.aws_caller_identity.current.account_id
        aws_caller_identity_arn        = data.aws_caller_identity.current.arn
        aws_eks_cluster_endpoint       = module.eks.cluster_endpoint
        aws_partition_id               = data.aws_partition.current.partition
        aws_region_name                = data.aws_region.current.name
        eks_cluster_id                 = module.eks.cluster_name
        eks_oidc_issuer_url            = module.eks.cluster_oidc_issuer_url
        eks_oidc_provider_arn          = module.eks.oidc_provider_arn
        tags                           = local.tags
        irsa_iam_role_path             = "/"
        irsa_iam_permissions_boundary  = null
    }     
    adot_collector_namespace                 = "adot-collector-kubeprometheus"
    adot_collector_service_account_name      = "adot-collector-kubeprometheus"    
}

# Managed Prometheus workspace
resource "aws_prometheus_workspace" "amp" {
  alias = local.prometheus_hub
  tags  = local.tags
}

module "operator" {
  source = "../modules/adot-operator"
  kubernetes_version  = module.eks.cluster_version
  addon_context       = local.context
}

resource "aws_iam_role" "adot_collector" {
  name               = "${module.eks.cluster_name}-adot-collector"
  assume_role_policy = data.aws_iam_policy_document.eks_assume.json
}

resource "aws_iam_role_policy_attachment" "AdotCollectorPolicy" {
  for_each   = toset(var.adot_collector_policy_arns)
  policy_arn = each.key
  role       = aws_iam_role.adot_collector.name
}

resource "aws_eks_pod_identity_association" "adot_collector" {
  cluster_name    = module.eks.cluster_name
  namespace       = local.adot_collector_namespace
  service_account = local.adot_collector_service_account_name
  role_arn        = aws_iam_role.adot_collector.arn
  # need to create podidentity association after ns is created.
  depends_on = [module.gitops_bridge_bootstrap]
}
