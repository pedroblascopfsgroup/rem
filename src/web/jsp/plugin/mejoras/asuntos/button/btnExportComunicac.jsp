<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>

new Ext.Button({
        text:'<s:message code="plugin.mejoras.asuntos.exportarComunicaciones" text="**Exportar comunicaciones" />'
        ,iconCls:'icon_pdf'
        ,handler: function() {
         	var flow = 'plugin/mejoras/asuntos/plugin.mejoras.asuntos.exportarComunicaciones';
			var params = {id:"${asunto.id}"};
			app.openBrowserWindow(flow,params);
	}
})