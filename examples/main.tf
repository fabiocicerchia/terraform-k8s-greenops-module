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
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0"
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

provider "kubectl" {
  config_path = "~/.kube/config"
}

### CERT-MANAGER INSTALLATION ###

data "http" "cert_manager" {
  url = "https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml"
}
data "kubectl_file_documents" "cert_manager" {
    content = data.http.cert_manager.response_body
}
resource "kubectl_manifest" "cert_manager" {
  for_each  = data.kubectl_file_documents.cert_manager.manifests
  yaml_body = each.value
}

#### GREENOPS MODULE DEPLOYMENT ###
module "greenops" {
  source = "../"

  providers = {
    helm    = helm
    kubectl = kubectl
  }

  observability = {
    prometheus = {
      enabled       = true
      release_name  = "prometheus-community"
      namespace     = "monitoring"
      chart_version = ""
      # https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml
      values = {
        prometheus = {
          prometheusSpec = {
            serviceMonitorSelectorNilUsesHelmValues = false
          }
        }
      }
    }
    keda = {
      enabled        = true
      release_name   = "kedacore"
      namespace      = "keda"
      chart_version  = ""
      # https://github.com/kedacore/charts/blob/main/keda/values.yaml
      values = {}
    }
  }

  cost_efficiency = {
    opencost = {
      enabled       = true
      release_name  = "opencost-charts"
      chart_version = ""
      namespace     = "opencost"
      # https://github.com/opencost/opencost-helm-chart/blob/main/charts/opencost/values.yaml
      values = {
        opencost = {
          carbonCost = {
            enabled = true
          }
          prometheus = {
            internal = {
              serviceName   = "prometheus-community-kube-prometheus"
              port          = 9090
              namespaceName = "monitoring"
            }
          }
        }
      }
    }
  }

  energy_power = {
    kepler = {
      enabled             = true
      release_name        = "kepler-operator"
      chart_version       = ""
      namespace           = "kepler-operator"
      deploy_powermonitor = true
      # https://github.com/sustainable-computing-io/kepler/blob/main/manifests/helm/kepler/values.yaml
      # https://github.com/sustainable-computing-io/kepler/blob/main/docs/user/configuration.md
      values = {
        serviceMonitor = {
          enabled = true
        }
      }
    }
    scaphandre = {
      enabled       = true
      release_name  = "scaphandre"
      chart_version = ""
      namespace     = "scaphandre"
      # https://github.com/hubblo-org/scaphandre/blob/main/helm/scaphandre/values.yaml
      values = {
        serviceMonitor = {
          enabled = true
        }
      }
    }
  }

  sustainability_optimisation = {
    kubegreen = {
      enabled       = true
      chart_version = ""
      release_name  = "kube-green"
      namespace     = "kube-green"
      # https://github.com/kube-green/kube-green/blob/main/charts/kube-green/values.yaml
      # https://kube-green.github.io/
      values = {}
    }
  }

  carbon_emissions = {
    carbon_intensity_exporter = {
      enabled       = true
      chart_version = ""
      release_name  = "carbon-intensity-exporter"
      namespace     = "carbon-intensity-exporter"
      # https://github.com/Azure/kubernetes-carbon-intensity-exporter/blob/main/charts/carbon-intensity-exporter/values.yaml
      values = {
        providerName = "WattTime"
        electricityMaps = {
          apiToken = "token" # Replace with your actual API token
        }
        wattTime = {
          username = "username" # Replace with your actual username
          password = "password" # Replace with your actual password
        }
      }
    }
    cloud_carbon_footprint = {
      enabled       = true
      chart_version = ""
      release_name  = "cloud-carbon-footprint"
      namespace     = "cloud-carbon-footprint"
      # https://github.com/cloud-carbon-footprint/cloud-carbon-footprint/blob/trunk/helm/charts/cloud-carbon-footprint/values.yaml
      values = {}
    }
    codecarbon = {
      enabled         = true
      name            = "codecarbon"
      namespace       = "codecarbon"
      image           = "fabiocicerchia/codecarbon:latest"
      api_endpoint    = "https://api.codecarbon.io"
      organization_id = "" # Set your organization ID
      project_id      = "" # Set your project ID
      experiment_id   = "" # Set your experiment ID
      api_key         = "" # Set your API key
    }
  }

  depends_on = [kubectl_manifest.cert_manager]
}

### CUSTOM SETTINGS OR ADDITIONAL RESOURCES ###

data "kubectl_path_documents" "extras" {
    pattern = "./*.yaml"
}
resource "kubectl_manifest" "extras" {
  for_each  = data.kubectl_path_documents.extras.manifests
  yaml_body = each.value
}

### DEMO APPLICATION DEPLOYMENT ###

data "http" "demo_app" {
  url = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/refs/heads/main/release/kubernetes-manifests.yaml"
}
data "kubectl_file_documents" "demo_app" {
    content = data.http.demo_app.response_body
}
resource "kubectl_manifest" "demo_app" {
  for_each  = data.kubectl_file_documents.demo_app.manifests
  yaml_body = each.value

  depends_on = [module.greenops]
}
