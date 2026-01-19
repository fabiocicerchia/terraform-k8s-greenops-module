module "greenops" {
  source = "./modules/greenops"

  providers = {
    helm = helm
  }

  prometheus = {
    enabled       = var.prometheus.enabled
    release_name  = var.prometheus.release_name
    namespace     = var.prometheus.namespace
    values        = var.prometheus.values
    chart_version = var.prometheus.chart_version
  }

  keda = {
    enabled        = var.keda.enabled
    release_name   = var.keda.release_name
    namespace      = var.keda.namespace
    values         = {}
    deploy_example = var.keda.deploy_example
    manifest_path  = var.keda.manifest_path
    chart_version  = var.keda.chart_version
  }

  opencost = {
    enabled       = var.opencost.enabled
    release_name  = var.opencost.release_name
    namespace     = var.opencost.namespace
    values        = var.opencost.values
    chart_version = var.opencost.chart_version
  }

  kepler = {
    enabled             = var.kepler.enabled
    release_name        = var.kepler.release_name
    namespace           = var.kepler.namespace
    values              = var.kepler.values
    deploy_powermonitor = var.kepler.deploy_powermonitor
    chart_version       = var.kepler.chart_version
  }

  scaphandre = {
    enabled       = var.scaphandre.enabled
    release_name  = var.scaphandre.release_name
    namespace     = var.scaphandre.namespace
    values        = var.scaphandre.values
    chart_version = var.scaphandre.chart_version
  }

  kubegreen = {
    enabled       = var.kubegreen.enabled
    release_name  = var.kubegreen.release_name
    namespace     = var.kubegreen.namespace
    values        = var.kubegreen.values
    chart_version = var.kubegreen.chart_version
  }

  depends_on = [null_resource.deploy_cert_manager]
}

resource "null_resource" "deploy_cert_manager" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml"
  }
}

resource "null_resource" "deploy_demo_app" {
  count = var.deploy_demo_app ? 1 : 0

  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/refs/heads/main/release/kubernetes-manifests.yaml"
  }

  depends_on = [module.greenops]
}
