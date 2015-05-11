del C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\WEB-INF\lib\recovery-coreextension-plugin*.jar

del /s /q C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\WEB-INF\flows\plugin\coreextension
del /s /q  C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\WEB-INF\jsp\plugin\coreextension
del /s /q  C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\img\plugin\coreextension
del /s /q  C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\reports\plugin\coreextension
del /s /q  C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration\*coreextension*

mvn eclipse:clean clean eclipse:eclipse