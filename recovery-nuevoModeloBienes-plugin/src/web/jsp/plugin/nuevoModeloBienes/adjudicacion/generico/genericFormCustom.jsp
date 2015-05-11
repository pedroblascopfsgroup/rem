<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
array = [];
array['uno']=1;
array['dos']=2;
array['tres']=3;
var tipo_wf='${tipoWf}';
var bottomBar = [];

<%@ include file="/WEB-INF/jsp/plugin/mejoras/generico/partesGenericForm/elementos.jsp" %>

<%@ include file="/WEB-INF/jsp/plugin/nuevoModeloBienes/adjudicacion/generico/items.jsp" %>
<%--items.push(app.creaText('idsTareas', 'idsTareas', '${idsTareas}', {hidden:true} ));  --%> 
var idsTareasArr = ${idsTareas};

<%@ include file="/WEB-INF/jsp/plugin/mejoras/generico/partesGenericForm/botonExportar.jsp" %>
<%@ include file="/WEB-INF/jsp/plugin/nuevoModeloBienes/adjudicacion/generico/botonGuardar.jsp" %>
<%@ include file="/WEB-INF/jsp/plugin/mejoras/generico/partesGenericForm/botonCancelar.jsp" %>

<c:if test="${form.tareaExterna.tareaProcedimiento.descripcion=='Dictar Instrucciones'}">
	bottomBar.push(btnExportarPDF);
</c:if>

<%@ include file="/WEB-INF/jsp/plugin/mejoras/generico/partesGenericForm/anyadirFechaFaltante.jsp" %>
<%@ include file="/WEB-INF/jsp/plugin/nuevoModeloBienes/adjudicacion/generico/panelEdicion.jsp" %>

page.add(panelEdicion);
</fwk:page>