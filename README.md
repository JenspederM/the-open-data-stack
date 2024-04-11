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

## The `justfile`

The justfile is used the manage the lifecycle of the stack. It is a simple way to define and run tasks. The `just` command is a CLI tool that reads the `justfile` and executes the tasks defined within it.

Additionally, it defines the versions of the stack components that are used to deploy the stack. These versions are used to fetch the default `values.yaml` files for each component and later to deploy the stack.

To modify the versions of the stack components, update the `justfile` with the desired versions.

```bash
# Defaults
PLATFORM_NAMESPACE:="platform" # Reserves the namespace for the platform components (e.g. Ingress, Cert-Manager, Operators)
CONFIG_PATH:="config" # Path to the configuration files

# Versions
CERT_MANAGER_VERSION:="<version>"
NGINX_VERSION:="<version>"
MINIO_VERSION:="<version>"
JUPYTERHUB_VERSION:="<version>"

# Commands
...
```

## The `config` directory

The `config` directory contains the default `values.yaml` files for each versioned stack component. These files are used to deploy the stack.

To fetch the default `values.yaml` files for each component, run the following command:

```bash
just get-config
```

This will fetch the default `values.yaml` files for each component and save them to the `config/default` directory named according to `<stack>-<version>.yaml`.

### `config/<environment>` directories

In addition to the `config/default` directory, there are directories for each environment that contain overrides for the default `values.yaml` files. These overrides are used to deploy the stack under a specific environment. For example, the `config/local` directory contains the overrides for the `local` environment.

To deploy the stack under a specific environment, run the following command:

```bash
just start mycompany env="local"
```

This will deploy the stack using the default `values.yaml` files and the overrides found in the `config/local` directory.

> Note: The `env` flag is optional. If not provided, the stack will be deployed using the local `values.yaml` files.
> Note: The `name` flag is required. It is used to name the tenant and namespace.
> Note: value override files must be named according to `<stack>-<version>.yaml`.
