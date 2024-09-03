# 🛠 Générateur de Kubeconfig pour ServiceAccounts

Bienvenue ! Ce script Bash génère des fichiers `kubeconfig` pour les `ServiceAccounts` dans un cluster Kubernetes. Il simplifie la configuration des clients Kubernetes en utilisant les secrets associés à chaque `ServiceAccount`.

## 📋 Fonctionnalités

- **Création Automatique** : Crée un répertoire de sortie si nécessaire.
- **Recherche Flexible** : Sélectionnez la recherche dans tous les namespaces ou ceux avec un préfixe spécifique.
- **Extraction des Secrets** : Récupère les secrets associés, incluant les données `ca.crt` et `token`.
- **Génération de Kubeconfig** : Crée des fichiers `kubeconfig` configurés pour chaque `ServiceAccount`.
- **Sauvegarde Organisée** : Enregistre les fichiers `kubeconfig` dans un répertoire désigné.

## ⚙️ Configuration

Adaptez les variables suivantes dans le script pour personnaliser son fonctionnement :

- **`SEARCH_ALL_NAMESPACES`** : 
  - `true` : Rechercher dans tous les namespaces.
  - `false` : Rechercher dans les namespaces correspondant au préfixe spécifié.

- **`PREFIX_NAMESPACE`** : Préfixe des namespaces à filtrer si `SEARCH_ALL_NAMESPACES` est `false`.

- **`PREFIX_SA`** : Préfixe des `ServiceAccounts` à rechercher.

- **`OUTPUT_DIR`** : Répertoire de sortie pour les fichiers `kubeconfig`.

- **`FORCESERVEUR`** : 
  - `true` : Utiliser un serveur spécifique.
  - `false` : Extraire l'URL du serveur de la configuration actuelle.

- **`SERVEURNAME`** : URL du serveur Kubernetes à utiliser si `FORCESERVEUR` est `true`.

## 🚀 Utilisation

1. **Configurer les Variables** : Modifiez les variables dans le script pour correspondre à vos besoins.
2. **Exécuter le Script** : Lancez le script depuis votre terminal.
3. **Vérifier les Résultats** : Les fichiers `kubeconfig` seront sauvegardés dans le répertoire défini par `OUTPUT_DIR`.

## 🔍 Exemple de Configuration

Pour générer des fichiers `kubeconfig` pour les `ServiceAccounts` dont le nom commence par `admin-` dans tous les namespaces et sauvegarder les résultats dans `kubeconfig-all`, configurez les variables comme suit :

- `SEARCH_ALL_NAMESPACES=true`
- `PREFIX_NAMESPACE="monapp-"`
- `PREFIX_SA="admin-"`
- `OUTPUT_DIR="kubeconfig-all"`
- `FORCESERVEUR=false`
- `SERVEURNAME="https://MONFQDNAPIKUBE.com"`

## 📝 Remarques

- Assurez-vous d'avoir les permissions nécessaires pour accéder aux namespaces, `ServiceAccounts`, et secrets dans votre cluster Kubernetes.
- Le script suppose que les secrets contiennent les clés `ca.crt` et `token`. Vérifiez que vos secrets respectent cette structure.

## 🗂 Licence

Ce projet est sous la licence [Nom de la Licence] - consultez le fichier [LICENSE](LICENSE) pour plus de détails.

---

*Pour toute question ou contribution, n'hésitez pas à ouvrir une issue ou à envoyer une pull request !* 😊
