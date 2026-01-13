*** Settings ***
Name       GET -> /PRODUTOS
Documentation    Consulta de Produtos - ServeRest
Resource    ../../../resources/base.resource

*** Test Cases ***
Cenário GET-PRODUTO-01: Consultar todos os produtos cadastrados
    [Tags]    001    produtos
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}
    
    ${response}    GET On Session    serverest
    ...    /produtos
    
    Status Should Be    200    ${response}

    # Validar que 'quantidade' corresponde ao tamanho da lista 'produtos'
    ${body}          Set Variable    ${response.json()}
    ${quantidade}    Set Variable    ${body}[quantidade]
    ${produtos}      Set Variable    ${body}[produtos]
    ${lista_len}    Get Length       ${produtos}
    Should Be Equal As Integers      ${quantidade}    ${lista_len}

    # Validar o primeiro produto: chaves existem e valores conforme exemplo
    ${primeiro}    Get From List     ${produtos}    0
    Dictionary Should Contain Key    ${primeiro}    nome
    Dictionary Should Contain Key    ${primeiro}    preco
    Dictionary Should Contain Key    ${primeiro}    descricao
    Dictionary Should Contain Key    ${primeiro}    quantidade
    Dictionary Should Contain Key    ${primeiro}    _id

Cenário GET-PRODUTO-02: Buscar produto por ID
    [Tags]    002    produtos
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

    ${response}    GET On Session    serverest
    ...    /produtos/${id_consulta}
    
    Status Should Be    200    ${response}

Cenário GET-PRODUTO-03: Não buscar produto com ID maior que o permitido
    [Tags]    003    produtos
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}

    ${response}    GET On Session     serverest
    ...    /produtos/64b7f8f8f8f8f8f8f8f8f8f8
    ...   expected_status=400
    
    Status Should Be    400    ${response}
    ${body}    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}        id
    Should Be Equal As Strings       ${body}[id]    id deve ter exatamente 16 caracteres alfanuméricos

Cenário GET-PRODUTO-04: Não buscar produto com ID menor que o permitido
    [Tags]    004    produtos
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}

    ${response}    GET On Session     serverest
    ...    /produtos/64b7f8f8f8f8134
    ...    expected_status=400

    Status Should Be    400    ${response}
    ${body}    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}     id
    Should Be Equal As Strings    ${body}[id]    id deve ter exatamente 16 caracteres alfanuméricos

Cenário GET-PRODUTO-05: Não buscar produto com ID inexistente
    [Tags]    005    produtos
    ${APIURL}    Get Url Api
    Create Session     serverest    ${APIURL}

    ${response}    GET On Session     serverest
    ...    /produtos/64b7f8f8f8f81345
    ...    expected_status=400

    Status Should Be    400    ${response}
    ${body}    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}             message
    Should Be Equal As Strings       ${body}[message]    Produto não encontrado
