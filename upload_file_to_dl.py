import os
from dotenv import load_dotenv
from azure.identity import ClientSecretCredential
from azure.keyvault.secrets import SecretClient
from azure.storage.blob import BlobServiceClient, generate_blob_sas, BlobSasPermissions, BlobClient
from datetime import datetime, timedelta, timezone

def load_env():
    """
    Charge les variables d'environnement à partir du fichier .env et les retourne sous forme de dictionnaire.
    """
    load_dotenv()
    return {
        "key_vault_name": os.getenv("KEY_VAULT_NAME"),
        "tenant_id": os.getenv("AZ_TENANT_ID"),
        "client_id": os.getenv("SP_CLIENT_ID"),
        "client_id_principal": os.getenv("SP_PRINCIPAL_CLIENT_ID"),
        "secret_name_principal": os.getenv("SECRET_NAME_PRINCIPAL"),
        "storage_account_name": os.getenv("STORAGE_ACCOUNT_NAME"),
        "container_name": os.getenv("CONTAINER_NAME"),
        "blob_name": os.getenv("BLOB_NAME"),
        "local_file_path": os.getenv("LOCAL_FILE_PATH"),
    }

def authenticate_client(tenant_id, client_id, client_secret):
    """
    Authentifie un client avec les informations d'identification fournies.
    
    Args:
        tenant_id (str): L'ID du locataire Azure.
        client_id (str): L'ID du client (application).
        client_secret (str): Le secret du client.
    
    Returns:
        ClientSecretCredential: L'objet d'authentification du client.
    """
    return ClientSecretCredential(tenant_id=tenant_id, client_id=client_id, client_secret=client_secret)

def get_secret_from_keyvault(vault_url, secret_name, credential):
    """
    Récupère un secret depuis Azure Key Vault.
    
    Args:
        vault_url (str): L'URL du Key Vault.
        secret_name (str): Le nom du secret à récupérer.
        credential (ClientSecretCredential): Les informations d'identification pour accéder au Key Vault.
    
    Returns:
        str: La valeur du secret récupéré.
    """
    try:
        secret_client = SecretClient(vault_url=vault_url, credential=credential)
        retrieved_secret = secret_client.get_secret(secret_name)
        return retrieved_secret.value
    except Exception as e:
        print(f"Erreur lors de la récupération du secret {secret_name} : {e}")
        return None

def generate_sas_token(storage_account_name, container_name, blob_name, credential):
    """
    Génère un jeton SAS pour accéder à un blob dans Azure Storage.
    
    Args:
        storage_account_name (str): Le nom du compte de stockage.
        container_name (str): Le nom du conteneur.
        blob_name (str): Le nom du blob.
        credential (ClientSecretCredential): Les informations d'identification pour accéder au compte de stockage.
    
    Returns:
        str: Le jeton SAS généré.
    """
    blob_service_client = BlobServiceClient(account_url=f"https://{storage_account_name}.blob.core.windows.net/", credential=credential)
    start_time = datetime.now(timezone.utc)
    expiry_time = start_time + timedelta(days=1)
    user_delegation_key = blob_service_client.get_user_delegation_key(key_start_time=start_time, key_expiry_time=expiry_time)
    
    return generate_blob_sas(
        account_name=storage_account_name,
        container_name=container_name,
        blob_name=blob_name,
        user_delegation_key=user_delegation_key,
        permission=BlobSasPermissions(write=True),
        expiry=expiry_time,
        start=start_time,
        protocol="https"
    )

def upload_file(blob_url, local_file_path):
    """
    Télécharge un fichier local vers un blob Azure Storage.
    
    Args:
        blob_url (str): L'URL du blob avec le jeton SAS.
        local_file_path (str): Le chemin du fichier local à télécharger.
    """
    try:
        blob_client = BlobClient.from_blob_url(blob_url)
        with open(local_file_path, "rb") as data:
            blob_client.upload_blob(data, overwrite=True)
        print(f"Fichier '{local_file_path}' uploadé avec succès vers le data lake.")
    except Exception as e:
        print(f"Erreur lors de l'upload du fichier : {e}")

def main():
    """
    Fonction principale qui orchestre le chargement des variables d'environnement, l'authentification,
    la récupération des secrets, la génération du jeton SAS et le téléchargement du fichier.
    """
    config = load_env()
    key_vault_url = f"https://{config['key_vault_name']}.vault.azure.net/"
    
    secondary_credential = authenticate_client(config['tenant_id'], config['client_id'], os.getenv("SP_SECONDARY_PASSWORD"))
    sp_principal_secret = get_secret_from_keyvault(key_vault_url, config['secret_name_principal'], secondary_credential)
    
    if not sp_principal_secret:
        print("Impossible de récupérer le secret du SP Principal. Abandon.")
        return
    
    sp_principal_credential = authenticate_client(config['tenant_id'], config['client_id_principal'], sp_principal_secret)
    
    sas_token = generate_sas_token(config['storage_account_name'], config['container_name'], config['blob_name'], sp_principal_credential)
    blob_url_with_sas = f"https://{config['storage_account_name']}.blob.core.windows.net/{config['container_name']}/{config['blob_name']}?{sas_token}"
    
    upload_file(blob_url_with_sas, config['local_file_path'])
    
if __name__ == "__main__":
    main()
