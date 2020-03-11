gcloud compute disks create crc-disk --image-project ubuntu-os-cloud --image-family ubuntu-1804-lts --zone us-central1-a
gcloud compute images create crc-v4-image --source-disk crc-disk --source-disk-zone us-central1-a  --licenses "https://compute.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"

#use this image to create a vm instance 
