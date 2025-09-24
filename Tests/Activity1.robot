*** Settings ***
Resource    ../Resources/CustomerPage.resource
Library    String

Test Setup    Prepare Test

*** Variables ***
${URL}    https://marmelab.com/react-admin-demo/
${USERNAME}    demo
${PASSWORD}    demo

*** Test Cases ***

TEST_CASE_1
    ${users}    Get Random Users
    Add And Verify First Five Users    ${users}
    Verify First Five Users In Table    ${users}


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


Add And Verify First Five Users
    [Arguments]    ${users}
    FOR    ${i}    IN RANGE    5
        Go To Customers Page
        Create User    ${users[${i}]}
        Verify User Form    ${users[${i}]}
    END


*** Variables ***
${table_row}    //*[@id="main-content"]/div/div[1]/div[2]/div/div[2]/table//tbody//tr

*** Keywords ***

Verify First Five Users In Table
    [Arguments]    ${users}
    Go To Customers Page
    Refresh Current Page
    ${row_count}=    Get Element Count    ${table_row}
    ${limit}=    Set Variable If    ${row_count} < 5    ${row_count}    5

    # Check that there are at least 5 rows to verify
    Should Be True    ${row_count} >= 5    Table does not have enough rows to verify 5 users.

    # Iterate through the first 5 users from your data list
    FOR    ${i}    IN RANGE    0    5
        # Get the current user from the list
        ${current_user}=    Set Variable    ${users}[${i}]

        # Search for this specific user in the table
        ${user_found}=    Set Variable    ${False}
        FOR    ${j}    IN RANGE    1    ${row_count}+1
            ${row_locator}=    Set Variable    ((${table_row})[${j}]//td)[2]
            ${fetched_name}=    Get Text    ${row_locator}
            IF    "\\n" in """${fetched_name}"""
                ${fetched_name}=    Evaluate    """${fetched_name}""".replace("\\n","")[1:]
            END

            ${name_parts}=    Split String    ${current_user["name"]}    ${SPACE}
            ${first_name}=    Set Variable    ${name_parts}[0]
            ${last_name}=    Set Variable    ${name_parts}[-1]
            ${expected_name}=    Set Variable    ${first_name} ${last_name}

            IF    '${fetched_name}' == '${expected_name}'
                ${user_found}=    Set Variable    ${True}
                Exit For Loop
            END
        END
        Should Be True    ${user_found}    User '${current_user["name"]}' was not found in the table.
    END 