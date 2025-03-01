# Azure_Data_Lake_Brief_2_04122024

# Context

Construire une infrastructure de données solide et sécurisée sur Microsoft Azure. L'objectif de ce brief autour de la sécurisation et du monitoring d'un Data Lake.

Les objetcifs du brief :
- Configurer un Data Lake pour centraliser les données. 
- Ingérer des données provenant de différentes sources.
- Mettre en place des mesures de sécurité avancées pour protéger les données sensibles.
- Configurer Azure Databricks pour permettre à l'équipe Data Science d'analyser les données.
- Implémenter un système de monitoring et d'alertes pour surveiller l'infrastructure.
- [Bonus] : déployer l'infrastructure via terrafrom.

# Pré-requis
Avant de lancer le projet, assurez-vous d'avoir installé les outils et dépendances suivants:

1. **poetry** : un gestionnaire de dépendances pour Python. Pour installer Poetry suivre le lien suivant [le site officiel de Poetry](https://python-poetry.org/docs/#installation).

2. **Azure CLI** : un ensemble d'outils en ligne de commande pour gérer les services Azure. [le site officiel d'Azure CLI](https://docs.microsoft.com/fr-fr/cli/azure/install-azure-cli).

3. **Terraform** : outil d'infrastructure as code, pour créer, gérer et versionner des ressources cloud. [le site officiel de Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).

4. **Dépendance Python** : avoir python installé [le site officiel de Python](https://www.python.org/downloads/).

5. **Dépendance Python** : pour installer les dépendances nécessaires pour ce projet avec poetry :

```sh
    poetry install
```

6. **Connexion Azure** : Connectez-vous à votre compte Azure en utilisant Azure CLI avec la commande suivante :

```sh
    az login
```

7. **Configuration des variables d'environnement** : Créez un fichier **`.env`** à la racine du projet et ajoutez les variables d'environnement nécessaires pour la configuration du projet:
```sh
    AZ_TENANT_ID=<votre_tenant_id>
    KEY_VAULT_NAME=<votre_key_vault_name>
    SECRET_NAME_SECONDAIRE=<nom_service_principal_secondaire>
    SECRET_NAME_PRINCIPAL=<nom_service_principal_principal>
    SP_CLIENT_ID=<votre_sp_client_id>
    SP_PRINCIPAL_CLIENT_ID=<votre_sp_principal_client_id>
    SP_SECONDARY_PASSWORD=<votre_sp_secondary_password>
    STORAGE_ACCOUNT_NAME=<votre_storage_account_name>
    CONTAINER_NAME=<votre_container_name>
    BLOB_NAME=<votre_blob_name>
    LOCAL_FILE_PATH=<votre_local_file_path>
    LOCAL_FILE_PATH=<votre_local_file_path_parquet>
```

8. **Lien documentation du projet**
[https://DaiTensa.github.io/Azure_Data_Lake_Security/](https://daitensa.github.io/Azure_Data_Lake_Security/)