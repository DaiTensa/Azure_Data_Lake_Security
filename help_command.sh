# Description: Help command for the terraform scripts

# Supprimer le dossier .terraform
rm -rf .terraform

# Supprimer le fichier terraform.tfstate
rm -f terraform.tfstate

# Supprimer le fichier terraform.tfstate.backup
rm -f terraform.tfstate.backup

# initialiser le dossier terraform
terraform init -upgrade

# lancer le plan de déploiement
terraform plan -var-file="terraform.tfvars" -out="plan.tfplan"

# appliquer le plan de déploiement
terraform apply "plan.tfplan"

# lancer mkdocs pour générer la documentation
poetry run mkdocs serve --config-file docs/mkdocs.yml

# show tenantId
az account show --query "tenantId" -o tsv
