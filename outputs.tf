output "prometheus" {
  description = "Prometheus module outputs"
  value = var.prometheus.enabled ? {
    namespace    = module.greenops.prometheus.namespace
    release_name = module.greenops.prometheus.release_name
    version      = module.greenops.prometheus.version
  } : null
}

output "keda" {
  description = "KEDA module outputs"
  value = var.keda.enabled ? {
    namespace    = module.greenops.keda.namespace
    release_name = module.greenops.keda.release_name
    version      = module.greenops.keda.version
  } : null
}

output "opencost" {
  description = "OpenCost module outputs"
  value = var.opencost.enabled ? {
    namespace    = module.greenops.opencost.namespace
    release_name = module.greenops.opencost.release_name
    version      = module.greenops.opencost.version
  } : null
}

output "kepler" {
  description = "Kepler module outputs"
  value = var.kepler.enabled ? {
    namespace    = module.greenops.kepler.namespace
    release_name = module.greenops.kepler.release_name
    version      = module.greenops.kepler.version
  } : null
}

output "scaphandre" {
  description = "Scaphandre module outputs"
  value = var.scaphandre.enabled ? {
    namespace    = module.greenops.scaphandre.namespace
    release_name = module.greenops.scaphandre.release_name
    version      = module.greenops.scaphandre.version
  } : null
}

output "kubegreen" {
  description = "KubeGreen module outputs"
  value = var.kubegreen.enabled ? {
    namespace    = module.greenops.kubegreen.namespace
    release_name = module.greenops.kubegreen.release_name
    version      = module.greenops.kubegreen.version
  } : null
}

output "deployed_components" {
  description = "Map of deployed components and their status"
  value       = module.greenops.deployed_components
}

output "demo_app_deployed" {
  description = "Whether the demo application was deployed"
  value       = var.deploy_demo_app
}
