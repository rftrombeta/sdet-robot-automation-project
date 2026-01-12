*** Settings ***
Name       GET -> /USUARIOS
Documentation    Consulta de Usuários - ServeRest
Resource    ../../../resources/base.resource

*** Test Cases ***
Cenário GET-01: Consultar todos os usuarios cadastrados
    [Tags]    001    positivo    get    usuarios
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}
    
    ${response}    GET On Session    serverest
    ...    /usuarios
    
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

Cenário GET-02: Buscar usuário por ID
    [Tags]    002    positivo    get_user
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}

    # 1. SETUP: Cadastra um usuário para garantir que o ID existe
    ${payload}    Create Payload Usuario
    
    ${resp_post}    POST On Session    serverest
    ...    /usuarios
    ...    json=${payload}
    
    Status Should Be    201    ${resp_post}
    ${ID_GERADO}    Set Variable       ${resp_post.json()}[_id]

    # 2. EXECUÇÃO: Busca o usuário pelo ID capturado
    ${response}    GET On Session    serverest
    ...    /usuarios/${ID_GERADO}

    # 3. VALIDAÇÃO: Verifica se os dados são íntegros
    Status Should Be    200    ${response}
    Should Be Equal As Strings    ${response.json()}[nome]     ${payload}[nome]
    Should Be Equal As Strings    ${response.json()}[email]    ${payload}[email]
    Should Be Equal As Strings    ${response.json()}[_id]      ${ID_GERADO}
    
    Log To Console    \nBusca realizada com sucesso para o ID: ${ID_GERADO}

Cenário GET-03: Não buscar usuário com ID maior que o permitido
    [Tags]    003    negativo
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}

    ${response}    GET On Session     serverest
    ...    /usuarios/64b7f8f8f8f8f8f8f8f8f8f8
    ...   expected_status=400
    
    Status Should Be    400    ${response}
    ${body}    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}        id
    Should Be Equal As Strings       ${body}[id]    id deve ter exatamente 16 caracteres alfanuméricos

Cenário GET-04: Não buscar usuário com ID menor que o permitido
    [Tags]    004    negativo
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}

    ${response}    GET On Session     serverest
    ...    /usuarios/64b7f8f8f8f8134
    ...    expected_status=400

    Status Should Be    400    ${response}
    ${body}    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}     id
    Should Be Equal As Strings    ${body}[id]    id deve ter exatamente 16 caracteres alfanuméricos

Cenário GET-05: Não buscar usuário com ID inexistente
    [Tags]    005    negativo
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}

    ${response}    GET On Session     serverest
    ...    /usuarios/64b7f8f8f8f81345
    ...    expected_status=400

    Status Should Be    400    ${response}
    ${body}    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}             message
    Should Be Equal As Strings       ${body}[message]    Usuário não encontrado
