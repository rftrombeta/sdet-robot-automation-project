*** Settings ***
Name       PUT -> /USUARIOS
Documentation    Alteração de Usuários - ServeRest
Resource    ../../../resources/base.resource

*** Test Cases ***
Cenário PUT-01: Altera o cadastro de usuário
    [Tags]    001    positivo    put_user
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}

    # 1. SETUP: Cadastra um usuário para garantir que o ID existe
    ${payload}    Create Payload Usuario
    
    ${resp_post}    POST On Session    serverest
    ...    /usuarios
    ...    json=${payload}
    
    Status Should Be    201    ${resp_post}
    ${ID_GERADO}    Set Variable       ${resp_post.json()}[_id]

    # 2. EXECUÇÃO: Gera novos dados e altera o usuário pelo ID capturado
    ${payload_alteracao}    Create Payload Usuario
    ${response}    PUT On Session    serverest
    ...    /usuarios/${ID_GERADO}
    ...    json=${payload_alteracao}

    # 3. VALIDAÇÃO: Verifica se os dados são íntegros
    Status Should Be    200    ${response}
    ${body}    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}             message
    Should Be Equal As Strings       ${body}[message]    Registro alterado com sucesso

    # 4. EXECUÇÃO: Busca o usuário pelo ID para garantir que os dados foram alterados
    ${response}    GET On Session
    ...    serverest
    ...    /usuarios/${ID_GERADO}
    ...    expected_status=200

    Status Should Be    200    ${response}
    Should Be Equal As Strings    ${response.json()}[nome]             ${payload_alteracao}[nome]
    Should Be Equal As Strings    ${response.json()}[email]            ${payload_alteracao}[email]
    Should Be Equal As Strings    ${response.json()}[password]         ${payload_alteracao}[password]
    Should Be Equal As Strings    ${response.json()}[administrador]    ${payload_alteracao}[administrador]
