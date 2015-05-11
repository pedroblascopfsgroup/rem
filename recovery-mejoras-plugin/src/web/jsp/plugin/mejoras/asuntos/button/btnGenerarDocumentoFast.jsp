<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>

new Ext.Button({
	text : '<s:message code="plugin.mejoras.asunto.generarDocumento" text="**Generara documento" />'
	,iconCls : 'icon_edit'
	,handler : function() {
		var w = app.openWindow({
			flow : 'plugin.mejoras.asuntos.generarDocumento'
			,width:600
			,title : '<s:message code="plugin.mejoras.asunto.generarDocumento.title" text="**Selección de documento" />' 
			,params : {idAsunto:data.id}
		});
		w.on(app.event.DONE, function(){
			w.close();
		});
		w.on(app.event.CANCEL, function(){ w.close(); });
	}
})