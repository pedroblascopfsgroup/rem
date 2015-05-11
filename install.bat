copy target\pfs-commons-java-2.2-SNAPSHOT.jar C:\pfs\batch
move target\pfs-commons-java-2.2-SNAPSHOT.jar C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\lib

xcopy /s /y  src\main\resources\META-INF\tags\*.* C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\tags
xcopy /s /y src\web\jsp\*.* C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\jsp
xcopy /s /y src\web\js\*.* C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\js
copy src\main\resources\optionalConfiguration\*.xml C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration 