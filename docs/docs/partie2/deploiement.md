# Déploiement de l'Infrastructure avec Terraform

## Prérequis

Avant de commencer, assurez-vous d'avoir les éléments suivants installés sur votre machine :

- [Terraform](https://www.terraform.io/downloads.html)
- [Azure CLI](https://docs.microsoft.com/fr-fr/cli/azure/install-azure-cli)

## Étapes pour lancer Terraform et déployer l'infrastructure

**Cloner le dépôt**

```sh
git clone https://github.com/DaiTensa/Azure_Data_Lake_Brief_2_04122024.git
```

```sh
cd Azure_Data_Lake_Brief_2_04122024
```

**Configurer les variables**

Créez un fichier `terraform.tfvars`

```sh
touch terraform.tfvars
```

Puis ajoutez les valeurs nécessaires pour le déploiement de l'infrastructure:

```hcl
rg_name        = <nom_du_resource_groupe>
rg_location    = <location_geographique>
storage_account = <nom_storage_account>
kv_name        = <nom_key_vault>
subscription_id = <qubqcription_azure_id>
initial_firstname = <initial_prenom>
lastname = <nom>
```

**Initialiser Terraform**

```sh
terraform init
```

**Planifier le déploiement**

```sh
terraform plan -var-file="terraform.tfvars" -out="plan.tfplan"
```

Cette commande génère un plan d'exécution et l'enregistre dans un fichier nommé `plan`.

**Appliquer le plan**

```sh
terraform apply "plan.tfplan"
```

Cette commande applique les modifications nécessaires pour atteindre l'état décrit dans le plan.

**Vérifier le déploiement**

Une fois le déploiement terminé, vous pouvez vérifier les ressources créées dans le portail Azure ou en utilisant l'Azure CLI.

## Nettoyage

Pour détruire l'infrastructure créée, utilisez la commande suivante :

```sh
terraform destroy
```

Cela supprimera toutes les ressources gérées par votre configuration Terraform.

# Notice

- Assurez-vous de bien configurer vos variables dans le fichier `terraform.tfvars`.