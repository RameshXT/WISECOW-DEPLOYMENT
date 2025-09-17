---

# Wisecow Deployment Project

This project sets up a CI/CD pipeline for deploying the Wisecow application using Docker and Kubernetes. The pipeline automates the build and deployment processes with GitHub Actions, deploying the application to a Kind (Kubernetes IN Docker) cluster.

## Prerequisites

1. **Docker**: Ensure Docker is installed on your local machine.
2. **Kind**: Kubernetes IN Docker to create a local Kubernetes cluster.
3. **GitHub**: Repository with GitHub Actions configured.
4. **Docker Hub**: For storing the Docker image.

## Project Structure

```
.
├── .github
│   └── workflows
│       └── ci-cd.yaml
├── k8s
│   ├── deployment.yaml
│   └── service.yaml
|── ingress.yaml
|── app.py
├── Dockerfile
├── kind-config.yaml
└── wisecow.sh
```

### Dockerfile

- **Path**: `Dockerfile`
- **Description**: Builds the Docker image for the Wisecow application.
- **Key Code**: 
  ```dockerfile
  FROM python:3.9
  WORKDIR /app
  COPY requirements.txt ./
  RUN pip install -r requirements.txt
  COPY . .
  CMD ["python", "app.py"]
  ```

### Kubernetes Manifests

- **Deployment**: `k8s/deployment.yaml`
- **Service**: `k8s/service.yaml`

These files define how the Wisecow application is deployed and exposed within the Kubernetes cluster.

### CI/CD Pipeline

- **Path**: `.github/workflows/ci-cd.yaml`
- **Description**: Automates the Docker build, push, and deployment to Kind.
- **Key Code**:
  ```yaml
  name: CI/CD Pipeline

  on:
    push:
      branches:
        - main
    pull_request:
      branches:
        - main

  jobs:
    build:
      runs-on: ubuntu-latest
      steps:
        - name: Checkout code
          uses: actions/checkout@v3

        - name: Set up Docker Buildx
          uses: docker/setup-buildx-action@v2

        - name: Log in to Docker Hub
          uses: docker/login-action@v2
          with:
            username: ${{ secrets.DOCKER_HUB_USERNAME }}
            password: ${{ secrets.DOCKER_HUB_ACCESS_TOKEN }}

        - name: Build and push Docker image
          uses: docker/build-push-action@v4
          with:
            context: .
            file: Dockerfile
            push: true
            tags: ${{ secrets.DOCKER_HUB_USERNAME }}/wisecow:latest

    deploy:
      runs-on: ubuntu-latest
      needs: build
      steps:
        - name: Checkout code
          uses: actions/checkout@v3

        - name: Set up Kind
          run: |
            curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64
            chmod +x ./kind
            sudo mv ./kind /usr/local/bin/kind

        - name: Create Kind cluster
          run: |
            kind create cluster --config kind-config.yaml

        - name: Set up kubectl
          run: |
            curl -LO "https://dl.k8s.io/release/v1.27.3/bin/linux/amd64/kubectl"
            chmod +x ./kubectl
            sudo mv ./kubectl /usr/local/bin/kubectl

        - name: Deploy to Kubernetes
          run: |
            kubectl apply -f k8s/deployment.yaml
            kubectl apply -f k8s/service.yaml
            kubectl apply -f k8s/ingress.yaml
  ```

### Kind Configuration

- **Path**: `kind-config.yaml`
- **Description**: Configuration file for creating a Kind cluster.
- **Key Code**:
  ```yaml
  kind: Cluster
  apiVersion: kind.x.k8s.io/v1alpha4
  metadata:
    name: wisecow-cluster
  spec:
    controlPlane:
      extraPortMappings:
        - containerPort: 80
          hostPort: 80
          protocol: TCP
        - containerPort: 4499
          hostPort: 4499
          protocol: TCP
    nodes:
      - role: control-plane
        image: kindest/node:v1.27.3
        extraPortMappings:
          - containerPort: 8080
            hostPort: 8080
            protocol: TCP
  ```

### wisecow.sh

- **Path**: `wisecow.sh`
- **Description**: Script to run the Wisecow application inside the Docker container.
- **Key Code**:
  ```bash
  #!/usr/bin/env bash

  SRVPORT=4499
  RSPFILE=response

  rm -f $RSPFILE
  mkfifo $RSPFILE

  handleRequest() {
      read line
      echo $line

      mod=$(fortune)

      cat <<EOF > $RSPFILE
  HTTP/1.1 200 OK

  <pre>$(cowsay "$mod")</pre>
  EOF
  }

  prerequisites() {
      command -v cowsay >/dev/null 2>&1 && command -v fortune >/dev/null 2>&1 || {
          echo "Please install cowsay and fortune."
          exit 1
      }
  }

  main() {
      prerequisites
      echo "Wisdom served on port=$SRVPORT..."

      while true; do
          cat $RSPFILE | nc -lN $SRVPORT | handleRequest
          sleep 0.01
      done
  }

  main
  ```

## Setup Instructions

1. **Clone the Repository**:

   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Build and Push Docker Image**:

   ```bash
   docker build -t your_dockerhub_username/wisecow:latest .
   docker push your_dockerhub_username/wisecow:latest
   ```

3. **Set Up GitHub Actions**:
   - Ensure that the `.github/workflows/ci-cd.yaml` file is in place.
   - Add Docker Hub credentials as GitHub secrets:
     - `DOCKER_HUB_USERNAME`
     - `DOCKER_HUB_ACCESS_TOKEN`

4. **Create and Configure Kind Cluster**:
   - Ensure Kind is installed:
     ```bash
     curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64
     chmod +x ./kind
     sudo mv ./kind /usr/local/bin/kind
     ```
   - Create the Kind cluster:
     ```bash
     kind create cluster --config kind-config.yaml
     ```

5. **Deploy to Kubernetes**:
   - Apply Kubernetes manifests:
     ```bash
     kubectl apply -f k8s/deployment.yaml
     kubectl apply -f k8s/service.yaml
     kubectl apply -f k8s/ingress.yaml
     ```

6. **Access the Application**:
   - Port-forward to access the application locally:
     ```bash
     kubectl port-forward service/wisecow-service 8080:80
     ```
   - Open `http://localhost:8080` in your browser to view the application.

## Troubleshooting

- **If the port-forwarding fails**: Ensure that the pods are running and not in a `Pending` state. Check pod logs and events for errors.
- **If the application is not accessible**: Verify that the service and deployment configurations are correct and that the Docker image is correctly built and pushed.

---

