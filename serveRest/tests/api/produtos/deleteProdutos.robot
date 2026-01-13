*** Settings ***
Name       DELETE -> /USUARIOS
Documentation    Exclusão de Usuários - ServeRest
Resource    ../../../resources/base.resource

*** Test Cases ***
Cenário DELETE-PRODUTO-01: Deletar um produto com sucesso
    [Tags]    001    produtos
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}
    
    # Cadastrando um usuário administrador
    ${payload_usuario}    Create Payload Usuario
    ${payload_usuario}[administrador]    Set Variable    true
    
    ${response}    POST On Session    serverest
    ...    /usuarios
    ...    json=${payload_usuario}
    
    Status Should Be    201    ${response}
    
    # Salvando o ID
    ${USER_ID}    Set Variable    ${response.json()}[_id]

    # Realizando o Login para capturar o token
    ${payload_login}    Create Payload Login
    ${payload_login}[email]       Set Variable    ${payload_usuario}[email]
    ${payload_login}[password]    Set Variable    ${payload_usuario}[password]

    ${response_login}   POST On Session    serverest
    ...    /login
    ...    json=${payload_login}
    
    Status Should Be    200    ${response_login}
    Should Be Equal     ${response_login.json()}[message]    Login realizado com sucesso
    ${TOKEN}    Set Variable    ${response_login.json()}[authorization]
    ${HEADERS}   Create Dictionary  Authorization=${response_login.json()}[authorization]

    # Cadastrando o primeiro produto
    ${payload_produto}    Create Payload Produto
    ${response_produto}    POST On Session    serverest
    ...    /produtos
    ...    json=${payload_produto}
    ...    headers=${HEADERS}

    Status Should Be    201    ${response_produto}

    # Salvando o ID
    ${PRODUTO_ID}    Set Variable    ${response_produto.json()}[_id]

    ${response_delete}    DELETE On Session    serverest
    ...    /produtos/${PRODUTO_ID}
    ...    headers=${HEADERS}

    Status Should Be    200    ${response_delete}
    Should Be Equal As Strings    ${response_delete.json()}[message]    Registro excluído com sucesso

Cenário DELETE-PRODUTO-02: Não deletar um produto inexistente
    [Tags]    002    produtos
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}
    
    # Cadastrando um usuário administrador
    ${payload_usuario}    Create Payload Usuario
    ${payload_usuario}[administrador]    Set Variable    true
    
    ${response}    POST On Session    serverest
    ...    /usuarios
    ...    json=${payload_usuario}
    
    Status Should Be    201    ${response}
    
    # Salvando o ID
    ${USER_ID}    Set Variable    ${response.json()}[_id]

    # Realizando o Login para capturar o token
    ${payload_login}    Create Payload Login
    ${payload_login}[email]       Set Variable    ${payload_usuario}[email]
    ${payload_login}[password]    Set Variable    ${payload_usuario}[password]

    ${response_login}   POST On Session    serverest
    ...    /login
    ...    json=${payload_login}
    
    Status Should Be    200    ${response_login}
    Should Be Equal     ${response_login.json()}[message]    Login realizado com sucesso
    ${TOKEN}    Set Variable    ${response_login.json()}[authorization]
    ${HEADERS}   Create Dictionary  Authorization=${response_login.json()}[authorization]

    ${response_delete}    DELETE On Session    serverest
    ...    /produtos/12345678fscvg124
    ...    headers=${HEADERS}

    Status Should Be    200    ${response_delete}
    Should Be Equal As Strings    ${response_delete.json()}[message]    Nenhum registro excluído

Cenário DELETE-PRODUTO-03: Não deletar um produto com usuário não administrador
    [Tags]    003    produtos
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}

    # Cadastrando um usuário não administrador
    ${payload_usuario}    Create Payload Usuario
    
    ${response}    POST On Session    serverest
    ...    /usuarios
    ...    json=${payload_usuario}
    
    Status Should Be    201    ${response}
    
    # Salvando o ID
    ${USER_ID}    Set Variable    ${response.json()}[_id]

    # Realizando o Login para capturar o token
    ${payload_login}    Create Payload Login
    ${payload_login}[email]       Set Variable    ${payload_usuario}[email]
    ${payload_login}[password]    Set Variable    ${payload_usuario}[password]

    ${response_login}   POST On Session    serverest
    ...    /login
    ...    json=${payload_login}
    
    Status Should Be    200    ${response_login}
    Should Be Equal     ${response_login.json()}[message]    Login realizado com sucesso
    ${TOKEN}    Set Variable    ${response_login.json()}[authorization]
    ${HEADERS}   Create Dictionary  Authorization=${response_login.json()}[authorization]
    
    ${response}    GET On Session    serverest
    ...    /produtos
    
    Status Should Be    200    ${response}

    # Recupera o ID do primeiro produto para realizar a consulta por ID
    ${body}          Set Variable    ${response.json()}
    ${produtos}      Set Variable    ${body}[produtos]
    ${produto}    Get From List     ${produtos}    0
    ${id_consulta}    Set Variable    ${produto}[_id]

    ${response_delete}    DELETE On Session    serverest
    ...    /produtos/${id_consulta}
    ...    headers=${HEADERS}
    ...    expected_status=403

    Status Should Be    403    ${response_delete}
    Should Be Equal As Strings    ${response_delete.json()}[message]    Rota exclusiva para administradores

Cenário DELETE-PRODUTO-04: Não deletar um produto sem autenticação
    [Tags]    004    produtos
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}
    
    ${response}    GET On Session    serverest
    ...    /produtos
    
    Status Should Be    200    ${response}

    # Recupera o ID do primeiro produto para realizar a consulta por ID
    ${body}          Set Variable    ${response.json()}
    ${produtos}      Set Variable    ${body}[produtos]
    ${produto}    Get From List     ${produtos}    0
    ${id_consulta}    Set Variable    ${produto}[_id]

    ${HEADERS_NTOKEN}   Create Dictionary  Authorization=Bearer INVALID_TOKEN

    ${response_delete}    DELETE On Session    serverest
    ...    /produtos/${id_consulta}
    ...    headers=${HEADERS_NTOKEN}
    ...    expected_status=401

    Status Should Be    401    ${response_delete}
    Should Be Equal As Strings    ${response_delete.json()}[message]    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Cenário DELETE-PRODUTO-05: Não deletar um produto que esteja no carrinho
    [Tags]    005    produtos
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}