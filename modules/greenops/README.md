# GreenOps Module

Comprehensive Terraform module for deploying a complete green operations monitoring stack on Kubernetes. Includes Prometheus, KEDA, OpenCost, Kepler Operator, Scaphandre, and KubeGreen with individual toggles for selective component deployment.

## Features

- **Selective Deployment**: Enable or disable components individually via feature toggles
- **Prometheus Monitoring**: Complete monitoring and metrics stack with Grafana
- **KEDA Autoscaling**: Event-driven workload scaling with optional examples
- **OpenCost**: Cloud cost monitoring and allocation with carbon tracking
- **Kepler Operator**: Environmental impact and power consumption tracking
- **Scaphandre**: Container-level power consumption monitoring
- **KubeGreen**: Automated resource cleanup and pod hibernation
- **Flexible Configuration**: Customize each component independently with HCL values

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| helm | >= 2.0 |
| null | >= 3.0 |

### External Requirements

- [kubectl](https://kubernetes.io/docs/tasks/tools/) - For interacting with your Kubernetes cluster
- [Kubernetes cluster](https://kubernetes.io/docs/setup/) - A running Kubernetes cluster (v1.24+)

## Usage

### Deploy All Components (Default)

```hcl
module "greenops" {
  source = "https://github.com/fabiocicerchia/terraform-kubernetes-greenops.git?ref=main"
}
```

All six components (Prometheus, KEDA, OpenCost, Kepler, Scaphandre, and KubeGreen) are **enabled by default**.

### Disable Specific Components

```hcl
module "greenops" {
  source = "https://github.com/fabiocicerchia/terraform-kubernetes-greenops.git?ref=main"

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
    enabled = true
  }
}
```

### Custom Configuration

```hcl
module "greenops" {
  source = "https://github.com/fabiocicerchia/terraform-kubernetes-greenops.git?ref=main"

  prometheus = {
    enabled      = true
    namespace    = "custom-monitoring"
    release_name = "prom"
    values = {
      prometheus = {
        prometheusSpec = {
          retention = "30d"
        }
      }
    }
  }

  keda = {
    enabled        = true
    namespace      = "custom-keda"
    deploy_example = false
    values         = {}
  }

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

  kepler = {
    enabled             = true
    namespace           = "sustainability"
    deploy_powermonitor = true
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| prometheus | Prometheus module configuration | `object({...})` | `{ enabled = true, ... }` | no |
| keda | KEDA module configuration | `object({...})` | `{ enabled = true, ... }` | no |
| opencost | OpenCost module configuration | `object({...})` | `{ enabled = true, ... }` | no |
| kepler | Kepler module configuration | `object({...})` | `{ enabled = true, ... }` | no |
| scaphandre | Scaphandre module configuration | `object({...})` | `{ enabled = true, ... }` | no |
| kubegreen | KubeGreen module configuration | `object({...})` | `{ enabled = true, ... }` | no |

### Detailed Input Schema

#### prometheus
```hcl
prometheus = {
  enabled      = bool                    # Enable Prometheus (default: true)
  release_name = string                  # Helm release name (default: "prometheus-community")
  namespace    = string                  # Kubernetes namespace (default: "monitoring")
  values       = any                     # Helm chart values (default: {...})
}
```

#### keda
```hcl
keda = {
  enabled        = bool                  # Enable KEDA (default: true)
  release_name   = string                # Helm release name (default: "kedacore")
  namespace      = string                # Kubernetes namespace (default: "keda")
  values         = any                   # Helm chart values (default: {})
  deploy_example = bool                  # Deploy example manifests (default: true)
  manifest_path  = string                # Path to example manifest (default: "keda.yaml")
}
```

#### opencost
```hcl
opencost = {
  enabled      = bool                    # Enable OpenCost (default: true)
  release_name = string                  # Helm release name (default: "opencost-charts")
  namespace    = string                  # Kubernetes namespace (default: "opencost")
  values       = any                     # Helm chart values (default: {...})
}
```

#### kepler
```hcl
kepler = {
  enabled             = bool             # Enable Kepler (default: true)
  release_name        = string           # Helm release name (default: "kepler-operator")
  namespace           = string           # Kubernetes namespace (default: "kepler-operator")
  values              = any              # Helm chart values (default: {...})
  deploy_powermonitor = bool             # Deploy PowerMonitor (default: true)
}
```

#### scaphandre
```hcl = bool                    # Enable Scaphandre (default: true)
  release_name  = string                  # Helm release name (default: "scaphandre")
  namespace     = string                  # Kubernetes namespace (default: "scaphandre")
  values        = any                     # Helm chart values (default: {})
  chart_version = string                  # Helm chart version (default: "" for latest)
}
```

#### kubegreen
```hcl
kubegreen = {
  enabled       = bool                    # Enable KubeGreen (default: true)
  release_name  = string                  # Helm release name (default: "kube-green")
  namespace     = string                  # Kubernetes namespace (default: "kube-green")
  values        = any                     # Helm chart values (default: {})
  chart_version = string                  # Helm chart version (default: "" for latest)
}
```

#### Chart Version Management

All modules support `chart_version` parameter:
- **Empty string (`""`)** - Deploy with the latest available Helm chart version (default)
- **Specific version** - Pin to an exact version (e.g., `"50.0.0"`)

Example:
```hcl
prometheus = {
  enabled       = true
  chart_version = "55.0.0"  # Pin to specific version
}

keda = {
  enabled       = true
  chart_version = ""        # Use latest (defaultube-green")
  namespace    = string                  # Kubernetes namespace (default: "kube-green")
  values       = any                     # Helm chart values (default: {})
}
```

## Outputs

The module provides outputs organized in nested objects for better structure:

### prometheus
Prometheus module outputs (if enabled):
```hcl
prometheus = {
  namespace    = string  # Kubernetes namespace where Prometheus is deployed
  release_name = string  # Helm release name of Prometheus
  version      = string  # Chart version deployed
}
```

### keda
KEDA module outputs (if enabled):
```hcl
keda = {
  namespace    = string  # Kubernetes namespace where KEDA is deployed
  release_name = string  # Helm release name of KEDA
  version      = string  # Chart version deployed
}
```

### opencost
OpenCost module outputs (if enabled):
```hcl
opencost = {
  namespace    = string  # Kubernetes namespace where OpenCost is deployed
  release_name = string  # Helm release name of OpenCost
  version      = string  # Chart version deployed
}
```

### kepler
Kepler module outputs (if enabled):
```hcl
kepler = {
  namespace    = string  # Kubernetes namespace where Kepler is deployed
  release_name = string  # Helm release name of Kepler
  version      = string  # Chart version deployed
}
```

### scaphandre
Scaphandre module outputs (if enabled):
```hcl
scaphandre = {
  namespace    = string  # Kubernetes namespace where Scaphandre is deployed
  release_name = string  # Helm release name of Scaphandre
  version      = string  # Chart version deployed
}
```

### kubegreen
KubeGreen module outputs (if enabled):
```hcl
kubegreen = {
  namespace    = string  # Kubernetes namespace where KubeGreen is deployed
  release_name = string  # Helm release name of KubeGreen
  version      = string  # Chart version deployed
}
```

### deployed_components
Map showing which components are enabled:
```hcl
deployed_components = {
  prometheus = bool  # true if Prometheus is enabled
  keda       = bool  # true if KEDA is enabled
  opencost   = bool  # true if OpenCost is enabled
  kepler     = bool  # true if Kepler is enabled
  scaphandre = bool  # true if Scaphandre is enabled
  kubegreen  = bool  # true if KubeGreen is enabled
}
```

## Architecture

```
greenops (orchestration module)
├── prometheus (metrics collection)
├── keda (event-driven autoscaling)
├── opencost (cost & carbon tracking)
├── kepler (environmental impact tracking)
└── demo_app (optional sample workload)
```

### Module Dependencies

- **Cert Manager**: Automatically deployed as a dependency of Kepler Operator
- **Prometheus ServiceMonitors**: Configured for all components when enabled
- **Demo App**: Depends on greenops module completion

## Configuration Examples

### Minimal Deployment

Only enable Prometheus for basic monitoring:

```hcl
module "greenops" {
  source = "https://github.com/fabiocicerchia/terraform-kubernetes-greenops.git?ref=main"

  prometheus = { enabled = true }
  keda       = { enabled = false }
  opencost   = { enabled = false }
  kepler     = { enabled = false }
}
```

### Cost Tracking Focus

Enable Prometheus and OpenCost for cost visibility:

```hcl
module "greenops" {
  source = "https://github.com/fabiocicerchia/terraform-kubernetes-greenops.git?ref=main"

  prometheus = { enabled = true }
  opencost   = { enabled = true }
}
```

### Sustainability Monitoring

Complete stack for environmental tracking:

```hcl
module "greenops" {
  source = "https://github.com/fabiocicerchia/terraform-kubernetes-greenops.git?ref=main"

  # All enabled by default, just provide custom values if needed
  prometheus = {
    enabled = true
  }

  opencost = {
    enabled = true
  }

  kepler = {
    enabled = true
  }

  scaphandre = {
    enabled = true  # Enable for container-level power monitoring
  }

  kubegreen = {
    enabled = true  # Enable for resource cleanup and pod hibernation
  }
}

  opencost = {
    enabled = true
  }

  kepler = {
    enabled = true
  }
}
```

## Using Different Git References

Deploy from specific tags, branches, or commits:

```hcl
module "greenops" {
  source = "https://github.com/fabiocicerchia/terraform-kubernetes-greenops.git?ref=v1.0.0"
  # or use: ref=develop, ref=main, ref=abc1234 (commit SHA)
}
```

## Troubleshooting

### Check Deployment Status

```bash
# Check all pods across all namespaces
kubectl get pods -A

