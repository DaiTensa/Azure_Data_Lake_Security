# Brief Data Lake 2 - 02-12-2024 Ingestion avancée, monitoring, et sécurité

## Objectif

Acquérir une **vision panoramique** des méthodes de sécurité disponibles sur Azure pour protéger les données dans un Data Lake. 

Il y a plusieurs aspects importants concernant les applications et les données en termes de sécurité :

- **Gestion des secrets** : Les applications ont besoin d'accéder à des bases de données et des services en utilisant des secrets ou des clés API. Si ces informations sont stockées en clair ou intégrées directement dans le code, cela augmente le risque d’accès non autorisé en cas de faille de sécurité.
- **Gestion des clés** : Essentielle pour protéger les données sensibles grâce au chiffrement.
- **Gestion des certificats** : Les applications communiquent entre elles, donc la gestion des certificats est cruciale pour sécuriser les communications réseau avec des certificats SSL/TLS.

En résumé, la gestion des secrets, des clés et des certificats est essentielle pour une sécurité solide. 

Cela permet de stocker des informations sensibles de manière sécurisée, de contrôler les accès et de chiffrer les données dans les environnements cloud. 

Ces processus doivent respecter les trois principes du Zero Trust : vérifier explicitement, limiter les accès au strict nécessaire et supposer qu’une faille est toujours possible. 

Pour y parvenir, des outils spécialisés sont nécessaires, comme Azure Key Vault, qui répond à ces besoins.

### Approches pour sécuriser une infrastructure
#### Zero Trust
Dans un système logiciel, deux composants principaux que sont les applications et les données. Les applications servent d’interface pour accéder aux données, et les données sont ce que les équipes de sécurité cherchent avant tout à protéger. 

Ainsi, garantir la sécurité des applications et des données est l’un des principaux objectifs du modèle **Zero Trust**.

**En résumé :** Zero Trust est une stratégie de sécurité.

Zero Trust n’est ni un produit ni un service. C’est plutôt une approche, un cadre, un modèle, ou même une philosophie de conception des systèmes, basée sur un principe simple : **ne jamais faire confiance, toujours vérifier**.

Au lieu de supposer que tout ce qui est derrière le pare-feu de l’entreprise est sécurisé, le modèle Zero Trust **part du principe qu’une violation est possible** et vérifie chaque demande comme si elle venait d’une source non fiable. Peu importe d’où provient la demande ou quelle ressource elle veut accéder, le modèle Zero Trust insiste : **ne jamais faire confiance, toujours vérifier**.

Plus précisément, Zero Trust repose sur trois piliers principaux :

1. **Vérification explicite** : toujours authentifier et autoriser en fonction de toutes les données disponibles.
2. **Accès au moindre privilège** : limiter les accès des utilisateurs avec des politiques adaptées, comme le **Just-In-Time (JIT, accès temporaire)** et le **Just-Enough-Access (JEA, accès suffisant), basées sur les risques et la protection des données.
3. **Supposer une violation** : minimiser les impacts en segmentant les accès. Vérifier le chiffrement de bout en bout et utiliser des outils d’analyse pour surveiller, détecter les menaces et renforcer les défenses.

Ce sont les fondements de Zero Trust.