# ------------------------------------------------------------------------------
# Category: Kubernetes Configuration
# ------------------------------------------------------------------------------
variable "kubectl_config_path" {
  description = "Path to kubectl config file"
  type        = string
  default     = "~/.kube/config"
}

variable "kubectl_context" {
  description = "Kubectl context to use for deployment. If not specified, uses current context."
  type        = string
  default     = null
}

# ------------------------------------------------------------------------------
# Category: Observability & Scaling Infrastructure
# ------------------------------------------------------------------------------
# RECOMMENDED: Start here! Enable Prometheus first to gain visibility into your cluster.
# Prometheus is the foundation for most other GreenOps tools.
variable "observability" {
  description = "Observability and scaling tools - START HERE for adoption"
  type = object({
    prometheus = optional(object({
      enabled       = bool
      release_name  = optional(string, "prometheus-community")
      namespace     = optional(string, "monitoring")
      values        = optional(any, {})
      chart_version = optional(string, "")
    }), { enabled = true })
    keda = optional(object({
      enabled        = bool
      release_name   = optional(string, "kedacore")
      namespace      = optional(string, "keda")
      values         = optional(any, {})
      deploy_example = optional(bool, false) # Disabled by default to avoid unwanted scaling
      manifest_path  = optional(string, "keda.yaml")
      chart_version  = optional(string, "")
    }), { enabled = false }) # Disabled by default - enable once you have metrics
  })
  default = {}
}

# ------------------------------------------------------------------------------
# Category: Cost & Resource Efficiency
# ------------------------------------------------------------------------------
variable "cost_efficiency" {
  description = "Cost and resource efficiency tools - provides cost visibility"
  type = object({
    opencost = optional(object({
      enabled       = bool
      release_name  = optional(string, "opencost-charts")
      namespace     = optional(string, "opencost")
      chart_version = optional(string, "")
      values        = optional(any, {})
    }), { enabled = true }) # Enabled by default - provides valuable cost insights
  })
  default = {}
}

# ------------------------------------------------------------------------------
# Category: Energy & Power Monitoring
# ------------------------------------------------------------------------------
# RECOMMENDED: Kepler provides energy consumption metrics - essential for GreenOps!
variable "energy_power" {
  description = "Energy and power monitoring tools - measure actual power consumption"
  type = object({
    kepler = optional(object({
      enabled             = bool
      release_name        = optional(string, "kepler-operator")
      namespace           = optional(string, "kepler-operator")
      values              = optional(any, {})
      chart_version       = optional(string, "")
      deploy_powermonitor = optional(bool, true)
    }), { enabled = true }) # Enabled by default - core GreenOps observability
    scaphandre = optional(object({
      enabled       = bool
      release_name  = optional(string, "scaphandre")
      namespace     = optional(string, "scaphandre")
      chart_version = optional(string, "")
      values        = optional(any, {})
    }), { enabled = false }) # Disabled - overlaps with Kepler, enable if you need both
  })
  default = {}
}

# ------------------------------------------------------------------------------
# Category: Carbon & Emissions Estimation
# ------------------------------------------------------------------------------
variable "carbon_emissions" {
  description = "Carbon and emissions estimation tools - track carbon footprint"
  type = object({
    carbon_intensity_exporter = optional(object({
      enabled       = bool
      release_name  = optional(string, "carbon-intensity-exporter")
      namespace     = optional(string, "carbon-intensity-exporter")
      chart_version = optional(string, "")
      values        = optional(any, {})
    }), { enabled = false }) # Disabled - useful for carbon-aware scheduling (advanced)
    cloud_carbon_footprint = optional(object({
      enabled       = bool
      release_name  = optional(string, "cloud-carbon-footprint")
      namespace     = optional(string, "cloud-carbon-footprint")
      chart_version = optional(string, "")
      values        = optional(any, {})
    }), { enabled = false }) # Disabled - requires cloud provider API credentials
    codecarbon = optional(object({
      enabled         = bool
      name            = optional(string, "codecarbon")
      namespace       = optional(string, "codecarbon")
      image           = optional(string, "fabiocicerchia/codecarbon:latest")
      api_endpoint    = optional(string, "https://api.codecarbon.io")
      organization_id = optional(string, "")
      project_id      = optional(string, "")
      experiment_id   = optional(string, "")
      api_key         = optional(string, "")
    }), { enabled = true }) # Enabled - provides application-level carbon observability
  })
  default   = {}
  sensitive = true
}

# ------------------------------------------------------------------------------
# Category: Sustainability Optimisation & Automation
# ------------------------------------------------------------------------------
# ⚠️  WARNING: These tools perform automated actions (scaling, shutdown)
# Only enable after you understand your metrics and have established baselines
variable "sustainability_optimisation" {
  description = "Sustainability optimisation and automation tools - ADVANCED: automated resource management"
  type = object({
    kubegreen = optional(object({
      enabled       = bool
      release_name  = optional(string, "kube-green")
      namespace     = optional(string, "kube-green")
      chart_version = optional(string, "")
      values        = optional(any, {})
    }), { enabled = false }) # Disabled - performs automated shutdown, enable after observing your workloads
  })
  default = {}
}
