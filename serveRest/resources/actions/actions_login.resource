*** Settings ***
Documentation    Resource > Actions - Login
Resource         ../base.resource

*** Keywords ***
Logar usuario com sucesso
    [Arguments]    ${email}    ${password}
    [Documentation]
    ...    Efetua a autenticação de um usuário no endpoint /login do ServeRest.
    ...
    ...    *Argumentos:*
    ...    - ``email``: Endereço de e-mail do usuário pré-cadastrado.
    ...    - ``password``: Senha correspondente ao usuário.
    ...
    ...    *Retorno:*
    ...    - Retorna o objeto de resposta completo (Response Object).
    ...
    ...    *Exemplo:*
    ...    - ${response} ____ Logar usuario com sucesso ____ admin@teste.com ____ 123456

    ${APIURL}    Get Url Api
    Create Session     postLogin    ${APIURL}

    ${payload_login}    Create Payload Login
    ${payload_login}[email]       Set Variable    ${email}
    ${payload_login}[password]    Set Variable    ${password}

    ${response_login}   POST On Session    postLogin
    ...    /login
    ...    json=${payload_login}
    ...    expected_status=200

    RETURN    ${response_login}

Logar usuario com senha ou email incorretos
    [Arguments]    ${email}    ${password}
    [Documentation]
    ...    Valida o fluxo de exceção ao tentar logar com credenciais inválidas.
    ...
    ...    *Argumentos:*
    ...    - ``email``: E-mail inexistente ou formatado incorretamente.
    ...    - ``password``: Senha incorreta ou vazia.
    ...
    ...    *Retorno:*
    ...    - Retorna o objeto de resposta completo (Response Object).
    ...
    ...    *Exemplo:*
    ...    - ${response} ____ Logar usuario com senha ou email incorretos ____ erro@teste.com ____ 000

    ${APIURL}    Get Url Api
    Create Session     postLogin    ${APIURL}

    ${payload_login}    Create Payload Login
    ${payload_login}[email]       Set Variable    ${email}
    ${payload_login}[password]    Set Variable    ${password}

    ${response_login}   POST On Session    postLogin
    ...    /login
    ...    json=${payload_login}
    ...    expected_status=401

    RETURN    ${response_login}
