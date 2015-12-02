<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="plugin.config.esquematurnado.buscador.menu" text="**Esquemas de turnado" />' 
		,iconCls : 'icon_busquedas'	
		,handler : function(){
			app.openTab("<s:message code="plugin.config.esquematurnado.buscador.tabName" text="**Esquemas de turnado"/>", "turnadodespachos/ventanaBusquedaEsquemas",{},{id:'plugin_config_buscadorEsquemasTurnado',iconCls:'icon_busquedas'});
		}