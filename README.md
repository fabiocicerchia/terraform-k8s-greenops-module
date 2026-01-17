# TF Kubernetes GreenOps Module

A comprehensive Terraform module for deploying a complete environmental impact monitoring and cost tracking stack on Kubernetes clusters. This module orchestrates four specialized sub-modules to provide visibility into your cluster's energy consumption, operational costs, and environmental impact.

## Overview

The GreenOps Module provides a unified way to deploy and manage:

- **Prometheus** - Metrics collection and storage with `kube-prometheus-stack`
- **KEDA** - Kubernetes Event Driven Autoscaling with optional example deployments
- **OpenCost** - Cost monitoring and allocation with carbon cost tracking
- **Kepler** - Environmental impact tracking via the Kepler Operator with optional power monitoring
- **Scaphandre** - Container-level power consumption monitoring
- **KubeGreen** - Automated resource cleanup and pod hibernation for cost optimization

All components are **enabled by default** and can be selectively disabled based on your requirements.

## Features

- 🟢 **Modular Architecture** - Deploy only the components you need
- 🔧 **Flexible Configuration** - HCL-based values configuration with sensible defaults
- 🔄 **Dynamic Git References** - Support for branches, tags, and commits
- 📊 **Integrated Monitoring** - Pre-configured metric scraping and alerting
- 💰 **Cost Visibility** - Track Kubernetes resource costs and carbon footprint
- 🚀 **Production Ready** - Enterprise-grade deployments with proper namespacing

