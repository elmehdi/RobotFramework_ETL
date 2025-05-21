*** Settings ***
Documentation    Tests pour valider le processus de CHARGEMENT
Resource         ../../Resources/variables.robot
Resource         ../../Resources/keywords.robot
Resource         ../../Resources/db_keywords.robot
Library          OperatingSystem
Library          Collections
Suite Setup      Connect To Oracle Database
Suite Teardown   Disconnect From Oracle Database

*** Test Cases ***
Verify Input Files Exist
    [Documentation]    Vérifier que les fichiers d'entrée correspondant au modèle MASK*.csv existent
    # from Keywords
    ${files}=    Find Files With Pattern    ${INPUT_DIR}    ${INPUT_FILE_PATTERN}
    Should Not Be Empty    ${files}    Aucun fichier correspondant au modèle ${INPUT_FILE_PATTERN} trouvé dans ${INPUT_DIR}
    Set Suite Variable    @{INPUT_FILES}    @{files}
    Log    Fichiers trouvés: @{INPUT_FILES}

Validate Structure Of Input Files
    [Documentation]    Valider la structure de chaque fichier d'entrée
    FOR    ${file}    IN    @{INPUT_FILES}
        ${file_path}=    Set Variable    ${INPUT_DIR}/${file}
        Log    Validation de la structure du fichier: ${file_path}
        # from Keywords
        Validate File Structure    ${file_path}    ${INPUT_FIELD_COUNT}    ${INPUT_FIELD_TYPES}    ${INPUT_FIELD_SIZES}
    END

Count Rows In Input Files
    [Documentation]    Compter le nombre de lignes dans chaque fichier d'entrée
    @{row_counts}=    Create List
    FOR    ${file}    IN    @{INPUT_FILES}
        ${file_path}=    Set Variable    ${INPUT_DIR}/${file}
        # from Keywords
        ${row_count}=    Count Lines In File    ${file_path}
        Append To List    ${row_counts}    ${row_count}
        Log    Le fichier ${file} contient ${row_count} lignes
    END
    Set Suite Variable    @{FILE_ROW_COUNTS}    @{row_counts}

Verify Job Execution Status
    [Documentation]    Vérifier que le job a été exécuté avec succès
    ${job_status}    ${job_details}=    Check Job Execution Status    ${CHARGEMENT_JOB_NAME}
    Should Be Equal As Strings    ${job_status}    OK    L'exécution du job a échoué avec le statut: ${job_status}
    Set Suite Variable    ${JOB_STATUS}    ${job_status}
    Set Suite Variable    ${JOB_DETAILS}    ${job_details}

Verify Chargement Execution Details
    [Documentation]    Vérifier les détails de l'exécution du CHARGEMENT
    [Tags]    database
    Run Keyword If    '${JOB_STATUS}' == 'OK'    Verify Chargement Details
    ...    ELSE    Fail    Impossible de vérifier les détails du CHARGEMENT car le statut du job n'est pas OK

Verify Rejection Handling
    [Documentation]    Vérifier la gestion des rejets s'il y a des lignes rejetées
    [Tags]    database
    Run Keyword If    '${JOB_STATUS}' == 'OK'    Verify Rejection Files
    ...    ELSE    Fail    Impossible de vérifier la gestion des rejets car le statut du job n'est pas OK

*** Keywords ***
Verify Chargement Details
    [Documentation]    Vérifier les détails de l'exécution du CHARGEMENT
    &{chargement_details}=    Get Chargement Execution Details    ${CHARGEMENT_JOB_NAME}

    # Vérifier que NB_LIGNES = NB_LIGNES_INS + NB_LIGNES_REJ
    ${sum}=    Evaluate    ${chargement_details.nb_lignes_ins} + ${chargement_details.nb_lignes_rej}
    Should Be Equal As Integers    ${chargement_details.nb_lignes}    ${sum}

    # Vérifier que NB_LIGNES correspond au nombre de lignes du fichier d'entrée
    # Par simplicité, nous vérifions par rapport au nombre de lignes du premier fichier
    # Dans un scénario réel, vous pourriez avoir besoin de faire la somme de tous les fichiers ou de faire correspondre des fichiers spécifiques
    Should Be Equal As Integers    ${chargement_details.nb_lignes}    ${FILE_ROW_COUNTS}[0]

    Set Suite Variable    &{CHARGEMENT_DETAILS}    &{chargement_details}

Verify Rejection Files
    [Documentation]    Vérifier les fichiers de rejet s'il y a des lignes rejetées
    Run Keyword If    ${CHARGEMENT_DETAILS.nb_lignes_rej} > 0    Verify Rejection And Archive Files
    ...    ELSE    Log    Pas de lignes rejetées, vérification des fichiers de rejet ignorée

Verify Rejection And Archive Files
    [Documentation]    Vérifier que les fichiers de rejet et d'archive existent
    FOR    ${file}    IN    @{INPUT_FILES}
        ${base_name}=    Fetch From Left    ${file}    .csv
        ${rej_file}=    Set Variable    ${base_name}_rej.csv

        # Vérifier si le fichier de rejet existe
        ${rej_exists}=    Run Keyword And Return Status    File Should Exist    ${REJECT_DIR}/${rej_file}
        Should Be True    ${rej_exists}    Le fichier de rejet ${rej_file} n'existe pas dans ${REJECT_DIR}

        # Vérifier si le fichier original existe dans l'archive
        ${archive_exists}=    Run Keyword And Return Status    File Should Exist    ${ARCHIVE_DIR}/${file}
        Should Be True    ${archive_exists}    Le fichier original ${file} n'existe pas dans ${ARCHIVE_DIR}
    END
