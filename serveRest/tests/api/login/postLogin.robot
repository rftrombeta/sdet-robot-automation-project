*** Settings ***
Name       POST -> /LOGIN
Documentation
...    Validação do endpoint de Login - ServeRest
Resource    ../../../resources/base.resource

*** Test Cases ***
Cenário POST-LOGIN-01: Login com sucesso
    [Tags]    001    login
    
    ${USUARIO}    Criar usuario comum

    ${TOKEN}    Logar usuario com sucesso    ${USUARIO}[email]    ${USUARIO}[password]

Cenário POST-LOGIN-02: Login com senha incorreta
    [Tags]    002    login
    
    ${USUARIO}    Criar usuario comum

    Logar usuario com senha ou email incorretos    ${USUARIO}[email]    123456

Cenário POST-LOGIN-03: Login com email incorreto
    [Tags]    003    login
    
    ${USUARIO}    Criar usuario comum

    Logar usuario com senha ou email incorretos    email_errado@teste.com    ${USUARIO}[password]
