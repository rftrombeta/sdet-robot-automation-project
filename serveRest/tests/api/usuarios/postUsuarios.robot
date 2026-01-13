*** Settings ***
Name       POST -> /USUARIOS
Documentation    Validação do Cadastro de Usuários - ServeRest
Resource    ../../../resources/base.resource

*** Test Cases ***
Cenário POST-USUARIOS-01: Cadastrar novo usuário com sucesso
    [Tags]    001    usuarios
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

Cenário POST-USUARIOS-02: Não cadastrar usuário com email existente
    [Tags]    002    usuarios
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}
    
    ${payload}    Create Payload Usuario
    
    ${response}    POST On Session    serverest
    ...    /usuarios
    ...    json=${payload}
    
    Status Should Be    201    ${response}

    ${response_usuario_duplicado}    POST On Session    serverest
    ...    /usuarios
    ...    json=${payload}
    ...   expected_status=400
    
    Status Should Be    400    ${response_usuario_duplicado}
    Should Be Equal As Strings    ${response_usuario_duplicado.json()}[message]    Este email já está sendo usado
