<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: '<s:message code="plugin.recobroConfig.politicaAcuerdos.menu" text="**Políticas de acuerdos" />' 
		,iconCls : 'icon_politicas'	
		,handler : function(){
			app.openTab("<s:message code="plugin.recobroConfig.politicaAcuerdos.tabName" text="**Políticas de acuerdos"/>", 
			"recobropoliticadeacuerdos/openABMPoliticas",
			{},
			{id:'plugin-recobroConfig-politicaAcuerdos-abm',iconCls : 'icon_politicas'});
		}
		