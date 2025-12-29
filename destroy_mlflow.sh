#!/bin/bash

INSTANCE_NAME="mlflow-simple"
ZONE="europe-north2-a"
FIREWALL_RULE="allow-mlflow-80"

echo "Destroying resources..."

gcloud compute instances delete $INSTANCE_NAME \
    --zone=$ZONE \
    --quiet

gcloud compute firewall-rules delete $FIREWALL_RULE \
    --quiet

echo "✓ Resources destroyed. Billing stopped."
