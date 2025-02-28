# Azure Data Lake Project

## Architecture du projet

1. **Répertoire racine**:
    - `.env`
    - `.gitignore`
    - `auth.py`
    - `create_project.sh`
    - `poetry.lock`
    - `pyproject.toml`
    - `README.md`

2. **Configuration Terraform**:
    - `AZURE_DATA_LAKE_BRIEF_2_04122024/`
        - `.terraform/`
            - `modules/`
            - `providers/`
        - `.terraform.lock.hcl`
        - `environments/`
            - `dev.tfvars`
            - `prod.tfvars`
            - `staging.tfvars`
        - `main.tf`
        - `modules/`
            - `data_lake/`
            - `databricks/`
            - `key_vault/`
            - `monitoring/`
            - `resource_group/`
        - `outputs.tf`
        - `plan.tfplan`
        - `provider.tf`
        - `terraform.tfstate`
        - `terraform.tfstate.backup`
        - `terraform.tfvars`
        - `variables.tf`

3. **Documentation**:
    - `docs/`
        - `docs/`
            - `images/`
            - `about.md`
            - `analytics.md`
            - `index.md`
            - `installation.md`
            - `security.md`
            - `storage.md`
            - `structure.md`
        - `mkdocs.yml`

### Composants clés:

- **Terraform Modules**:
    - `resource_group`: Manages Azure Resource Groups.
    - `data_lake`: Gère Azure Data Lake Storage.
    - `key_vault`: Gère Azure Key Vault.
    - `databricks`: Gère l'espace de travail Azure Databricks.
    - `monitoring`: Gère les ressources de surveillance.

- **Terraform State and Configuration**:
    - `main.tf`: Fichier de configuration principal Terraform.
    - `variables.tf`: Définit les variables d'entrée.
    - `outputs.tf`: Définit les valeurs de sortie.
    - `provider.tf`: Configure les fournisseurs Terraform.
    - `terraform.tfvars`: Définit les valeurs des variables.
    - `terraform.tfstate`: Stocke l'état de l'infrastructure.
    - `terraform.tfstate.backup`: Sauvegarde du fichier d'état.
    - `plan.tfplan`: Plan d'exécution pour Terraform.

- **Documentation**:
    - `mkdocs.yml`: Configuration pour MkDocs.
    - `about.md`, `analytics.md`, `index.md`: Fichiers de documentation.

