*** Settings ***
Library    SeleniumLibrary
Variables    ../Variables/customerpage.py
Library    ../Library/CustomLibrary.py
Variables    ../Variables/variables.py



*** Variables ***

${URL}
${USERNAME}
${LIST_1}
${DICT_1}

*** Keywords ***

Prepare Test
    Launch browser
    Login User


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

Refresh Current Page
    Click Button    ${btn_refresh}
    Wait Until Element Is Visible    ${loading_icon}
    Wait Until Element Is Not Visible    ${loading_icon}
    Log To Console    ${URL}
    Log To Console    ${USERNAME}
    Log To Console    ${LIST_1}
    Log To Console    ${DICT_1}