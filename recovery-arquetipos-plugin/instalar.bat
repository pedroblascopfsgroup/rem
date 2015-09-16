move target\recovery-arquetipos-plugin-1.0-SNAPSHOT.jar C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\lib
xcopy /s /y src\web\flows\*.* C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\flows
xcopy /s /y src\web\jsp\*.* C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\jsp
xcopy /s /y src\web\img\*.* C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\img
xcopy /s /y src\web\img\*.* C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\img
copy src\main\resources\optionalConfiguration\*.xml C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration 