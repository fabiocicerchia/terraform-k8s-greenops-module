# Troubleshooting

## Common Issues

## Kubernetes Access Issues

### kubeconfig not found

**Symptoms**: `Error: Kubernetes cluster unreachable` or `kubeconfig: no such file`

**Solutions**:
```bash
# Set kubeconfig path
export KUBECONFIG=~/.kube/config

# Verify cluster access
kubectl cluster-info
kubectl auth can-i create deployments
```

### Authentication failed

**Symptoms**: `error: Unable to connect to the server` or `certificate verify failed`

**Solutions**:
```bash
# Check current context
kubectl config current-context

# List available contexts
kubectl config get-contexts

# Switch to correct context
kubectl config use-context <context-name>

# Verify credentials
kubectl auth can-i get pods
```

## Deployment Issues

### Helm release failed to install

**Symptoms**: `Error: release failed to install` or chart not found

**Solutions**:
```bash
# Update Helm repositories
helm repo update

# Verify chart exists
helm search repo kube-prometheus-stack
helm search repo opencost

# Check Helm provider configuration
terraform plan -var='kubeconfig_path=~/.kube/config'
```

### Namespace creation failures

**Symptoms**: `Error creating namespace: namespaces "monitoring" already exists`

**Solutions**:
```bash
# Check existing namespace
kubectl get ns monitoring -o yaml

# Either use a different namespace or remove the existing one
kubectl delete ns monitoring

# Wait for deletion to complete
kubectl get ns
```

## Resource Issues

### Insufficient memory

**Symptoms**: Pod stuck in `Pending` state, `FailedScheduling` events

**Solutions**:
```bash
# Check node resources
kubectl top nodes
kubectl describe nodes

# Check Pod events
kubectl describe pod -n monitoring <pod-name>

# Check available storage
kubectl get pvc -A

# Reduce resource requirements in configuration
# See CONFIGURATION.md for custom values examples
```

### Insufficient storage

**Symptoms**: `FailedCreatePodSandBox` or `FailedAttachVolume`

**Solutions**:
```bash
# Check storage classes
kubectl get storageclass

# Check PersistentVolumeClaims
kubectl get pvc -A

# Check PersistentVolumes
kubectl get pv

# Check events for storage issues
kubectl describe pvc -n monitoring <pvc-name>
```

## Component-Specific Issues

### Prometheus

**Targets showing as "Down"**

```bash
# Port-forward to Prometheus
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090

# Check Prometheus logs
kubectl logs -n monitoring -l app.kubernetes.io/name=prometheus

# Verify ServiceMonitor configuration
kubectl get servicemonitor -n monitoring

# Check target details in UI at http://localhost:9090/targets
```

**No metrics being scraped**

```bash
# Verify Prometheus config
kubectl exec -n monitoring prometheus-0 -- cat /etc/prometheus/prometheus.yml

# Check for scrape errors
kubectl logs -n monitoring -l app.kubernetes.io/name=prometheus | grep scrape

# Verify kubelet metrics endpoint
curl http://localhost:10250/metrics --insecure | head -20
```

### Grafana

**Cannot access Grafana dashboard**

```bash
# Port-forward to Grafana
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80

# Check Grafana pod status
kubectl get pod -n monitoring -l app.kubernetes.io/name=grafana
kubectl logs -n monitoring -l app.kubernetes.io/name=grafana

# Verify service exists
kubectl get svc -n monitoring
```

**Default credentials not working**

```bash
# Check Grafana admin secret
kubectl get secret -n monitoring prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 -d

# Reset admin password
kubectl exec -n monitoring <grafana-pod> -- grafana-cli admin reset-admin-password <new-password>
```

### KEDA

**KEDA not scaling workloads**

```bash
# Check KEDA deployment
kubectl get pods -n keda
kubectl logs -n keda -l app=keda-operator

# View ScaledObjects
kubectl get scaledobjects -A
kubectl describe scaledobject -n <namespace> <name>

# Check KEDA operator events
kubectl get events -n keda
```

### OpenCost

**No cost data showing**

```bash
# Check OpenCost pod
kubectl get pods -n opencost
kubectl logs -n opencost -l app=opencost

# Verify Prometheus connection
kubectl logs -n opencost -l app=opencost | grep prometheus

# Check OpenCost API
kubectl port-forward -n opencost svc/opencost 9090:9090
curl http://localhost:9090/healthz
```

### Kepler

**Kepler not collecting metrics**

```bash
# Check Kepler pod
kubectl get pods -n kepler-operator
kubectl logs -n kepler-operator -l app=kepler

# Check PowerMonitor (if enabled)
kubectl get powermonitors -A
kubectl describe powermonitor -A

# Verify cert-manager is running
kubectl get pods -n cert-manager
```

### Scaphandre

**Scaphandre DaemonSet not running**

```bash
# Check Scaphandre DaemonSet
kubectl get ds -n scaphandre
kubectl describe ds -n scaphandre scaphandre

# Check logs
kubectl logs -n scaphandre -l app=scaphandre --tail=50

# Verify node compatibility
kubectl get nodes
kubectl describe node <node-name>
```

### KubeGreen

**Pods not being hibernated**

```bash
# Check KubeGreen pod
kubectl get pods -n kube-green
kubectl logs -n kube-green -l app.kubernetes.io/name=kube-green

# Check SleepInfos
kubectl get sleepinfos -A
kubectl describe sleepinfo -n <namespace> <name>

# Check KubeGreen events
kubectl get events -n kube-green
```

## Debugging Workflows

### Check Overall Deployment Status

```bash
# Check all deployments across namespaces
kubectl get deployments -A

# Check all pods
kubectl get pods -A

# Check all services
kubectl get svc -A
```

### View Comprehensive Logs

```bash
# Prometheus logs
kubectl logs -n monitoring -l app.kubernetes.io/name=prometheus --tail=50

# Kepler logs
kubectl logs -n kepler-operator -l app=kepler --tail=50

# OpenCost logs
kubectl logs -n opencost -l app=opencost --tail=50

# KEDA logs
kubectl logs -n keda -l app=keda-operator --tail=50
```

### Check System Events

```bash
# View all recent events
kubectl get events -A --sort-by='.lastTimestamp'

# Check for errors
kubectl get events -A --sort-by='.lastTimestamp' | grep Error
```

### Verify Metrics Collection

```bash
# Port forward Prometheus
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090

# Visit http://localhost:9090 and check:
# - Status > Targets (see scrape jobs)
# - Status > Configuration (see prometheus config)
# - Graph (query metrics)
```

## Cleanup

### Remove All Deployments

```bash
# Destroy Terraform resources
terraform destroy

# Verify removal
kubectl get deployments -A
kubectl get ns monitoring
```

### Reset and Redeploy

```bash
# Remove namespaces completely
kubectl delete ns monitoring opencost kepler-operator keda scaphandre kube-green --ignore-not-found=true

# Wait for deletion
kubectl get ns

# Reapply Terraform
terraform apply
```

### Remove Individual Components

```bash
# Disable and reapply
terraform apply -var='kepler={enabled=false}'

# Or manually delete namespace
kubectl delete ns kepler-operator
```

## Getting Help

### Check Terraform State

```bash
# View state
terraform state list
terraform state show module.greenops

# Refresh state
terraform refresh
```

### Debug Terraform

```bash
# Enable debug logging
export TF_LOG=DEBUG
terraform apply

# Unset debug logging
unset TF_LOG
```

### Verify Configuration

```bash
# Validate Terraform
terraform validate

# Format check
terraform fmt -check -recursive

# Plan without applying
terraform plan
```
