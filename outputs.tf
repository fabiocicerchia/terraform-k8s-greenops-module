output "observability" {
  description = "Observability and scaling outputs"
  value = {
    prometheus = var.observability.prometheus.enabled ? {
      namespace    = module.prometheus[0].namespace
      release_name = module.prometheus[0].release_name
      version      = module.prometheus[0].chart_version
    } : null
    keda = var.observability.keda.enabled ? {
      namespace    = module.keda[0].namespace
      release_name = module.keda[0].release_name
      version      = module.keda[0].chart_version
    } : null
  }
}

output "kubectl_config" {
  description = "Kubectl configuration used for deployment"
  value = {
    config_path = var.kubectl_config_path
    context     = coalesce(var.kubectl_context, "current")
  }
}

output "cost_efficiency" {
  description = "Cost and resource efficiency outputs"
  value = {
    opencost = var.cost_efficiency.opencost.enabled ? {
      namespace    = module.opencost[0].namespace
      release_name = module.opencost[0].release_name
      version      = module.opencost[0].chart_version
    } : null
  }
}

output "energy_power" {
  description = "Energy and power monitoring outputs"
  value = {
    kepler = var.energy_power.kepler.enabled ? {
      namespace    = module.kepler[0].namespace
      release_name = module.kepler[0].release_name
      version      = module.kepler[0].chart_version
    } : null
    scaphandre = var.energy_power.scaphandre.enabled ? {
      namespace    = module.scaphandre[0].namespace
      release_name = module.scaphandre[0].release_name
      version      = module.scaphandre[0].chart_version
    } : null
  }
}

output "sustainability_optimisation" {
  description = "Sustainability optimization outputs"
  value = {
    kubegreen = var.sustainability_optimisation.kubegreen.enabled ? {
      namespace    = module.kubegreen[0].namespace
      release_name = module.kubegreen[0].release_name
      version      = module.kubegreen[0].chart_version
    } : null
  }
}

output "carbon_emissions" {
  description = "Carbon and emissions estimation outputs"
  value = {
    carbon_intensity_exporter = var.carbon_emissions.carbon_intensity_exporter.enabled ? {
      namespace    = module.carbon_intensity_exporter[0].namespace
      release_name = module.carbon_intensity_exporter[0].release_name
      version      = module.carbon_intensity_exporter[0].chart_version
    } : null
    cloud_carbon_footprint = var.carbon_emissions.cloud_carbon_footprint.enabled ? {
      namespace          = module.cloud_carbon_footprint[0].namespace
      release_name       = module.cloud_carbon_footprint[0].release_name
      version            = module.cloud_carbon_footprint[0].chart_version
      client_service_url = module.cloud_carbon_footprint[0].client_service_url
      api_service_url    = module.cloud_carbon_footprint[0].api_service_url
    } : null
    codecarbon = var.carbon_emissions.codecarbon.enabled ? {
      namespace      = module.codecarbon[0].namespace
      daemonset_name = module.codecarbon[0].daemonset_name
    } : null
  }
}

output "deployed_components" {
  description = "List of deployed components"
  value = {
    observability = {
      prometheus = var.observability.prometheus.enabled
      keda       = var.observability.keda.enabled
    }
    cost_efficiency = {
      opencost = var.cost_efficiency.opencost.enabled
    }
    energy_power = {
      kepler     = var.energy_power.kepler.enabled
      scaphandre = var.energy_power.scaphandre.enabled
    }
    sustainability_optimisation = {
      kubegreen = var.sustainability_optimisation.kubegreen.enabled
    }
    carbon_emissions = {
      carbon_intensity_exporter = var.carbon_emissions.carbon_intensity_exporter.enabled
      cloud_carbon_footprint    = var.carbon_emissions.cloud_carbon_footprint.enabled
      codecarbon                = var.carbon_emissions.codecarbon.enabled
    }
  }
}
