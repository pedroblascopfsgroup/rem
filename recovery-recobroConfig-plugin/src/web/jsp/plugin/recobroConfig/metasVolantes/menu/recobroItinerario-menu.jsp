<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: '<s:message code="plugin.recobroConfig.itinerario.menu" text="**Metas Volantes" />' 
		,iconCls : 'icon_metas'	
		,handler : function(){
			app.openTab("<s:message code="plugin.recobroConfig.itinerario.titulo" text="**Búsqueda de Itinerarios"/>", 
			"recobroitinerario/abreABMItinerariosRecobro",
			{},
			{id:'plugin-recobroConfig-itinerario-abm',iconCls : 'icon_metas'});
		}
		