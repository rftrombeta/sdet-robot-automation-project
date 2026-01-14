*** Settings ***
Documentation    Resource > Actions - Login
Resource         ../base.resource

*** Keywords ***
Logar usuario com sucesso
    [Arguments]    ${email}    ${password}
    [Documentation]
    ...    Realiza o login de um usuário no ServeRest e retorna o token de autorização

    ${APIURL}    Get Url Api
    Create Session     postLogin    ${APIURL}

    ${payload_login}    Create Payload Login
    ${payload_login}[email]       Set Variable    ${email}
    ${payload_login}[password]    Set Variable    ${password}

    ${response_login}   POST On Session    postLogin
    ...    /login
    ...    json=${payload_login}
    ...    expected_status=200

    ${TOKEN}    Valida login de usuario com sucesso    ${response_login}

    RETURN    ${TOKEN}

Logar usuario com senha ou email incorretos
    [Arguments]    ${email}    ${password}
    [Documentation]
    ...    Realiza o login de um usuário no ServeRest e retorna o token de autorização

    ${APIURL}    Get Url Api
    Create Session     postLogin    ${APIURL}

    ${payload_login}    Create Payload Login
    ${payload_login}[email]       Set Variable    ${email}
    ${payload_login}[password]    Set Variable    ${password}

    ${response_login}   POST On Session    postLogin
    ...    /login
    ...    json=${payload_login}
    ...    expected_status=401
