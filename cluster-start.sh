PROFILE=hajle-silesia
minikube start --driver=hyperv --memory 2.5g --profile $PROFILE
minikube ssh -p $PROFILE -- \
'[ ! -d "/data/file_content_monitor" ] && sudo mkdir /data/file_content_monitor;
[ ! -d "/data/file_content_converter" ] && sudo mkdir /data/file_content_converter;
[ ! -d "/data/file_content_processor" ] && sudo mkdir /data/file_content_processor;'

minikube -p $PROFILE mount "C:/recipe:/data/recipe" &