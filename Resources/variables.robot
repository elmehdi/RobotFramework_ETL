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
${CHARGEMENT_JOB_NAME}    CHARGEMENT_OCI

# Chemins des fichiers
${INPUT_DIR}       input
${ARCHIVE_DIR}     archive
${REJECT_DIR}      rej

# Modèles de fichiers
${OCI_FILE_PATTERN}    OCI*.csv

# Structure attendue des fichiers
@{OCI_FIELD_COUNT}    10    # Nombre de champs attendus dans les fichiers OCI
@{OCI_FIELD_TYPES}    STRING    INT    DOUBLE    DATE    STRING    STRING    INT    DOUBLE    STRING    STRING
@{OCI_FIELD_SIZES}    50    10    15    19    100    100    10    15    50    50

# Format de date pour la validation
${DATE_FORMAT}     %Y%m%d %H:%M
