<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: '<s:message code="plugin.recobroConfig.modeloFacturacion.menu" text="**Modelos de facturaci�n" />' 
		,iconCls : 'icon_facturacion'	
		,handler : function(){
			app.openTab("<s:message code="plugin.recobroConfig.modeloFacturacion.menu" text="**Modelos de facturaci�n"/>", 
			"recobromodelofacturacion/openABMFacturacion",
			{idModFact:2},
			{id:'plugin-recobroConfig-facturacion-abm',iconCls : 'icon_facturacion'});
		}