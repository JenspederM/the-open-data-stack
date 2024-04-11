CONFIG_PATH:="config"
CERT_MANAGER_VERSION:="v1.14.4"
NGINX_VERSION:="4.10.0"
MINIO_VERSION:="5.0.14"
JUPYTERHUB_VERSION:="3.3.7"

# This namespace will contain operaters and other cluster-wide resources
PLATFORM_NAMESPACE:="platform"

default: 
    @just --list

init:
    @echo "Initializing the project from config at $(CONFIG_PATH)"
    @echo ""
    @echo "Components:"
    @echo "    - Cert-Manager ({{MINIO_VERSION}})"
    @echo "    - Nginx ({{MINIO_VERSION}})"
    @echo "    - MinIO Operator ({{MINIO_VERSION}})"
    @echo "    - MinIO Tenant ({{MINIO_VERSION}})"
    @echo "    - JupyterHub ({{MINIO_VERSION}})"
    @echo ""
    @echo ""

    helm repo add jetstack https://charts.jetstack.io
    helm repo add nginx https://kubernetes.github.io/ingress-nginx
    helm repo add minio https://operator.min.io
    helm repo add jupyterhub https://hub.jupyter.org/helm-chart/
    helm repo update

    @echo ""
    @echo "Creating the cluster"
    k3d cluster create -c cluster.yaml || "Cluster already exists"

    just get-config

forget:
    @echo "Deleting the cluster and all resources"
    k3d cluster delete -c cluster.yaml

get-minio-jwt:
    kubectl -n {{PLATFORM_NAMESPACE}} get secret console-sa-secret -o jsonpath="{.data.token}" | base64 --decode

get-config:
    @echo "Getting versioned config from the helm charts"
    mkdir -p {{CONFIG_PATH}}/default
    helm show values minio/operator --version {{MINIO_VERSION}} > {{CONFIG_PATH}}/default/minio-operator-{{MINIO_VERSION}}.yaml
    helm show values nginx/ingress-nginx --version {{NGINX_VERSION}} > {{CONFIG_PATH}}/default/nginx-{{NGINX_VERSION}}.yaml
    helm show values jetstack/cert-manager --version {{CERT_MANAGER_VERSION}} > {{CONFIG_PATH}}/default/cert-manager-{{CERT_MANAGER_VERSION}}.yaml
    helm show values minio/tenant --version {{MINIO_VERSION}} > {{CONFIG_PATH}}/default/minio-tenant-{{MINIO_VERSION}}.yaml
    helm show values jupyterhub/jupyterhub --version {{JUPYTERHUB_VERSION}} > {{CONFIG_PATH}}/default/jupyterhub-{{JUPYTERHUB_VERSION}}.yaml

install env="local":
    just _install "ingress-nginx" "{{env}}" "{{PLATFORM_NAMESPACE}}" "nginx/ingress-nginx" "{{NGINX_VERSION}}" "nginx-{{NGINX_VERSION}}.yaml"
    just _install "cert-manager" "{{env}}" "{{PLATFORM_NAMESPACE}}" "jetstack/cert-manager" "{{CERT_MANAGER_VERSION}}" "cert-manager-{{CERT_MANAGER_VERSION}}.yaml"
    just _install "minio-operator" "{{env}}" "{{PLATFORM_NAMESPACE}}" "minio/operator" "{{MINIO_VERSION}}" "minio-operator-{{MINIO_VERSION}}.yaml"

tenant-add name env="local":
    just _install "minio-{{name}}" "{{env}}" "tenant-{{name}}" "minio/tenant" "{{MINIO_VERSION}}" "minio-tenant-{{MINIO_VERSION}}.yaml"
    just _install "jupyter-{{name}}" "{{env}}" "tenant-{{name}}" "jupyterhub/jupyterhub" "{{JUPYTERHUB_VERSION}}" "jupyterhub-{{JUPYTERHUB_VERSION}}.yaml"

_install name env="local" namespace="{{PLATFORM_NAMESPACE}}" chart="minio-operator" version="{{MINIO_VERSION}}" config="config/default/minio-operator-15.0.14.yaml":
    helm upgrade --install {{name}} {{chart}} --namespace {{namespace}} --create-namespace --version {{version}} -f {{CONFIG_PATH}}/default/{{config}} -f {{CONFIG_PATH}}/{{env}}/{{config}}
