# Configuration des Variables GitLab CI/CD

Ce document explique comment configurer les variables GitLab CI/CD pour les tests Robot Framework.

## Variables de Configuration

Les tests Robot Framework nécessitent des variables de configuration qui ne doivent pas être stockées directement dans le code source. À la place, nous utilisons des variables GitLab CI/CD.

### Variables de Base de Données

Configurez les variables suivantes dans les paramètres CI/CD de votre projet GitLab pour la connexion à la base de données Oracle :

| Variable | Description | Exemple |
|----------|-------------|---------|
| `DB_NAME` | Nom de la base de données Oracle | `PROD_DB` |
| `DB_USER` | Nom d'utilisateur pour la connexion | `app_user` |
| `DB_PASSWORD` | Mot de passe pour la connexion | `password123` |
| `DB_HOST` | Hôte de la base de données | `oracle-db.example.com` |

### Variables de Contrôle des Tests

Configurez les variables suivantes pour contrôler le comportement des tests :

| Variable | Description | Valeurs possibles | Défaut |
|----------|-------------|-------------------|--------|
| `VALIDATE_FIELDS` | Active/désactive la validation des types et tailles des champs | `TRUE` ou `FALSE` | `TRUE` |

### Comment Configurer les Variables

1. Accédez à votre projet GitLab
2. Allez dans **Paramètres > CI/CD**
3. Développez la section **Variables**
4. Cliquez sur **Ajouter une variable**
5. Remplissez le formulaire pour chaque variable :
   - Clé : nom de la variable (ex: `DB_PASSWORD`)
   - Valeur : valeur de la variable
   - Type : Variable (par défaut)
   - Environnement : Tous (par défaut)
   - Protégée : Cochez cette case pour les informations sensibles
   - Masquée : Cochez cette case pour les mots de passe

### Valeurs par Défaut

Si les variables ne sont pas définies dans GitLab CI/CD, les valeurs par défaut suivantes seront utilisées (à des fins de développement uniquement) :

```
# Variables de base de données
DB_NAME_DEFAULT: "oracle_db_name"
DB_USER_DEFAULT: "db_username"
DB_PASSWORD_DEFAULT: "db_password"
DB_HOST_DEFAULT: "db_host"

# Variables de contrôle des tests
VALIDATE_FIELDS_DEFAULT: "TRUE"
```

**Note importante** : N'utilisez pas ces valeurs par défaut en production. Elles sont fournies uniquement pour faciliter le développement local.
