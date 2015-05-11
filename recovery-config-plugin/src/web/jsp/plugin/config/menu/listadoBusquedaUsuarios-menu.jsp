<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="plugin.config.usuarios.busqueda.menu" text="**Usuarios" />' 
		,iconCls:'icon_busquedas'
		,handler : function(){
			app.openTab("<s:message code="plugin.config.usuarios.busqueda.menu.tabName" text="**Usuarios"/>", "plugin/config/usuarios/ADMlistadoBusquedaUsuarios",{},{id:'plugin_config_busqueda_usuarios',iconCls:'icon_busquedas'});
		}