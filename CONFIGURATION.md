# Configuration

## Module Variables

### Global Settings

- `kubeconfig_path` (string) - Path to kubeconfig file (default: `~/.kube/config`)

### Prometheus Configuration
```hcl
prometheus = {
  enabled      = bool      # Enable Prometheus (default: true)
  release_name = string    # Helm release name (default: "prometheus-community")
  namespace    = string    # Kubernetes namespace (default: "monitoring")
  chart_version = string   # Helm chart version (default: "" for latest)
  values       = object    # Helm chart values (see defaults in variables.tf)
}
```

### KEDA Configuration
```hcl
keda = {
  enabled        = bool    # Enable KEDA (default: true)
  release_name   = string  # Helm release name (default: "kedacore")
  namespace      = string  # Kubernetes namespace (default: "keda")
  chart_version  = string  # Helm chart version (default: "" for latest)
  values         = object  # Helm chart values
  deploy_example = bool    # Deploy example KEDA scalers (default: true)
  manifest_path  = string  # Path to KEDA manifest (default: "keda.yaml")
}
```

### OpenCost Configuration
```hcl
opencost = {
  enabled       = bool     # Enable OpenCost (default: true)
  release_name  = string   # Helm release name (default: "opencost-charts")
  namespace     = string   # Kubernetes namespace (default: "opencost")
  chart_version = string   # Helm chart version (default: "" for latest)
  values        = object   # Helm chart values with carbon cost enabled
}
```

### Kepler Configuration
```hcl
kepler = {
  enabled             = bool    # Enable Kepler (default: true)
  release_name        = string  # Helm release name (default: "kepler-operator")
  namespace           = string  # Kubernetes namespace (default: "kepler-operator")
  chart_version       = string  # Helm chart version (default: "" for latest)
  values              = object  # Helm chart values
  deploy_powermonitor = bool    # Deploy Kepler power monitor (default: true)
}
```

### Scaphandre Configuration
```hcl
scaphandre = {
  enabled       = bool      # Enable Scaphandre (default: true)
  release_name  = string    # Helm release name (default: "scaphandre")
  namespace     = string    # Kubernetes namespace (default: "scaphandre")
  chart_version = string    # Helm chart version (default: "" for latest)
  values        = object    # Helm chart values
}
```

### KubeGreen Configuration
```hcl
kubegreen = {
  enabled       = bool      # Enable KubeGreen (default: true)
  release_name  = string    # Helm release name (default: "kube-green")
  namespace     = string    # Kubernetes namespace (default: "kube-green")
  chart_version = string    # Helm chart version (default: "" for latest)
  values        = object    # Helm chart values
}
```

## Chart Version Management

All modules support `chart_version` parameter:

- **Empty string (`""`)** - Deploy with the latest available Helm chart version (default)
- **Specific version** - Pin to an exact version (e.g., `"50.0.0"`)
- **Configurable at all levels** - Set globally in `terraform.tfvars` or per-module

### Example: Pin Chart Versions

```hcl
prometheus = {
  enabled       = true
  chart_version = "51.0.0"
}

keda = {
  enabled       = true
  chart_version = "2.12.0"
}

opencost = {
  enabled       = true
  chart_version = "1.15.0"
}
```

## Advanced Configuration

### Custom Helm Values

Override default Helm chart values:

```hcl
prometheus = {
  enabled = true
  values = {
    prometheus = {
      prometheusSpec = {
        retention = "30d"
        storageSpec = {
          volumeClaimTemplate = {
            spec = {
              storageClassName = "fast-ssd"
              resources = {
                requests = {
                  storage = "50Gi"
                }
              }
            }
          }
        }
      }
    }
  }
}
```

### Using Different Git References

Deploy from a specific tag or branch:

Create `terraform.tfvars`:

```hcl
git_ref = "v1.0.0"  # or "develop", or "abc1234" for commit SHA
```

Or via CLI:

```bash
terraform apply -var='git_ref=v1.0.0'
```

## Selective Deployment

### Disable via terraform.tfvars

```hcl
prometheus = {
  enabled = true
}

keda = {
  enabled = false  # Disable KEDA
}

opencost = {
  enabled = true
}

kepler = {
  enabled = true
}

scaphandre = {
  enabled = false  # Disable Scaphandre
}

kubegreen = {
  enabled = false  # Disable KubeGreen
}
```

### Disable via CLI

```bash
terraform apply -var='keda={enabled=false}' \
                 -var='scaphandre={enabled=false}' \
                 -var='kubegreen={enabled=false}'
```

## Use Case Presets

### Complete Monitoring Stack

Deploy all modules for comprehensive monitoring, cost tracking, and optimization:

```hcl
# terraform.tfvars
prometheus = { enabled = true }
keda = { enabled = true }
opencost = { enabled = true }
kepler = { enabled = true }
scaphandre = { enabled = true }
kubegreen = { enabled = true }
```

### Cost & Carbon Tracking Only

Enable Prometheus (for metrics) and OpenCost (for costs):

```hcl
prometheus = { enabled = true }
keda = { enabled = false }
opencost = { enabled = true }
kepler = { enabled = false }
scaphandre = { enabled = false }
kubegreen = { enabled = false }
```

### Sustainability Focus

Enable environmental impact tracking with Kepler and Scaphandre:

```hcl
prometheus = { enabled = true }
kepler = { enabled = true }
scaphandre = { enabled = true }
kubegreen = { enabled = true }
keda = { enabled = false }
opencost = { enabled = false }
```

### Development Environment

Minimal setup for testing, with cost optimization:

```hcl
prometheus = { enabled = true }
kubegreen = { enabled = true }  # Reduce costs during off-hours
keda = { enabled = false }
opencost = { enabled = false }
kepler = { enabled = false }
scaphandre = { enabled = false }
```
