create-ns:
	kubectl create ns sealed-secrets || true
	kubectl create ns cnpg || true
	kubectl create ns keycloakx || true
	kubectl create ns argocd || true
	kubectl create ns reloader || true

install-sealed-secrets:
	helm upgrade sealed-secrets \
		charts/sealed-secrets \
		--values values/sealed-secrets/values.yaml \
		--install \
		--namespace sealed-secrets

install-cnpg:
	helm upgrade cnpg \
		charts/cloudnative-pg \
		--values values/cloudnative-pg/values.yaml \
		--install \
		--namespace cnpg

install-keycloakx:
	helm upgrade keycloakx \
		charts/keycloakx \
		--values values/keycloakx/values.yaml \
		--install \
		--namespace keycloakx

create-tls-secret:
	kubectl create secret tls r16z-tls \
  --cert=tls/tls.crt \
  --key=tls/tls.key \
  -n default
	kubectl apply -f manifests/traefik/tlsstore.yaml

install-argocd:
	helm upgrade argocd \
		charts/argo-cd \
		--values values/argo-cd/values.yaml \
		--install \
		--namespace argocd

install-reloader:
	helm upgrade reloader \
		charts/reloader \
		--values values/reloader/values.yaml \
		--install \
		--namespace reloader
