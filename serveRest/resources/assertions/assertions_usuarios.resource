*** Settings ***
Documentation    Resource > Assertions - Login
Resource         ../base.resource

*** Keywords ***
Valida cadastro de usuario
    [Arguments]    ${response}
    [Documentation]
    ...    Valida a tentativa de cadastro de um usuário no ServeRest.
    ...
    ...    *Argumentos:*
    ...    - ``response``: Objeto de resposta retornado pela tentativa de cadastro.
    ...
    ...    *Exemplo:*
    ...    - Valida cadastro de usuario ____ ${response}

    IF    '${response.status_code}' == '201'
        Dictionary Should Contain Key    ${response.json()}    _id
        Should Be Equal As Strings    ${response.json()}[message]    Cadastro realizado com sucesso
    ELSE IF    '${response.status_code}' == '400'
        Should Be Equal As Strings    ${response.json()}[message]    Este email já está sendo usado
    END

Valida lista de usuarios cadastrados
    [Arguments]    ${response}
    [Documentation]
    ...    Valida a integridade da lista de usuários retornada pelo endpoint /usuarios.
    ...
    ...    *Argumentos:*
    ...    - ``response``: Objeto de resposta retornado pela consulta de usuários.
    ...
    ...    *Exemplo:*
    ...    - Valida lista de usuarios ____ ${response}

    Status Should Be    200    ${response}

    # Validar que 'quantidade' corresponde ao tamanho da lista 'usuarios'
    ${body}          Set Variable    ${response.json()}
    ${quantidade}    Set Variable    ${body}[quantidade]
    ${usuarios}      Set Variable    ${body}[usuarios]
    ${lista_len}    Get Length       ${usuarios}
    Should Be Equal As Integers      ${quantidade}    ${lista_len}

    # Validar o primeiro usuário: chaves existem e valores conforme exemplo
    ${primeiro}    Get From List     ${usuarios}    0
    Dictionary Should Contain Key    ${primeiro}    nome
    Dictionary Should Contain Key    ${primeiro}    email
    Dictionary Should Contain Key    ${primeiro}    password
    Dictionary Should Contain Key    ${primeiro}    administrador
    Dictionary Should Contain Key    ${primeiro}    _id

Valida usuario cadastrado
    [Arguments]    ${payload}    ${response}
    [Documentation]
    ...    Valida a integridade dos dados de um usuário específico retornado pelo endpoint /usuarios/{id}.
    ...
    ...    *Argumentos:*
    ...    - ``payload``: Dados do usuário a serem validados.
    ...    - ``response``: Objeto de resposta retornado pela consulta de usuários.
    ...
    ...    *Exemplo:*
    ...    - Valida usuario cadastrado ____ ${response}

    Status Should Be    200    ${response}

    Should Be Equal As Strings    ${payload}[nome]             ${response.json()}[nome]
    Should Be Equal As Strings    ${payload}[email]            ${response.json()}[email]
    Should Be Equal As Strings    ${payload}[password]         ${response.json()}[password]
    Should Be Equal As Strings    ${payload}[administrador]    ${response.json()}[administrador]

Valida resposta de erro para consulta com ID inválido
    [Arguments]    ${response}
    [Documentation]
    ...    Valida a resposta ao consultar um usuário com ID inválido.
    ...
    ...    *Argumentos:*
    ...    - ``response``: Objeto de resposta retornado pela consulta de usuários.
    ...
    ...    *Exemplo:*
    ...    - Valida resposta de erro para consulta com ID inválido ____ ${response}

    Status Should Be    400    ${response}

    ${body}    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}        id
    Should Be Equal As Strings       ${body}[id]    id deve ter exatamente 16 caracteres alfanuméricos

Valida resposta de erro para consulta com ID inexistente
    [Arguments]    ${response}
    [Documentation]
    ...    Valida a resposta ao consultar um usuário com ID inexistente.
    ...
    ...    *Argumentos:*
    ...    - ``response``: Objeto de resposta retornado pela consulta de usuários.
    ...
    ...    *Exemplo:*
    ...    - Valida resposta de erro para consulta com ID inexistente ____ ${response}

    Status Should Be    400    ${response}

    ${body}    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}             message
    Should Be Equal As Strings       ${body}[message]    Usuário não encontrado

Valida alteracoes de usuario
    [Arguments]    ${id_usuario}    ${dados_usuario}
    [Documentation]
    ...    Valida a resposta ao alterar os dados de um usuário.
    ...
    ...    *Argumentos:*
    ...    - ``id_usuario``: ID do usuário alterado.
    ...    - ``dados_usuario``: Dados que foram utilizados na alteração.
    ...
    ...    *Exemplo:*
    ...    - Valida alteracoes de usuario ____ ${response}

    ${response_get}    Consultar usuarios    ${id_usuario}

    Should Be Equal As Strings    ${response_get.json()}[nome]             ${dados_usuario}[nome]
    Should Be Equal As Strings    ${response_get.json()}[email]            ${dados_usuario}[email]
    Should Be Equal As Strings    ${response_get.json()}[password]         ${dados_usuario}[password]
    Should Be Equal As Strings    ${response_get.json()}[administrador]    ${dados_usuario}[administrador]
