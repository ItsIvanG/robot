from SeleniumLibrary import SeleniumLibrary
import shutil
import logging

def log_chromedriver_path():
    driver_path = shutil.which("chromedriver")
    if driver_path:
        logging.info(f"Chromedriver found at: {driver_path}")
    else:
        logging.info("Chromedriver not found in PATH. Selenium Manager may be downloading it automatically.")
