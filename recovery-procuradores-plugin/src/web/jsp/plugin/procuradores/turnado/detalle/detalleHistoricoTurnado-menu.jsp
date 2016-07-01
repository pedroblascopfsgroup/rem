<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="plugin.procuradores.turnado.detalle.titulo" text="**Asignaciones de procuradores" />' 
		,iconCls : 'icon_engranaje'	
		,handler : function(){
			app.openTab("<s:message code="plugin.procuradores.turnado.detalle.titulo" text="**Asignaciones de procuradores"/>", "turnadoprocuradores/detalleHistoricoTurnado",{},{id:'plugin_config_detalleHistoricoTurnado',iconCls:'icon_busquedas'});
		}