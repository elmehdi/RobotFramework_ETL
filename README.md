# Suite de Tests Robot Framework

Les tests sont organisés en trois catégories :

1. Tests DDL
2. Tests de CHARGEMENT
3. Tests d'ALIM

## Tests de CHARGEMENT

Les tests de CHARGEMENT valident le processus de chargement des données en vérifiant les fichiers d'entrée, leur structure, et les résultats dans la base de données après l'exécution du job.

### Flux de Test

#### Partie A : Validation des Fichiers d'Entrée

1. **Vérification de l'Existence des Fichiers d'Entrée**
   - Vérifier que les fichiers d'entrée correspondant au modèle `MASK*.csv` existent
   - Le test gère plusieurs fichiers correspondant à ce modèle

2. **Validation de la Structure des Fichiers**
   - Vérifier le nombre de champs dans chaque fichier
   - Valider les tailles des champs
   - Vérifier les types de données (Double, Entier, Date au format "yyyyMMdd HH:mm")

3. **Validation du Nombre de Lignes**
   - Compter le nombre de lignes dans chaque fichier d'entrée

#### Partie B : Validation de la Base de Données

1. **Vérification du Statut d'Exécution du Job**
   - Interroger la table `JOB_EXE` pour vérifier si le job s'est terminé avec succès
   - Vérifier que le champ `ETAT` est "OK" (pas "ERREUR")

2. **Validation du Chargement des Données**
   - Si le statut du job est "OK" :
     - Interroger la table `CHARGEMENT_EXE` pour le job
     - Vérifier que `NB_LIGNES = NB_LIGNES_INS + NB_LIGNES_REJ`
     - Vérifier que `NB_LIGNES` correspond au nombre de lignes du fichier d'entrée

3. **Vérification de la Gestion des Rejets**
   - Si `NB_LIGNES_REJ > 0` :
     - Vérifier qu'un fichier de rejet `MASK*_rej.csv` existe dans le dossier `rej/`
     - Vérifier que le fichier original existe dans le dossier `archive/`

## Structure des Tests

```
Robot/
├── Resources/
│   ├── variables.robot       # Contient les variables comme les noms de jobs, détails de connexion DB
│   ├── keywords.robot        # Mots-clés communs utilisés dans les suites de tests
│   └── db_keywords.robot     # Mots-clés spécifiques à la base de données
├── Tests/
│   ├── DDL/
│   │   └── ddl_tests.robot
│   ├── CHARGEMENT/
│   │   └── chargement_tests.robot
│   └── ALIM/
│       └── alim_tests.robot
└── README.md
```

## Exécution des Tests

Pour exécuter les tests de CHARGEMENT :

```
robot -d Results Tests/CHARGEMENT/chargement_tests.robot
```

## Dépendances

- Robot Framework
- DatabaseLibrary pour les connexions à la base de données Oracle
- Module oracledb pour la connexion à Oracle (remplace cx_Oracle)
- Bibliothèque OperatingSystem pour les opérations sur les fichiers
