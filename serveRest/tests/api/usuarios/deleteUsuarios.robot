*** Settings ***
Name       DELETE -> /USUARIOS
Documentation    Exclusão de Usuários - ServeRest
Resource    ../../../resources/base.resource

*** Test Cases ***
Cenário DELETE-USUARIOS-01: Excluir usuário
    [Tags]    001    usuarios
    
    ${usuario}    ${response_cadastro}    Criar usuario comum
    ${id_usuario}    Set Variable    ${response_cadastro.json()}[_id]

    ${response_delete}    Deletar usuario    ${id_usuario}

    ${response_consulta}    Não permitir consultar usuarios    ${id_usuario}

    Valida resposta de erro para consulta com ID inexistente    ${response_consulta}

Cenário DELETE-USUARIOS-02: Não excluir usuário inexistente
    [Tags]    002    usuarios
    
    ${id_inexistente}    Generate Identifier Code Random    16
    
    ${response_delete}    Deletar usuario    ${id_inexistente}    True

Cenário DELETE-USUARIOS-03: Não excluir usuário com carrinho cadastrado
    [Tags]    003    usuarios    del_user
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
