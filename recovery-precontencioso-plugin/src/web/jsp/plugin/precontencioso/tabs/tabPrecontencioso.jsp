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
		title:'<s:message code="procedimiento.precontencioso.expedienteJudicial" text="**Precontencioso"/>'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,nombreTab : 'precontencioso'
	});

	<sec:authorize ifAllGranted="TAB_PRECONTENCIOSO_DOCUMENTOS">
		panel.add(gridDocumentos);
	</sec:authorize>

	<sec:authorize ifAllGranted="TAB_PRECONTENCIOSO_LIQUIDACIONES">
		panel.add(gridLiquidaciones);
	</sec:authorize>

	<sec:authorize ifAllGranted="TAB_PRECONTENCIOSO_BUROFAXES">
		panel.add(gridBurofax);
	</sec:authorize>

	panel.getValue = function() {}

	panel.setValue = function(){
		
	    var data = entidad.get("data");
        
        Ext.Ajax.request({
			url: page.resolveUrl('expedientejudicial/isExpedienteEditable')
			,params: {idProcedimiento:data.id}
			,method: 'POST'
			,success: function (result, request)
			{
				var r = Ext.util.JSON.decode(result.responseText);
				data.esExpedienteEditable = r.isEditable;
				
				Ext.Ajax.request({
					url: page.resolveUrl('expedientejudicial/isGestoria')
					,params: {idProcedimiento:data.id}
					,method: 'POST'
					,success: function (result, request)
					{
						var r = Ext.util.JSON.decode(result.responseText);
						data.esUsuarioGestoria = r.esUsuarioGestoria;
				
						<sec:authorize ifAllGranted="TAB_PRECONTENCIOSO_DOCUMENTOS">
							ponerVisibilidadBotonesDoc(data.botonesVisiblesDocPco, data.botonesInvisiblesDocPco);
							refrescarDocumentosGrid();
						</sec:authorize>
				
						<sec:authorize ifAllGranted="TAB_PRECONTENCIOSO_LIQUIDACIONES">
							ponerVisibilidadBotonesLiq(data.botonesVisiblesLiqPco, data.botonesInvisiblesLiqPco);
							refrescarLiquidacionesGrid();
							ocultarColumnasGrid();
						</sec:authorize>
				
						<sec:authorize ifAllGranted="TAB_PRECONTENCIOSO_BUROFAXES">
							ponerVisibilidadBotonesBur(data.botonesVisiblesBurPco, data.botonesInvisiblesBurPco);
							refrescarBurofaxGrid();
						</sec:authorize>
					}
				});	
			}
		});
	}

 	panel.setVisibleTab = function(data) {
		return data.hayPrecontencioso;
	}

	return panel;
})
