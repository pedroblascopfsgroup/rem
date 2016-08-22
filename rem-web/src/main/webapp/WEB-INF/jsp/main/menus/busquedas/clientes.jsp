<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="main.toolbar.buscar.clientes" text="**Clientes" />'
		,iconCls : 'icon_cliente'
		,handler : function(){
			app.openTab("<s:message code="menu.clientes" text="**Clientes"/>", "clientes/listadoClientes", {gv:false,gsis:false,gsin:false},{id:'busqueda_clientes',iconCls:'icon_busquedas'});
		}
	