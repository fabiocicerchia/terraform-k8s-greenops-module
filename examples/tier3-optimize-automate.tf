# ==============================================================================
# TIER 3: OPTIMIZE - Automation & Efficiency ⚡
# ==============================================================================
# Advanced configuration with automated optimization.
# ⚠️  ONLY deploy this after understanding your metrics from Tiers 1 & 2!
#
# What's new in Tier 3:
# ✅ KEDA - Event-driven autoscaling based on metrics
# ✅ KubeGreen - Automated shutdown of non-production environments
#
# ⚠️  WARNING: These tools perform automated actions!
# - KEDA will scale your workloads based on metrics
# - KubeGreen will shut down pods during off-hours
#
# Prerequisites:
# - Tier 1 & 2 deployed and understood
# - Baseline metrics established (30+ days recommended)
# - Non-production environment for testing
# - SleepInfo CRDs configured for KubeGreen
#
# Safety checklist:
# ☐ Tested in dev/staging environment first
# ☐ Defined scaling policies based on observed metrics
# ☐ Configured KubeGreen exclusions for critical services
# ☐ Set up alerts for unexpected scaling behavior
# ☐ Documented rollback procedures
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

module "greenops_optimize" {
  source = "fabiocicerchia/greenops/kubernetes"

  providers = {
    helm    = helm
    kubectl = kubectl
  }

  # Pass kubectl context to the module
  kubectl_context = var.kubectl_context

  # Full observability stack
  observability = {
    prometheus = {
      enabled = true
      values = {
        prometheus = {
          prometheusSpec = {
            retention = "90d" # Longer retention for trend analysis
          }
        }
      }
    }

    # 🆕 TIER 3: Enable autoscaling
    keda = {
      enabled        = true
      deploy_example = false # Set to true to deploy example scaled workload
      values = {
        # Configure KEDA to use Prometheus metrics
        prometheus = {
          address = "http://prometheus-community-kube-prometheus.monitoring:9090"
        }
      }
    }
  }

  # Cost tracking with carbon
  cost_efficiency = {
    opencost = {
      enabled = true
      values = {
        opencost = {
          carbonCost = {
            enabled = true
          }
        }
      }
    }
  }

  # Full energy monitoring
  energy_power = {
    kepler = {
      enabled             = true
      deploy_powermonitor = true
    }
    # Optional: enable Scaphandre for additional granularity
    scaphandre = {
      enabled = false
    }
  }

  # Carbon tracking
  carbon_emissions = {
    carbon_intensity_exporter = {
      enabled = true
    }
    cloud_carbon_footprint = {
      enabled = true
    }
    codecarbon = {
      enabled = false # Enable if you've instrumented apps
    }
  }

  # 🆕 TIER 3: Enable automated optimization
  sustainability_optimisation = {
    kubegreen = {
      enabled = true
      # KubeGreen requires SleepInfo CRDs to be created per namespace
      # Example SleepInfo configuration:
      # values = {
      #   sleepInfos = [
      #     {
      #       name      = "dev-environment-sleep"
      #       namespace = "development"
      #       sleepAt   = "20:00"     # Shut down at 8 PM
      #       wakeUpAt  = "08:00"     # Wake up at 8 AM
      #       weekdays  = "1-5"       # Monday to Friday
      #       timeZone  = "America/New_York"
      #       excludeRef = [
      #         {
      #           apiVersion = "apps/v1"
      #           kind       = "Deployment"
      #           name       = "critical-service" # Don't shut this down
      #         }
      #       ]
      #     }
      #   ]
      # }
    }
  }
}

# ==============================================================================
# Post-deployment configuration:
#
# 1. KEDA ScaledObjects - Define scaling policies:
#    kubectl apply -f - <<EOF
#    apiVersion: keda.sh/v1alpha1
#    kind: ScaledObject
#    metadata:
#      name: prometheus-scaledobject
#      namespace: your-app
#    spec:
#      scaleTargetRef:
#        name: your-deployment
#      triggers:
#      - type: prometheus
#        metadata:
#          serverAddress: http://prometheus-community-kube-prometheus.monitoring:9090
#          metricName: http_requests_total
#          query: sum(rate(http_requests_total[2m]))
#          threshold: '100'
#    EOF
#
# 2. KubeGreen SleepInfo - Configure shutdown schedules per namespace
#
# 3. Monitor impact:
#    - Track energy reduction via Kepler
#    - Monitor cost savings via OpenCost
#    - Ensure availability meets SLAs
# ==============================================================================

# ==============================================================================
# Success metrics to track:
# - Energy consumption reduction (Kepler metrics before/after)
# - Cost savings (OpenCost reports)
# - Carbon emissions reduction
# - Application availability/performance (no degradation)
# ==============================================================================
