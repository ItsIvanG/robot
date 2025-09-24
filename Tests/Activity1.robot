*** Settings ***
Resource    ../Resources/CustomerPage.resource

Test Setup    Prepare Test

*** Variables ***
${URL}    https://marmelab.com/react-admin-demo/
${USERNAME}    demo
${PASSWORD}    demo

*** Test Cases ***

TEST_CASE_1
    
    ${users}    Get Random Users
    FOR    ${i}    IN RANGE    5
        Go To Customers Page
        Create User    ${users[${i}]}
        Verify User Form    ${users[${i}]}
    END



*** Keywords ***
Prepare Test
    Launch browser
    Login User

Click user in table
    [Arguments]    ${user}
    Go To Customers Page
    Refresh Current Page
    ${fetched_name}    Get Text    ((${table_row})[1]//td)[2]
    IF    "\\n" in """${fetched_name}"""
        ${fetched_name}    Evaluate    """${fetched_name}""".replace("\\n","")[1:]
        Click Element    ((${table_row})[1]//td)[2]
    END
    Should Be Equal As Strings    ${user["name"].split(" ")[0]} ${user["name"].split(" ")[1]}    ${fetched_name}


Verify User Form
    [Arguments]    ${user}
    Wait Until Element Is Visible    ${customers_txt_firstname}
    ${firstname}=    Get Element Attribute    ${customers_txt_firstname}    value
    Should Be Equal As Strings    ${firstname}    ${user["name"].split(" ")[0]}

    ${lastname}=    Get Element Attribute    ${customers_txt_lastname}    value
    Should Be Equal As Strings    ${lastname}    ${user["name"].split(" ")[1]}

    ${email}=    Get Element Attribute    ${customers_txt_email}    value
    Should Be Equal As Strings    ${email}    ${user["email"]}

    
    ${birthday_ui}=    Get Element Attribute    ${customers_txt_birthday}    value
    ${bday}=    Set Variable    ${user["birthday"]}
    ${yyyy}=    Set Variable    ${bday}[4:]
    ${mm}=      Set Variable    ${bday}[2:4]
    ${dd}=      Set Variable    ${bday}[0:2]
    ${birthday_expected}=    Set Variable    ${yyyy}-${dd}-${mm}
    Should Be Equal As Strings    ${birthday_ui}    ${birthday_expected}

    ${address}=    Get Element Attribute    ${customers_txt_address}    value
    Should Be Equal As Strings    ${address}    ${user["address"]["street"]} ${user["address"]["suite"]}

    ${city}=    Get Element Attribute    ${customers_txt_city}    value
    Should Be Equal As Strings    ${city}    ${user["address"]["city"]}

    ${state}=    Get Element Attribute    ${customers_txt_sateAbbr}    value
    Should Be Equal As Strings    ${state}    ${user["address"]["stateAbbr"]}

    ${zipcode}=    Get Element Attribute    ${customers_txt_zipcode}    value
    Should Be Equal As Strings    ${zipcode}    ${user["address"]["zipcode"]}

    ${password}=    Get Element Attribute    ${customers_txt_password}    value
    Should Be Equal As Strings    ${password}    ${user["password"]}

    ${confirm}=    Get Element Attribute    ${customers_txt_confirm_password}    value
    Should Be Equal As Strings    ${confirm}    ${user["password"]}
