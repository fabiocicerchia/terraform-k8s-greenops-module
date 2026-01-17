kubeconfig_path = "~/.kube/config"
deploy_demo_app = true

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
          serviceName   = "prometheus-kube-prometheus-prometheus"
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
  # https://github.com/hubblo-org/scaphandre
  values = {}
}

kubegreen = {
  enabled       = true
  chart_version = ""
  release_name  = "kube-green"
  namespace     = "kube-green"
  # https://github.com/kube-green/kube-green
  # https://kube-green.github.io/
  values = {}
}
