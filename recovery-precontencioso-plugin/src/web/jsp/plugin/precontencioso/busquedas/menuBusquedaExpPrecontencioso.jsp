<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

text: '<s:message code="plugin.precontencioso.menu.buscador.expedientes" text="**Expedientes Judiciales" />',
iconCls : 'icon_busquedas',
handler : function(){
	app.openTab("<s:message code="plugin.precontencioso.menu.buscador.expedientes" text="**Expedientes Judiciales"/>", "expedientejudicial/abrirBusquedaProcedimiento", {}, {id: 'plugin-precontencioso-busqueda-procedimientos', iconCls: 'icon_busquedas'});
}