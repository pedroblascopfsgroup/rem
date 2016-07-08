<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text:'<s:message code="menu.analisis.analisisExterna" text="**Análisis Externa" />'
		,iconCls:'icon_analisis_externa'
		,handler : function(){ 
			app.openTab("Análisis Externa","analisisExterna/busquedaAnalisis",{},{id:'busquedaAnalisisExterna', iconCls:'icon_analisis_externa'} )
}