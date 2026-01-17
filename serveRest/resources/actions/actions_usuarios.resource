*** Settings ***
Documentation    Resource > Actions - Usuarios
Resource         ../base.resource

*** Keywords ***
Criar usuario comum
    [Documentation]
    ...    Cria um usuário comum no ServeRest e retorna os dados do usuário criado.
    ...
    ...    *Retorno:*
    ...    - Retorna o objeto de resposta completo (Response Object).
    ...
    ...    *Exemplo:*
    ...    - ${response} ____ Criar usuario comum

    ${APIURL}    Get Url Api
    Create Session     postUsuario    ${APIURL}

    ${payload_usuario}    Create Payload Usuario

    ${response}    POST On Session    postUsuario
    ...    /usuarios
    ...    json=${payload_usuario}
    ...    expected_status=201

    RETURN    ${payload_usuario}    ${response}

Criar usuario administrador
    [Documentation]
    ...    Cria um usuário administrador no ServeRest e retorna os dados do usuário criado.
    ...
    ...    *Retorno:*
    ...    - Retorna o objeto de resposta completo (Response Object).
    ...
    ...    *Exemplo:*
    ...    - ${response} ____ Criar usuario administrador

    ${APIURL}    Get Url Api
    Create Session     postUsuario    ${APIURL}

    ${payload_usuario}    Create Payload Usuario
    ${payload_usuario}[administrador]    Set Variable    true

    ${response}    POST On Session    postUsuario
    ...    /usuarios
    ...    json=${payload_usuario}
    ...    expected_status=201

    RETURN    ${payload_usuario}    ${response}

Criar usuario duplicado
    [Arguments]    ${payload_usuario}
    [Documentation]
    ...    Tenta criar um usuário duplicado no ServeRest e verifica o erro de duplicação
    ${APIURL}    Get Url Api
    Create Session     postUsuario    ${APIURL}

    ${response}    POST On Session    postUsuario
    ...    /usuarios
    ...    json=${payload_usuario}
    ...    expected_status=400

    RETURN    ${payload_usuario}    ${response}