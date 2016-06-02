<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="main.toolbar.buscar.expedientesRecobro" text="**Expedientes" />' 
		,iconCls : 'icon_expedientes'
		,handler : function(){
				app.openTab("<s:message code="expedientesRecobro" text="**Expedientes Recobro"/>", "expedientes/listadoExpedientesRecobro",{},{id:'busqueda_expedientes_recobro',iconCls:'icon_busquedas'});
		}
	