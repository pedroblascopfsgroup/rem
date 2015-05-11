<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="plugin.busquedaTareas.messages.tituloMenu" text="**Tareas" />' 
		,iconCls : 'icon_busquedas'	
		,handler : function(){
			app.openTab("<s:message code="plugin.busquedaTareas.messages.tituloMenu" text="**Tareas"/>", "plugin/busquedaTareas/BTAlistadoTareas",{},{id:'plugin_busquedaTareas_listadoTareas',iconCls:'icon_busquedas'});
		}