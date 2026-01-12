*** Settings ***
Documentation    Resource - ServeRest Login
Resource         ../base.resource

*** Keywords ***
dados validos para realizar um login
    [Documentation]
    ...    Retorna     uma URL válida para cadastro no ServeRest Login

    ${email}       Set Variable    fulano@teste.com
    ${password}    Set Variable    123456

    RETURN    ${email}    ${password}

url valida para cadastro
    [Documentation]
    ...    Retorna uma URL válida para cadastro no ServeRest Login

    ${url}    Set Variable    Get Url Api

    RETURN    ${url}