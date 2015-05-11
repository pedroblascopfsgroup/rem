<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>

new Ext.Button({
        text:'<s:message code="plugin.mejoras.asuntos.exportarHistorico" text="**Exportar histórico" />'
        ,iconCls:'icon_pdf'
		,condition: ''
        ,handler: function() {
         	var flow = 'plugin/mejoras/asuntos/plugin.mejoras.asuntos.exportarHistorico';
			var params = {id:data.id};
			app.openBrowserWindow(flow,params);
	}
})