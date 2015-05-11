<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="plugin.config.despachoExterno.busqueda.menu" text="**Despachos externos" />' 
		,iconCls : 'icon_busquedas'	
		,handler : function(){
			app.openTab("<s:message code="plugin.config.despachoExterno.busqueda.tabName" text="**Despachos externos"/>", "plugin/config/despachoExterno/ADMlistadoBusquedaDespExt",{},{id:'plugin_config_busqueda_despachosExternos',iconCls:'icon_busquedas'});
		}