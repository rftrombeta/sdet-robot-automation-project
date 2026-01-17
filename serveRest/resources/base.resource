***Settings***
Documentation    Arquivo que implementa a estrutura inicial do projeto de teste

# --- Import Utils Robot Framework --- #
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Library    JSONLibrary
Library    robot.libraries.DateTime
Library    robot.libraries.String

# --- Lib QA --- #
Library    sdet_python_automation_core.models
Library    sdet_python_automation_core.url
Library    sdet_python_automation_core.utils
Library    sdet_python_automation_core.generators

# --- Resource Files --- #
## Actions
Resource    ../resources/actions/actions_login.resource
Resource    ../resources/actions/actions_usuarios.resource

## Assertions
Resource    ../resources/assertions/assertions_login.resource
Resource    ../resources/assertions/assertions_usuarios.resource