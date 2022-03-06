PROFILE=hajle-silesia
minikube start -p $PROFILE
minikube -p $PROFILE mount "C:/recipe:/data/file_content_monitor" &