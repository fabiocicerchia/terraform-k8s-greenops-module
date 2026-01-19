# Getting Started

## Requirements

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0 or [OpenTofu](https://opentofu.org/docs/intro/install/)
- [Kubernetes](https://kubernetes.io/) cluster (v1.24+)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/) configured to access your cluster
- [Helm](https://helm.sh/) (provider handles installation)

## Quick Start

### Basic Deployment (All Components)

Deploy all components with defaults:

```bash
terraform init
terraform apply
```

All six components (Prometheus, KEDA, OpenCost, Kepler, Scaphandre, and KubeGreen) are enabled by default.

### Custom Deployment

Disable specific components in `terraform.tfvars`:

```hcl
# terraform.tfvars
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

Then apply:

```bash
terraform apply
```

Or via command line:

```bash
terraform apply -var='keda={enabled=false}' \
                 -var='scaphandre={enabled=false}' \
                 -var='kubegreen={enabled=false}'
```

## Local Development with Minikube

### Start Minikube

```bash
minikube start --kubernetes-version=v1.34.0
minikube addons enable metrics-server
kubectl config use-context minikube && kubectl config current-context
```

### Deploy the Stack

```bash
terraform init
terraform apply
```

### Access Services Locally

Get Grafana admin password:

```bash
kubectl --namespace monitoring get secrets prometheus-community-grafana \
  -o jsonpath="{.data.admin-password}" | base64 -d ; echo
```

Port forward services:

```bash
kubectl port-forward -n monitoring svc/prometheus-community-grafana 3000:80
kubectl port-forward -n monitoring svc/prometheus-community-kube-prometheus 9090:9090
kubectl port-forward -n opencost svc/opencost 9090
```

Access Grafana at <http://localhost:3000> with default credentials: `admin` / `prom-operator`

## Next Steps

- See [CONFIGURATION.md](CONFIGURATION.md) for detailed configuration options
- See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues and solutions
- See [OUTPUTS.md](OUTPUTS.md) for accessing deployment information
