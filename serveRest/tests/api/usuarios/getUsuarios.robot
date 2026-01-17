*** Settings ***
Name       GET -> /USUARIOS
Documentation    Consulta de Usuários - ServeRest
Resource    ../../../resources/base.resource

*** Test Cases ***
Cenário GET-USUARIOS-01: Consultar todos os usuarios cadastrados
    [Tags]    001    usuarios
    
    ${RESPONSE_CONSULTA}    Consultar usuarios
    
    Valida lista de usuarios cadastrados   ${RESPONSE_CONSULTA}

Cenário GET-USUARIOS-02: Buscar usuário por ID
    [Tags]    002    usuarios
    
    ${PAYLOAD_USUARIO}    ${RESPONSE_CADASTRO}    Criar usuario comum

    ${RESPONSE_CONSULTA}    Consultar usuarios    ${RESPONSE_CADASTRO.json()}[_id]

    Valida usuario cadastrado    ${PAYLOAD_USUARIO}    ${RESPONSE_CONSULTA}

Cenário GET-USUARIOS-03: Não buscar usuário com ID maior que o permitido
    [Tags]    003    usuarios
    
    ${RESPONSE_CONSULTA}    Não permitir consultar usuarios    64b7f8f8f8f8f8f8f8f8f8f8
    
    Valida resposta de erro para consulta com ID inválido    ${RESPONSE_CONSULTA}

Cenário GET-USUARIOS-04: Não buscar usuário com ID menor que o permitido
    [Tags]    004    usuarios
    
    ${RESPONSE_CONSULTA}    Não permitir consultar usuarios    64b7f8f8f8f8134
    
    Valida resposta de erro para consulta com ID inválido    ${RESPONSE_CONSULTA}

Cenário GET-USUARIOS-05: Não buscar usuário com ID inexistente
    [Tags]    005    usuarios
    
    ${RESPONSE_CONSULTA}    Não permitir consultar usuarios    64b7f8f8f8f81345
    
    Valida resposta de erro para consulta com ID inexistente    ${RESPONSE_CONSULTA}
