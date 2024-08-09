#!/bin/bash

# Variables
SEARCH_ALL_NAMESPACES=true  
PREFIX_NAMESPACE="monapp-"   
PREFIX_SA="admin-"
OUTPUT_DIR="kubeconfig-all"
FORCESERVEUR=false
SERVEURNAME="https://MONFQDNAPIKUBE.com"

# Créer le répertoire de sortie s'il n'existe pas déjà
mkdir -p "$OUTPUT_DIR"

# Récupérer les namespaces
if [ "$SEARCH_ALL_NAMESPACES" = true ]; then
  namespaces=$(kubectl get namespaces -o jsonpath="{.items[*].metadata.name}")
else
  namespaces=$(kubectl get namespaces -o name | grep "namespace/$PREFIX_NAMESPACE" | cut -d'/' -f2)
fi

# Boucle sur chaque namespace
for ns in $namespaces; do
  echo "Namespace: $ns"

  # Récupérer tous les ServiceAccounts et filtrer ceux qui commencent par le préfixe défini
  service_accounts=$(kubectl get sa -n "$ns" -o jsonpath="{.items[*].metadata.name}" | tr ' ' '\n' | grep "^$PREFIX_SA")

  if [ -z "$service_accounts" ]; then
    echo "  Aucun ServiceAccount trouvé avec le préfixe $PREFIX_SA dans le namespace $ns."
    continue
  fi

  # Boucle sur chaque ServiceAccount
  for sa in $service_accounts; do
    if [ -z "$sa" ]; then
      echo "  ServiceAccount name is empty, skipping..."
      continue
    fi

    echo "  ServiceAccount: $sa"

    # Récupérer tous les secrets dans le namespace
    secret_names=$(kubectl get secrets -n "$ns" -o jsonpath="{.items[*].metadata.name}")

    if [ -z "$secret_names" ]; then
      echo "    Aucun secret trouvé dans le namespace $ns."
      continue
    fi

    # Boucle sur chaque secret pour trouver les secrets associés au ServiceAccount
    for secret_name in $secret_names; do
      if [ -z "$secret_name" ]; then
        echo "      Secret name is empty, skipping..."
        continue
      fi

      # Extraire les données du secret
      ca_crt=$(kubectl get secret "$secret_name" -n "$ns" -o jsonpath="{.data['ca\.crt']}" | base64 --decode 2>/dev/null)
      token=$(kubectl get secret "$secret_name" -n "$ns" -o jsonpath="{.data['token']}" | base64 --decode 2>/dev/null)

      # Vérifier si ca_crt et token sont correctement récupérés
      if [ -z "$ca_crt" ] || [ -z "$token" ]; then
        echo "      Erreur lors de la récupération du certificat CA ou du token depuis le secret $secret_name. Assurez-vous que le secret contient les données 'ca.crt' et 'token'."
        continue
      fi

      # Vérifier si le secret est associé au ServiceAccount en utilisant le suffixe de nom de secret
      if [[ "$secret_name" == *"$sa"* ]]; then
        echo "    Traitement du secret: $secret_name"

        # Assurez-vous que le certificat est encodé en base64 correctement
        ca_crt_base64=$(echo "$ca_crt" | base64 | tr -d '\n')
        namespace="$ns"
        if [ "$FORCESERVEUR" = true ]; then
          server=$SERVEURNAME 
        else
          server=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
        fi

        # Créer le kubeconfig
        kubeconfig_content="
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: $ca_crt_base64
    server: $server
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    namespace: $namespace
    user: $sa
  name: $sa@$namespace
current-context: $sa@$namespace
users:
- name: $sa
  user:
    token: $token
"

        # Sauvegarder le kubeconfig dans un fichier
        echo "$kubeconfig_content" > "$OUTPUT_DIR/$ns.yaml"
        echo "      Fichier kubeconfig généré: $OUTPUT_DIR/$ns.yaml"
      else
        echo "      Secret $secret_name n'est pas associé au ServiceAccount $sa."
      fi
    done
  done
done

echo "Tous les kubeconfigs ont été générés dans le répertoire $OUTPUT_DIR."
