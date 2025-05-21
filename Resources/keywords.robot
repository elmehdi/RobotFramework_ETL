*** Settings ***
Documentation    Mots-clés communs pour les tests de validation ETL
Library          OperatingSystem
Library          String
Library          Collections
Library          DateTime

*** Keywords ***
Find Files With Pattern
    [Documentation]    Trouver tous les fichiers correspondant à un modèle dans un répertoire
    [Arguments]    ${directory}    ${pattern}
    ${files}=    List Files In Directory    ${directory}    ${pattern}
    [Return]    ${files}

Count Lines In File
    [Documentation]    Compter le nombre de lignes dans un fichier CSV
    [Arguments]    ${file_path}
    ${content}=    Get File    ${file_path}
    @{lines}=    Split To Lines    ${content}
    ${line_count}=    Get Length    ${lines}
    [Return]    ${line_count}

Validate File Structure
    [Documentation]    Valider la structure d'un fichier CSV (toutes les lignes)
    [Arguments]    ${file_path}    ${expected_field_count}    ${field_types}    ${field_sizes}
    ${content}=    Get File    ${file_path}
    @{lines}=    Split To Lines    ${content}
    ${line_count}=    Get Length    ${lines}

    # Vérifier chaque ligne du fichier
    FOR    ${line_index}    ${line}    IN ENUMERATE    @{lines}
        # Ignorer les lignes vides
        ${line_length}=    Get Length    ${line}
        Continue For Loop If    ${line_length} == 0

        # Diviser la ligne en champs
        @{fields}=    Split String    ${line}    ;

        # Vérifier le nombre de champs
        ${actual_field_count}=    Get Length    ${fields}
        Should Be Equal As Integers    ${actual_field_count}    ${expected_field_count}    La ligne ${line_index + 1} contient ${actual_field_count} champs au lieu de ${expected_field_count}

        # Vérifier les types et tailles des champs si VALIDATE_FIELDS est TRUE
        Run Keyword If    ${VALIDATE_FIELDS}    Validate Field Types And Sizes    ${fields}    ${field_types}    ${field_sizes}    ${line_index + 1}
    END

    # Vérifier qu'il y a au moins une ligne dans le fichier
    Should Be True    ${line_count} > 0    Le fichier est vide

Validate Field Types And Sizes
    [Documentation]    Valider les types et tailles des champs
    [Arguments]    ${fields}    ${field_types}    ${field_sizes}    ${line_number}=1
    FOR    ${index}    ${field}    ${expected_type}    ${expected_size}    IN ZIP    ${fields}    ${field_types}    ${field_sizes}
        Run Keyword If    '${expected_type}' == 'INT'    Validate Integer Field    ${field}    ${line_number}    ${index}
        Run Keyword If    '${expected_type}' == 'DOUBLE'    Validate Double Field    ${field}    ${line_number}    ${index}
        Run Keyword If    '${expected_type}' == 'DATE'    Validate Date Field    ${field}    ${DATE_FORMAT}    ${line_number}    ${index}
        ${field_length}=    Get Length    ${field}
        Should Be True    ${field_length} <= ${expected_size}    Ligne ${line_number}, champ ${index}: dépasse la taille maximale (${field_length} > ${expected_size})
    END

Validate Integer Field
    [Documentation]    Valider qu'un champ contient un entier
    [Arguments]    ${field}    ${line_number}=1    ${field_index}=0
    ${is_integer}=    Run Keyword And Return Status    Convert To Integer    ${field}
    Should Be True    ${is_integer}    Ligne ${line_number}, champ ${field_index}: '${field}' n'est pas un entier

Validate Double Field
    [Documentation]    Valider qu'un champ contient un nombre décimal
    [Arguments]    ${field}    ${line_number}=1    ${field_index}=0
    ${is_number}=    Run Keyword And Return Status    Convert To Number    ${field}
    Should Be True    ${is_number}    Ligne ${line_number}, champ ${field_index}: '${field}' n'est pas un nombre

Validate Date Field
    [Documentation]    Valider qu'un champ contient une date au format attendu
    [Arguments]    ${field}    ${format}    ${line_number}=1    ${field_index}=0
    # Pour le format "yyyyMMdd HH:mm"
    ${is_valid_date}=    Run Keyword And Return Status    Convert Date    ${field}    date_format=${format}
    Should Be True    ${is_valid_date}    Ligne ${line_number}, champ ${field_index}: '${field}' n'est pas une date valide au format '${format}'
