<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.messages.tituloMenu" text="**Bienes" />' 
		,iconCls : 'icon_bienes'	
		,handler : function(){
			app.openTab("<s:message code="plugin.nuevoModeloBienes.busquedaBienes.messages.tituloMenu" text="**Bienes"/>", "plugin/nuevoModeloBienes/bienes/busquedas/NMBlistadoBienes",{},{id:'plugin_busquedaBienes_listadoBienes',iconCls:'icon_busquedas'});
		}