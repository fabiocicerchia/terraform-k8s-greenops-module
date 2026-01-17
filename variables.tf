variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "deploy_demo_app" {
  description = "Deploy the Google microservices demo application"
  type        = bool
  default     = true
}

# Prometheus configuration
variable "prometheus" {
  description = "Prometheus module configuration"
  type = object({
    enabled       = optional(bool, true)
    release_name  = optional(string, "prometheus-community")
    namespace     = optional(string, "monitoring")
    values        = optional(any, {})
    chart_version = optional(string, "")
  })
  default = {}
}

# KEDA configuration
variable "keda" {
  description = "KEDA module configuration"
  type = object({
    enabled        = optional(bool, true)
    release_name   = optional(string, "kedacore")
    namespace      = optional(string, "keda")
    deploy_example = optional(bool, true)
    manifest_path  = optional(string, "keda.yaml")
    chart_version  = optional(string, "")
  })
  default = {}
}

# OpenCost configuration
variable "opencost" {
  description = "OpenCost module configuration"
  type = object({
    enabled       = optional(bool, true)
    release_name  = optional(string, "opencost-charts")
    namespace     = optional(string, "opencost")
    chart_version = optional(string, "")
    values        = optional(any, {})
  })
  default = {}
}

# Kepler configuration
variable "kepler" {
  description = "Kepler module configuration"
  type = object({
    enabled             = optional(bool, true)
    release_name        = optional(string, "kepler-operator")
    namespace           = optional(string, "kepler-operator")
    values              = optional(any, {})
    chart_version       = optional(string, "")
    deploy_powermonitor = optional(bool, true)
  })
  default = {}
}

# Scaphandre configuration
variable "scaphandre" {
  description = "Scaphandre module configuration"
  type = object({
    enabled       = optional(bool, true)
    release_name  = optional(string, "scaphandre")
    namespace     = optional(string, "scaphandre")
    chart_version = optional(string, "")
    values        = optional(any, {})
  })
  default = {}
}

# KubeGreen configuration
variable "kubegreen" {
  description = "KubeGreen module configuration"
  type = object({
    enabled       = optional(bool, true)
    release_name  = optional(string, "kube-green")
    namespace     = optional(string, "kube-green")
    chart_version = optional(string, "")
    values        = optional(any, {})
  })
  default = {}
}
