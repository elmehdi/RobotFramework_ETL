*** Settings ***
Documentation     Test de connexion à la base de données Oracle avec oracledb
Resource          Resources/db_keywords.robot
Resource          Resources/variables.robot
Suite Setup       Connect To Oracle Database
Suite Teardown    Disconnect From Oracle Database

*** Test Cases ***
Verify Database Connection
    [Documentation]    Vérifier que la connexion à la base de données fonctionne
    ${query}=    Set Variable    SELECT 1 FROM DUAL
    @{results}=    Query    ${query}
    Log    Résultat de la requête: @{results}
    Should Not Be Empty    ${results}    La requête n'a pas retourné de résultats
