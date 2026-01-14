*** Settings ***
Name       POST -> /USUARIOS
Documentation    Validação do Cadastro de Usuários - ServeRest
Resource    ../../../resources/base.resource

*** Test Cases ***
Cenário POST-USUARIOS-01: Cadastrar novo usuário com sucesso
    [Tags]    001    usuarios
    
    ${USUARIO}    ${RESPONSE_CADASTRO}    Criar usuario comum
    
    Log To Console    Usuário criado com ID: ${RESPONSE_CADASTRO.json()}[_id]

Cenário POST-USUARIOS-02: Não cadastrar usuário com email existente
    [Tags]    002    usuarios
    
    ${USUARIO}    ${RESPONSE_CADASTRO}    Criar usuario comum

    ${USUARIO}    ${RESPONSE_CADASTRO}    Criar usuario duplicado    ${USUARIO}
