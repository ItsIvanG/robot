*** Settings ***
Resource    ../Resources/App.resource
*** Keywords ***
*** Keywords ***
Launch browser
    [Arguments]    ${url}=${URL}
    
    # --- Chrome Options ---
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --disable-popup-blocking
    Call Method    ${options}    add_argument    --disable-notifications
    Call Method    ${options}    add_argument    --disable-save-password-bubble
    Call Method    ${options}    add_argument    --start-maximized
    Call Method    ${options}    add_argument    --disable-password-manager-reauthentication

    # --- Chrome Preferences ---
    ${prefs}=    Create Dictionary
    ...    credentials_enable_service=False
    ...    profile.password_manager_enabled=False
    ...    profile.default_content_setting_values.notifications=2
    ...    safebrowsing.enabled=False
    ...    safebrowsing.disable_download_protection=True
    Call Method    ${options}    add_experimental_option    prefs    ${prefs}

    # --- Open Browser ---
    Open Browser    ${url}    chrome    options=${options}

    # --- Wait for Login Page ---
    Wait Until Keyword Succeeds    5x    0.5s    Wait Until Element Is Visible    ${login_txt_username}
Login User
    [Arguments]    ${username}=${USERNAME}    ${password}=${PASSWORD}
    Input Text    ${login_txt_username}    ${username}
    Input Text    ${login_txt_password}    ${password}
    Click Button    //*[@id="root"]/div/div/form/div/button

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
    Click Button    ${customers_btn_save}
    Wait Until Page Contains    Customer created

Verify user is added
    [Arguments]    ${user}
    Go To Customers Page

    Refresh Current Page
    ${fetched_name}    Get Text    ((${table_row})[1]//td)[2]
    IF    "\\n" in """${fetched_name}"""
        ${fetched_name}    Evaluate    """${fetched_name}""".replace("\\n","")[1:]
    END
    Should Be Equal As Strings    ${user["name"].split(" ")[0]} ${user["name"].split(" ")[1]}    ${fetched_name}