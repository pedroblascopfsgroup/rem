<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="plugin.config.funciones.listado.menu" text="**Funciones" />' 
		,iconCls:'icon_busquedas'
		,handler : function(){
			app.openTab("<s:message code="plugin.config.funciones.listado.menu.tabName" text="**Funciones"/>", "plugin/config/funciones/ADMlistadoFunciones",{},{id:'plugin_config_listado_funciones',iconCls:'icon_busquedas'});
		}