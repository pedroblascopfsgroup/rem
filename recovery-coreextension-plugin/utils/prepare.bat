del C:\pfs\tomcat-6.0\wtpwebapps\rec-web\WEB-INF\lib\recovery-coreextension-plugin*.jar

del /s /q C:\pfs\tomcat-6.0\wtpwebapps\rec-web\WEB-INF\flows\plugin\coreextension
del /s /q  C:\pfs\tomcat-6.0\wtpwebapps\rec-web\WEB-INF\jsp\plugin\coreextension
del /s /q  C:\pfs\tomcat-6.0\wtpwebapps\rec-web\img\plugin\coreextension
del /s /q  C:\pfs\tomcat-6.0\wtpwebapps\rec-web\reports\plugin\coreextension
del /s /q  C:\pfs\tomcat-6.0\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration\*coreextension*

mvn eclipse:clean clean eclipse:eclipse