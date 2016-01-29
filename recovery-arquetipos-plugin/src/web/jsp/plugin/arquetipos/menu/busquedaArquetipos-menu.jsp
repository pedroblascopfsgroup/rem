
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

text : '<s:message code="plugin.arquetipos.busqueda.menu" text="**Arquetipos" />' 
		,iconCls : 'icon_busquedas'	
		,handler : function(){
			app.openTab("<s:message code="plugin.arquetipos.busqueda.tabName" text="**Busqueda de arquetipos"/>", "plugin/arquetipos/arquetipos/ARQbusquedaArquetipos",{},{id:'plugin-arquetipos-busquedaArquetipo', iconCls:'icon_busquedas'} );
		}