<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text:'<s:message code="menu.analisis.mapaGlobal" text="**Mapa Global" />'
		,iconCls:'icon_analisis'
		,handler : function(){ 
			app.openTab("Mapa Global","analisis/busquedaMapaGlobal",{},{id:'busquedaMapaGlobal', iconCls:'icon_analisis'} )
}