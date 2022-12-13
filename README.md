### About
This repository is responsible for:
- preparing local machine environment to run minikube cluster
- creating Kubernetes infrastructure for other components

### Installation
Prerequisites:
- WSL enabled on Windows
- [Docker](https://www.docker.com/products/docker-desktop/) installed
- [minikube](https://minikube.sigs.k8s.io/docs/start/) installed
- [X Window System](https://sourceforge.net/projects/vcxsrv/) installed

Setup:
- create "recipe" directory on C drive
- press Win+R
- type ```shell:startup```
- copy hajle-silesia-x11-config.xlaunch and hajle-silesia-autostart.sh into Autostart folder
- execute cluster-start.sh

Result:
- hajle-silesia cluster should be spin in minikube and it should start automatically with OS start
- location for importing XML BeerSmith recipe from local machine to minikube host should be created in C:/recipe
