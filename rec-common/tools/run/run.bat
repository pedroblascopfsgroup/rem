@echo off
 
setlocal ENABLEDELAYEDEXPANSION
 
set APPCLASSPATH="%CLASSPATH%"
rem set APPCLASSPATH=.

for %%i in ("*.jar") do set APPCLASSPATH=!APPCLASSPATH!;%%i

java -classpath %APPCLASSPATH% es.capgemini.pfs.batch.Main
