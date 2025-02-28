# Stratégie de Sécurité

Cette partie décrit la stratégie de sécurité mise en place pour le projet Azure Data Lake Brief 2, les rôles des Service Principals (SP) et justifie les permissions attribuées à chaque SP.

## Rôles des Service Principals

### SP Principal (sp_primary_p1)

Le Service Principal principal (`sp_primary_p1`) est utilisé pour gérer les opérations critiques sur le Data Lake et le Key Vault. Les rôles et permissions attribués à ce SP sont les suivants :

- **DataLakeUserDelegationRole** : Ce rôle personnalisé permet de générer des User Delegation Keys et de manipuler les fichiers dans le Data Lake. Les actions autorisées incluent :
  - Génération de User Delegation Keys
  - Lecture, écriture et suppression des conteneurs de blobs

- **Storage Blob Delegator** : Ce rôle permet au SP de déléguer l'accès aux blobs dans le Storage Account.

- **Storage Blob Data Contributor** : Ce rôle permet au SP de lire, écrire et supprimer des blobs dans le Storage Account.

- **Key Vault Secrets User** : Ce rôle permet au SP d'accéder aux secrets stockés dans le Key Vault.

- **Key Vault Contributor** : Ce rôle permet au SP de gérer les ressources du Key Vault.

- **Storage Account Key Operator Service Role** : Ce rôle permet au SP de gérer les clés du Storage Account.

### SP Secondaire (sp_secondary_s1)

Le Service Principal secondaire (`sp_secondary_s1`) est utilisé pour des opérations moins critiques mais nécessaires pour le bon fonctionnement du projet. Les rôles et permissions attribués à ce SP sont les suivants :

- **Key Vault Secrets User** : Ce rôle permet au SP d'accéder aux secrets stockés dans le Key Vault.

- **Key Vault Contributor** : Ce rôle permet au SP de gérer les ressources du Key Vault.

- **Reader** : Ce rôle permet au SP de lire les ressources du Key Vault.

## Justification des Permissions

### Permissions du SP Principal

- **DataLakeUserDelegationRole** : Les permissions de ce rôle sont nécessaires pour permettre au SP principal de gérer les User Delegation Keys et de manipuler les fichiers dans le Data Lake, ce qui est essentiel pour les opérations de stockage et de gestion des données.

- **Storage Blob Delegator** et **Storage Blob Data Contributor** : Ces rôles permettent au SP principal de gérer les blobs dans le Storage Account, ce qui est crucial pour les opérations de lecture, écriture et suppression des données.

- **Key Vault Secrets User** et **Key Vault Contributor** : Ces rôles permettent au SP principal de gérer et d'accéder aux secrets dans le Key Vault, assurant ainsi la sécurité et la gestion des informations sensibles.

- **Storage Account Key Operator Service Role** : Ce rôle permet au SP principal de gérer les clés du Storage Account, ce qui est nécessaire pour sécuriser l'accès aux données stockées.

### Permissions du SP Secondaire

- **Key Vault Secrets User** et **Key Vault Contributor** : Ces rôles permettent au SP secondaire de gérer et d'accéder aux secrets dans le Key Vault, assurant ainsi la sécurité et la gestion des informations sensibles.

- **Reader** : Ce rôle permet au SP secondaire de lire les ressources du Key Vault, ce qui est nécessaire pour les opérations de lecture des secrets et des configurations.

## Bonnes Pratiques de Sécurité

La stratégie de sécurité mise en place utilise des Service Principals avec des rôles et des permissions spécifiques pour assurer la sécurité et la gestion efficace des ressources Azure. Les permissions attribuées sont justifiées par les besoins opérationnels du projet et visent à minimiser les risques de sécurité tout en permettant une gestion efficace des ressources.

### **Principe du moindre privilège**
- Chaque SP a des rôles spécifiques à ses besoins
- Permissions minimales requises

### **Séparation des responsabilités**
- SP Principal : Gestion globale
- SP Secondaire : Accès limité
- SP Databricks : Dédié à Databricks

### **Gestion des secrets**
- Stockage centralisé dans Key Vault
- Rotation automatique des secrets
- Dates d'expiration définies

### **Traçabilité**
- Nommage explicite des ressources
- Utilisation des tags
- Dépendances explicites

## Maintenance et Surveillance

### Points de surveillance
- Dates d'expiration des secrets
- Utilisation des permissions
- Accès aux ressources

### Tâches de maintenance
- Renouvellement des secrets
- Révision des permissions
- Mise à jour des rôles
