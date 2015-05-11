del C:\pfs\batch\recovery-procedimientos-bpm*.jar
del C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\lib\recovery-procedimientos-bpm*.jar
del C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\lib\recovery-procedimientos-plugin*.jar

del /s /q C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\flows\plugin\procedimientos
del /s /q C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\jsp\plugin\procedimientos
del /s /q C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\img\plugin\procedimientos
del C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration\*procedimientos* 
del C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration\*rec-bpm* 


mvn eclipse:clean clean eclipse:eclipse