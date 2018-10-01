#!/bin/bash

set -e

/opt/katalonstudio/katalon -runMode=console -projectPath=/katalon/katalon/source/KatalonAndroidSample.prj -consoleLog -testSuitePath=Test\ Suites/Regression\ Tests -browserType=Remote
