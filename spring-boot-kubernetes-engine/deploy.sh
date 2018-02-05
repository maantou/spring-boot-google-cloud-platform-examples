#!/usr/bin/env bash

BUCKET=spring-boot
JAR=spring-boot-kubernetes-engine-0.0.1-SNAPSHOT.jar
VM=spring-boot

mvn package

gsutil mb gs://${BUCKET}
gsutil cp ./target/${JAR} gs://${BUCKET}/${JAR}

gcloud compute firewall-rules update ${VM}-www --allow tcp:80 --target-tags ${VM}

gcloud compute instances create ${VM} \
  --tags ${VM} \
  --zone us-central1-a  --machine-type n1-standard-1 \
  --metadata-from-file startup-script=startup.sh
