*** Settings ***
Resource    ../Resources/CustomerPage.resource

# Test Setup    Launch browser
# Test Teardown    

*** Variables ***
# ${URL}    https://opensource-demo.orangehrmlive.com/web/index.php/auth/login
# ${USERNAME}    Admin
# ${PASSWORD}    admin123

${URL}    https://marmelab.com/react-admin-demo/
${USERNAME}    demo
${PASSWORD}    demo

&{DICT_1}    key_1=value_1    key_2=value_2    key_3=value_3
@{LIST_1}    VAL1    VAL2    VAL3

*** Test Cases ***
TEST-000001
    [Documentation]    This is a sample test case
    Launch browser
    Login User
    Try for loops
    Sleep    5s

TEST-000002
    ${users}    Get Random Users
    # FOR    ${i}    IN    @{users}
    #     Log To Console    ${i["name"]}
        

    # END
    Launch browser
    Login User
    Go To Customers Page
    Create User    ${users[0]}
    Check user fields    ${users[0]}



TEST-000003
    ${array_1}    Create List    val_1    val_2
    ${eval_1}    

*** Keywords ***
Check user fields
    [Arguments]    ${user}
    Verify user is added    ${user}
    


