az login
az acr login --name luxurai.azurecr.io
docker build -t wordpress-nginx -f wordpressNginx.Dockerfile .
docker tag wordpress-nginx luxurai.azurecr.io/wordpress-nginx:latest
docker push luxurai.azurecr.io/wordpress-nginx:latest
