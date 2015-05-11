copy recovery-procedimientos-bpm\target\recovery-procedimientos-bpm-2.1-SNAPSHOT.jar C:\pfsunnim\batch
move recovery-procedimientos-bpm\target\recovery-procedimientos-bpm-2.1-SNAPSHOT.jar C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\WEB-INF\lib
move recovery-procedimientos-plugin\target\recovery-procedimientos-plugin-2.1-SNAPSHOT.jar C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\WEB-INF\lib


xcopy /s /y recovery-procedimientos-plugin\src\web\flows\*.* C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\WEB-INF\flows
xcopy /s /y recovery-procedimientos-plugin\src\web\jsp\*.* C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\WEB-INF\jsp
xcopy /s /y recovery-procedimientos-plugin\src\web\img\*.* C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\img
xcopy /s /y recovery-procedimientos-plugin\src\web\img\*.* C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\img
copy recovery-procedimientos-plugin\src\main\resources\optionalConfiguration\*.xml C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration 
copy recovery-procedimientos-bpm\src\main\resources\optionalConfiguration\*.xml C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration
copy recovery-procedimientos-bpm\src\main\resources\*.xml C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration  