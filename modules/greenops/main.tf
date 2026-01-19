module "prometheus" {
  count  = var.prometheus.enabled ? 1 : 0
  source = "https://github.com/fabiocicerchia/terraform-helm-prometheus-stack/?ref=main"

  providers = {
    helm = helm
  }

  release_name    = var.prometheus.release_name
  namespace       = var.prometheus.namespace
  values          = var.prometheus.values
  chart_version   = var.prometheus.chart_version
}

module "keda" {
  count  = var.keda.enabled ? 1 : 0
  source = "https://github.com/fabiocicerchia/terraform-helm-keda/?ref=main"

  providers = {
    helm = helm
  }

  release_name    = var.keda.release_name
  namespace       = var.keda.namespace
  values          = var.keda.values
  deploy_example  = var.keda.deploy_example
  manifest_path   = var.keda.manifest_path
  chart_version   = var.keda.chart_version
}

module "opencost" {
  count  = var.opencost.enabled ? 1 : 0
  source = "https://github.com/fabiocicerchia/terraform-helm-opencost/?ref=main"

  providers = {
    helm = helm
  }

  release_name    = var.opencost.release_name
  namespace       = var.opencost.namespace
  chart_version   = var.opencost.chart_version
  values          = var.opencost.values
}

module "kepler" {
  count  = var.kepler.enabled ? 1 : 0
  source = "https://github.com/fabiocicerchia/terraform-helm-kepler/?ref=main"

  providers = {
    helm = helm
  }

  release_name        = var.kepler.release_name
  namespace           = var.kepler.namespace
  values              = var.kepler.values
  chart_version       = var.kepler.chart_version
  deploy_powermonitor = var.kepler.deploy_powermonitor
}

module "scaphandre" {
  count  = var.scaphandre.enabled ? 1 : 0
  source = "https://github.com/fabiocicerchia/terraform-helm-scaphandre/?ref=main"

  providers = {
    helm = helm
  }

  release_name    = var.scaphandre.release_name
  namespace       = var.scaphandre.namespace
  chart_version   = var.scaphandre.chart_version
  values          = var.scaphandre.values
}

module "kubegreen" {
  count  = var.kubegreen.enabled ? 1 : 0
  source = "https://github.com/fabiocicerchia/terraform-helm-kubegreen/?ref=main"

  providers = {
    helm = helm
  }

  release_name    = var.kubegreen.release_name
  chart_version   = var.kubegreen.chart_version
  namespace       = var.kubegreen.namespace
  values          = var.kubegreen.values
}
