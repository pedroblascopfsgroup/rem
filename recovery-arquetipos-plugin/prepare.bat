del C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\lib\recovery-arquetipos-plugin*.jar

del /s /q C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\flows\plugin\arquetipos
del /s /q  C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\jsp\plugin\arquetipos
del /s /q  C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\img\plugin\arquetipos
del /s /q  C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\reports\plugin\arquetipos
del /s /q  C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration\*arquetipos*

mvn eclipse:clean clean eclipse:eclipse