*** Settings ***
Documentation    Variables associés aux champs trouvés dans le csv
 
*** Variables ***
# Structure attendue des fichiers ou JDD
@{INPUT_FIELD_COUNT}    10    # Nombre de champs attendus dans les fichiers attendus
@{INPUT_FIELD_TYPES}    STRING    INT    DOUBLE    DATE    STRING    STRING    INT    DOUBLE    STRING    STRING
@{INPUT_FIELD_SIZES}    50    10    15    19    100    100    10    15.3    50    50
# Variables générées à partir de ./sample_fields.csv
# Générées le Wed, May 21, 2025  5:56:56 PM
