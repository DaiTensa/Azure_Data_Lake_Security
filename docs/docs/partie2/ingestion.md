# Ingestion de Données dans Azure Data Lake

Comment uploader des données dans le datalake gen2

**`upload_file_to_dl.py`** pour ingérer des fichiers CSV ou Parquet dans Azure Data Lake de manière sécurisée en utilisant des Service Principals (SP) et des SAS tokens.

## Prérequis

- Python 3.12 ou supérieur
- Les bibliothèques Python suivantes :
  - `python-dotenv`
  - `azure-identity`
  - `azure-keyvault-secrets`
  - `azure-storage-blob`
- Un compte Azure avec les services suivants configurés :
  - Azure Key Vault
  - Azure Storage Account
- Deux Service Principals configurés avec les rôles et permissions nécessaires

## Configuration

1. Créez un fichier `.env` à la racine du projet avec les variables d'environnement suivantes :

```env
    KEY_VAULT_NAME=<votre_nom_de_key_vault>
    AZ_TENANT_ID=<votre_tenant_id>
    SP_CLIENT_ID=<votre_client_id_secondaire>
    SP_PRINCIPAL_CLIENT_ID=<votre_client_id_principal>
    SECRET_NAME_PRINCIPAL=<nom_du_secret_principal>
    STORAGE_ACCOUNT_NAME=<nom_du_storage_account>
    CONTAINER_NAME=<nom_du_conteneur>
    BLOB_NAME=<nom_du_blob>
    LOCAL_FILE_PATH=<chemin_vers_le_fichier_local>
    SP_SECONDARY_PASSWORD=<mot_de_passe_du_sp_secondaire>
```

## Utilisation

### Niveau 1 - Ingestion de Données CSV

1. Téléchargez le fichier CSV de `reviews.csv` et placez-le à l'emplacement spécifié par `LOCAL_FILE_PATH` dans le fichier `.env`

2. Exécutez le script `upload.sh`

    ```sh
    ./upload.sh
    ```

Le script effectuera les opérations suivantes :

- Charger les variables d'environnement depuis le fichier `.env`
- Authentifier le Service Principal secondaire pour récupérer le secret du Service Principal principal depuis Azure Key Vault.
- Authentifier le Service Principal principal en utilisant le secret récupéré.
- Générer un SAS token pour le blob spécifié.
- Télécharger le fichier local vers le blob dans Azure Storage Account en utilisant le SAS token.

### Niveau 1 - Ingestion de Données Parquet

Pour ingérer un fichier Parquet, suivez les mêmes étapes que pour le fichier CSV, en remplaçant simplement le fichier CSV par un fichier Parquet et en mettant à jour la variable `LOCAL_FILE_PATH` dans le fichier `.env` pour pointer vers le fichier Parquet.

## Fonctionnement du Script

### Fonctions Principales

- **`load_env()`**: Charge les variables d'environnement depuis le fichier **`.env`**.
- **`authenticate_client(tenant_id, client_id, client_secret)`** : Authentifie un client Azure en utilisant les informations d'identification fournies.
- **`get_secret_from_keyvault(vault_url, secret_name, credential)`** : Récupère un secret depuis Azure Key Vault.
- **`generate_sas_token(storage_account_name, container_name, blob_name, credential)`** : Génère un SAS token pour un blob dans Azure Storage Account.
- **`upload_file(blob_url, local_file_path)`** : Télécharge un fichier local vers un blob en utilisant l'URL du blob avec le SAS token.

### Fonction `main()`

La fonction **`main()`** orchestre les étapes suivantes :

1. Charger la configuration depuis les variables d'environnement.
2. Authentifier le Service Principal secondaire pour récupérer le secret du Service Principal principal.
3. Authentifier le Service Principal principal en utilisant le secret récupéré.
4. Générer un SAS token pour le blob spécifié.
5. Télécharger le fichier local vers le blob en utilisant le SAS token.

Le script **`upload_file_to_dl.py`** permet d'ingérer des fichiers CSV et Parquet dans Azure Data Lake de manière sécurisée en utilisant des Service Principals et des SAS tokens. Assurez-vous de configurer correctement les variables d'environnement et les permissions des Service Principals pour garantir le bon fonctionnement du script.