## Requirements

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0 or [OpenTofu](https://opentofu.org/docs/intro/install/)
- [Kubernetes](https://kubernetes.io/) cluster (v1.24+)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/) configured to access your cluster
- [Helm](https://helm.sh/) (provider handles installation)

## Quick Start

### Basic Deployment (All Components)

```hcl
# Deploy all components with defaults
terraform init
terraform apply
```

All six components (Prometheus, KEDA, OpenCost, Kepler, Scaphandre, and KubeGreen) are enabled by default.

### Custom Deployment

```hcl
# terraform.tfvars - Disable specific components
prometheus = {
  enabled = true
}

keda = {
  enabled = true
}

opencost = {
  enabled = false  # Disable OpenCost
}

kepler = {
  enabled = true
}

scaphandre = {
  enabled = true
}

kubegreen = {
  enabled = false  # Disable KubeGreen
}
```

### Local Development with Minikube

Boot your minikube cluster:

```bash
minikube start --kubernetes-version=v1.32.0
kubectl config use-context minikube && kubectl config current-context
```

Deploy the stack:

```bash
terraform init
terraform apply
```

Expose services locally:

```bash
# Get Grafana password
kubectl --namespace monitoring get secrets prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo

# Port forward services
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80 & \
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090 & \
kubectl port-forward -n opencost svc/opencost 9090
```

Access Grafana at <http://localhost:3000>

## Configuration

### Module Variables

#### Global Settings

- `kubeconfig_path` (string) - Path to kubeconfig file (default: `~/.kube/config`)

#### Prometheus Configuration
```hcl
prometheus = {
  enabled      = bool      # Enable Prometheus (default: true)
  release_name = string    # Helm release name (default: "prometheus-community")
  namespace    = string    # Kubernetes namespace (default: "monitoring")
  values       = object    # Helm chart values (see defaults in variables.tf)
}
```

#### KEDA Configuration
```hcl
keda = {
  enabled        = bool    # Enable KEDA (default: true)
  release_name   = string  # Helm release name (default: "kedacore")
  namespace      = string  # Kubernetes namespace (default: "keda")
  values         = object  # Helm chart values
  deploy_example = bool    # Deploy example KEDA scalers (default: true)
  manifest_path  = string  # Path to KEDA manifest (default: "keda.yaml")
}
```

#### OpenCost Configuration
```hcl
opencost = {
  enabled      = bool      # Enable OpenCost (default: true)
  release_name = string    # Helm release name (default: "opencost-charts")
  namespace    = string    # Kubernetes namespace (default: "opencost")
  values       = object    # Helm chart values with carbon cost enabled
}
```

#### Kepler Configuration
```hcl
kepler = {
  enabled             = bool    # Enable Kepler (default: true)
  release_name        = string  # Helm release name (default: "kepler-operator")
  namespace           = string  # Kubernetes namespace (default: "kepler-operator")
  values              = object  # Helm chart values
  deploy_powermonitor = bool    # Deploy Kepler power monitor (default: true)
  chart_version       = string  # Helm chart version (default: "" for latest)
}
```

#### Scaphandre Configuration
```hcl
scaphandre = {
  enabled       = bool      # Enable Scaphandre (default: true)
  release_name  = string    # Helm release name (default: "scaphandre")
  namespace     = string    # Kubernetes namespace (default: "scaphandre")
  values        = object    # Helm chart values
  chart_version = string    # Helm chart version (default: "" for latest)
}
```

#### KubeGreen Configuration
```hcl
kubegreen = {
  enabled       = bool      # Enable KubeGreen (default: true)
  release_name  = string    # Helm release name (default: "kube-green")
  namespace     = string    # Kubernetes namespace (default: "kube-green")
  values        = object    # Helm chart values
  chart_version = string    # Helm chart version (default: "" for latest)
}
```

#### Chart Version Management
All modules support `chart_version` parameter:
- **Empty string (`""`)** - Deploy with the latest available Helm chart version (default)
- **Specific version** - Pin to an exact version (e.g., `"50.0.0"`)
- **Configurable at all levels** - Set globally in `terraform.tfvars` or per-module

### Selective Deployment

Disable specific components using `terraform.tfvars`:

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

Or via command line:

```bash
terraform apply -var='keda={enabled=false}' \
                 -var='scaphandre={enabled=false}' \
                 -var='kubegreen={enabled=false}'
```

## Outputs

The module provides outputs organized in nested objects:

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
Boolean indicating if the demo application was deployed

## Grafana Dashboards

Import these community dashboards for visualization:

- [Kepler Main Dashboard](https://raw.githubusercontent.com/sustainable-computing-io/kepler-operator/main/hack/dashboard/assets/kepler/dashboard.json)
- [Kepler Prometheus Dashboard](https://raw.githubusercontent.com/sustainable-computing-io/kepler-operator/main/hack/dashboard/assets/prometheus/dashboard.json)
- [Ariewald Kepler Dashboard](https://raw.githubusercontent.com/ariewald/kepler-grafana-dashboard/refs/heads/main/kepler.json)
- [Energy K8s Experiments Dashboard](https://raw.githubusercontent.com/bernardodon/energy-k8s-experiments/refs/heads/main/grafana-setup.json)

## Architecture

```
greenops (root module)
├── prometheus (Metrics collection)
├── keda (Event-driven autoscaling)
├── opencost (Cost & carbon tracking)
├── kepler (Environmental impact tracking)
├── scaphandre (Container-level power monitoring)
├── kubegreen (Resource cleanup & pod hibernation)
└── demo_app (Optional Google microservices demo)
```

### Dependencies

- Cert Manager is automatically deployed as a dependency of Kepler
- Prometheus ServiceMonitors are configured for all components
- All components can be independently enabled/disabled

## Advanced Usage

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

## Troubleshooting

### Check Deployment Status

```bash
# Check all deployments
kubectl get deployments -A

# Check specific namespace
kubectl get pods -n monitoring
kubectl get pods -n keda
kubectl get pods -n opencost
kubectl get pods -n kepler-operator
```

### View Logs

```bash
# Prometheus logs
kubectl logs -n monitoring -l app.kubernetes.io/name=prometheus

# Kepler logs
kubectl logs -n kepler-operator -l app.kubernetes.io/name=kepler

# OpenCost logs
kubectl logs -n opencost -l app=opencost
```

### Verify Metrics

```bash
# Port forward Prometheus
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090

# Visit http://localhost:9090 and check Status > Targets
```

## Contributing

Contributions are welcome! Please submit pull requests to the [GitHub repository](https://github.com/fabiocicerchia/kepler-module).

## License

Copyright 2026 Fabio Cicerchia.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Resources

- [Prometheus Helm Chart](https://github.com/prometheus-community/helm-charts)
- [KEDA Helm Chart](https://github.com/kedacore/charts)
- [OpenCost Helm Chart](https://github.com/opencost/opencost-helm-chart)
- [Kepler Helm Chart](https://github.com/sustainable-computing-io/kepler)
