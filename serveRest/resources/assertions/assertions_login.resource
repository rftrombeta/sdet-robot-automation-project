*** Settings ***
Documentation    Resource > Assertions - Login
Resource         ../base.resource

*** Keywords ***
Valida login de usuario com sucesso
    [Arguments]    ${response}
    [Documentation]
    ...    Valida o fluxo de autenticação bem-sucedida de um usuário.
    ...
    ...    *Argumentos:*
    ...    - ``response``: Objeto de resposta retornado pela tentativa de login.
    ...
    ...    *Exemplo:*
    ...    - Valida login de usuario com sucesso ____ ${response}

    Dictionary Should Contain Key    ${response.json()}    authorization

Valida login de usuario com senha ou email incorretos
    [Arguments]    ${response}
    [Documentation]
    ...    Valida o fluxo de exceção ao tentar logar com credenciais inválidas.
    ...
    ...    *Argumentos:*
    ...    - ``response``: Objeto de resposta retornado pela tentativa de login.
    ...
    ...    *Exemplo:*
    ...    - Valida login de usuario com senha ou email incorretos ____ ${response}

    Should Be Equal As Strings    ${response.json()}[message]    Email e/ou senha inválidos
