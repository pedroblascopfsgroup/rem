del C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\lib\recovery-itinerarios-plugin*.jar

del /s /q C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\flows\plugin\itinerarios
del /s /q  C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\jsp\plugin\itinerarios
del /s /q  C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\img\plugin\itinerarios
del /s /q  C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\reports\plugin\itinerarios
del /s /q  C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration\*itinerarios*

mvn eclipse:clean clean eclipse:eclipse