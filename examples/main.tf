terraform {
  required_version = ">= 1.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

module "greenops" {
  source = "../"

  providers = {
    helm = helm
  }

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
    deploy_example = true
    manifest_path  = "keda.yaml"
    # https://github.com/kedacore/charts/blob/main/keda/values.yaml
    values         = {}
  }

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
    values        = {
      serviceMonitor = {
        enabled = true
      }
    }
  }

  kubegreen = {
    enabled       = true
    chart_version = ""
    release_name  = "kube-green"
    namespace     = "kube-green"
    # https://github.com/kube-green/kube-green
    # https://kube-green.github.io/
    values        = {}
  }

  carbon_intensity_exporter = {
    enabled       = true
    chart_version = ""
    release_name  = "carbon-intensity-exporter"
    namespace     = "carbon-intensity-exporter"
    # https://github.com/Azure/kubernetes-carbon-intensity-exporter
    values        = {}
  }

  cloud_carbon_footprint = {
    enabled       = true
    chart_version = ""
    release_name  = "cloud-carbon-footprint"
    namespace     = "cloud-carbon-footprint"
    # https://github.com/cloud-carbon-footprint/cloud-carbon-footprint
    values        = {}
  }

  depends_on = [null_resource.deploy_cert_manager]
}

resource "null_resource" "deploy_cert_manager" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml"
  }
}

resource "null_resource" "deploy_demo_app" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/refs/heads/main/release/kubernetes-manifests.yaml"
  }

  depends_on = [module.greenops]
}
