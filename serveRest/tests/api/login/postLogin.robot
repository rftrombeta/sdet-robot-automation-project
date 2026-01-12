*** Settings ***
Name       POST -> /LOGIN
Documentation
...    Validação do endpoint de Login - ServeRest
Resource    ../../../resources/base.resource

*** Test Cases ***
Cenário LGN-01: Login com sucesso
    [Tags]    001    positivo
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}
    
    ${payload_user}    Create Payload Usuario
    
    ${response_user}    POST On Session    serverest
    ...    /usuarios
    ...    json=${payload_user}
    
    Status Should Be    201    ${response_user}

    ${payload_login}    Create Payload Login
    ${payload_login}[email]       Set Variable    ${payload_user}[email]
    ${payload_login}[password]    Set Variable    ${payload_user}[password]

    ${response_login}   POST On Session    serverest
    ...    /login
    ...    json=${payload_login}
    
    Status Should Be    200    ${response_login}
    Should Be Equal     ${response_login.json()}[message]    Login realizado com sucesso
    Dictionary Should Contain Key    ${response_login.json()}    authorization
    Log To Console    \nToken capturado: ${response_login.json()}[authorization]

Cenário LGN-02: Login com senha incorreta
    [Tags]    002    negativo
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}
    
    ${payload_user}    Create Payload Usuario
    
    ${response_user}    POST On Session    serverest
    ...    /usuarios
    ...    json=${payload_user}
    
    Status Should Be    201    ${response_user}

    ${payload_login}    Create Payload Login
    ${payload_login}[email]       Set Variable    ${payload_user}[email]
    ${payload_login}[password]    Set Variable    12345

    ${response_login}   POST On Session    serverest
    ...    /login
    ...    json=${payload_login}
    ...    expected_status=401
    
    Should Be Equal As Strings    ${response_login.json()}[message]    Email e/ou senha inválidos

Cenário LGN-03: Login com email incorreto
    [Tags]    003    negativo
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}
    
    ${payload_user}    Create Payload Usuario
    
    ${response_user}    POST On Session    serverest
    ...    /usuarios
    ...    json=${payload_user}
    
    Status Should Be    201    ${response_user}

    ${payload_login}    Create Payload Login
    ${payload_login}[email]       Set Variable    email_errado@teste.com
    ${payload_login}[password]    Set Variable    ${payload_user}[password]

    ${response_login}   POST On Session    serverest
    ...    /login
    ...    json=${payload_login}
    ...    expected_status=401
    
    Should Be Equal As Strings    ${response_login.json()}[message]    Email e/ou senha inválidos
