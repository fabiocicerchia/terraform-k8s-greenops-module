# ==============================================================================
# TIER 2: MEASURE - Carbon Tracking 🌍
# ==============================================================================
# Builds on Tier 1 by adding carbon emissions tracking.
# Use this after you've established baseline energy/cost metrics.
#
# What's new in Tier 2:
# ✅ Carbon Intensity Exporter - Grid carbon intensity for your region
# ✅ Cloud Carbon Footprint - Estimate cloud infrastructure carbon emissions
# 
# Use cases:
# - ESG reporting with measured carbon data
# - Carbon-aware scheduling decisions
# - Understanding carbon vs. cost trade-offs
#
# Prerequisites:
# - Tier 1 deployed and running
# - For Cloud Carbon Footprint: cloud provider API credentials
#
# Next steps:
# 1. Deploy this configuration
# 2. Configure Cloud Carbon Footprint with your cloud credentials
# 3. View carbon metrics in Grafana
# 4. When ready for optimization, progress to Tier 3
# ==============================================================================

terraform {
  required_version = ">= 1.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
}

# Set your kubectl context here (or use default current context)
variable "kubectl_context" {
  description = "Kubectl context to use"
  type        = string
  default     = null # null = use current context, or set to specific context like "minikube"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = var.kubectl_context
  }
}

provider "kubectl" {
  config_path    = "~/.kube/config"
  config_context = var.kubectl_context
}

module "greenops_measure" {
  source = "fabiocicerchia/greenops/kubernetes"

  providers = {
    helm    = helm
    kubectl = kubectl
  }

  # Pass kubectl context to the module
  kubectl_context = var.kubectl_context

  # Observability foundation
  observability = {
    prometheus = {
      enabled = true
    }
    keda = {
      enabled = false # Still not using autoscaling
    }
  }

  # Cost tracking
  cost_efficiency = {
    opencost = {
      enabled = true
      values = {
        opencost = {
          carbonCost = {
            enabled = true # Link carbon to cost
          }
        }
      }
    }
  }

  # Energy monitoring
  energy_power = {
    kepler = {
      enabled             = true
      deploy_powermonitor = true
    }
    scaphandre = {
      enabled = false
    }
  }

  # 🆕 TIER 2: Carbon emissions tracking
  carbon_emissions = {
    # Get real-time grid carbon intensity for your region
    carbon_intensity_exporter = {
      enabled = true
      # Configure your region in values:
      # values = {
      #   carbonIntensity = {
      #     region = "US-CA" # California
      #   }
      # }
    }

    # Estimate cloud infrastructure carbon footprint
    # ⚠️  Requires cloud provider credentials
    cloud_carbon_footprint = {
      enabled = true # Set to false if you don't have credentials yet
      # values = {
      #   api = {
      #     credentials = {
      #       AWS_ACCESS_KEY_ID     = "your-key"
      #       AWS_SECRET_ACCESS_KEY = "your-secret"
      #     }
      #   }
      # }
    }

    # CodeCarbon for application-level tracking
    # Enable this when you instrument your applications
    codecarbon = {
      enabled = false
    }
  }

  # Automation - not yet
  sustainability_optimisation = {
    kubegreen = {
      enabled = false
    }
  }
}

# ==============================================================================
# Dashboards to explore:
# - Carbon Intensity Dashboard - See your region's grid carbon in real-time
# - Cloud Carbon Footprint - Estimated emissions by service/region
# - OpenCost Carbon View - Cost and carbon side-by-side
# ==============================================================================
