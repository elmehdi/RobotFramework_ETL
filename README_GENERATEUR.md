# Générateur de Variables pour Robot Framework

Ce script permet de générer automatiquement les variables de validation de champs pour les tests Robot Framework à partir d'un fichier CSV contenant les métadonnées des colonnes.

## Fonctionnalités

- Analyse un fichier CSV contenant les métadonnées des colonnes
- Convertit les types de données Oracle en types de validation Robot Framework
- Génère les variables `@{INPUT_FIELD_COUNT}`, `@{INPUT_FIELD_TYPES}` et `@{INPUT_FIELD_SIZES}`
- Crée un fichier de log détaillé
- Affiche un résumé des champs au format tableau

## Format du fichier CSV d'entrée

Le fichier CSV doit contenir les colonnes suivantes (séparées par des **points-virgules**) :

1. **Numéro de Colonne** : La position du champ (1 à N)
2. **Nom de Colonne** : Le nom du champ
3. **Type de Données** : Un des types suivants : DATE, VARCHAR2, NUMBER
4. **Longueur** : La longueur maximale du champ
5. **Échelle** : Pour les champs NUMBER, indique les décimales (0 pour les entiers, >0 pour les décimaux)

Exemple :
```
Number of the Column;Column Name;Data Type;Data Length;Data Scale
1;field1;VARCHAR2;50;
2;field2;NUMBER;10;0
3;field3;NUMBER;15;2
4;field4;DATE;19;
```

## Conversion des types

Le script convertit les types de données Oracle en types de validation Robot Framework :

- **VARCHAR2** → **STRING**
- **NUMBER** avec échelle 0 → **INT**
- **NUMBER** avec échelle > 0 → **DOUBLE**
- **DATE** → **DATE**

## Utilisation

### Générer les variables et les écrire dans le fichier Robot Framework

```bash
./generate_field_variables.sh chemin/vers/fichier.csv
```

Le script génère automatiquement les variables dans le fichier `Resources/champs_variables.robot`.

## Fichiers de log

Le script génère automatiquement des fichiers de log dans le répertoire `logs/` avec un horodatage. Ces logs contiennent :

- Les détails de chaque champ traité
- Un résumé des champs au format tableau `[TYPE:TAILLE, ...]`
- Les messages d'erreur ou d'avertissement

## Exemple de sortie

```
# Structure attendue des fichiers
@{INPUT_FIELD_COUNT}    10    # Nombre de champs attendus dans les fichiers attendus
@{INPUT_FIELD_TYPES}    STRING    INT    DOUBLE    DATE    STRING    STRING    INT    DOUBLE    STRING    STRING
@{INPUT_FIELD_SIZES}    50    10    15    19    100    100    10    15    50    50
# Variables générées à partir de sample_fields.csv
# Générées le Wed, May 21, 2025 5:31:38 PM
```

## Intégration avec Robot Framework

Pour utiliser les variables générées dans vos tests Robot Framework :

1. Générez les variables dans un fichier (par exemple `field_variables.robot`)
2. Importez ce fichier dans votre suite de tests avec `Resource    field_variables.robot`
3. Les variables seront disponibles pour la validation des fichiers

## Notes

- Le script ignore automatiquement les lignes d'en-tête dans le fichier CSV
- Le nombre total de champs est déterminé par le numéro de colonne dans la dernière ligne du fichier
- Les types de données inconnus sont convertis en STRING par défaut
- Le script inclut une gestion améliorée des erreurs pour détecter les problèmes de format dans le fichier CSV
- Les tableaux de types et de tailles sont vérifiés avant traitement pour éviter les erreurs
- Le script utilise les points-virgules (;) comme séparateurs de champs dans le fichier CSV

## Dépannage

Si vous rencontrez des erreurs comme `syntax error: invalid arithmetic operator`, vérifiez que :

1. Votre fichier CSV utilise bien des points-virgules (;) comme séparateurs et non des virgules
2. Le format du fichier CSV correspond à l'exemple fourni
3. Il n'y a pas de caractères spéciaux ou d'espaces supplémentaires dans les valeurs numériques
