del C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\lib\recovery-busquedaTareas-plugin*.jar

del /s /q C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\flows\plugin\busquedaTareas
del /s /q  C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\jsp\plugin\busquedaTareas
del /s /q  C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\img\plugin\busquedaTareas
del /s /q  C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\reports\plugin\busquedaTareas
del /s /q  C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration\*busquedaTareas*

mvn eclipse:clean clean eclipse:eclipse