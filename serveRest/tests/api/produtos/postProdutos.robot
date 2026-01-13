*** Settings ***
Name       POST -> /PRODUTOS
Documentation    Validação do Cadastro de Produtos - ServeRest
Resource    ../../../resources/base.resource

*** Test Cases ***
Cenário PROD-01: Cadastrar novo produto com sucesso
    [Tags]    001    positivo    produtos
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
    Dictionary Should Contain Key    ${response.json()}    _id
    Should Be Equal As Strings       ${response.json()}[message]    Cadastro realizado com sucesso

Cenário PROD-02: Não cadastrar produto com usuario não administrador
    [Tags]    002    positivo    produtos
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}
    
    # Cadastrando um usuário administrador
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
    ${HEADERS}   Create Dictionary  Authorization=${TOKEN}

    # Cadastrando o primeiro produto
    ${payload_produto}    Create Payload Produto
    ${response_produto}    POST On Session    serverest
    ...    /produtos
    ...    json=${payload_produto}
    ...    headers=${HEADERS}
    ...    expected_status=403

    Status Should Be    403    ${response_produto}
    Should Be Equal As Strings    ${response_produto.json()}[message]    Rota exclusiva para administradores

Cenário PROD-03: Não cadastrar mais de um produto com mesmo nome
    [Tags]    003    positivo    produtos
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

    ${response_produto_duplicado}    POST On Session    serverest
    ...    /produtos
    ...    json=${payload_produto}
    ...    headers=${HEADERS}
    ...    expected_status=400

    Status Should Be    400    ${response_produto_duplicado}
    Should Be Equal As Strings       ${response_produto_duplicado.json()}[message]    Já existe produto com esse nome

Cenário PROD-04: Não cadastrar produto sem a autenticação de administrador
    [Tags]    004    positivo    produtos
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
    ${HEADERS}   Create Dictionary  Authorization=Bearer INVALID_TOKEN

    # Cadastrando o primeiro produto
    ${payload_produto}    Create Payload Produto
    ${response_produto}    POST On Session    serverest
    ...    /produtos
    ...    json=${payload_produto}
    ...    headers=${HEADERS}
    ...    expected_status=401

    Status Should Be    401    ${response_produto}
    Should Be Equal As Strings    ${response_produto.json()}[message]    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
