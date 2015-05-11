<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: '<s:message code="plugin.recobroConfig.agenciasRecobro.menu" text="**Agencias de Recobro" />' 
		,iconCls : 'icon_agencias'	
		,handler : function(){
			app.openTab("<s:message code="plugin.recobroConfig.agenciasRecobro.menu" text="**Agencias de Recobro"/>", 
			"recobroagencia/openABMAgencia",
			{},
			{id:'plugin-recobroConfig-agenciasRecobro-abm',iconCls : 'icon_agencias'});
		}
		