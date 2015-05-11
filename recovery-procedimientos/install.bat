copy recovery-procedimientos-bpm\target\recovery-procedimientos-bpm-2.0-SNAPSHOT.jar C:\pfs\batch
move recovery-procedimientos-bpm\target\recovery-procedimientos-bpm-2.0-SNAPSHOT.jar C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\lib
move recovery-procedimientos-plugin\target\recovery-procedimientos-plugin-2.0-SNAPSHOT.jar C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\lib


xcopy /s /y recovery-procedimientos-plugin\src\web\flows\*.* C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\flows
xcopy /s /y recovery-procedimientos-plugin\src\web\jsp\*.* C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\jsp
xcopy /s /y recovery-procedimientos-plugin\src\web\img\*.* C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\img
xcopy /s /y recovery-procedimientos-plugin\src\web\img\*.* C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\img
copy recovery-procedimientos-plugin\src\main\resources\optionalConfiguration\*.xml C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration 
copy recovery-procedimientos-bpm\src\main\resources\optionalConfiguration\*.xml C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration
copy recovery-procedimientos-bpm\src\main\resources\*.xml C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration  