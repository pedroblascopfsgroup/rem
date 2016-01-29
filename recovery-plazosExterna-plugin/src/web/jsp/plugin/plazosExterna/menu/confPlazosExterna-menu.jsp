<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: '<s:message code="plugin.plazosExterna.configuracion.menu" text="**Plazos de Tareas Externas" />' 
		,iconCls : 'icon_busquedas'	
		,handler : function(){
			app.openTab("<s:message code="plugin.plazosExterna.configuracion.tabName" text="**Plazos de Externa"/>", "plugin/plazosExterna/plugin.plazosExterna.buscaTareasExterna",{},{id:'plugin-plazosExterna-busqueda',iconCls : 'icon_busquedas'});
		}