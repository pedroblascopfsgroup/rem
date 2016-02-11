<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="idConfDespExt" value="${ConfiguracionDespachoExterno.id}" />
	<json:property name="iddespacho" value="${ConfiguracionDespachoExterno.despachoExterno.id}" />
	<json:property name="idcategorizacionTareas" value="${ConfiguracionDespachoExterno.categorizacionTareas.id}" />
	<json:property name="idcategorizacionResoluciones" value="${ConfiguracionDespachoExterno.categorizacionResoluciones.id}" />
	<json:property name="despachoIntegal" value="${ConfiguracionDespachoExterno.despachoIntegal}" />
	<json:property name="avisos" value="${ConfiguracionDespachoExterno.avisos}" />
	<json:property name="pausados" value="${ConfiguracionDespachoExterno.pausados}" />
</fwk:json>