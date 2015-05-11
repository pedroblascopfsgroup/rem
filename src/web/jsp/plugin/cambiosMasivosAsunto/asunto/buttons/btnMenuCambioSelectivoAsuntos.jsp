<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
		
		text: '<s:message code="plugin.cambiosMasivosAsuntos.cambiogestores.selectivo.title" text="**Cambio selectivo de gestores" />' 
		,iconCls:'icon_cambio_gestor'	
		,handler : function(){
			app.openTab('<s:message code="plugin.cambiosMasivosAsuntos.cambiogestores.selectivo.title" text="**Cambio selectivo de gestores" />', 
						'plugin/cambiosMasivosAsunto/listadoBusquedaAsuntosCambioGestor',{},{id:'cambioGestores', iconCls:'icon_cambio_gestor'});
		}
		
    
