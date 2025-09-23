*** Settings ***
Library    SeleniumLibrary
Library    ../Library/CustomLibrary.py
Variables    ../variables.py

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
    Go To Customers Page

    Verify user is added    ${users[0]}

*** Keywords ***
Launch browser
    [Arguments]    ${url}=${URL}
    Open Browser    ${url}    chrome    options=add_argument("--start-maximized");
    Wait Until Keyword SUcceeds    5x    .5s    Wait Until Element Is Visible    ${login_txt_username}

Login User
    [Arguments]    ${username}=${USERNAME}    ${password}=${PASSWORD}
    Input Text    ${login_txt_username}    ${username}
    Input Text    ${login_txt_password}    ${password}
    Click Button    //*[@id="root"]/div/div/form/div/button

Try for loops
    FOR    ${i}    IN    @{LIST_1}
        Log To Console    ${i}
    END
    
    FOR    ${i}    IN RANGE    0    2
        Log To Console    ${LIST_1[${i}]}
    END

    FOR    ${i}    IN    @{DICT_1.keys()}
        Log To Console    ${DICT_1["${i}"]}
    END

Go To Customers Page
    Click Element    ${nav_btn_customers}
    Wait Until Element Is Visible    //table//tbody//tr

Create User
    [Arguments]    ${user}
    Click Element    ${customers_btn_create}
    Wait Until Element Is Visible    ${customers_txt_firstname}
    Input Text    ${customers_txt_firstname}    ${user["name"].split(" ")[0]}
    Input Text    ${customers_txt_lastname}    ${user["name"].split(" ")[1]}
    Input Text    ${customers_txt_email}    ${user["email"]}
    Input Text    ${customers_txt_birthday}    ${user["birthday"]}
    Input Text    ${customers_txt_address}    ${user["address"]["street"]} ${user["address"]["suite"]}
    Input Text    ${customers_txt_city}    ${user["address"]["city"]}
    Input Text    ${customers_txt_sateAbbr}    ${user["address"]["stateAbbr"]}
    Input Text    ${customers_txt_zipcode}    ${user["address"]["zipcode"]}
    Input Text    ${customers_txt_password}    ${user["password"]}
    Input Text    ${customers_txt_confirm_password}    ${user["password"]}
    Click Button    ${customers_txt_save}
    Wait Until Page Contains    Customer created

Verify user is added
    [Arguments]    ${user}
    Wait Until Page Contains    ${user["name"]}
    ${fetched_name}    Get Text    ((//table//tbody//tr)[1]//td)[2]
    IF    "\\n" in """${fetched_name}"""
        ${fetched_name}    Evaluate    """${fetched_name}""".replace("\\n","")[1:]  
    END
    Should Be Equal As Strings    ${user["name"]}    ${fetched_name}
    Log To Console    ${fetched_name}