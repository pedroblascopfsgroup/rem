<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- Buttons --%>

var btnSolicitar = new Ext.Button({
	text: '<s:message code="plugin.precontencioso.grid.liquidacion.button.solicitar" text="**Solicitar" />',
	id : 'btnSolicitar',
	iconCls: 'icon_mas',
	cls: 'x-btn-text-icon',
	handler: function() {
		if (comprobarDatosCalculoRellenos()) {
			Ext.Msg.confirm(
			'<s:message code="app.confirmar" text="**Confirmar" />', 
			'<s:message code="plugin.precontencioso.grid.liquidacion.solicitarLiquidacion.confirmacion" text="**La liquidacion seleccionada se encuentra calculada, ¿Desea continuar?" />', 
			function(btn) {
				if (btn == 'yes') {
					abrirPantallaSolicitar();
				}
			});
		} else {
			abrirPantallaSolicitar();
		}
	}
});

var abrirPantallaSolicitar = function() {
	var w = app.openWindow({
		flow: 'liquidacion/abrirSolicitarLiquidacion',
		autoWidth: true,
		closable: true,
		title: '<s:message code="plugin.precontencioso.grid.liquidacion.titulo.solicitarliq" text="**Solicitar liquidación" />',
		params: {idLiquidacion: idLiquidacionSeleccionada()}
	});

	w.on(app.event.DONE, function() {
		refrescarLiquidacionesGrid();
		w.close();
	});

	w.on(app.event.CANCEL, function() {
		w.close();
	});
}

var abrirPantallaPlantillasLiquidacion = function() {
	var w = app.openWindow({
		flow: 'liquidacion/abrirPlantillasLiquidacion',
		params: {idLiquidacion:idLiquidacionSeleccionada()},
		autoWidth: true,
		closable: true,
		title: '<s:message code="plugin.precontencioso.liquidaciones.generar.seleccionar.plantillas" text="**Seleccionar plantilla a generar" />'
	});

	w.on(app.event.DONE, function() {
		w.close();
	});

	w.on(app.event.CANCEL, function() {
		w.close();
	});
}

<sec:authentication var="user" property="principal" />


var btnEditarValores = new Ext.Button({
	text: '<s:message code="plugin.precontencioso.grid.liquidacion.button.editar" text="**Editar valores" />',
	id : 'btnEditarValores',
	iconCls: 'icon_edit',
	cls: 'x-btn-text-icon',
	handler: function() {
		var w = app.openWindow({
			flow: 'liquidacion/abrirEditarLiquidacion',
			width: 	<c:choose>
					    <c:when test="${user.entidad.descripcion eq 'CAJAMAR'}">
					       410
					    </c:when>
					    <c:otherwise>
					        670
					    </c:otherwise>
					</c:choose>,
			closable: true,
			title: '<s:message code="plugin.precontencioso.grid.liquidacion.titulo.editarliq" text="**Editar Liquidacion" />',
			params: {idLiquidacion: idLiquidacionSeleccionada()}
		});

		w.on(app.event.DONE, function() {
			refrescarLiquidacionesGrid();
			w.close();
		});

		w.on(app.event.CANCEL, function() {
			w.close();
		});
	}
});

var btnConfirmar = new Ext.Button({
	text: '<s:message code="plugin.precontencioso.grid.liquidacion.button.confimar" text="**Confirmar" />',
	id : 'btnConfirmar',
	iconCls: 'x-tbar-page-next',
	cls: 'x-btn-text-icon',
	handler: function() {
		myMask.show();
		Ext.Ajax.request({
			url: page.resolveUrl('liquidacion/confirmar'),
			params: {idLiquidacion: idLiquidacionSeleccionada()},
			method: 'POST',
			success: function ( result, request ) {
				myMask.hide();
				refrescarLiquidacionesGrid();
			}
		});
	}
});

var btnVisar = new Ext.Button({
	text: '<s:message code="plugin.precontencioso.grid.liquidacion.button.visar" text="**Visar" />',
	id : 'btnVisar',
	iconCls: 'icon_contratos_pase',
	cls: 'x-btn-text-icon',
	handler: function() {
		Ext.Msg.confirm('<s:message code="app.confirmar" text="**Confirmar" />', '<s:message code="plugin.precontencioso.grid.liquidacion.visar.confirmacion" text="**¿Est&aacute; seguro de dar por visada la liquidaci&oacute;n seleccionada?" />', 
			function(btn){
	  			if (btn == 'yes'){
					Ext.Ajax.request({
						url: page.resolveUrl('liquidacion/visar'),
						params: {idLiquidacion: idLiquidacionSeleccionada()},
						method: 'POST',
						success: function ( result, request ) {
							refrescarLiquidacionesGrid();
						},
						failure: function ( result, request ) {
						}
					});
	  			}
			}
		);
	}
});

