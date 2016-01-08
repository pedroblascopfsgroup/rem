<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text : '<s:message code="plugin.itinerarios.busqueda.menu" text="**Itinerarios" />' 
		,iconCls : 'icon_busquedas'	
		,handler : function(){
			app.openTab("<s:message code="plugin.itinerarios.busqueda.tabName" text="**Busqueda Itinerarios"/>", "plugin/itinerarios/plugin.itinerarios.buscaItinerarios",{},{id:'plugin-itinerarios-busqueda',iconCls : 'icon_busquedas'});
		}