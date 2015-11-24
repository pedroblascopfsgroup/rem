<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>

	<%@ include file="tabs/procedimiento/tabFiltroProcedimiento.jsp" %>
	<%@ include file="tabs/procedimiento/tabFiltroPersonaContrato.jsp" %>
	<%@ include file="tabs/procedimiento/tabFiltroDocumentos.jsp" %>
	<%@ include file="tabs/procedimiento/tabFiltroLiquidaciones.jsp" %>
	<%@ include file="tabs/procedimiento/tabFiltroBurofax.jsp" %>
	<%@ include file="grids/procedimientoPcoGrid.jsp" %>

<%-- Filtros --%>

	var filtroTabPanel = new Ext.TabPanel({
		items: [filtrosTabDatosProcedimiento, filtrosTabPersonaContrato, filtrosTabDocumentos, filtrosTabLiquidacion, filtrosTabBurofax],
		id: 'idTabFiltros',
		layoutOnTabChange: true, 
		autoScroll: true,
		autoHeight: true,
		autoWidth: true,
		border: false,
		activeItem: 0
	});
	
	var btnBuscar = app.crearBotonBuscar({
		handler : function(){
			var params = getParametros();
			params.start = 0;
			params.limit = 25;
			panelFiltros.collapse(true);
			procedimientoPcoStore.webflow(params);
			pagingBar.show();
	}});
	
	var camposLimpiar = [fieldCodigo,fieldNombreExpedienteJudicial,dateFieldInicioPreparacionDesde,dateFieldInicioPreparacionHasta,
				dateFieldPreparadoDesde,dateFieldPreparadoHasta,dateFieldEnviadoLetradoDesde,dateFieldEnviadoLetradoHasta,dateFieldFinalizadoDesde,
				dateFieldFinalizadoHasta,dateFieldUltimaSubsanacionDesde,dateFieldUltimaSubsanacionHasta,dateFieldCanceladoDesde,dateFieldCanceladoHasta,
				dateFieldParalizacionDesde,dateFieldParalizacionHasta,comboTipoProcPropuesto,comboTipoPreparacion,filtroEstadoPreparacion,comboTiposGestor,
				comboDespachos,comboGestor,comboJerarquia,comboZonas,comboDisponibleDocumentos,comboDisponibleLiquidaciones,comboDisponibleBurofaxes, fieldImporteDesde, fieldImporteHasta,
				fieldDiasGestion,fieldCodigoContrato,comboTiposProducto,fieldNif,fieldNombre,fieldApellidos,comboTipoDocumento,comboEstadoDocumento,
				comboRespuestaSolicitud,dateFieldSolicitudDocDesde,dateFieldSolicitudDocHasta,dateFieldResultadoDocDesde,dateFieldResultadoDocHasta,dateFieldEnvioDocDesde,
				dateFieldEnvioDocHasta,dateFieldRecepcionDocDesde,dateFieldRecepcionDocHasta,comboAdjuntoDoc,comboSolicitudPreviaDoc,fieldDiasGestionDoc,
				comboTiposGestorDoc,comboDespachosDoc,comboGestorDoc,comboEstadoLiquidacion,dateFieldSolicitudLiqDesde,dateFieldSolicitudLiqHasta,dateFieldRecepcionLiqDesde,
				dateFieldRecepcionLiqHasta,dateFieldConfirmacionLiqDesde,dateFieldConfirmacionLiqHasta,dateFieldCierreLiqDesde,dateFieldCierreLiqHasta,
				fieldTotalLiqDesde,fieldTotalLiqHasta,fieldDiasGestionLiq,comboNotificado,comboResultadoBurofax,dateFieldSolicitudBurDesde,dateFieldSolicitudBurHasta,
				dateFieldEnvioBurDesde,dateFieldEnvioBurHasta,dateFieldAcuseBurDesde,dateFieldAcuseBurHasta];
	
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
	
	var btnLimpiar = new Ext.Button(cfgBtnLimpiar);

	var btnExportar = new Ext.Button({
		text: '<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a Excel" />',
		iconCls: 'icon_exportar_csv',
		handler: function() {
			var flow = '/pfs/expedientejudicial/exportarExcel';
			var params = getParametros();
			params.tipoSalida = '<fwk:const value="es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO.SALIDA_XLS" />';
		    app.openBrowserWindow(flow, params);
		}
	});

	var panelFiltros = new Ext.Panel({
		autoHeight: true,
		autoWidth: true,
		title: '<s:message code="plugin.precontencioso.buscador.expedientes.titulo" text="**Buscador Expedientes Judiciales" />',
		titleCollapse: true,
		collapsible: true,
		tbar: [btnBuscar, btnLimpiar, btnExportar],
		defaults: {xtype: 'panel', cellCls: 'vtop', border: false},
		style: 'padding-bottom: 10px;',
		items: [{
			items:[{
				layout: 'form',
				items: [filtroTabPanel]
			}]
		}]
	});

	var mainPanel = new Ext.Panel({
		bodyStyle: 'padding:15px',
		autoHeight: true,

		border: false,
		items: [panelFiltros, gridProcedimientosPco]
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