var btnDescartar = new Ext.Button({
	text: '<s:message code="plugin.precontencioso.grid.liquidacion.button.descartar" text="**Descartar" />',
	id : 'btnDescartar',
	iconCls: 'icon_menos',
	cls: 'x-btn-text-icon',
	handler: function() {
		myMask.show();
		Ext.Ajax.request({
			url: page.resolveUrl('liquidacion/descartar'),
			params: {idLiquidacion: idLiquidacionSeleccionada()},
			method: 'POST',
			success: function ( result, request ) {
				myMask.hide();
				refrescarLiquidacionesGrid();
			}
		});
	}
});

var btnGenerar = new Ext.Button({
	text: '<s:message code="plugin.precontencioso.grid.liquidacion.button.generar" text="**Generar" />',
	id : 'btnGenerar',
	hidden: true,
	iconCls: 'icon_pdf',
	cls: 'x-btn-text-icon',
	handler: function() {
			abrirPantallaPlantillasLiquidacion();
	}		
});

<sec:authorize ifAllGranted="TAB_PRECONTENCIOSO_LIQ_BTN_GENERAR">
	btnGenerar.hidden = false;
</sec:authorize>

var abrirPantallaDoc = function(destino) {
	var w = app.openWindow({
		flow: destino,
		params: {idLiquidacion:idLiquidacionSeleccionada()},
		autoWidth: true,
		closable: true,
		title: '<s:message code="plugin.precontencioso.liquidaciones.generar.documentos.titulo" text="**Complete los datos necesarios para generar el documento" />'
	});
	w.on(app.event.DONE, function() {
		w.close();
	});
	w.on(app.event.CANCEL, function() {
		w.close();
	});
}

var btnLiqGenDoc = new Ext.Button({
	id:'btnLiqGenDoc',
	text: '<s:message code="plugin.precontencioso.grid.liquidacion.button.generarDoc" text="**Generar Documento" />',
	iconCls: 'icon_pdf',
	cls: 'x-btn-text-icon',
	menu: {
		items: [{
			text: '<s:message code="plugin.precontencioso.grid.liquidacion.button.generarCertSaldo" text="**Certificado de saldo" />',
			icon:'/pfs/css/page_red.png',
			handler: function() {
				abrirPantallaDoc('liquidaciondoc/abrirPopupCertSaldo');
			}
		},{
			text: '<s:message code="plugin.precontencioso.grid.liquidacion.button.generarCartaNotario" text="**Carta al notario" />',
			icon:'/pfs/css/page_red.png',
			handler: function() {
				abrirPantallaDoc('liquidaciondoc/abrirPopupCartaNotario');
			}
		}]
	}
});


<%-- Grid --%>
var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"Cargando..."});

var liquidacionesRecord = Ext.data.Record.create([
	{name: 'id'},
	{name: 'contrato'},
	{name: 'nroContrato'},
	{name: 'solicitante'},
	{name: 'producto'},
	{name: 'estadoLiquidacion'},
	{name: 'estadoCodigo'},
	{name: 'fechaSolicitud'},
	{name: 'fechaRecepcion'},
	{name: 'fechaConfirmacion'},
	{name: 'fechaCierre'},
	{name: 'capitalVencido'},
	{name: 'capitalNoVencido'},
	{name: 'interesesOrdinarios'},
	{name: 'interesesDemora'},
	{name: 'total'},
	{name: 'apoderado'},
	{name: 'comisiones'},
	{name: 'gastos'},
	{name: 'impuestos'}
]);

var storeLiquidaciones = page.getStore({
	eventName: 'resultado',
	flow: 'liquidacion/getLiquidacionesPorProcedimientoId',
	storeId: 'storeLiquidaciones',
	reader: new Ext.data.JsonReader({
		root: 'liquidaciones'
	}, liquidacionesRecord)
});

storeLiquidaciones.on(
	'load',
	function (store, data, options) {
		actualizarBotonesLiquidacion();
	}
);

