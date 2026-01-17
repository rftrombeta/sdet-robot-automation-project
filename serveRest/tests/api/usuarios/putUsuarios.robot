*** Settings ***
Name       PUT -> /USUARIOS
Documentation    Alteração de Usuários - ServeRest
Resource    ../../../resources/base.resource

*** Test Cases ***
Cenário PUT-USUARIOS-01: Altera o cadastro de um usuário
    [Tags]    001    usuarios
    
    ${payload_usuario}    ${response_cadastro}    Criar usuario comum
    ${id_usuario}    Set Variable    ${response_cadastro.json()}[_id]

    ${payload_usuario_put}    Create Payload Usuario

    ${response_put}    Alterar dados de usuario    ${id_usuario}    ${payload_usuario_put}

    Valida alteracoes de usuario    ${id_usuario}    ${payload_usuario_put}

Cenário PUT-USUARIOS-02: Atualização via PUT com ID inexistente que resulta em criação
    [Tags]    002    usuarios
    
    ${id_inexistente}    Generate Identifier Code Random    16

    ${payload_usuario_put}    Create Payload Usuario

    ${response_put}    Alterar dados de usuario    ${id_inexistente}    ${payload_usuario_put}
    ${new_id_usuario}    Set Variable    ${response_put.json()}[_id]

    Valida alteracoes de usuario    ${new_id_usuario}    ${payload_usuario_put}

Cenário PUT-USUARIOS-03: Altera o cadastro de um usuário utilizando um email já existente
    [Tags]    003    usuarios
    
    ${payload_usuario}    ${response_cadastro}    Criar usuario comum
    ${id_usuario}    Set Variable    ${response_cadastro.json()}[_id]

    ${payload_segundo_usuario}    ${response_segundo_cadastro}    Criar usuario comum
    ${id_segundo_usuario}    Set Variable    ${response_segundo_cadastro.json()}[_id]

    ${payload_usuario_put}    Create Payload Usuario
    ${payload_usuario_put}[email]    Set Variable    ${payload_usuario}[email]

    ${response_put}    Alterar dados de usuario    ${id_segundo_usuario}    ${payload_usuario_put}
