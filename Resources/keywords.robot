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
    [Documentation]    Compter le nombre de lignes dans un fichier
    [Arguments]    ${file_path}
    ${content}=    Get File    ${file_path}
    @{lines}=    Split To Lines    ${content}
    ${line_count}=    Get Length    ${lines}
    # Soustraire 1 s'il y a une ligne d'en-tête
    ${line_count}=    Evaluate    ${line_count} - 1
    [Return]    ${line_count}

Validate File Structure
    [Documentation]    Valider la structure d'un fichier CSV
    [Arguments]    ${file_path}    ${expected_field_count}    ${field_types}    ${field_sizes}
    ${content}=    Get File    ${file_path}
    @{lines}=    Split To Lines    ${content}

    # Ignorer la ligne d'en-tête
    ${first_data_row}=    Set Variable    ${lines}[1]
    @{fields}=    Split String    ${first_data_row}    ,

    # Vérifier le nombre de champs
    ${actual_field_count}=    Get Length    ${fields}
    Should Be Equal As Integers    ${actual_field_count}    ${expected_field_count}

    # Vérifier les types et tailles des champs
    FOR    ${index}    ${field}    ${expected_type}    ${expected_size}    IN ZIP    ${fields}    ${field_types}    ${field_sizes}
        Run Keyword If    '${expected_type}' == 'INT'    Validate Integer Field    ${field}
        Run Keyword If    '${expected_type}' == 'DOUBLE'    Validate Double Field    ${field}
        Run Keyword If    '${expected_type}' == 'DATE'    Validate Date Field    ${field}    ${DATE_FORMAT}
        ${field_length}=    Get Length    ${field}
        Should Be True    ${field_length} <= ${expected_size}    Le champ à l'index ${index} dépasse la taille maximale
    END

Validate Integer Field
    [Documentation]    Valider qu'un champ contient un entier
    [Arguments]    ${field}
    ${is_integer}=    Run Keyword And Return Status    Convert To Integer    ${field}
    Should Be True    ${is_integer}    Le champ '${field}' n'est pas un entier

Validate Double Field
    [Documentation]    Valider qu'un champ contient un nombre décimal
    [Arguments]    ${field}
    ${is_number}=    Run Keyword And Return Status    Convert To Number    ${field}
    Should Be True    ${is_number}    Le champ '${field}' n'est pas un nombre

Validate Date Field
    [Documentation]    Valider qu'un champ contient une date au format attendu
    [Arguments]    ${field}    ${format}
    # Pour le format "yyyyMMdd HH:mm"
    ${is_valid_date}=    Run Keyword And Return Status    Convert Date    ${field}    date_format=${format}
    Should Be True    ${is_valid_date}    Le champ '${field}' n'est pas une date valide au format '${format}'