var cmLiquidacion = new Ext.grid.ColumnModel([
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.contrato" text="**Contrato" />', dataIndex: 'nroContrato'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.producto" text="**Producto" />', dataIndex: 'producto'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.estadoLiquidacion" text="**Estado Liquidacion" />', dataIndex: 'estadoLiquidacion'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.fechaSolicitud" text="**Fecha Solicitud" />', dataIndex: 'fechaSolicitud'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.fechaRecepcion" text="**Fecha Recepcion" />', dataIndex: 'fechaRecepcion'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.fechaConfirmacion" text="**Fecha Confirmacion" />', dataIndex: 'fechaConfirmacion'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.fechaCierre" text="**Fecha Cierre" />', dataIndex: 'fechaCierre'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.capitalVencido" text="**Capital Vencido" />', dataIndex: 'capitalVencido'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.capitalNoVencido" text="**Capital No Vencido" />', dataIndex: 'capitalNoVencido'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.interesesOrdinarios" text="**Intereses Ordinarios" />', dataIndex: 'interesesOrdinarios'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.interesesDemora" text="**Intereses Demora" />', dataIndex: 'interesesDemora'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.comisiones" text="**Comisiones" />', dataIndex: 'comisiones'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.gastos" text="**Gastos" />', dataIndex: 'gastos'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.impuestos" text="**Impuestos" />', dataIndex: 'impuestos'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.total" text="**Total" />', dataIndex: 'total'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.solicitante" text="**Solicitante" />', dataIndex: 'solicitante', hidden: true},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.apoderado" text="**Apoderado" />', dataIndex: 'apoderado', width: 200}
]);

var botonRefresh = new Ext.Button({
	text : 'Refresh'
	,id : 'botonRefreshLiq'
	,iconCls : 'icon_refresh'
	,handler:function(){
		refrescarLiquidacionesGrid();
	}
});

var gridLiquidaciones = app.crearGrid(storeLiquidaciones, cmLiquidacion, {
	title: '<s:message code="plugin.precontencioso.grid.liquidacion.titulo" text="**Liquidaciones" />',
	<sec:authorize ifAllGranted="TAB_PRECONTENCIOSO_LIQ_BTN">
	bbar: [
	<sec:authorize ifNotGranted="PERSONALIZACION-BCC">	btnSolicitar, </sec:authorize>
		btnEditarValores, 
		btnConfirmar, 
		btnVisar,
		btnDescartar, 
		new Ext.Toolbar.Fill(),
		btnGenerar,
		btnLiqGenDoc,
		botonRefresh
	],
	</sec:authorize>
	height: 250,
	autoWidth: true,
	style:'padding-top: inherit',
	collapsible: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true})
});

gridLiquidaciones.on('rowclick', function(grid, rowIndex, e) {
	actualizarBotonesLiquidacion();
});

<%-- States --%>

var actualizarBotonesLiquidacion = function() {
	// Se comprueba que el procedimiento se encuentre en un estado que permita editar las liquidaciones
	if (data != null) {
		var estadoActualCodigoProcedimiento = data.precontencioso.estadoActualCodigo;
		if (!data.esExpedienteEditable || (estadoActualCodigoProcedimiento != 'PR' && estadoActualCodigoProcedimiento != 'SU' && estadoActualCodigoProcedimiento != 'SC')) {
			btnSolicitar.setDisabled(true);
			btnEditarValores.setDisabled(true);
			btnConfirmar.setDisabled(true);
			btnVisar.setDisabled(true);
			btnDescartar.setDisabled(true);
			btnGenerar.setDisabled(true);
			btnLiqGenDoc.setDisabled(true);
			return;
		}
	}

	var liquidacion = gridLiquidaciones.getSelectionModel().getSelected();

	var estadoCodigo = '';
	if (liquidacion) {
		estadoCodigo = liquidacion.get('estadoCodigo');
	}

	switch(estadoCodigo) {

		case 'PEN':
			btnSolicitar.setDisabled(false);
			btnEditarValores.setDisabled(btnSolicitar.isVisible());
			btnConfirmar.setDisabled(true);
			btnVisar.setDisabled(true);
			btnDescartar.setDisabled(true);
			btnGenerar.setDisabled(true);
			btnLiqGenDoc.setDisabled(true);
			break;

		case 'SOL':
			btnSolicitar.setDisabled(true);
			btnEditarValores.setDisabled(true);
			btnConfirmar.setDisabled(true);
			btnVisar.setDisabled(true);
			btnDescartar.setDisabled(false);
			btnGenerar.setDisabled(true);
			btnLiqGenDoc.setDisabled(true);
			break;

		case 'DES':
			btnSolicitar.setDisabled(false);
			btnEditarValores.setDisabled(btnSolicitar.isVisible());
			btnConfirmar.setDisabled(true);
			btnVisar.setDisabled(true);
			btnDescartar.setDisabled(true);
			btnGenerar.setDisabled(true);
			btnLiqGenDoc.setDisabled(true);
			break;

		case 'CON':
			btnSolicitar.setDisabled(true);
			btnEditarValores.setDisabled(true);
			btnConfirmar.setDisabled(true);
			btnVisar.setDisabled(false);
			btnDescartar.setDisabled(false);
			btnGenerar.setDisabled(false);
			btnLiqGenDoc.setDisabled(false);
			break;
			
		case 'VIS':
			btnSolicitar.setDisabled(true);
			btnEditarValores.setDisabled(true);
			btnConfirmar.setDisabled(true);
			btnVisar.setDisabled(true);
			btnDescartar.setDisabled(false);
			btnGenerar.setDisabled(false);
			btnLiqGenDoc.setDisabled(false);
			break;

		case 'CAL':
			btnSolicitar.setDisabled(true);
			btnEditarValores.setDisabled(false);
			btnConfirmar.setDisabled(false);
			btnVisar.setDisabled(true);
			btnDescartar.setDisabled(false);
			btnGenerar.setDisabled(true);
			btnLiqGenDoc.setDisabled(true);
			break;

		case 'INC':
			btnSolicitar.setDisabled(true);
			btnEditarValores.setDisabled(true);
			btnConfirmar.setDisabled(true);
			btnVisar.setDisabled(true);
			btnDescartar.setDisabled(false);
			btnGenerar.setDisabled(true);
			btnLiqGenDoc.setDisabled(true);
			break;

		default:
			btnSolicitar.setDisabled(true);
			btnEditarValores.setDisabled(true);
			btnConfirmar.setDisabled(true);
			btnVisar.setDisabled(true);
			btnDescartar.setDisabled(true);
			btnGenerar.setDisabled(true);
			btnLiqGenDoc.setDisabled(true);
	}
	
	btnConfirmar.setDisabled(btnConfirmar.disabled || !comprobarDatosCalculoRellenos());

}

