PROFILE=hajle-silesia
minikube stop -p $PROFILE
minikube start -p $PROFILE
minikube -p $PROFILE mount "C:/recipe:/data/file_content_monitor" &