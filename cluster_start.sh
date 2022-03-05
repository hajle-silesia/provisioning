. ./load_env.sh
minikube start --driver=hyperv --memory 2000m --profile $PROFILE
minikube ssh -p $PROFILE -- '[ ! -d "/data/file_content_monitor" ] && sudo mkdir /data/file_content_monitor'
minikube -p $PROFILE mount "C:/recipe:/data/file_content_monitor" &