#!/bin/bash

# Nom du projet
PROJECT_NAME="AZURE_DATA_LAKE_BRIEF_2_04122024"

# Créer la structure de répertoires
mkdir -p $PROJECT_NAME/{modules/{resource_group,data_lake,key_vault,databricks,monitoring},environments}

# Fichiers principaux
touch $PROJECT_NAME/{main.tf,provider.tf,variables.tf,outputs.tf,terraform.tfvars}

# Fichiers pour les modules
MODULES=("resource_group" "data_lake" "key_vault" "databricks" "monitoring")
for MODULE in "${MODULES[@]}"; do
  touch $PROJECT_NAME/modules/$MODULE/{main.tf,variables.tf,outputs.tf}
done

# Fichiers pour les environnements
touch $PROJECT_NAME/environments/{dev.tfvars,staging.tfvars,prod.tfvars}

echo "Structure du projet Terraform '$PROJECT_NAME' créée avec succès !"
