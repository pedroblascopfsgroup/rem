SET tomcatLocation=C:\pfsunnim\unnimtomcat\wtpwebapps

move target\recovery-agendaMultifuncion-plugin-1.0-SNAPSHOT.jar %tomcatLocation%\rec-web\WEB-INF\lib
xcopy /s /y src\web\flows\*.* %tomcatLocation%\rec-web\WEB-INF\flows
xcopy /s /y src\web\jsp\*.* %tomcatLocation%\rec-web\WEB-INF\jsp
xcopy /s /y src\web\img\*.* %tomcatLocation%\rec-web\img
xcopy /s /y src\web\reports\*.* %tomcatLocation%\rec-web\reports
copy src\main\resources\optionalConfiguration\*.xml %tomcatLocation%\rec-web\WEB-INF\classes\optionalConfiguration
