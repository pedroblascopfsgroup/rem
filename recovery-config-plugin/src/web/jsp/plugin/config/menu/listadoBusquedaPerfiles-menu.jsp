<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="plugin.config.perfiles.busqueda.menu" text="**Perfiles" />' 
		,iconCls:'icon_busquedas'	
		,handler : function(){
			app.openTab("<s:message code="plugin.config.perfiles.busqueda.menu.tabName" text="**Perfiles"/>", "plugin/config/perfiles/ADMlistadoBusquedaPerfiles",{},{id:'plugin_config_busqueda_perfiles',iconCls:'icon_busquedas'});
		}