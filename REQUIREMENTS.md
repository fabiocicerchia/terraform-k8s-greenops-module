# Requirements

## Terraform

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| helm | >= 2.0 |

## External Requirements

### kubectl

Command-line tool for Kubernetes cluster management and interaction.

- **Installation**: [kubectl Installation Guide](https://kubernetes.io/docs/tasks/tools/)
- **Purpose**: Verify cluster access, manage Kubernetes resources
- **Minimal version**: 1.20+

### Kubernetes Cluster

A running Kubernetes cluster where components will be deployed.

- **Installation**: [Kubernetes Cluster Setup Guide](https://kubernetes.io/docs/setup/)
- **Minimal version**: 1.24+
- **Requirements**:
  - At least 4 GB available memory for full stack
  - At least 20 GB disk space for metrics storage
  - Network access to cluster API
  - Valid kubeconfig file for authentication

### Helm

Package manager for Kubernetes (provider handles installation).

- **Installation**: [Helm Installation Guide](https://helm.sh/docs/intro/install/)
- **Purpose**: Deploy Helm charts for components

## Provider Requirements

### Helm Provider

The Helm provider is used to deploy Helm charts for all components.

```hcl
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
  }
}
```

Configuration via kubeconfig:

```hcl
provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}
```

### Kubernetes Provider (optional)

For managing Kubernetes resources like namespaces:

```hcl
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}
```

### Null Provider (optional)

Used for local-exec provisioners in some configurations:

```hcl
terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
}
```

## Environment Setup

Ensure your environment is properly configured before deploying:

```bash
# Verify kubectl access
kubectl cluster-info

# Check kubeconfig location
echo $KUBECONFIG

# Check Kubernetes version
kubectl version --short

# Verify cluster nodes
kubectl get nodes
```

## Cluster Resource Requirements

### Minimum Requirements

For a basic deployment:

- **CPU**: 2 cores
- **Memory**: 4 GB
- **Storage**: 20 GB

### Recommended Requirements

For production deployment:

- **CPU**: 4+ cores
- **Memory**: 8+ GB
- **Storage**: 50+ GB

### Component-Specific Requirements

Each component has its own resource requirements:

- **Prometheus**: 1 CPU, 2 GB RAM, 10+ GB storage
- **Grafana**: 0.5 CPU, 512 MB RAM
- **KEDA**: 0.2 CPU, 256 MB RAM
- **OpenCost**: 0.5 CPU, 512 MB RAM
- **Kepler**: 0.5 CPU, 512 MB RAM
- **Scaphandre**: 0.5 CPU, 256 MB RAM (per node)
- **KubeGreen**: 0.5 CPU, 256 MB RAM

## Supported Kubernetes Versions

- Kubernetes v1.24+
- Currently tested on: v1.28, v1.29, v1.30, v1.31, v1.32

## Optional Tools

### For Local Development

- **Minikube**: [Minikube Installation Guide](https://minikube.sigs.k8s.io/docs/start/)
- **Kind**: [Kind Installation Guide](https://kind.sigs.k8s.io/docs/user/quick-start/)
- **Docker/Podman**: For running containers locally

### For Administration

- **Helm**: Direct Helm CLI for chart inspection and debugging
- **kubeconfig**: Multiple cluster contexts for multi-cluster management
