<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: '<s:message code="plugin.busquedaProcedimientos.configuracion.menu" text="**Actuaciones" />' 
		,iconCls : 'icon_busquedas'	
		,handler : function(){
			app.openTab("<s:message code="plugin.busquedaProcedimientos.configuracion.menu" text="**Actuaciones"/>", "plugin/busquedaProcedimientos/plugin.busquedaProcedimientos.buscaProcedimientos",{},{id:'plugin-busquedaProcedimientos-busqueda',iconCls : 'icon_busquedas'});
		}