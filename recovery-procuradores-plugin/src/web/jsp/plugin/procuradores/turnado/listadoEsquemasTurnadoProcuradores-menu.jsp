<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="plugin.procuradores.turnado.buscador.menu" text="**Esquemas de turnado de procuradores" />' 
		,iconCls : 'icon_engranaje'	
		,handler : function(){
			app.openTab("<s:message code="plugin.procuradores.turnado.tabtitle" text="**Esquemas de turnado de procuradores"/>", "turnadoprocuradores/ventanaBusquedaEsquemasProcuradores",{},{id:'plugin_config_buscadorEsquemasTurnado',iconCls:'icon_busquedas'});
		}