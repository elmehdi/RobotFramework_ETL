*** Settings ***
Documentation    Mots-clés de base de données pour les tests de validation ETL
Library          DatabaseLibrary
Library          Collections

*** Keywords ***
Connect To Oracle Database
    [Documentation]    Se connecter à la base de données Oracle
    Connect To Database    cx_Oracle    ${DB_NAME}    ${DB_USER}    ${DB_PASSWORD}    ${DB_HOST}:${DB_PORT}

Disconnect From Oracle Database
    [Documentation]    Se déconnecter de la base de données Oracle
    Disconnect From Database

Check Job Execution Status
    [Documentation]    Vérifier si un job a été exécuté avec succès
    [Arguments]    ${job_name}
    ${query}=    Set Variable    SELECT * FROM JOB_EXE WHERE JOB_NOM = '${job_name}' ORDER BY DATE_DEBUT DESC
    @{results}=    Query    ${query}
    ${first_row}=    Set Variable    ${results}[0]
    ${job_status}=    Set Variable    ${first_row}[ETAT]
    [Return]    ${job_status}    ${first_row}

Get Chargement Execution Details
    [Documentation]    Obtenir les détails de la table CHARGEMENT_EXE pour un job
    [Arguments]    ${job_name}
    ${query}=    Set Variable    SELECT * FROM CHARGEMENT_EXE WHERE JOB_NOM = '${job_name}' ORDER BY DATE_DEBUT DESC
    @{results}=    Query    ${query}
    ${first_row}=    Set Variable    ${results}[0]
    ${nb_lignes}=    Set Variable    ${first_row}[NB_LIGNES]
    ${nb_lignes_ins}=    Set Variable    ${first_row}[NB_LIGNES_INS]
    ${nb_lignes_rej}=    Set Variable    ${first_row}[NB_LIGNES_REJ]
    &{details}=    Create Dictionary    nb_lignes=${nb_lignes}    nb_lignes_ins=${nb_lignes_ins}    nb_lignes_rej=${nb_lignes_rej}
    [Return]    &{details}
