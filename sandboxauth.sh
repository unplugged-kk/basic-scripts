#!/bin/bash

echo -n "Enter Sandbox Project ID "
read PROJECT_ID

#export SA=tf-acg-gcp-sandboxecho " User id is $USER"echo " Project id is $PROJECT_ID"#echo " Service Account id is $SA"echo " Enabling necessary APIS "

gcloud services enable container.googleapis.com storage.googleapis.com anthos.googleapis.com anthosgke.googleapis.com cloud.googleapis.com cloudresourcemanager.googleapis.com containerregistry.googleapis.com file.googleapis.com ; gcloud services list --enabled

#echo " Creating Service Account "

#gcloud iam service-accounts create $SA --display-name="$SA"

#gcloud projects add-iam-policy-binding $PROJECT_ID \
#    --member="serviceAccount:$SA@$PROJECT_ID.iam.gserviceaccount.com" \
#    --role="roles/owner"

#gcloud iam service-accounts keys create acgsandbox.json \
#        --iam-account=$SA@$PROJECT_ID.iam.gserviceaccount.com

#cloudshell download acgsandbox.json

echo " Creating GKE Sandbox Cluster "

gcloud beta container --project $PROJECT_ID clusters create acg-sandbox-gke --zone "us-central1-c" --no-enable-basic-auth --cluster-version "1.20.8-gke.900" --release-channel "regular" --machine-type "e2-standard-2" --image-type "COS_CONTAINERD" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/cloud-platform" --max-pods-per-node "110" --num-nodes "3" --enable-stackdriver-kubernetes --enable-ip-alias --network "projects/$PROJECT_ID/global/networks/default" --subnetwork "projects/$PROJECT_ID/regions/us-central1/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,Istio,ApplicationManager,GcePersistentDiskCsiDriver --istio-config auth=MTLS_PERMISSIVE --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --enable-autoprovisioning --min-cpu 1 --max-cpu 1 --min-memory 1 --max-memory 1 --enable-autoprovisioning-autorepair --enable-autoprovisioning-autoupgrade --autoprovisioning-max-surge-upgrade 1 --autoprovisioning-max-unavailable-upgrade 0 --enable-vertical-pod-autoscaling --enable-shielded-nodes --node-locations "us-central1-c"
