*** Settings ***
Documentation    Resource > Assertions - Login
Resource         ../base.resource

*** Keywords ***
Valida login de usuario com sucesso
    [Arguments]    ${response}
    [Documentation]
    ...    Retorna os dados de um usuário comum cadastrado no ServeRest

    Dictionary Should Contain Key    ${response.json()}    authorization

    RETURN    ${response.json()}[authorization]

Valida login de usuario com senha ou email incorretos
    [Arguments]    ${response}
    [Documentation]
    ...    Retorna os dados de um usuário comum cadastrado no ServeRest

    Should Be Equal As Strings    ${response.json()}[message]    Email e/ou senha inválidos
