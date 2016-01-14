<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>

	<%@ include file="tabs/elementos/tabFiltroProcedimiento.jsp" %>
	<%@ include file="tabs/elementos/tabFiltroPersonaContrato.jsp" %>
	<%@ include file="tabs/elementos/tabFiltroDocumentos.jsp" %>
	<%@ include file="tabs/elementos/tabFiltroLiquidaciones.jsp" %>
	<%@ include file="tabs/elementos/tabFiltroBurofax.jsp" %>
	<%@ include file="grids/documentosPcoGrid.jsp" %>
	<%@ include file="grids/liquidacionesPcoGrid.jsp" %>
	<%@ include file="grids/burofaxesPcoGrid.jsp" %>

<%-- Filtros --%>

	var filtroTabPanel = new Ext.TabPanel({
		items: [filtrosTabDatosProcedimiento, filtrosTabPersonaContrato, filtrosTabDocumentos, filtrosTabLiquidacion, filtrosTabBurofax],
		id: 'idTabFiltrosEle',
		layoutOnTabChange: true, 
		autoScroll: true,
		autoHeight: true,
		autoWidth: true,
		border: false,
		activeItem: 0
	});


	var btnBuscarEle = app.crearBotonBuscar({
		handler : function(){
			panelFiltros.collapse(true);
				var params = getParametros();
				params.start = 0;
				params.limit = 25;
				
				if(comboTipoBusqueda.getValue() == documento) {
					documentoPcoStore.webflow(params);
				} else if(comboTipoBusqueda.getValue() == liquidacion){
					liquidacionPcoStore.webflow(params);
				} else if(comboTipoBusqueda.getValue() == burofax){
					burofaxPcoStore.webflow(params);
				}
		}});
		
	var camposLimpiar = [comboTipoBusqueda, fieldCodigoEle, fieldNombreExpedienteJudicialEle,dateFieldInicioPreparacionDesdeEle, dateFieldInicioPreparacionHastaEle,
		dateFieldPreparadoDesdeEle, dateFieldPreparadoHastaEle, dateFieldEnviadoLetradoDesdeEle, dateFieldEnviadoLetradoHastaEle,
		dateFieldFinalizadoDesdeEle, dateFieldFinalizadoHastaEle, dateFieldUltimaSubsanacionDesdeEle, dateFieldUltimaSubsanacionHastaEle,
		dateFieldCanceladoDesdeEle, dateFieldCanceladoHastaEle, dateFieldParalizacionDesdeEle, dateFieldParalizacionHastaEle,
		comboTipoProcPropuestoEle, comboTipoPreparacionEle, filtroEstadoPreparacion, comboTiposGestorEle,
		comboDespachosEle, comboGestorEle, comboJerarquiaEle, comboZonasEle, comboDisponibleDocumentosEle, comboDisponibleLiquidacionesEle,
		comboDisponibleBurofaxesEle, fieldDiasGestionEle,fieldCodigoContratoEle, comboTiposProductoEle, fieldNifEle, 
		fieldNombreEle, fieldApellidosEle, comboTipoDocumento, comboEstadoDocumento, comboRespuestaSolicitud, 
		dateFieldSolicitudDocDesdeEle, dateFieldSolicitudDocHastaEle, dateFieldResultadoDocDesdeEle, dateFieldResultadoDocHastaEle,
		dateFieldEnvioDocDesdeEle, dateFieldEnvioDocHastaEle, dateFieldRecepcionDocDesdeEle, dateFieldRecepcionDocHastaEle, 
		comboAdjuntoDocEle, comboSolicitudPreviaDocEle, fieldDiasGestionDocEle, comboTiposGestorEleDoc, comboDespachosEleDoc, comboGestorEleDoc, 
		comboEstadoLiquidacion, dateFieldSolicitudLiqDesdeEle, dateFieldSolicitudLiqHastaEle, dateFieldRecepcionLiqDesdeEle, dateFieldRecepcionLiqHastaEle, 
		dateFieldConfirmacionLiqDesdeEle, dateFieldConfirmacionLiqHastaEle, dateFieldCierreLiqDesdeEle, dateFieldCierreLiqHastaEle, fieldTotalLiqDesdeEle, 
		fieldTotalLiqHastaEle, fieldDiasGestionLiqEle, comboNotificadoEle, comboResultadoBurofax, dateFieldSolicitudBurDesdeEle, dateFieldSolicitudBurHastaEle,
		dateFieldEnvioBurDesdeEle, dateFieldEnvioBurHastaEle, dateFieldAcuseBurDesdeEle, dateFieldAcuseBurHastaEle, comboAcuseReciboEle, comboRegManualEle, fieldrefExternaEnvioEle];

	var camposStoreLimpiar = [optionsZonasStore, optionsGestoresStore, optionsGestoresStoreDoc];

	var limpiarCamposStore = function(){	
	 	for (var i = 0; i < camposStoreLimpiar.length ; i++) {	 			
	 		camposStoreLimpiar[i].removeAll();
   	 	}
	}
	
	var cfgBtnLimpiar = {
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler : function(){
				app.resetCampos(camposLimpiar);
				limpiarCamposStore();
		}
	};
	
	var btnLimpiarEle = new Ext.Button(cfgBtnLimpiar);

	var btnExportar = new Ext.Button({
		text: '<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a Excel" />',
		iconCls: 'icon_exportar_csv',
		handler: function() {
			var flow = '/pfs/expedientejudicial/exportarExcelElementos';
			var params = getParametros();
			params.tipoSalida = '<fwk:const value="es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO.SALIDA_XLS" />';
		    app.openBrowserWindow(flow, params);
		}
	});

	var panelFiltros = new Ext.Panel({
		autoHeight: true,
		autoWidth: true,
		title: '<s:message code="plugin.precontencioso.buscador.elementos.titulo" text="**Buscador Elementos Judiciales" />',
		titleCollapse: true,
		collapsible: true,
		tbar: [btnBuscarEle, btnLimpiarEle, btnExportar],
		defaults: {xtype: 'panel', cellCls: 'vtop', border: false},
		style: 'padding-bottom: 10px;',
		items: [{
			items:[{
				layout: 'form',
				items: [filtroTabPanel]
			}]
		}]
	});

