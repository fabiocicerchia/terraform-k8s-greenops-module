# Outputs

The module provides outputs organized in nested objects for easy access to deployment information.

## Output Structure

### prometheus

Prometheus deployment information (if enabled):

```hcl
prometheus = {
  namespace    = string  # Kubernetes namespace
  release_name = string  # Helm release name
  version      = string  # Chart version
}
```

Access via: `module.greenops.prometheus.namespace`

### keda

KEDA deployment information (if enabled):

```hcl
keda = {
  namespace    = string  # Kubernetes namespace
  release_name = string  # Helm release name
  version      = string  # Chart version
}
```

Access via: `module.greenops.keda.namespace`

### opencost

OpenCost deployment information (if enabled):

```hcl
opencost = {
  namespace    = string  # Kubernetes namespace
  release_name = string  # Helm release name
  version      = string  # Chart version
}
```

Access via: `module.greenops.opencost.namespace`

### kepler

Kepler deployment information (if enabled):

```hcl
kepler = {
  namespace    = string  # Kubernetes namespace
  release_name = string  # Helm release name
  version      = string  # Chart version
}
```

Access via: `module.greenops.kepler.namespace`

### scaphandre

Scaphandre deployment information (if enabled):

```hcl
scaphandre = {
  namespace    = string  # Kubernetes namespace
  release_name = string  # Helm release name
  version      = string  # Chart version
}
```

Access via: `module.greenops.scaphandre.namespace`

### kubegreen

KubeGreen deployment information (if enabled):

```hcl
kubegreen = {
  namespace    = string  # Kubernetes namespace
  release_name = string  # Helm release name
  version      = string  # Chart version
}
```

Access via: `module.greenops.kubegreen.namespace`

### deployed_components

Status of all deployed components:

```hcl
deployed_components = {
  prometheus = bool  # Deployment status
  keda       = bool  # Deployment status
  opencost   = bool  # Deployment status
  kepler     = bool  # Deployment status
  scaphandre = bool  # Deployment status
  kubegreen  = bool  # Deployment status
}
```

### demo_app_deployed

Boolean indicating if the demo application was deployed.

## Using Outputs

### Display Deployment Info

Display all deployment information:

```hcl
output "deployment_info" {
  value = module.greenops
}
```

### Access Specific Component

Access information for a specific component:

```hcl
output "prometheus_namespace" {
  value = module.greenops.prometheus.namespace
}

output "kepler_version" {
  value = module.greenops.kepler.version
}
```

### Check Deployment Status

Check which components were deployed:

```hcl
output "components" {
  value = module.greenops.deployed_components
}
```

### Reference in Other Modules

Use outputs to configure other Terraform resources:

```hcl
resource "kubernetes_config_map" "app_config" {
  metadata {
    name      = "app-config"
    namespace = module.greenops.prometheus.namespace
  }

  data = {
    prometheus_url = "http://prometheus-community-kube-prometheus.${module.greenops.prometheus.namespace}.svc.cluster.local:9090"
  }
}
```
