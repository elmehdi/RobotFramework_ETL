*** Settings ***
Documentation    Variables pour les tests de validation ETL

*** Variables ***
# Connexion à la base de données
${DB_NAME}         ${DB_NAME_VAR}
${DB_USER}         ${DB_USER_VAR}
${DB_PASSWORD}     ${DB_PASSWORD_VAR}
${DB_HOST}         ${DB_HOST_VAR}
${DB_PORT}         1521

# Noms des jobs
${CHARGEMENT_JOB_NAME}    CHARGEMENT_*

# Chemins des fichiers
${INPUT_DIR}       input
${ARCHIVE_DIR}     archive
${REJECT_DIR}      rej

# Modèles de fichiers
${INPUT_FILE_PATTERN}    MASK*.csv

# Structure attendue des fichiers
@{INPUT_FIELD_COUNT}    10    # Nombre de champs attendus dans les fichiers attendus
@{INPUT_FIELD_TYPES}    STRING    INT    DOUBLE    DATE    STRING    STRING    INT    DOUBLE    STRING    STRING
@{INPUT_FIELD_SIZES}    50    10    15    19    100    100    10    15    50    50

# Format de date pour la validation
${DATE_FORMAT}     %Y%m%d %H:%M

# Contrôle de validation
${VALIDATE_FIELDS}    ${TRUE}    # Si TRUE, valide les types et tailles des champs, sinon ignore cette validation
