<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

text: '<s:message code="" text="**Elementos Precontencioso" />',
iconCls : 'icon_busquedas',
handler : function(){
	app.openTab("<s:message code="" text="**Elementos Precontencioso"/>", "expedientejudicial/abrirBusquedaElementosPco", {}, {id: 'plugin-precontencioso-busqueda-elementos', iconCls: 'icon_busquedas'});
}