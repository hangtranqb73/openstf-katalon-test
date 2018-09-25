#!/bin/bash

set -e

/opt/katalonstudio/katalon -runMode=console -projectPath=/katalon/katalon/source/KatalonAndroidSample.prj -testSuitePath=Test\ Suites/Regression\ Tests -browserType=Remote -remoteWebDriverUrl=http://appium:7423/wd/hub -remoteWebDriverType=Appium
