<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

(function() {

    var panel = new Ext.Panel({
        title: '<s:message code="analisis.titulo" text="**Analisis" />'
        ,autoHeight: true
        ,autoScroll:true
        ,autoWidth: true
        ,bodyStyle: 'padding:10px'
        ,layout: 'table'
        ,layoutConfig: {columns:1}
        ,nombreTab : 'analisis'
    });

	panel.on('render', function(){
	
		var readOnly = false;
		<c:if test="${readOnly != null && readOnly == true}">
			readOnly = true;
		</c:if>
	
		<%@include file="../panelAnalisisPersonas.jsp"%>
		<%@include file="../panelAnalisisOperaciones.jsp"%>
		<%@include file="../panelRevisiones.jsp"%>
		<%@include file="../panelGestionesRealizadas.jsp" %>
	
		var panelAnalisisPersonas = createPanelPersonas();
		var panelAnalisisOperaciones = createPanelOperaciones();
		var panelRevisiones = createPanelRevisiones();
		var panelGestionesRealizadas = createPanelGestionesRealizadas();
	
	
		panel.add(panelAnalisisPersonas);
		panel.add(panelAnalisisOperaciones);
		panel.add(panelRevisiones);
		panel.add(panelGestionesRealizadas);
	});
	
    return panel;
})()