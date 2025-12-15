*** Settings ***
Library    sdet_python_automation_core.libraries.base_library.BaseLibrary

*** Test Cases ***
Criar usuário com sucesso
    Create HTTP Client From Config
    Criar Usuário ServeRest
    Validar Status Code    201
