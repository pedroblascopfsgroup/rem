<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.messages.tituloMenu" text="**Subastas" />' 
		,iconCls : 'icon_subasta'	
		,handler : function(){
			app.openTab("<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.messages.tituloMenu" text="**Subastas"/>", 
				"plugin/nuevoModeloBienes/subastas/busquedas/NMBlistadoSubastas",
				{},
				{id:'plugin_busquedaSubastas_listadoSubastas',iconCls:'icon_subasta'}
			);
		}