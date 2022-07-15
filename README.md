# Cloud Build Multi-arch Demo

This demo creates a [multi-arch docker image](https://docs.docker.com/desktop/multi-arch/) using 
[Cloud Build](https://cloud.google.com/build/).

The trick is twofold:
1. Use a [build config](https://cloud.google.com/build/docs/building/build-containers#use-buildconfig), rather than a 
   [plain Dockerfile](https://cloud.google.com/build/docs/building/build-containers#use-dockerfile) 
   when configuring Cloud Build. This allows you to specify additional parameters to Docker, such as the architecture
2. Use the [docker docker container](https://hub.docker.com/_/docker), rather than the 
   [Cloud Build docker builder container](https://github.com/GoogleCloudPlatform/cloud-builders/tree/master/docker).

## Setup

1. Enable Artifcat Registry: https://console.cloud.google.com/apis/api/artifactregistry.googleapis.com
2. Wait about 15min for API propagaion to complete
3. Create a new repository (mine was named "test") at https://console.cloud.google.com/artifacts/docker
4. Replace the image path `us-central1-docker.pkg.dev/gke-autopilot-test/test/hello-ma` in the sample code with your own a) project, and b) repository.
   i.e. `us-central1-docker.pkg.dev/PROJECT_ID/REPO_NAME/hello-ma`

## Building

```
gcloud builds submit --config cloudbuild.yaml .
```

## Deploying to GKE

Create an [Arm-capable cluster](https://wdenniss.com/arm-on-autopilot).

```
kubectl create -f pod-arm.yaml
kubectl create -f pod-x86.yaml
```

## Inspecting

```
$ kubectl get pods -w
NAME     READY   STATUS      RESTARTS   AGE
armpod   0/1     Completed   0          9s
x86pod   0/1     Completed   0          13s
$ kubectl logs armpod
Hello World
$ kubectl logs x86pod
Hello World
```
