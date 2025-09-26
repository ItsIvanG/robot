*** Settings ***
Resource    ../Resources/CustomerPage.resource
Suite Setup    Prepare Test

*** Variables ***
${URL}    https://marmelab.com/react-admin-demo/
${USERNAME}    demo
${PASSWORD}    demo
${MIN_TOTAL_SPENDING}    3500

*** Test Cases ***

TEST_CASE_1
    ${users}    Get Random Users
    Add And Verify First Five Users    ${users}
    Verify First Five Users In Table    ${users}

TEST_CASE_2
    ${users}    Get Random Users
    ${users_to_edit}    Set Variable    ${users}[5:]   
    Edit And Verify Last Five Users    ${users_to_edit}

TEST_CASE_3
    Log Table Data

TEST_CASE_4
    Analyze User Spending From Table


