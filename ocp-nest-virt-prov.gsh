gcloud compute disks create crc-v4 --<<NAME OF THE GCP PROJECT HERE>> ubuntu-os-cloud --image-family ubuntu-1804-lts --zone us-central1-a
gcloud compute images create crc-v4-virt   --source-disk crc-v4 --source-disk-zone us-central1-a   --licenses "https://compute.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"

#use this image to create a vm instance 
