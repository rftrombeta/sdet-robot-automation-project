*** Settings ***
Library    sdet_python_automation_core.libraries.base_library.BaseLibrary

*** Test Cases ***
GET Example Using Core Framework
    Create HTTP Client    https://jsonplaceholder.typicode.com
    GET    /posts/1
    Status Should Be    200
