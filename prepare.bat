del C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\lib\recovery-config-plugin*.jar

del /s /q C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\flows\config
del /s /q C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\jsp\config
del /s /q C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\img\config
del C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration\*config* 


mvn eclipse:clean clean eclipse:eclipse