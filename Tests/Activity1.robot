*** Settings ***
Resource    ../Resources/CustomerPage.resource
Library    String
Library    Collections 
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

Edit And Verify Last Five Users
    [Arguments]    ${users_to_edit}
    FOR    ${i}    IN RANGE    0    5
        ${table_row_index}=    Evaluate    ${i} + 6
        ${user_data}=    Set Variable    ${users_to_edit}[${i}]
        Go To Customers Page

        Click User In Specific Table Row    ${table_row_index}

        Edit User Form    ${user_data}

    END

    
Verify First Five Users In Table
    [Arguments]    ${users}
    Go To Customers Page
    Refresh Current Page
    ${row_count}=    Get Element Count    ${table_row}
    ${limit}=    Set Variable If    ${row_count} < 5    ${row_count}    5

    Should Be True    ${row_count} >= 5    Table does not have enough rows to verify 5 users.

    FOR    ${i}    IN RANGE    0    5
        ${current_user}=    Set Variable    ${users}[${i}]

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

Click User In Specific Table Row
    [Arguments]    ${row_index}
    # Locator for the <td> element containing the name in the specified row
    ${name_locator}=    Set Variable    ((${table_row})[${row_index}]//td)[2]
    
    # Wait for the element to be visible before clicking
    Wait Until Element Is Visible    ${name_locator}

    # Extract the name to ensure we are clicking the correct field (optional but good practice)
    ${fetched_name}=    Get Text    ${name_locator}
    IF    "\\n" in """${fetched_name}"""
        ${fetched_name}    Evaluate    """${fetched_name}""".replace("\\n","")[1:]
    END
    
    Click Element    ${name_locator}
    Wait Until Element Is Visible    ${customers_txt_firstname}
Edit User Form
    [Arguments]    ${user}
    Wait Until Element Is Visible    ${customers_txt_firstname}

    # CTRL (for Windows/Linux) or ${CTRL_OR_CMD}=    COMMAND (for macOS)
    ${SELECT_ALL}=    Set Variable    COMMAND+a

    # --- First Name ---
    Click Element    ${customers_txt_firstname}
    Press Keys    ${customers_txt_firstname}    ${SELECT_ALL}    BACKSPACE
    Input Text    ${customers_txt_firstname}    ${user["name"].split(" ")[0]}

    # --- Last Name ---

    Click Element    ${customers_txt_lastname}
    Press Keys    ${customers_txt_lastname}    ${SELECT_ALL}    BACKSPACE
    Input Text    ${customers_txt_lastname}    ${user["name"].split(" ")[1]}

    # --- Email ---
    Click Element    ${customers_txt_email}
    Press Keys    ${customers_txt_email}    ${SELECT_ALL}    BACKSPACE
    Input Text    ${customers_txt_email}    ${user["email"]}

    # --- Birthday ---
    Click Element    ${customers_txt_birthday}
    Press Keys    ${customers_txt_birthday}    ${SELECT_ALL}    BACKSPACE    TAB    BACKSPACE    TAB    BACKSPACE
    Input Text    ${customers_txt_birthday}    ${user["birthday"]}

    # --- Address ---
    ${full_address}=    Set Variable    ${user["address"]["street"]} ${user["address"]["suite"]}
    Click Element    ${customers_txt_address}
    Press Keys    ${customers_txt_address}    ${SELECT_ALL}    BACKSPACE
    Input Text    ${customers_txt_address}    ${full_address}

    # --- City ---
    Click Element    ${customers_txt_city}
    Press Keys    ${customers_txt_city}    ${SELECT_ALL}    BACKSPACE
    Input Text    ${customers_txt_city}    ${user["address"]["city"]}

    # --- State Abbreviation ---
    Click Element    ${customers_txt_sateAbbr}
    Press Keys    ${customers_txt_sateAbbr}    ${SELECT_ALL}    BACKSPACE
    Input Text    ${customers_txt_sateAbbr}    ${user["address"]["stateAbbr"]}

    # --- Zipcode ---
    Click Element    ${customers_txt_zipcode}
    Press Keys    ${customers_txt_zipcode}    ${SELECT_ALL}    BACKSPACE
    Input Text    ${customers_txt_zipcode}    ${user["address"]["zipcode"]}

    # --- Password ---
    Click Element    ${customers_txt_password}
    Press Keys    ${customers_txt_password}    ${SELECT_ALL}    BACKSPACE
    Input Text    ${customers_txt_password}    ${user["password"]}

    # --- Confirm Password ---
    Click Element    ${customers_txt_confirm_password}
    Press Keys    ${customers_txt_confirm_password}    ${SELECT_ALL}    BACKSPACE
    Input Text    ${customers_txt_confirm_password}    ${user["password"]}

    Click Button    ${customers_btn_save}
    Wait Until Page Contains    Customer updated
Log Table Data
    Go To Customers Page
    Refresh Current Page
    
    Wait Until Element Is Visible    ${table_row}
    
    ${row_count}=    Get Element Count    ${table_row}
    Log To Console    \n--- Logging Customer Table Data (${row_count} Rows) ---
    
    FOR    ${i}    IN RANGE    1    ${row_count}+1
        Log To Console    \n====== User ${i} ======
        
        # Row base locator
        ${current_row_locator}=    Set Variable    (${table_row})[${i}]
        
        # 1. Name (2nd column)
        ${name_locator}=    Set Variable    ${current_row_locator}/td[2]//a/div
        ${raw_name}=    Get Text    ${name_locator}
        ${name}=    Evaluate    " ".join("""${raw_name}""".split()[1:])
        Log To Console    Name: ${name}
        
        # 2. Last Seen (3rd column)
        ${last_seen_locator}=    Set Variable    ${current_row_locator}/td[3]
        ${last_seen}=    Get Text    ${last_seen_locator}
        Log To Console    Last seen: ${last_seen}
        
        # 3. Orders (4th column)
        ${orders_locator}=    Set Variable    ${current_row_locator}/td[4]
        ${orders}=    Get Text    ${orders_locator}
        Log To Console    Orders: ${orders}
        
        # 4. Total Spend (5th column)
        ${total_spent_locator}=    Set Variable    ${current_row_locator}/td[5]
        ${total_spent}=    Get Text    ${total_spent_locator}
        Log To Console    Total spent: ${total_spent}
        
        # 5. Latest Purchase (6th column)
        ${latest_purchase_locator}=    Set Variable    ${current_row_locator}/td[6]
        ${latest_purchase}=    Get Text    ${latest_purchase_locator}
        Log To Console    Latest purchase: ${latest_purchase}
        
       # 6. Has Newsletter (7th column with SVG)
        ${newsletter_locator}=    Set Variable    ${current_row_locator}/td[7]//*[@data-testid]
        ${has_newsletter}=    Get Element Attribute    ${newsletter_locator}    aria-label
        Log To Console    Has newsletter: ${has_newsletter}
        # 7. Segments (8th column chips/spans)
        ${segment_locator}=    Set Variable    ${current_row_locator}/td[8]//span
        ${segment_spans}=    Get Webelements    ${segment_locator}
        
        ${segments}=    Create List
        FOR    ${seg}    IN    @{segment_spans}
            ${seg_text}=    Get Text    ${seg}
            Append To List    ${segments}    ${seg_text}
        END
        Log To Console    Segments: ${segments}
        
    END
    Log To Console    \n--- END OF TABLE DATA ---


Analyze User Spending From Table
    Go To Customers Page

    ${users_with_spent}=    Create List
    ${total_spent}=    Set Variable    0

    ${row_count}=    Get Element Count    ${table_row}
    FOR    ${i}    IN RANGE    1    ${row_count}+1
        ${current_row_locator}=    Set Variable    (${table_row})[${i}]

        # --- Name ---
        ${name_locator}=    Set Variable    ${current_row_locator}/td[2]//a/div
        ${raw_name}=    Get Text    ${name_locator}
        ${name}=    Evaluate    " ".join("""${raw_name}""".split()[1:])


        # --- Total Spent ---
        ${spent_locator}=    Set Variable    ${current_row_locator}/td[5]
        ${spent_text}=    Get Text    ${spent_locator}
        ${spent_text}=    Evaluate    """${spent_text}""".replace("$","").replace(",","").strip()
        ${spent}=    Evaluate    int(${spent_text}) if ${spent_text} else 0

        # --- Keep users with spending > 0 ---
        IF    ${spent} > 0
            ${user}=    Create Dictionary    name=${name}    spent=${spent}
            Append To List    ${users_with_spent}    ${user}
            ${total_spent}=    Evaluate    ${total_spent} + ${spent}
        END
    END

    # --- Display All Users with Spending ---
    Log To Console    \n--- Users with Spending --- 
    FOR    ${user}    IN    @{users_with_spent}
        Log To Console    ${user['name']}: $${user['spent']}
    END

    # --- Display Total ---
    Log To Console    \n=========================
    Log To Console    Total Customer Spending: $${total_spent}
    Log To Console    =========================

    # --- Validate Total Spending ---
    IF    ${total_spent} < ${MIN_TOTAL_SPENDING}
        Log To Console    FAIL: Total spending ($${total_spent}) is below minimum threshold ($${MIN_TOTAL_SPENDING})
        Fail    Total spending below minimum threshold
    ELSE
        Log To Console    PASS: Total spending ($${total_spent}) meets minimum threshold ($${MIN_TOTAL_SPENDING})
    END