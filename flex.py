#!/usr/bin/python3
import time
import pyautogui
from pyautogui import hotkey, typewrite, press
import pyperclip
import os

#usage : python3 ~/.scripts/flex.py

os.system("i3-msg 'split v'")

name = "Camille Is Me "

delay = 0.1

def enter_text(text):
    pyperclip.copy(text)
    pyautogui.hotkey("ctrl","shift","v")
    pyautogui.press("enter")

pyautogui.hotkey("win","e")

for i in range(2):pyautogui.hotkey("win","enter")

time.sleep(delay)

pyautogui.hotkey("win","shift","down")

time.sleep(delay)

enter_text("wego -d 1 --location 'Valence, FR'")

time.sleep(delay)

enter_text("chalk-animation rainbow 'Rice by Camille.Is_Me'")

time.sleep(delay)

pyautogui.hotkey("win","up")

time.sleep(delay)

enter_text("hyfetch")

time.sleep(delay)

pyautogui.hotkey("win","left")

time.sleep(delay)

enter_text("cbonsai -li")