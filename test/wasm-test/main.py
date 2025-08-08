import argparse
import http
import typing
import splinter
from splinter import Browser
from time import sleep

from splinter.driver.webdriver import WebDriverElement, WebDriverWait
from operator import attrgetter


def run(url: str, driver: str, headless: bool):
    print("Begin running.")
    with Browser(driver, config=splinter.Config(headless=headless)) as browser:
        browser.visit(url)
        print("Waiting for output")
        WebDriverWait(browser, 10).until(lambda d: len(d.find_by_css(".stdout-entry")) > 4, "stdout not found")
        stdout = browser.find_by_css(".stdout-entry")
        stderr = browser.find_by_css(".stderr-entry")
        print("Stdout:")
        print([typing.cast(WebDriverElement, x)["textContent"] for x in stdout])
        print("Stderr:")
        print([typing.cast(WebDriverElement, x)["textContent"] for x in stderr])

def main():
    parser = argparse.ArgumentParser(
        description='run tests for a web game')
    parser.add_argument(
        'url', type=str,
        help='url with the deployed game to test')
    parser.add_argument(
        '--browser', default="firefox", type=str, choices=["firefox", "chromium", "edge", "remote"],
        help='browser to run')
    parser.add_argument(
        '--headless', action="store_true",
        help='whether the browser should run headless (not supported by all browsers)')
    args = parser.parse_args()
    url: str = args.url
    browser: str = args.browser

    print("Hello from wasm-test!")
    print(f"Running with url {url}, browser {args.browser}")
    run(url, driver=browser, headless=args.headless)



if __name__ == "__main__":
    main()
