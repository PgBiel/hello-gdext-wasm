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
        print("Dream, dream")
        root = browser.find_by_tag("html").first
        WebDriverWait(browser, 10).until(lambda d: len(d.find_by_css(".stdout-entry")) > 4, "stdout not found")
        print("Done waiting")
        stdout = browser.find_by_css(".stdout-entry")
        stderr = browser.find_by_css(".stderr-entry")
        print("Stdout:")
        print(stdout)
        print([typing.cast(WebDriverElement, x)["textContent"] for x in stdout])
        # print("First text:", browser.execute_script("return arguments[0].textContent;", stdout[0]))
        # https://www.reddit.com/r/learnpython/comments/mrifjq/selenium_webscrapper_returns_empty_string_from_a/
        stdout2 = browser.execute_script("return Array.from(document.querySelectorAll('.stdout-entry')).map(el => el.textContent);")
        stderr2 = browser.execute_script("return Array.from(document.querySelectorAll('.stderr-entry')).map(el => el.textContent);")
        print("Stdout text:", stdout2)
        print("Stderr text:", stderr2)

def main():
    parser = argparse.ArgumentParser(
        description='run tests for a web game')
    # parser.add_argument(
    #     'integers', metavar='int', nargs='+', type=int,
    #     help='an integer to be summed')
    parser.add_argument(
        'url', type=str,
        help='url with the deployed game to test')
    parser.add_argument(
        '--browser', default="firefox", type=str, choices=["firefox", "chromium", "edge", "remote"],
        help='browser to run')
    parser.add_argument(
        '--headless', default=False, type=bool,
        help='whether the browser should run headless (not supported by all browsers)')
    args = parser.parse_args()
    url: str = args.url
    browser: str = args.browser

    print("Hello from wasm-test!")
    print(f"Running with url {url}, browser {args.browser}")
    run(url, driver=browser, headless=args.headless)



if __name__ == "__main__":
    main()
