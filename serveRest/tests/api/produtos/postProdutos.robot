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

    # Cadastrando o produto
    ${payload_produto}    Create Payload Produto
    ${response_produto}    POST On Session    serverest
    ...    /produtos
    ...    json=${payload_produto}
    ...    Authorization=${TOKEN}

    Status Should Be    201    ${response_produto}