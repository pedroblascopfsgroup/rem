<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	text:'<s:message code="metricas.menu" text="**Scoring y Alertas" />'
		,menu:[
		  {
			text:'<s:message code="metricas.menu" text="**Indicadores de Alertas" />'
			,iconCls:'icon_scoring_alertas'
			,handler: function() {
				app.openTab('<s:message code="metricas.menu.submenu" text="**Indicadores de Alertas" />'
	                        ,'metricas/indicadores'
	                        ,{},{id:'indicadores', iconCls:'icon_scoring_alertas'});
			  }
		  }
		]
	