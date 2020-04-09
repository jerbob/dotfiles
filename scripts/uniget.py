#!/bin/env python

"""uniget.py: Pull timetable data from my.hud.ac.uk."""

import json
import re
from datetime import datetime
from pathlib import Path
from typing import Any, List

from requestium import Session

from selenium.webdriver.remote.webelement import WebElement


root = 'https://my.hud.ac.uk'

session = Session(
    browser='chrome',
    webdriver_path='/usr/bin/chromedriver',
    webdriver_options=dict(arguments=['headless'])
)

config = Path('~/.config/uniget').expanduser()

with open(config / 'credentials.txt') as file:
    credentials = file.read().strip().split(':')

session.driver.get(f'{root}/Pages/default.aspx')

button = session.driver.find_element_by_class_name('btn-primary')
username, password = session.driver.find_elements_by_class_name('form-control')

username.send_keys(credentials[0])
password.send_keys(credentials[1])
button.click()

session.driver.get(
    f'{root}/_layouts/15/HudStuPortal/simpleCPIP.aspx?sys=timetable'
)
session.driver.ensure_element_by_tag_name('td')

lessons: List[WebElement] = [
    *session.driver.find_elements_by_class_name('lect'),
    *session.driver.find_elements_by_class_name('prac')
]
session.close()

timetable: List[List[Any]] = [[], [], [], [], []]


def search(pattern: str, source: str) -> str:
    """Return the first group matched by a pattern."""
    match = re.search(pattern, source)
    if match is not None:
        return match.group(1)
    else:
        return str()


for lesson in lessons:
    day = -1
    result = re.match(
        r'ctl00_ContentPlaceHolder1_Schedule1_r\d+-c(\d)',
        lesson.find_element_by_tag_name('span').get_property('id')
    )
    if result is not None:
        day += int(result.group(1))
    timetable[day].append([
        search(r'Room: (.*?)\s', lesson.text),
        search(r'\n([A-Za-z0-9 ]+\([A-Z][a-z]+\))\n', lesson.text),
        *re.findall(r'\d\d:\d\d', lesson.text),
    ])

for column in timetable:
    column.sort(
        key=lambda day:
        datetime.strptime(
            day[2], '%H:%M'
        )
    )


with open(config / 'timetable.json', 'w+') as file:
    json.dump(timetable, file)
