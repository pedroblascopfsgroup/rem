<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>

new Ext.Button({
	text : '<s:message code="plugin.burofax.button.caption" text="**Burofax" />'
	,handler : function() {
		var w = app.openWindow({
			flow : 'plugin.burofax.confirmarDatos'
			,width:700
			,title : '<s:message code="plugin.burofax.confirmardatos.window.title" text="**Confirmar datos" />' 
			,params : {personaId:data.id}
		});
		w.on(app.event.DONE, function(){
			w.close();
		});
		w.on(app.event.CANCEL, function(){ w.close(); });
	}
})