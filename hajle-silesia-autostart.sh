export PROFILE=hajle-silesia
minikube stop -p $PROFILE
minikube start -p $PROFILE
minikube -p $PROFILE mount "/mnt/c/recipe:/data/recipe" &