<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text : '<s:message code="plugin.comites.busqueda.menu" text="**Comit�s" />' 
		,iconCls : 'icon_busquedas'	
		,handler : function(){
			app.openTab("<s:message code="plugin.comites.busqueda.tabName" text="**Busqueda Comit�s"/>", "plugin/comites/plugin.comites.buscaComites",{},{id:'plugin-comites-busqueda',iconCls : 'icon_busquedas'});
		}