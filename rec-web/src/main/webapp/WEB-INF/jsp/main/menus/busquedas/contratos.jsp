<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="main.toolbar.buscar.contratos" text="**Contratos" />' 
		,iconCls : 'icon_contratos'	
		,handler : function(){
			app.openTab("<s:message code="contratos.listado.tabName" text="**Listado Contratos"/>", "contratos/listadoBusquedaContratos",{},{id:'busqueda_contratos',iconCls:'icon_busquedas'});
		}
	