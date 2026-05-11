# revora
A Kubernetes-native GitOps platform ecosystem

### CN-PG
```
helm repo add cnpg https://cloudnative-pg.github.io/charts
helm repo update
helm fetch --untar cnpg/cloudnative-pg --version 0.28.0
```

### Sealed Secrets
```
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm repo update
helm fetch --untar sealed-secrets/sealed-secrets --version 2.18.5
```

### Keycloak
```
helm repo add codecentric https://codecentric.github.io/helm-charts
helm repo update
helm fetch --untar codecentric/keycloakx --version 7.1.11
```

### ArgoCD
```
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm fetch --untar argo/argo-cd --version 9.5.13
```

### Stakater Reloader
```
helm repo add stakater https://stakater.github.io/stakater-charts
helm repo update
helm fetch --untar stakater/reloader --version 2.2.11
```