<%-- Grid --%>

	gridLiquidacionPco.hide();
    gridBurofaxPco.hide();
    
	filtrosTabLiquidacion.disable();	            	
	filtrosTabBurofax.disable();

	gridDocumentoPco.on('load', function() {
		panelFiltros.collapse(true);
	});
	
	gridLiquidacionPco.on('load', function() {
		panelFiltros.collapse(true);
	});
	
	gridBurofaxPco.on('load', function() {
		panelFiltros.collapse(true);
	});

	var mainPanel = new Ext.Panel({
		bodyStyle: 'padding:15px',
		autoHeight: true,

		border: false,
		items: [panelFiltros, gridDocumentoPco, gridLiquidacionPco, gridBurofaxPco]
	});

	page.add(mainPanel);

	<%-- Utils --%>

	var getParametros = function() {

		var fusion = function(destination, source) {
		    for (var property in source) {
		        if (source.hasOwnProperty(property)) {
		            destination[property] = source[property];
		        }
		    }
		    return destination;
		};

		var out = {};

		if (filtrosTabDatosProcedimientoActive) {
			out = fusion(out, getParametrosFiltroProcedimiento());
		}

		if (filtrosTabPersonaContratoActive) {
			out = fusion(out, getParametrosFiltroPersonaContrato());
		}

		if (filtrosTabDocumentosActive) {
			out = fusion(out, getParametrosFiltroDocumentos());
		}

		if (filtrosTabLiquidacionActive) {
			out = fusion(out, getParametrosFiltroLiquidaciones());
		}

		if (filtrosTabBurofaxActive) {
			out = fusion(out, getParametrosFiltroBurofax());
		}

		return out;
	}

</fwk:page>