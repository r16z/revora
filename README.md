# Revora
A Kubernetes-native platform ecosystem leveraging GitOps, centralized identity, and service mesh principles using K3s, Argo CD, Keycloak, and Istio.

## Core Services

| Service | URL |
|---|---|
| ArgoCD | https://argocd.r16z.org |
| Keycloak | https://auth.r16z.org/auth |
| Gatus | https://status.r16z.org |

## Implementation Summary
- Provisioned a K3s cluster on a GCP Compute Engine instance.
- Integrated the compute instance into the Tailscale network for secure remote kubectl access.
- Deployed Sealed Secrets for GitOps-compatible secret management.
- Deployed CloudNativePG and provisioned a single-node PostgreSQL cluster for Keycloak and Gatus.
- Deployed Keycloak with PostgreSQL as the backing datastore.
- Deployed Argo CD for GitOps-based application delivery.
- Generated wildcard TLS certificates for r16z.org, stored them in K3s, and configured them through Traefik TLSStore.
- Exposed Keycloak and ArgoCD via Traefik ingress routing.
- Integrated Keycloak with ArgoCD using the OIDC authentication flow.
- Created a dedicated repository containing Kubernetes manifests for Gatus deployment.
- Deployed Stakater Reloader to enable automatic rollout restarts on ConfigMap updates.
- Configured a dedicated ArgoCD application for automated Gatus deployment into K3s.
- Configured DNS A records for Keycloak, ArgoCD, and Gatus endpoints.
- Deployed Istio and enabled automatic sidecar injection for Keycloak, ArgoCD, Gatus, Traefik, and PostgreSQL workloads.

## Keycloak <-> ArgoCD OIDC Authentication & Authorization Flow

```
User -> ArgoCD -> Keycloak (OIDC) -> Signed JWT Tokens -> Token Validation -> RBAC Mapping -> Authorized Session
```

### Flow
1. User accesses Argo CD through the Traefik ingress endpoint.
2. ArgoCD detects the absence of an authenticated session and initiates the OIDC Authorization Code Flow with Keycloak as the centralized Identity Provider (IdP).
3. The user is securely redirected to Keycloak, where authentication is performed independently of ArgoCD, ensuring credential isolation and centralized identity management.
4. Upon successful authentication, Keycloak issues cryptographically signed JWT tokens containing identity, group, role, and authorization claims.
5. The browser is redirected back to ArgoCD with a temporary authorization code, which is securely exchanged for ID and access tokens over TLS-protected channels.
6. ArgoCD validates:
- JWT signature integrity
- token expiration (exp)
- issuer (iss)
- audience (aud)
- nonce and OIDC claims
- configured scopes and redirect URIs
7. ArgoCD extracts group and role claims from the validated JWT and maps them to internal RBAC policies for fine-grained authorization control.
8. A trusted authenticated session is established, and access is granted strictly based on centrally managed RBAC permissions.

## Helm Repos

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

### Traefik
```
helm repo add traefik https://traefik.github.io/charts
helm repo update
helm fetch --untar traefik/traefik --version 40.0.1
```

