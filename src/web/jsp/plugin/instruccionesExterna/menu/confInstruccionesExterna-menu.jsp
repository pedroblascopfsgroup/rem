<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: '<s:message code="plugin.instruccionesExterna.configuracion.menu" text="**Instrucciones de Tareas Externas" />' 
		,iconCls : 'icon_busquedas'	
		,handler : function(){
			app.openTab("<s:message code="plugin.instruccionesExterna.configuracion.tabName" text="**Instrucciones de Externa"/>", "plugin/instruccionesExterna/plugin.instruccionesExterna.buscaInstrucciones",{},{id:'plugin-instruccionesExterna-busqueda',iconCls : 'icon_busquedas'});
		}