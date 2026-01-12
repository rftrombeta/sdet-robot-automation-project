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

# --- Resource Files --- #
Resource    ../resources/actions/actions_serverest_login.resource