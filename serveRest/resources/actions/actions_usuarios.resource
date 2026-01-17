*** Settings ***
Documentation    Resource > Actions - Usuarios
Resource         ../base.resource

*** Keywords ***
Criar usuario comum
    [Documentation]
    ...    Cria um usuário comum no ServeRest e retorna os dados do usuário criado.
    ...
    ...    *Retorno:*
    ...    - Payload do usuário criado.
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
    ...    - Payload do usuário criado.
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
    [Arguments]    ${payload_usuario_existente}
    [Documentation]
    ...    Tenta criar um usuário com um e-mail já existente para validar o fluxo de exceção.
    ...
    ...    *Argumentos:*
    ...    - ``payload_usuario_existente``: Dados do usuário com e-mail já cadastrado.
    ...
    ...    *Retorno:*
    ...    - Retorna o objeto de resposta completo (Response Object).
    ...
    ...    *Exemplo:*
    ...    - ${response} ____ Criar usuario duplicado ____ ${payload_usuario_existente}

    ${APIURL}    Get Url Api
    Create Session     postUsuario    ${APIURL}

    ${response}    POST On Session    postUsuario
    ...    /usuarios
    ...    json=${payload_usuario_existente}
    ...    expected_status=400

    RETURN    ${response}

Consultar usuarios
    [Arguments]    ${id_usuario}=None
    [Documentation]
    ...    Consulta de usuários cadastrados no ServeRest.
    ...    Se o argumento ``id_usuario`` for fornecido, consulta o usuário específico por ID.
    ...
    ...    *Argumentos:*
    ...    - ``id_usuario``: ID do usuário a ser consultado. Opcional
    ...
    ...    *Retorno:*
    ...    - Retorna o objeto de resposta completo (Response Object).

    ${APIURL}    Get Url Api
    Create Session     getUsuario    ${APIURL}

    IF    '${id_usuario}' != 'None'
        ${PATH}    Set Variable    /usuarios/${id_usuario}
    ELSE
        ${PATH}    Set Variable    /usuarios
    END

    ${response}    GET On Session    getUsuario
    ...    ${PATH}

    RETURN    ${response}

Não permitir consultar usuarios
    [Arguments]    ${id_usuario}
    [Documentation]
    ...    Tentativa de consulta de usuários passando informações incorretas.
    ...
    ...    *Argumentos:*
    ...    - ``id_usuario``: ID do usuário a ser consultado.
    ...
    ...    *Retorno:*
    ...    - Retorna o objeto de resposta completo (Response Object).

    ${APIURL}    Get Url Api
    Create Session     getUsuario    ${APIURL}

    ${response}    GET On Session    getUsuario
    ...    /usuarios/${id_usuario}
    ...    expected_status=400

    RETURN    ${response}

Alterar dados de usuario
    [Arguments]    ${id_usuario}    ${payload_alteracao}
    [Documentation]
    ...    Altera os dados de um usuário existente no ServeRest.
    ...
    ...    *Argumentos:*
    ...    - ``id_usuario``: ID do usuário a ser alterado.
    ...    - ``payload_alteracao``: Dados atualizados do usuário.
    ...
    ...    *Retorno:*
    ...    - Retorna o objeto de resposta completo (Response Object).

    ${APIURL}    Get Url Api
    Create Session     putUsuario    ${APIURL}

    ${response}    PUT On Session    putUsuario
    ...    /usuarios/${id_usuario}
    ...    json=${payload_alteracao}
    ...    expected_status=any

    ${body}    Set Variable    ${response.json()}
    IF    '${response.status_code}' == '200'
        Dictionary Should Contain Key    ${body}             message
        Should Be Equal As Strings       ${body}[message]    Registro alterado com sucesso
    ELSE IF    '${response.status_code}' == '201'
        Dictionary Should Contain Key    ${body}             message
        Should Be Equal As Strings       ${body}[message]    Cadastro realizado com sucesso
    ELSE IF    '${response.status_code}' == '400'
        Dictionary Should Contain Key    ${body}             message
        Should Be Equal As Strings       ${body}[message]    Este email já está sendo usado
    END

    RETURN    ${response}

Deletar usuario
    [Arguments]    ${id_usuario}    ${id_existente}=False
    [Documentation]
    ...    Deleta um usuário existente no ServeRest.
    ...
    ...    *Argumentos:*
    ...    - ``id_usuario``: ID do usuário a ser deletado.
    ...
    ...    *Retorno:*
    ...    - Retorna o objeto de resposta completo (Response Object).

    ${APIURL}    Get Url Api
    Create Session     deleteUsuario    ${APIURL}

    ${response}    DELETE On Session    deleteUsuario
    ...    /usuarios/${id_usuario}
    ...    expected_status=any

    ${body}    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}    message
    IF    '${response.status_code}' == '200'
        IF    '${id_existente}' == 'False'
            Should Be Equal As Strings       ${body}[message]    Registro excluído com sucesso
        ELSE IF    '${id_existente}' == 'True'
            Should Be Equal As Strings       ${body}[message]    Nenhum registro excluído
        END
    ELSE IF    '${response.status_code}' == '400'
        Dictionary Should Contain Key    ${body}             message
        Should Be Equal As Strings       ${body}[message]    Não é permitido excluir usuário com carrinho cadastrado
    END

    RETURN    ${response}