### About
This repository is responsible for:
- preparing local machine environment to run minikube cluster
- creating Kubernetes infrastructure foundation for other components

Currently, all scripts are prepared to be run on Microsoft Windows OS. 

### Installation
Prerequisites:
- Hyper-V enabled and current user added to "Hyper-V Administrators" group
- [minikube](https://minikube.sigs.k8s.io/docs/start/) installed and default driver set to hyperv
- [X Window System](https://sourceforge.net/projects/vcxsrv/) installed

Setup:
- create "recipe" directory on C drive
- press Win+R
- type ```shell:startup```
- copy hajle-silesia-x11-config.xlaunch and hajle-silesia-autostart.sh into Autostart folder
- execute cluster_start.sh

Result:
- hajle-silesia cluster should be spin in minikube and it should start automatically with OS start
- location for importing XML BeerSmith recipe from local machine to minikube host should be created in C:/recipe
