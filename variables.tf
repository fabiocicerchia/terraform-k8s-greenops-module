# Prometheus configuration
variable "prometheus" {
  description = "Prometheus module configuration"
  type = object({
    enabled       = bool
    release_name  = optional(string, "prometheus-community")
    namespace     = optional(string, "monitoring")
    values        = optional(any, {})
    chart_version = optional(string, "")
  })
  default = { enabled = true }
}

# KEDA configuration
variable "keda" {
  description = "KEDA module configuration"
  type = object({
    enabled        = bool
    release_name   = optional(string, "kedacore")
    namespace      = optional(string, "keda")
    values         = optional(any, {})
    deploy_example = optional(bool, true)
    manifest_path  = optional(string, "keda.yaml")
    chart_version  = optional(string, "")
  })
  default = { enabled = true }
}

# OpenCost configuration
variable "opencost" {
  description = "OpenCost module configuration"
  type = object({
    enabled       = bool
    release_name  = optional(string, "opencost-charts")
    namespace     = optional(string, "opencost")
    chart_version = optional(string, "")
    values        = optional(any, {})
  })
  default = { enabled = true }
}

# Kepler configuration
variable "kepler" {
  description = "Kepler module configuration"
  type = object({
    enabled             = bool
    release_name        = optional(string, "kepler-operator")
    namespace           = optional(string, "kepler-operator")
    values              = optional(any, {})
    chart_version       = optional(string, "")
    deploy_powermonitor = optional(bool, true)
  })
  default = { enabled = true }
}

# Scaphandre configuration
variable "scaphandre" {
  description = "Scaphandre module configuration"
  type = object({
    enabled       = bool
    release_name  = optional(string, "scaphandre")
    namespace     = optional(string, "scaphandre")
    chart_version = optional(string, "")
    values        = optional(any, {})
  })
  default = { enabled = true }
}

# KubeGreen configuration
variable "kubegreen" {
  description = "KubeGreen module configuration"
  type = object({
    enabled       = bool
    release_name  = optional(string, "kube-green")
    namespace     = optional(string, "kube-green")
    chart_version = optional(string, "")
    values        = optional(any, {})
  })
  default = { enabled = true }
}

# Carbon Intensity Exporter configuration
variable "carbon_intensity_exporter" {
  description = "Carbon Intensity Exporter module configuration"
  type = object({
    enabled       = bool
    release_name  = optional(string, "carbon-intensity-exporter")
    namespace     = optional(string, "carbon-intensity-exporter")
    chart_version = optional(string, "")
    values        = optional(any, {})
  })
  default = { enabled = true }
}

# Cloud Carbon Footprint configuration
variable "cloud_carbon_footprint" {
  description = "Cloud Carbon Footprint module configuration"
  type = object({
    enabled       = bool
    release_name  = optional(string, "cloud-carbon-footprint")
    namespace     = optional(string, "cloud-carbon-footprint")
    chart_version = optional(string, "")
    values        = optional(any, {})
  })
}
