<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%-- 
Este tag escribe lo necesario para renderizar una p�gina por ajax en ExtJS.

El c�digo de la p�gina se ejecuta dentro de una funci�n an�nima y tiene como par�metro el objeto "page"
--%>
<span id="${fwk.uuid}"></span>
<script>
    fwk.onReady('${appProperties.appName}', '${fwk.uuid}', '${flowExecutionKey}', '${flowExecutionUrl}', function(page){
    <jsp:doBody />
    var events = <fwk:json />;
    });
</script>