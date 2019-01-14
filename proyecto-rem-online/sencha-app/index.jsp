<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page session="false" %>

<!DOCTYPE HTML>
<html manifest="">
<head>
	<link rel="shortcut icon" href="resources/images/favicon.png" type="image/png">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">

    <title>Haya REM</title>

    <script type="text/javascript" src="resources/js/AppConfig.js"></script>
    <script type="text/javascript">
        var Ext = Ext || {}; // Ext namespace won't be defined yet...
		<%--
         This function is called by the Microloader after it has performed basic
         device detection. The results are provided in the "tags" object. You can
         use these tags here or even add custom tags. These can be used by platform
         filters in your manifest or by platformConfig expressions in your app.
        --%>
        Ext.beforeLoad = function (tags) {
            var s = location.search,  // the query string (ex "?foo=1&bar")
                profile;
            <%--
            // For testing look for "?classic" or "?modern" in the URL to override
            // device detection default.
            //
            --%>
            if (s.match(/\bclassic\b/)) {
                profile = 'classic';
            }
            else if (s.match(/\bmodern\b/)) {
                profile = 'modern';
            }
            else {
                profile = tags.desktop ? 'classic' : 'modern';
                <%-- //profile = tags.phone ? 'modern' : 'classic'; --%>
            }
            
            <%-- // Profile por defecto que no tendrá en cuenta el dispositivo  --%>
            profile = 'classic';
            <%-- // ---------------------------------------------------------- --%>
            
            Ext.manifest = profile; // this name must match a build profile name

            <%--
            // This function is called once the manifest is available but before
            // any data is pulled from it.
            //
            //return function (manifest) {
                // peek at / modify the manifest object
            //};
            --%>
             <%
            java.util.Date currentDate = new java.util.Date();
            java.lang.Long hoy = new java.util.Date().getTime();      
            %>
            $AC.setWebPath('<c:url value="/"/>');$AC.setCurrentDate(<c:out value="<%= hoy %>"/>);$AC.setVersion('${version}');$AC.setDebugMode(${jsDebug})
            
            
        };
    </script>
    
    <%-- The line below must be kept intact for Sencha Cmd to build your application --%>
    <script id="microloader" data-app="5b430458-ad79-457b-a1d5-35448e8ae93c" type="text/javascript" src="bootstrap.js"></script>
        <%-- Google maps --%>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?v=3&libraries=places&key=AIzaSyCHM4WB2ypg6R5ZygQW_bh3cAgA5c6DyZs"></script>
    
    

</head>
<body></body>
</html>
