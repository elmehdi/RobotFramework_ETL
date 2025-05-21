# Configuration des Variables GitLab CI/CD

Ce document explique comment configurer les variables GitLab CI/CD pour les tests Robot Framework.

## Variables de Base de Données

Les tests Robot Framework nécessitent des informations de connexion à la base de données Oracle. Pour des raisons de sécurité, ces informations ne doivent pas être stockées directement dans le code source. À la place, nous utilisons des variables GitLab CI/CD.

### Variables Requises

Configurez les variables suivantes dans les paramètres CI/CD de votre projet GitLab :

| Variable | Description | Exemple |
|----------|-------------|---------|
| `DB_NAME` | Nom de la base de données Oracle | `PROD_DB` |
| `DB_USER` | Nom d'utilisateur pour la connexion | `app_user` |
| `DB_PASSWORD` | Mot de passe pour la connexion | `password123` |
| `DB_HOST` | Hôte de la base de données | `oracle-db.example.com` |

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
DB_NAME_DEFAULT: "oracle_db_name"
DB_USER_DEFAULT: "db_username"
DB_PASSWORD_DEFAULT: "db_password"
DB_HOST_DEFAULT: "db_host"
```

**Note importante** : N'utilisez pas ces valeurs par défaut en production. Elles sont fournies uniquement pour faciliter le développement local.
