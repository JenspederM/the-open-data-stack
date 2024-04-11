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

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [k3d](https://k3d.io/#installation)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [helm](https://helm.sh/docs/intro/install/)
- [just](https://github.com/casey/just)

## Getting Started

Convenience functions that can be accessed through `just`:

- `just` Prints this help message
- `just destroy` Deletes the cluster and all associated resources
- `just get-config` Gets and saves the default `values.yaml` file associated with versioned stack components to the `config/default` directory as `<component>-<version>.yaml`
- `just get-minio-jwt` Get the decoded Minio JWT token for the Minio Operator
- `just init` Adds helm repos and initializes the cluster
- `just install env="local"` Installs core stack components, such as Ingress, Cert-Manager, and Operators under a specific environment
- `just start name env="local"` Runs `init`, `install`, and adds a tenant to the stack
- `just tenant-add name env="local"` Creates a namespace with a Minio tenant and JupyterHub instance

Running the stack locally:

```bash
### Initialize the stack
# This will add the necessary helm repos and initialize the cluster
# Next it will install the core stack components and add a tenant called `mycompany`
# It will use the overrides found in the `config/local` directory
just start mycompany env="local"
```

To add another tenant to the stack:

```bash
### Add a tenant to the stack
# This will create a namespace with a Minio tenant and JupyterHub instance
just tenant-add mycompany env="local"
```

To destroy the stack:

```bash
### Destroy the stack
# This will delete the cluster and all associated resources
just destroy
```
