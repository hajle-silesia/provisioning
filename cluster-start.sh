PROFILE=hajle-silesia
minikube start --driver=hyperv --memory 2.5g --profile $PROFILE
minikube ssh -p $PROFILE -- '[ ! -d "/data/file_content_monitor" ] && sudo mkdir /data/file_content_monitor'

kubectl apply -f file-content-monitor-pv.yml
kubectl apply -f file-content-monitor-pvc.yml
minikube -p $PROFILE mount "C:/recipe:/data/file_content_monitor" &