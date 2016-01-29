<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: '<s:message code="plugin.plazasJuzgados.configuracion.menu" text="**Plazas Y Juzgados" />' 
		,iconCls : 'icon_busquedas'	
		,handler : function(){
			app.openTab("<s:message code="plugin.plazasJuzgados.configuracion.menu" text="**Plazas Y Juzgados"/>", "plugin/plazasJuzgados/plugin.plazasJuzgados.buscaPlazasJuzgados",{},{id:'plugin-plazasJuzgados-busqueda',iconCls : 'icon_busquedas'});
		}