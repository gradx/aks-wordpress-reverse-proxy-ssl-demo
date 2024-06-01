# Azure Kubernetes Service + WordPress/Nginx Reverse Proxy + LetsEncrypt SSL Demo

A 7 step kismet with 6 lessons learned revisiting some prior work:

## Seven Simple Steps -- the "*SSS*" S-stack
- Install Kubernetes
- Login into AKS cluster
- Install Cert Manager
- Install Ingress Nginx Controller
- Update DNS Provider with A record resolving to the ingress-nginx controller
- Create Lets Encrypt SSL Cluster Issuer
- Deploy WordPress/Nginx + MariaDB

#### Install Kubernetes
```console
az aks create \
    --resource-group <ResourceGroup> \
    --subscription <SubscriptionName> \
    --name yokubix \
    --location eastus2 \
    --node-vm-size Standard_D2s_v3 \
    --node-count 1 \
    --max-pods 50 \
    --generate-ssh-keys \
    --enable-workload-identity \
    --enable-oidc-issuer \
    --enable-aad \
    --aad-admin-group-object-ids <Entra_Group_Id>
```
#### Login into AKS Cluster
```console
az aks get-credentials --resource-group networkwatcherrg --name yokubix
export KUBECONFIG=~/kube.config
kubelogin convert-kubeconfig -l azurecli
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

#### Update DNS Provider with A record resolving to the ingress-nginx controller
```console
kubectl get svc -n ingress-nginx
```
- Find the external IP address of the ingress-nginx-controller
  
  ![image](https://github.com/gradx/aks-wordpress-reverse-proxy-ssl-demo/assets/7133215/0aa78046-1bb3-40c6-914f-ed5b499b73cf)
- Add an A record in your DNS
  
![image](https://github.com/gradx/aks-wordpress-reverse-proxy-ssl-demo/assets/7133215/ea408b27-4874-4364-9557-d52021787b19)

#### Create Let's Encrypt Cluster Issuer
`kubectl apply -f cluster-prod.yaml` and `kubectl apply -f cluster-staging.yaml`

#### Deploy WordPress/Nginx + MariaDB
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
- **IMPORTANT** Update settings, especially in mariadb-deployment and wordpress-deployment.yaml

---

# Demo Complete
![Here](https://github.com/gradx/aks-wordpress-reverse-proxy-ssl-demo/blob/main/docs/Example.png)


---

### Lessons Learned
- `--aad-admin-group-object-ids` is required for [Entra](https://learn.microsoft.com/en-us/azure/aks/enable-authentication-microsoft-entra-id#non-interactive-sign-in-with-kubelogin) ID access
- Bitnami supports these settings to resolve infinite loop redirect issues with [HTTP_X_FORWARDED_PROTO](https://developer.wordpress.org/advanced-administration/security/https/)
```yaml
        - name: WORDPRESS_ENABLE_REVERSE_PROXY
          value: "yes"
        - name: WORDPRESS_ENABLE_HTTPS
          value: "yes"
```
- SecurityContext resolves permissions issues writing wp-config.php to the volumeMount `/bitnami/wordpress`
```yaml
    spec:
      securityContext:
        runAsUser: 1
        fsGroup: 0
```
- Annotations can vary to fix Nginx `client_max_body_size` based on your ingress nginx [controller](https://stackoverflow.com/a/73548785)
```yaml
    nginx.ingress.kubernetes.io/proxy-body-size: 80m
```
- Use of a [static](https://learn.microsoft.com/en-us/azure/aks/static-ip) IP for the ingress nginx controller is a best practice
- A [DaemonSet](https://techcommunity.microsoft.com/t5/azure-stack-blog/notes-from-the-field-nginx-ingress-controller-for-production-on/ba-p/3781350) ingress configuration is sometimes recommended
