<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

text : '<s:message code="plugin.arquetipos.modelo.busqueda.menu" text="**Modelos de arquetipos" />' 
		,iconCls : 'icon_busquedas'	
		,handler : function(){
			app.openTab("<s:message code="plugin.arquetipos.modelosArquetipos.busqueda.tabName" text="**Busqueda de modelos"/>", "plugin/arquetipos/modelosArquetipos/ARQbusquedaModelos",{},{id:'plugin-arquetipos-busquedaModelo',iconCls : 'icon_busquedas'});
		}