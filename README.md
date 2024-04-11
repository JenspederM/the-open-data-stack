# The Open Data Stack

The ambition of this project is to provide a data platform built solely on free-to-use
open source technologies.

The stack will include the following layers:

- A storage layer that can be used to store data in a variety of formats.
  - Minio
- A compute layer that can be used to process data stored in the storage layer.
  - JupyterHub
- A catalog layer that can be used to discover data stored in the storage layer.
- A visualization layer that can be used to visualize data stored in the storage layer.

## Storage

The storage layer will be built on Minio.

### Installation

First we need to install the Minio operator following this guide [here](https://min.io/docs/minio/kubernetes/upstream/operations/install-deploy-manage/deploy-operator-helm.html#minio-k8s-deploy-operator-helm).

```bash
# Add the MinIO Helm repository
helm repo add minio-operator https://operator.min.io/

# Save the values.yaml
helm show values minio-operator/operator --version 5.0.12 > minio-operator.local.yaml

# Install the MinIO Operator
helm upgrade --install minio-operator minio-operator/operator --values minio-operator.local.yaml
```

Then we can install the Minio instance following this guide [here](https://min.io/docs/minio/kubernetes/upstream/operations/install-deploy-manage/deploy-minio-helm.html#minio-k8s-deploy-minio-helm).

```bash
# Save the values.yaml
helm show values minio-operator/tenant --version 5.0.12 > minio-tenant.local.yaml

# Install the MinIO Tenant
helm upgrade --install minio-tenant minio-operator/tenant --values minio-tenant.local.yaml
```
