# ==============================================================================
# TIER 1: OBSERVE - Start Here! 🔭
# ==============================================================================
# This is the recommended starting point for GreenOps adoption.
# Deploys only observability tools to gain visibility into your infrastructure.
#
# What you get:
# ✅ Prometheus - Metrics collection and storage
# ✅ Kepler - Real-time energy consumption metrics per pod/namespace
# ✅ OpenCost - Cost allocation and carbon cost tracking
# ✅ CodeCarbon - Application-level carbon emissions tracking
#
# What this does NOT do:
# ❌ No automated scaling or shutdowns
# ❌ No external API calls or credentials needed
# ❌ No changes to your existing workloads
#
# Next steps:
# 1. Deploy this configuration
# 2. Access Grafana dashboards to view energy and cost metrics
# 3. Identify high-impact workloads and optimization opportunities
# 4. When ready, progress to Tier 2 (tier2-measure-carbon.tf)
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

module "greenops_observe" {
  source = "fabiocicerchia/greenops/kubernetes"

  providers = {
    helm    = helm
    kubectl = kubectl
  }

  # Pass kubectl context to the module
  # Uncomment and set to your cluster name for protection:
  # cluster_safety = {
  #   require_cluster_name = "dev-cluster-1"  # Get with: kubectl config view --minify -o jsonpath='{.clusters[0].name}'
  #   confirm_deployment   = true             # Shows cluster info before deployment (default: true)
  # }

  # Core observability - enabled by default
  observability = {
    prometheus = {
      enabled = true
      # Optional: customize retention period
      # values = {
      #   prometheus = {
      #     prometheusSpec = {
      #       retention = "30d"  # Store 30 days of metrics
      #     }
      #   }
      # }
    }
    # KEDA disabled - enable in Tier 3 when ready for autoscaling
    keda = {
      enabled = false
    }
  }

  # Cost visibility - see where money is spent
  cost_efficiency = {
    opencost = {
      enabled = true
    }
  }

  # Energy monitoring - core GreenOps metric
  energy_power = {
    kepler = {
      enabled             = true
      deploy_powermonitor = true
    }
    scaphandre = {
      enabled = false # Not needed alongside Kepler
    }
  }

  # Carbon tracking at application level
  carbon_emissions = {
    carbon_intensity_exporter = {
      enabled = false # Advanced - enable in Tier 2
    }
    cloud_carbon_footprint = {
      enabled = false # Advanced - enable in Tier 2
    }
    codecarbon = {
      enabled = true # Track carbon emissions from your applications
      # Optional: configure API key for cloud reporting
      # api_key = "your-codecarbon-api-key"
    }
  }

  # Automation - disabled, enable in Tier 3
  sustainability_optimisation = {
    kubegreen = {
      enabled = false
    }
  }
}

# ==============================================================================
# After deployment, access your dashboards:
# 
# kubectl port-forward -n monitoring svc/prometheus-community-grafana 3000:80
# 
# Then browse to: http://localhost:3000
# Default credentials: admin / prom-operator
#
# Look for these dashboards:
# - Kepler Exporter Dashboard - Energy consumption by pod/namespace
# - OpenCost - Cost allocation and trends
# ==============================================================================
