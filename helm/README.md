## Installation
Nécessite kubernetes et helm installés avec un environnement kubernetes configuré

### Création des secrets docker-registry
` kubectl create secret docker-registry regdev --docker-server=ghcr.io --docker-username=${GITHUB_USRNAME} --docker-password=${GITHUB_TOKEN} --docker-email=${EMAIL} `  
` kubectl create secret docker-registry regcred --docker-server=ghcr.io --docker-username=${GITHUB_USRNAME} --docker-password=${GITHUB_TOKEN} --docker-email=${EMAIL} `  

### Création des namespaces
` kubectl create namespace dev `  
` kubectl create namespace staging `  

### Installation des helm-charts et création des namespaces
Depuis le dossier parent des deux projets:
#### Environnement dev
` helm install dev-back Projet_4_Back_End/helm -n dev -f Projet_4_Back_End/helm/values-base.yaml -f Projet_4_Back_End/helm/values-dev.yaml `  
` helm install dev-front Projet_4_Front_End/helm -n dev -f Projet_4_Front_End/helm/values-base.yaml -f Projet_4_Front_End/helm/values-dev.yaml `
#### Environnement staging
` helm install staging-back Projet_4_Back_End/helm -n staging -f Projet_4_Back_End/helm/values-base.yaml -f Projet_4_Back_End/helm/values-staging.yaml `  
` helm install staging-front Projet_4_Front_End/helm -n staging -f Projet_4_Front_End/helm/values-base.yaml -f Projet_4_Front_End/helm/values-staging.yaml `  

## Mise à jour des images Docker
#### Environnement dev
Faire un restart des déploiements des pods front et back utilisant les images avec les commandes:
` kubectl rollout restart deployment/olympic-games-app-deployment -n dev `  
` kubectl rollout restart deployment/workshop-organizer-app-deployment -n dev `  
#### Environnement staging
Mettre à jour la version de l'image dans les deux fichiers `values-staging.yaml` puis relancer les deux commandes d'installation

## Configuration des environnements
### Environnement dev
- 500Mo de storage pour le volume de la bdd
- 1 replica pour l'application Spring et 1 pour l'application Angular
- Clé docker `regdev`
- Image docker basée sur le dernier commit de la branche `dev`
### Environnement staging
- 1Go de storage pour le volume de la bdd
- 3 replicas pour l'application Spring et 3 pour l'application Angular
- Clé docker `regcred`
- Image docker basée sur la version `1.1.0`, montée de version à faire manuellement