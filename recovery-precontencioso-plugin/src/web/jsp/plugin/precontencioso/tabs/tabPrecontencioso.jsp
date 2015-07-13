<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>


(function(page,entidad){

<%@ include file="/WEB-INF/jsp/plugin/precontencioso/documento/grids/documentoGrid.jsp" %>
<%@ include file="/WEB-INF/jsp/plugin/precontencioso/liquidacion/grids/liquidacionGrid.jsp" %>
<%@ include file="/WEB-INF/jsp/plugin/precontencioso/burofax/grids/burofax.jsp" %>

	var panel = new Ext.Panel({
		title:'<s:message code="procedimiento.precontencioso" text="**Precontencioso"/>'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,nombreTab : 'precontencioso'
		,items: [gridDocumentos, gridLiquidaciones,gridBurofax]
	});


        panel.getValue = function() {}

        panel.setValue = function(){
                var data = entidad.get("data");
        }

        return panel;
})

