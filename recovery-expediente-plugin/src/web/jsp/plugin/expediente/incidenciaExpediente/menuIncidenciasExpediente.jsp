<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: '<s:message code="plugin.expediente.incidenciasExpediente.titulo" text="**Incidencias" />' 
		,iconCls : 'icon_busquedas'	
		,handler : function(){
			app.openTab('<s:message code="plugin.expediente.incidenciasExpediente.titulo" text="**Incidencias" />', "incidenciaexpediente/abrirVentanaIncidenciaExpediente",{},{id:'plugin_expediente_busquedaIncidencias_listadoIncidencias',iconCls:'icon_busquedas'});
		}