<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%-- 
Este tag escribe lo necesario para renderizar una página por ajax en ExtJS.

El código de la página se ejecuta dentro de una función anónima y tiene como parámetro el objeto "page"
--%>
<span id="${fwk.uuid}"></span>
<script>
    fwk.onReady('${appProperties.appName}', '${fwk.uuid}', '${flowExecutionKey}', '${flowExecutionUrl}', function(page){
    <jsp:doBody />
    var events = <fwk:json />;
    });
</script>