*** Settings ***
Name       POST -> /USUARIOS
Documentation    Validação do Cadastro de Usuários - ServeRest
Resource    ../../../resources/base.resource

*** Test Cases ***
Cenário POST-USUARIOS-01: Cadastrar novo usuário com sucesso
    [Tags]    001    usuarios
    
    ${USUARIO}    ${RESPONSE_CADASTRO}    Criar usuario comum

    Valida cadastro de usuario    ${RESPONSE_CADASTRO}
    
    Log To Console    Usuário criado com ID: ${RESPONSE_CADASTRO.json()}[_id]

Cenário POST-USUARIOS-02: Cadastrar novo usuário administrador com sucesso
    [Tags]    002    usuarios
    
    ${USUARIO}    ${RESPONSE_CADASTRO}    Criar usuario administrador

    Valida cadastro de usuario    ${RESPONSE_CADASTRO}
    
    Log To Console    Usuário criado com ID: ${RESPONSE_CADASTRO.json()}[_id]

Cenário POST-USUARIOS-03: Não cadastrar usuário com email existente
    [Tags]    003    usuarios
    
    ${USUARIO}    ${RESPONSE_CADASTRO}    Criar usuario comum

    Valida cadastro de usuario    ${RESPONSE_CADASTRO}

    ${RESPONSE_CADASTRO_DUPLICADO}    Criar usuario duplicado    ${USUARIO}

    Valida cadastro de usuario    ${RESPONSE_CADASTRO_DUPLICADO}
