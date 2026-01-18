# TF Kubernetes GreenOps Module

A comprehensive Terraform module for deploying a complete environmental impact monitoring and cost tracking stack on Kubernetes clusters. This module orchestrates six specialized sub-modules to provide visibility into your cluster's energy consumption, operational costs, and environmental impact.

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

## Quick Links

- 📖 [Getting Started](GETTING_STARTED.md) - Quick start and setup instructions
- 🔧 [Configuration](CONFIGURATION.md) - Detailed configuration options and variables
- 📤 [Outputs](OUTPUTS.md) - Available output values and how to use them
- ✅ [Requirements](REQUIREMENTS.md) - Technical requirements and dependencies
- 🆘 [Troubleshooting](TROUBLESHOOTING.md) - Common issues and solutions

## Quick Start

### Basic Deployment

```bash
terraform init
terraform apply
```

All six components (Prometheus, KEDA, OpenCost, Kepler, Scaphandre, and KubeGreen) are enabled by default.

See [GETTING_STARTED.md](GETTING_STARTED.md) for detailed setup instructions.

## Module Details

### Prometheus
Monitoring and metrics collection powered by `kube-prometheus-stack`. Includes Prometheus, Grafana, and Alertmanager. Essential foundation for the entire monitoring stack.

**Use case**: When you need comprehensive cluster metrics, visualization, and alerting capabilities.

### KEDA
Kubernetes Event Driven Autoscaling enables scaling based on events and external metrics, not just CPU/memory. Includes optional example deployments.

**Use case**: When you need to autoscale workloads based on event sources (queues, schedules, metrics) or custom metrics.

### OpenCost
Cloud cost monitoring and allocation with carbon footprint tracking. Integrates with Prometheus for cost visibility.

**Use case**: When you need to track infrastructure costs and carbon emissions by workload, namespace, or pod.

### Kepler
Kubernetes Environmental Power Profiling Operator tracks environmental impact and power consumption. Includes optional PowerMonitor resource for detailed power metrics.

**Use case**: When you want to monitor and optimize the energy efficiency and environmental impact of your Kubernetes cluster.

### Scaphandre
Container-level power consumption monitoring using CPU models and turbostat. Provides granular power usage data.

**Use case**: When you need detailed power consumption data at the container or process level.

### KubeGreen
Automated resource cleanup and pod hibernation for cost optimization. Automatically sleeps and wakes workloads on schedules.

**Use case**: When you want to reduce costs by automatically sleeping non-production workloads during off-hours.

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

## Grafana Dashboards

Import these community dashboards for visualization:

- [Kepler Main Dashboard](https://raw.githubusercontent.com/sustainable-computing-io/kepler-operator/main/hack/dashboard/assets/kepler/dashboard.json)
- [Kepler Prometheus Dashboard](https://raw.githubusercontent.com/sustainable-computing-io/kepler-operator/main/hack/dashboard/assets/prometheus/dashboard.json)
- [Ariewald Kepler Dashboard](https://raw.githubusercontent.com/ariewald/kepler-grafana-dashboard/refs/heads/main/kepler.json)
- [Energy K8s Experiments Dashboard](https://raw.githubusercontent.com/bernardodon/energy-k8s-experiments/refs/heads/main/grafana-setup.json)
- [OpenCost Dashboards](https://github.com/opencost/opencost/tree/develop/dashboard)

## Contributing

Contributions are welcome! Please submit pull requests to the [GitHub repository](https://github.com/fabiocicerchia/tf-k8s-greenops-module).

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
- [Scaphandre Repository](https://github.com/hubblo-org/scaphandre)
- [KubeGreen Repository](https://github.com/kube-green/kube-green)
