# windows-dark-theme-regulator
Powershell script that can be run as system to change a logged in users light/dark theme. 
Created to be run from a system management server such as K1000.

darkModeRegulator.ps1 is intended to be run as system while a user is currently logged in. It will prompt the user to select DARK/LIGHT
mode with a simple messagebox prompt. Then, ask if they would like to be logged out if they didn't choose cancel, to apply the changes.

This script was only tested in a domain joined enviroment that locks these settings down.
