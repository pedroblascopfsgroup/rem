<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="main.toolbar.buscar.acuerdos" text="**Acuerdos" />' 
		,iconCls : 'icon_asuntos'	
		,handler : function(){
			app.openTab("<s:message code="acuerdos.listado.tabName" text="**Listado Acuerdos"/>", "acuerdo/listadoBusquedaAcuerdos",{},{id:'busqueda_acuerdos',iconCls:'icon_busquedas'});
		}
