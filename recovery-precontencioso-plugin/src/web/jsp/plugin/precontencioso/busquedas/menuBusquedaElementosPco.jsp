<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

text: '<s:message code="plugin.precontencioso.menu.buscador.elementos" text="**Elementos Judiciales" />',
iconCls : 'icon_busquedas',
handler : function(){
	app.openTab("<s:message code="plugin.precontencioso.menu.buscador.elementos" text="**Elementos Judiciales"/>", "expedientejudicial/abrirBusquedaElementosPco", {}, {id: 'plugin-precontencioso-busqueda-elementos', iconCls: 'icon_busquedas'});
}