# Check specific component namespaces
kubectl get pods -n monitoring      # Prometheus
kubectl get pods -n keda            # KEDA
kubectl get pods -n opencost        # OpenCost
kubectl get pods -n kepler-operator # Kepler
kubectl get pods -n scaphandre      # Scaphandre
kubectl get pods -n kube-green      # KubeGreen
```

### View Component Logs

```bash
# Prometheus
kubectl logs -n monitoring -l app.kubernetes.io/name=prometheus --tail=100

# KEDA
kubectl logs -n keda -l app=keda-operator --tail=100

# OpenCost
kubectl logs -n opencost -l app=opencost --tail=100

# Kepler
kubectl logs -n kepler-operator -l app.kubernetes.io/name=kepler --tail=100

# Scaphandre
kubectl logs -n scaphandre -l app=scaphandre --tail=100

# KubeGreen
kubectl logs -n kube-green -l app.kubernetes.io/name=kube-green --tail=100
```

### Access Services Locally

```bash
# Prometheus
kubectl port-forward -n monitoring svc/prometheus-community-kube-prometheus 9090:9090

# Grafana (part of Prometheus)
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80

# OpenCost UI
kubectl port-forward -n opencost svc/opencost 9090
```

### Debug Component Issues

```bash
# Describe pods to see events
kubectl describe pod -n monitoring <pod-name>

# Check resource requests/limits
kubectl get pods -n monitoring -o json | grep -A5 "resources"

# Check ServiceMonitor status
kubectl get servicemonitor -A

# Check Helm releases
helm list -A
```

## Related Resources

- [Prometheus Community Helm Charts](https://github.com/prometheus-community/helm-charts)
- [KEDA Documentation](https://keda.sh/)
- [OpenCost Project](https://www.opencost.io/)
- [Kepler Project](https://sustainable-computing.io/)
- [Scaphandre Repository](https://github.com/hubblo-org/scaphandre)
- [KubeGreen Repository](https://github.com/kube-green/kube-green)
