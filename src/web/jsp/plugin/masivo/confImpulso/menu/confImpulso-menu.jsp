<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: '<s:message code="plugin.masivo.confImpulso.configuracion.menu" text="**Impulsos automáticos" />' 
		,iconCls : 'icon_busquedas'	
		,handler : function(){
			app.openTab("<s:message code="plugin.masivo.confImpulso.configuracion.menu" text="**Impulsos automáticos"/>", 
			"msvconfimpulsoautomatico/abreVentana",
			{},
			{id:'plugin-masivo-confImpulso-busqueda',iconCls : 'icon_busquedas'});
		}
		
