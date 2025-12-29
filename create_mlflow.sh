#!/bin/bash

# Configuration
INSTANCE_NAME="mlflow-simple"
ZONE="europe-north2-a"

gcloud compute instances create $INSTANCE_NAME \
    --zone=$ZONE \
    --machine-type=e2-micro \
    --provisioning-model=SPOT \
    --instance-termination-action=STOP \
    --tags=http-server \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata=startup-script='#! /bin/bash
        apt-get update && apt-get install -y python3-pip htop
        pip3 install mlflow
        mkdir -p /home/mlflow_data
        mlflow server --backend-store-uri sqlite:////home/mlflow_data/mlruns.db --default-artifact-root /home/mlflow_data/artifacts --host 0.0.0.0 --port 80 &
    '

gcloud compute firewall-rules create allow-mlflow-80 \
    --action=ALLOW \
    --rules=tcp:80 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=http-server

echo "Waiting for VM..."
sleep 15
gcloud compute instances list --filter="name=$INSTANCE_NAME" --format="value(networkInterfaces[0].accessConfigs[0].natIP)"
