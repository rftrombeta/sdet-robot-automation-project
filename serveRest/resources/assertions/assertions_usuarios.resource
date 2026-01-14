*** Settings ***
Documentation    Resource > Assertions - Login
Resource         ../base.resource

*** Keywords ***
Valida cadastro de usuario
    [Arguments]    ${response}
    [Documentation]
    ...    Retorna os dados de um usuário comum cadastrado no ServeRest

    IF    '${response.status_code}' == '201'
        Dictionary Should Contain Key    ${response.json()}    _id
        Should Be Equal As Strings    ${response.json()}[message]    Cadastro realizado com sucesso
    ELSE IF    '${response.status_code}' == '400'
        Should Be Equal As Strings    ${response.json()}[message]    Este email já está sendo usado
    END
