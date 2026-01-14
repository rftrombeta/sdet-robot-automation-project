*** Settings ***
Documentation    Resource > Actions - Usuarios
Resource         ../base.resource

*** Keywords ***
Criar usuario comum
    [Documentation]
    ...    Retorna os dados de um usuário comum cadastrado no ServeRest
    ${APIURL}    Get Url Api
    Create Session     postUsuario    ${APIURL}

    ${payload_usuario}    Create Payload Usuario

    ${response}    POST On Session    postUsuario
    ...    /usuarios
    ...    json=${payload_usuario}
    ...    expected_status=201

    Valida cadastro de usuario    ${response}

    RETURN    ${payload_usuario}    ${response}

Criar usuario administrador
    [Documentation]
    ...    Retorna os dados de um usuário administrador cadastrado no ServeRest

    ${APIURL}    Get Url Api
    Create Session     postUsuario    ${APIURL}

    ${payload_usuario}    Create Payload Usuario
    ${payload_usuario}[administrador]    Set Variable    true

    ${response}    POST On Session    postUsuario
    ...    /usuarios
    ...    json=${payload_usuario}
    ...    expected_status=201

    Valida cadastro de usuario    ${response}

    RETURN    ${payload_usuario}    ${response}

Criar usuario duplicado
    [Arguments]    ${payload_usuario}
    [Documentation]
    ...    Retorna os dados de um usuário comum cadastrado no ServeRest
    ${APIURL}    Get Url Api
    Create Session     postUsuario    ${APIURL}

    ${response}    POST On Session    postUsuario
    ...    /usuarios
    ...    json=${payload_usuario}
    ...    expected_status=400

    Valida cadastro de usuario    ${response}

    RETURN    ${payload_usuario}    ${response}