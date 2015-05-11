@echo off
 
setlocal ENABLEDELAYEDEXPANSION
 
set APPCLASSPATH="%CLASSPATH%"
rem set APPCLASSPATH=.

set TC_INSTALL_DIR="I:\Terracota\terracotta-2.7.0-stable0"
set TC_CONFIG_PATH="10.68.8.70:9510"

for %%i in ("*.jar") do set APPCLASSPATH=!APPCLASSPATH!;%%i

set DSO_BOOT_JAR="I:\Terracota\terracotta-2.7.0-stable0\lib\dso-boot\dso-boot-hotspot_win32_160.jar"

java -classpath %APPCLASSPATH% -Xbootclasspath/p:%DSO_BOOT_JAR% -Dtc.install-root=%TC_INSTALL_DIR% -Dtc.config=%TC_CONFIG_PATH%  es.capgemini.pfs.batch.Main
