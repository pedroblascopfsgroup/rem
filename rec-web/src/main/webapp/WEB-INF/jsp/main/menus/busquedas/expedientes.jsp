<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="main.toolbar.buscar.expedientes" text="**Expedientes" />' 
		,iconCls : 'icon_expedientes'
		,handler : function(){
				app.openTab("<s:message code="expedientes" text="**Expedientes Gestión"/>", "expedientes/listadoExpedientes",{},{id:'busqueda_expedientes',iconCls:'icon_busquedas'});
		}
	