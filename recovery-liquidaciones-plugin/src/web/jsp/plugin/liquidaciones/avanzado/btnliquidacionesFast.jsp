<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>

new Ext.Button({
	text : '<s:message code="plugin.liquidaciones.btnliquidaciones.caption" text="**Liquidar" />'
	,conodition : '' 
	,handler : function() {
		var w = app.openWindow({
			flow : 'plugin.liquidaciones.avanzado.introducirdatos'
			,width:950
			,title : '<s:message code="plugin.liquidaciones.introducirdatos.window.title" text="**Liquidaciones" />' 
			,params : {idAsunto:data.id}
		});
		w.on(app.event.DONE, function(){
			w.close();
		});
		w.on(app.event.CANCEL, function(){ w.close(); });
	}
})