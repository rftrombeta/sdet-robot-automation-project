*** Settings ***
Name       POST -> /USUARIOS
Documentation    Validação do Cadastro de Usuários - ServeRest
Resource    ../../../resources/base.resource

*** Test Cases ***
Cenário USR-01: Cadastrar novo usuário com sucesso
    [Tags]    001    positivo    usuarios
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}
    
    ${payload}    Create Payload Usuario
    
    ${response}    POST On Session    serverest
    ...    /usuarios
    ...    json=${payload}
    
    Status Should Be    201    ${response}
    Dictionary Should Contain Key    ${response.json()}    _id
    Should Be Equal As Strings    ${response.json()}[message]    Cadastro realizado com sucesso
    
    # Salvando o ID para usar em um futuro GET ou DELETE
    ${USER_ID}    Set Variable    ${response.json()}[_id]
    Log To Console    \nUsuário criado com ID: ${USER_ID}