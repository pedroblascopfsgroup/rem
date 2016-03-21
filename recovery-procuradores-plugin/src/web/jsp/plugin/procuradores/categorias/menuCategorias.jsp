<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: '<s:message code="plugin.procuradores.categorizaciones.menu.titulo" text="**Categor&iacute;as" />' 
		,iconCls : 'icon_busquedas'	
		,handler : function(){
			app.openTab('<s:message code="plugin.procuradores.categorizaciones.tab.titulo" text="**Categorizaciones" />', "categorizaciones/abreVentanaCategorizaciones",{},{id:'plugin_procuradores_busquedaCategorizaciones_listadoCategorizaciones',iconCls:'icon_busquedas'});
		}