# AKS WordPress/Nginx Reverse Proxy + LetsEncrypt SSL Demo

## In this demo
- Install Kubernetes
- Install Cert Manager
- Install Ingress Nginx Controller
- Create Lets Encrypt SSL Cluster Issuer
- Deploy MariaDB
- Deploy Bitnami WordPress/Nginx
- Update DNS Provider with A record resolving to the ingress-nginx controller

#### Install Kubernetes
```console
az aks create \
    --resource-group networkwatcherrg \
    --subscription Yearly \
    --name yokubix \
    --location eastus2 \
    --node-vm-size Standard_D2s_v3 \
    --node-count 1 \
    --max-pods 50 \
    --generate-ssh-keys \
    --enable-workload-identity \
    --enable-oidc-issuer \
    --enable-aad \
    --aad-admin-group-object-ids 65e4b1b3-ccc2-4697-bf33-d006405c6a88
```

#### Install Cert Manager
```console
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.5/cert-manager.yaml
```

#### Install Ingress Nginx Controller
```console
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/cl
oud/deploy.yaml
```

#### Create Let's Encrypt Cluster Issuer
```console
kubectl apply -f cluster-prod.yaml` and `kubectl apply -f cluster-staging.yaml
```

#### Deploy WordPress + MariaDB
```console
kubectl apply -f mariadb-volume.yaml
kubectl apply -f mariadb-claim.yaml
kubectl apply -f mariadb-service.yaml
kubectl apply -f mariadb-deployment.yaml

kubectl apply -f wordpress-volume.yaml
kubectl apply -f wordpress-claim.yaml
kubectl apply -f wordpress-ingress.yaml
kubectl apply -f wordpress-service.yaml
kubectl apply -f wordpress-deployment.yaml
```

#### Update DNS
```console
kubectl get ingress
```
- Find the external IP address of the ingress-nginx-controller
- Add an A record in your DNS
