. ./load_env.sh
minikube start --driver=docker --memory 1800m --profile $PROFILE
minikube ssh -p $PROFILE -- '[ ! -d "/data/file_content_monitor" ] && sudo mkdir /data/file_content_monitor'
minikube -p $PROFILE mount "C:/recipe:/data/file_content_monitor" &