*** Settings ***
Name       DELETE -> /USUARIOS
Documentation    Exclusão de Usuários - ServeRest
Resource    ../../../resources/base.resource

*** Test Cases ***
Cenário DEL-01: Excluir usuário
    [Tags]    001    positivo    del_user
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}

    # 1. SETUP: Cadastra um usuário para garantir que o ID existe
    ${payload}    Create Payload Usuario
    
    ${resp_post}    POST On Session    serverest
    ...    /usuarios
    ...    json=${payload}
    
    Status Should Be    201    ${resp_post}
    ${ID_GERADO}    Set Variable       ${resp_post.json()}[_id]

    # 2. EXECUÇÃO: Deleta o usuário pelo ID capturado
    ${response}    DELETE On Session    serverest
    ...    /usuarios/${ID_GERADO}

    # 3. VALIDAÇÃO: Verifica se os dados são íntegros
    Status Should Be    200    ${response}
    ${body}    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}             message
    Should Be Equal As Strings       ${body}[message]    Registro excluído com sucesso

    # 4. EXECUÇÃO: Busca o usuário pelo ID deletado para garantir que não existe mais
    ${response}    GET On Session
    ...    serverest
    ...    /usuarios/${ID_GERADO}
    ...    expected_status=400

    Status Should Be    400    ${response}
    ${body}    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}             message
    Should Be Equal As Strings       ${body}[message]    Usuário não encontrado

Cenário del-02: Não excluir usuário inexistente
    [Tags]    002    negativo
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}

    ${response}    DELETE On Session    serverest
    ...    /usuarios/64b7A1A1A1A1A1f8
    ...   expected_status=200
    
    Status Should Be    200    ${response}
    ${body}    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}             message
    Should Be Equal As Strings       ${body}[message]    Nenhum registro excluído

Cenário DEL-03: Não excluir usuário com carrinho cadastrado
    [Tags]    003    negativo    del_user
    Skip    Necessário fazer a inclusão do carrinho para finalizar esse cenário
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}

    # 1. SETUP: Cadastra um usuário para garantir que o ID existe
    ${payload}    Create Payload Usuario
    
    ${resp_post}    POST On Session    serverest
    ...    /usuarios
    ...    json=${payload}
    
    Status Should Be    201    ${resp_post}
    ${ID_GERADO}    Set Variable       ${resp_post.json()}[_id]

    # 3. SETUP: Cria um carrinho para o usuário criado

    # 2. EXECUÇÃO: Deleta o usuário pelo ID capturado
    ${response}    DELETE On Session    serverest
    ...    /usuarios/${ID_GERADO}

    # 3. VALIDAÇÃO: Verifica se os dados são íntegros
    Status Should Be    200    ${response}
    ${body}    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}             message
    Should Be Equal As Strings       ${body}[message]    Registro excluído com sucesso

    # 4. EXECUÇÃO: Busca o usuário pelo ID deletado para garantir que não existe mais
    ${response}    GET On Session
    ...    serverest
    ...    /usuarios/${ID_GERADO}
    ...    expected_status=400

    Status Should Be    400    ${response}
    ${body}    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}             message
    Should Be Equal As Strings       ${body}[message]    Usuário não encontrado