<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: '<s:message code="plugin.recobroConfig.cartera.menu" text="**Carteras" />' 
		,iconCls : 'icon_cartera'	
		,handler : function(){
			app.openTab("<s:message code="plugin.recobroConfig.cartera.titulo" text="**Búsqueda de carteras"/>", 
			"recobrocartera/openABMCarteras",
			{},
			{id:'plugin-recobroConfig-cartera-abm',iconCls : 'icon_cartera'});
		}
		