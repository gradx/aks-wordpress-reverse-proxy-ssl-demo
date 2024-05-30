kubectl delete -f wordpress-deployment.yaml
kubectl delete -f wordpress-claim.yaml
kubectl delete -f wordpress-volume.yaml
kubectl delete -f wordpress-ingress.yaml
kubectl delete -f wordpress-service.yaml
kubectl delete -f wordpress-deployment.yaml

kubectl delete -f mariadb-deployment.yaml
kubectl delete -f mariadb-claim.yaml
kubectl delete -f mariadb-volume.yaml
kubectl delete -f mariadb-service.yaml

kubectl delete -f cluster-staging.yaml
kubectl delete -f cluster-prod.yaml

kubectl apply -f cluster-staging.yaml
kubectl apply -f cluster-prod.yaml

kubectl apply -f mariadb-volume.yaml
kubectl apply -f mariadb-claim.yaml
kubectl apply -f mariadb-service.yaml
kubectl apply -f mariadb-deployment.yaml

kubectl apply -f wordpress-volume.yaml
kubectl apply -f wordpress-claim.yaml
kubectl apply -f wordpress-ingress.yaml
kubectl apply -f wordpress-service.yaml
kubectl apply -f wordpress-deployment.yaml
