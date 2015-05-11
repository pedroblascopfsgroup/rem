<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: '<s:message code="plugin.recobroConfig.procesosFacturacion.menu" text="**Procesos de facturación" />' 
		,iconCls : 'icon_procesosFacturacion'
		,handler : function(){
			app.openTab("<s:message code="plugin.recobroConfig.procesosFacturacion.menu" text="**Procesos de facturación"/>",
			"recobroprocesosfacturacion/openLauncher",{},{id:'plugin-recobroConfig-proceosFacturacion',iconCls:'icon_procesosFacturacion'});
		}