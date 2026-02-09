*** Settings ***
Name       PUT -> /PRODUTOS
Documentation    Validação de Atualização no Cadastro de Produtos - ServeRest
Resource    ../../../resources/base.resource

*** Test Cases ***
Cenário PUT-PRODUTO-01: Alterar um produto existente com sucesso
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
    ${HEADERS}   Create Dictionary  Authorization=${TOKEN}

    # Cadastrando o produto
    ${payload_produto}    Create Payload Produto
    ${response_produto}    POST On Session    serverest
    ...    /produtos
    ...    json=${payload_produto}
    ...    headers=${HEADERS}

    Status Should Be    201    ${response_produto}
    ${ID_GERADO}    Set Variable       ${response_produto.json()}[_id]

    ${payload_produto}[nome]    Set Variable    ${payload_produto}[nome] - Alterado
    ${response_produto}    PUT On Session    serverest
    ...    /produtos/${ID_GERADO}
    ...    json=${payload_produto}
    ...    headers=${HEADERS}

    Status Should Be    200    ${response_produto}
    Should Be Equal     ${response_produto.json()}[message]    Registro alterado com sucesso

    ${response_produto_get}    GET On Session    serverest
    ...    /produtos/${ID_GERADO}

    Status Should Be    200    ${response_produto_get}
    Should Be Equal     ${response_produto_get.json()}[nome]    ${payload_produto}[nome]

Cenário PUT-PRODUTO-02: Criar novo produto quando o ID não existir
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
    ${HEADERS}   Create Dictionary  Authorization=${TOKEN}

    # Cadastrando o produto
    ${payload_produto}    Create Payload Produto
    
    ${ID_GERADO}    Set Variable    ilHhiAsAlguralOb

    ${response_produto}    PUT On Session    serverest
    ...    /produtos/${ID_GERADO}
    ...    json=${payload_produto}
    ...    headers=${HEADERS}

    Status Should Be    201    ${response_produto}
    Should Be Equal     ${response_produto.json()}[message]    Cadastro realizado com sucesso
    ${NEW_ID_GERADO}    Set Variable       ${response_produto.json()}[_id]

    ${response_produto_get}    GET On Session    serverest
    ...    /produtos/${NEW_ID_GERADO}

    Status Should Be    200    ${response_produto_get}
    Should Be Equal     ${response_produto_get.json()}[nome]    ${payload_produto}[nome]

Cenário PUT-PRODUTO-03: Não Alterar um produto com o mesmo nome de outro existente - ERRO
    [Tags]    003    produtos
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
    ${HEADERS}   Create Dictionary  Authorization=${TOKEN}

    # Cadastrando o produto
    ${payload_produto}    Create Payload Produto
    ${response_produto}    POST On Session    serverest
    ...    /produtos
    ...    json=${payload_produto}
    ...    headers=${HEADERS}

    Status Should Be    201    ${response_produto}
    ${ID_GERADO}    Set Variable       ${response_produto.json()}[_id]

    ${new_response_produto}    PUT On Session    serverest
    ...    /produtos/${ID_GERADO}
    ...    json=${payload_produto}
    ...    headers=${HEADERS}

    Status Should Be    400    ${new_response_produto}
    Should Be Equal     ${new_response_produto.json()}[message]    Já existe produto com esse nome

Cenário PUT-PRODUTO-04: Não atualizar produto com usuario não administrador
    [Tags]    004    produtos
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
    ${HEADERS}   Create Dictionary  Authorization=${TOKEN}

    # Cadastrando o primeiro produto
    ${payload_produto}    Create Payload Produto
    ${response_produto}    POST On Session    serverest
    ...    /produtos
    ...    json=${payload_produto}
    ...    headers=${HEADERS}

    Status Should Be    201    ${response_produto}

    # Salvando o ID
    ${PRODUTO_ID}    Set Variable    ${response_produto.json()}[_id]

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
    ${HEADERS_NADM}   Create Dictionary  Authorization=${TOKEN}

    ${response_produto_put}    PUT On Session    serverest
    ...    /produtos/${PRODUTO_ID}
    ...    json=${payload_produto}
    ...    headers=${HEADERS_NADM}
    ...    expected_status=403

    Status Should Be    403    ${response_produto_put}
    Should Be Equal     ${response_produto_put.json()}[message]    Rota exclusiva para administradores

Cenário PUT-PRODUTO-05: Não atualizar produto sem autenticação
    [Tags]    005    produtos
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
    ${HEADERS}   Create Dictionary  Authorization=${TOKEN}

    # Cadastrando o primeiro produto
    ${payload_produto}    Create Payload Produto
    ${response_produto}    POST On Session    serverest
    ...    /produtos
    ...    json=${payload_produto}
    ...    headers=${HEADERS}

    Status Should Be    201    ${response_produto}

    # Salvando o ID
    ${PRODUTO_ID}    Set Variable    ${response_produto.json()}[_id]
    ${HEADERS_NTOKEN}   Create Dictionary  Authorization=Bearer INVALID_TOKEN

    ${response_produto_put}    PUT On Session    serverest
    ...    /produtos/${PRODUTO_ID}
    ...    json=${payload_produto}
    ...    headers=${HEADERS_NTOKEN}
    ...    expected_status=401

    Status Should Be    401    ${response_produto_put}
    Should Be Equal     ${response_produto_put.json()}[message]    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
