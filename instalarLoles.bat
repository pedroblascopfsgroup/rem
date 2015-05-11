copy target\recovery-previsiones-plugin-*SNAPSHOT.jar C:\pfs\batch
move target\recovery-previsiones-*SNAPSHOT.jar C:\pfssor\sortomcat\wtpwebapps\rec-web\WEB-INF\lib

copy src\main\resources\optionalConfiguration\*.xml C:\pfssor\sortomcat\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration 

xcopy /s /y src\web\flows\*.* C:\pfssor\sortomcat\wtpwebapps\rec-web\WEB-INF\flows
xcopy /s /y src\web\jsp\*.* C:\pfssor\sortomcat\wtpwebapps\rec-web\WEB-INF\jsp
xcopy /s /y src\web\img\*.* C:\pfssor\sortomcat\wtpwebapps\rec-web\img
xcopy /s /y src\web\reports\*.* C:\pfssor\sortomcat\wtpwebapps\rec-web\reports