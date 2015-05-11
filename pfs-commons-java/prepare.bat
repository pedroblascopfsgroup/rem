del C:\pfs\batch\pfs-commons-java*.jar
del C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\lib\pfs-commons-java*.jar

del /s /q C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\tags\pfs
del /s /q  C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration\*pfs-commons-java*
del /s /q  C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\WEB-INF\jsp\lib\pfs-commons-java
del /s /q  C:\pfs\Tomcat-6.0\wtpwebapps\rec-web\js\lib\pfs-commons-java

mvn eclipse:clean clean eclipse:eclipse