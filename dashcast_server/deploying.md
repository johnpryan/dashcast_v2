**Note**: These instructions use Google Compute Engine,
but this is not the best way to run Dart servers on Google Cloud.

## Docker
Build docker image:

```
docker build -t dashcast .
```

Run:

```
docker run -i -t -p 8080:8080 dashcast
```

## Deploying

Upgrade `gcloud` components, if necessary

```
gcloud components update
```

Set region:

```
gcloud compute zones list
gcloud config set compute/region us-west1
gcloud config set compute/zone us-west1-a
```

Build docker image:

Set project:

```
gcloud config set project dashcast 
```

Login and set Docker credentials:

```
gcloud auth login
gcloud auth configure-docker
```

Upload to Google Container Registry:

```
docker tag dashcast gcr.io/dashcast/dashcast-container
docker push gcr.io/dashcast/dashcast-container
```

Verify:

```
gcloud container images list-tags gcr.io/dashcast/dashcast-container
```

## Deploying a new VM

```
gcloud compute instances create-with-container dashcast-vm \
 --zone=us-west1-a \
 --machine-type=e2-micro \
 --container-image gcr.io/dashcast/dashcast-container \
 --tags http-server
```

```
gcloud compute firewall-rules create allow-http \
 --allow tcp:8080 --target-tags http-server
```

## Deploying a new version

```
docker build -t dashcast .
```

```
docker tag dashcast gcr.io/dashcast/dashcast-container
docker push gcr.io/dashcast/dashcast-container
```

Update instance group:

```
gcloud compute instance-groups managed rolling-action restart instance-group-1 --zone=us-west1-b
```

## HTTPS

Set up an external load balancer:

https://cloud.google.com/load-balancing/docs/https/ext-https-lb-simple

Create a domain name with google domains, add A record to external IP address of
the load balancer

Create an Google-Managed SSL cert (requires a domain name)

https://cloud.google.com/load-balancing/docs/ssl-certificates/google-managed-certs
