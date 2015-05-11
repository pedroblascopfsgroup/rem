<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: '<s:message code="plugin.recobroConfig.esquemaAgencia.menu" text="**Conformación esquema" />' 
		,iconCls : 'icon_esquema'	
		,handler : function(){
			app.openTab("<s:message code="plugin.recobroConfig.esquemaAgencia.tabName" text="**Conformación esquemas agencias de recobro"/>", 
			"recobroesquema/openABMEsquema",
			{},
			{id:'plugin-recobroConfig-esquemaAgencia-abm',iconCls : 'icon_esquema'});
		}
		