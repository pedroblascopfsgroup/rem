<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="main.toolbar.buscar.asuntos" text="**Asuntos" />' 
		,iconCls : 'icon_asuntos'	
		,handler : function(){
			app.openTab("<s:message code="asuntos.listado.tabName" text="**Listado Asuntos"/>", "asuntos/listadoBusquedaAsuntos",{},{id:'busqueda_asuntos',iconCls:'icon_busquedas'});
		}
