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

Refresh Current Page
    Click Button    ${btn_refresh}
    Wait Until Element Is Visible    ${loading_icon}
    Wait Until Element Is Not Visible    ${loading_icon}
    Log To Console    ${URL}
    Log To Console    ${USERNAME}
    Log To Console    ${LIST_1}
    Log To Console    ${DICT_1}