<%-- Utils --%>


<%-- Sustituido por gestion de visibilidad a base de projectContext --%>
<%--
var ocultarBtnSolicitar = function(){
	Ext.Ajax.request({
		url : page.resolveUrl('liquidacion/getOcultarBotonSolicitar'),
		method: 'POST',
		success: function ( result, request ) {
			var resultado = Ext.decode(result.responseText);

			var indexFechaSolicitud = gridLiquidaciones.getColumnModel().findColumnIndex('fechaSolicitud');
			var indexFechaRecepcion = gridLiquidaciones.getColumnModel().findColumnIndex('fechaRecepcion');

			if(resultado.ocultarBtnSolicitar) {
				btnSolicitar.hide();

				gridLiquidaciones.getColumnModel().setHidden(indexFechaSolicitud, true);
				gridLiquidaciones.getColumnModel().setHidden(indexFechaRecepcion, true);

				return true;
			}else{
				btnSolicitar.show();
				return false;
			}
		}
	});
}
--%>
<%-- Acciones a tomar cuando la entidad tiene configurado que no soporta solicitar las liquidaciones --%>
<%--
ocultarBtnSolicitar();
--%>

<%-- Sustituido por gestion de visibilidad a base de projectContext --%>
<%--
if('${appProperties.precontenciosoVisadoActivo}' != 'true') {
	btnVisar.hide();
}
--%>

var comprobarDatosCalculoRellenos = function() {
	var liquidacion = gridLiquidaciones.getSelectionModel().getSelected();

	return !(liquidacion.get('capitalVencido') === ""
			|| liquidacion.get('capitalNoVencido') === ""
			|| liquidacion.get('interesesOrdinarios') === ""
			|| liquidacion.get('interesesDemora') === ""
			|| liquidacion.get('gastos') === ""
			|| liquidacion.get('comisiones') === ""
			|| liquidacion.get('impuestos') === ""
			|| liquidacion.get('total') === "" );
}


var idLiquidacionSeleccionada = function() {
	return gridLiquidaciones.getSelectionModel().getSelected().get('id');
}

var refrescarLiquidacionesGrid = function() {
	storeLiquidaciones.webflow({idProcedimientoPCO: data.precontencioso.id});
}

var ponerVisibilidadBotonesLiq = function(visibles, invisibles) {
	for (var i=0; i < visibles.length; i++){
		if (typeof(Ext.getCmp(visibles[i].boton)) != 'undefined') {
			Ext.getCmp(visibles[i].boton).setVisible(true);
		}
	}
	for (var i=0; i < invisibles.length; i++){
		if (typeof(Ext.getCmp(visibles[i].boton)) != 'undefined') {
			Ext.getCmp(invisibles[i].boton).setVisible(false);
		}
	}
}

<%-- Visibilidad de las columnas dependiendo de la del boton Solicitar --%>
var ocultarColumnasGrid = function() {
	if (!btnSolicitar.isVisible()) {
		var indexFechaSolicitud = gridLiquidaciones.getColumnModel().findColumnIndex('fechaSolicitud');
		var indexFechaRecepcion = gridLiquidaciones.getColumnModel().findColumnIndex('fechaRecepcion');
		gridLiquidaciones.getColumnModel().setHidden(indexFechaSolicitud, true);
		gridLiquidaciones.getColumnModel().setHidden(indexFechaRecepcion, true);
	}
}

