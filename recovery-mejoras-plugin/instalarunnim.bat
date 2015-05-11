move target\recovery-mejoras-plugin-4.0.2.0.5*.* C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\WEB-INF\lib
xcopy /s /y src\web\flows\*.* C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\WEB-INF\flows
xcopy /s /y src\web\jsp\*.* C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\WEB-INF\jsp
xcopy /s /y src\web\img\*.* C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\img
xcopy /s /y src\web\reports\*.* C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\reports
copy src\main\resources\optionalConfiguration\*.xml C:\pfsunnim\unnimtomcat\wtpwebapps\rec-web\WEB-INF\classes\optionalConfiguration 
