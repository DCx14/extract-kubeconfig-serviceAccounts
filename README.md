# Générateur de Kubeconfig pour ServiceAccounts

Ce script Bash génère des fichiers `kubeconfig` pour les `ServiceAccounts` présents dans les namespaces Kubernetes spécifiés. Il est conçu pour faciliter la configuration des clients Kubernetes avec les informations nécessaires à partir des `ServiceAccounts` et de leurs secrets associés.

## Description

Le script exécute les étapes suivantes :

1. **Création du Répertoire de Sortie :** Crée un répertoire pour stocker les fichiers `kubeconfig` si ce répertoire n'existe pas encore.
2. **Récupération des Namespaces :** Selon la configuration, il récupère tous les namespaces ou ceux qui correspondent à un préfixe spécifié.
3. **Traitement des ServiceAccounts :** Recherche les `ServiceAccounts` dans chaque namespace avec un préfixe défini et traite chacun d'eux.
4. **Récupération des Secrets :** Identifie les secrets associés aux `ServiceAccounts`, extrait les données nécessaires (`ca.crt` et `token`).
5. **Génération des Fichiers Kubeconfig :** Crée un fichier `kubeconfig` pour chaque `ServiceAccount` avec les données extraites.
6. **Sauvegarde des Kubeconfigs :** Stocke chaque fichier `kubeconfig` dans le répertoire de sortie.

## Variables

- **SEARCH_ALL_NAMESPACES** : (booléen) Détermine si tous les namespaces doivent être recherchés (`true`) ou seulement ceux avec le préfixe spécifié (`false`).
- **PREFIX_NAMESPACE** : (chaîne) Préfixe des namespaces à traiter si `SEARCH_ALL_NAMESPACES` est `false`.
- **PREFIX_SA** : (chaîne) Préfixe des `ServiceAccounts` à rechercher.
- **OUTPUT_DIR** : (chaîne) Répertoire où les fichiers `kubeconfig` seront sauvegardés.
- **FORCESERVEUR** : (booléen) Indique si un serveur spécifique doit être utilisé (`true`) ou si l'URL du serveur doit être extraite de la configuration actuelle (`false`).
- **SERVEURNAME** : (chaîne) URL du serveur Kubernetes à utiliser si `FORCESERVEUR` est `true`.

## Utilisation

1. **Configurer les Variables :** Modifiez les variables en haut du script pour répondre à vos besoins spécifiques.
2. **Exécuter le Script :** Lancez le script depuis votre terminal avec la commande suivante :

   `bash votre_script.sh`

3. **Vérifier les Résultats :** Les fichiers `kubeconfig` générés seront enregistrés dans le répertoire spécifié par la variable `OUTPUT_DIR`.

## Exemple de Configuration

Pour générer des fichiers `kubeconfig` pour tous les `ServiceAccounts` dont le nom commence par `admin-` dans tous les namespaces et sauvegarder les résultats dans le répertoire `kubeconfig-all`, configurez les variables comme suit :

- `SEARCH_ALL_NAMESPACES=true`
- `PREFIX_NAMESPACE="monapp-"`
- `PREFIX_SA="admin-"`
- `OUTPUT_DIR="kubeconfig-all"`
- `FORCESERVEUR=false`
- `SERVEURNAME="https://MONFQDNAPIKUBE.com"`

Ensuite, exécutez le script pour générer les fichiers `kubeconfig`.

## Remarques

- Assurez-vous que vous disposez des permissions nécessaires pour accéder aux namespaces, `ServiceAccounts`, et secrets dans votre cluster Kubernetes.
- Le script suppose que les secrets associés aux `ServiceAccounts` contiennent les clés `ca.crt` et `token`. Veillez à ce que vos secrets respectent cette structure.

## Auteurs

- [Votre Nom]

## Licence

Ce projet est sous la licence [Nom de la Licence] - voir le fichier [LICENSE](LICENSE) pour les détails.
