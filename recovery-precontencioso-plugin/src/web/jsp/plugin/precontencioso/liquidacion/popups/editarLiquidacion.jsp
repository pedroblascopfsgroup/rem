<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<fwk:page>

	<%-- Fields --%>

	<pfsforms:numberfield name="capitalVencidoField" labelKey="plugin.precontencioso.grid.liquidacion.capitalVencido" 
	label="**Capital vencido" value="${liquidacion.capitalVencido}" />

	<pfsforms:numberfield name="capitalNoVencidoField" labelKey="plugin.precontencioso.grid.liquidacion.capitalNoVencido" 
	label="**Capital no vencido" value="${liquidacion.capitalNoVencido}" />

	<pfsforms:numberfield name="interesesOrdinariosField" labelKey="plugin.precontencioso.grid.liquidacion.interesesOrdinarios" 
	label="**Intereses ordinarios" value="${liquidacion.interesesOrdinarios}" />

	<pfsforms:numberfield name="interesesDemoraField" labelKey="plugin.precontencioso.grid.liquidacion.interesesDemora" 
	label="**Intereses demora" value="${liquidacion.interesesDemora}" />

	<pfsforms:numberfield name="totalField" labelKey="plugin.precontencioso.grid.liquidacion.total" 
	label="**Total" value="${liquidacion.total}" />

<%-- Apoderado --%>

	<%-- Combo Tipo Gestor --%>

	var tipoGestorRecord = Ext.data.Record.create([
		{name: 'id'},
		{name: 'descripcion'}
	]);

	var tipoGestorStore = page.getStore({
		flow: 'coreextension/getListTipoGestorAdicionalData',
		reader: new Ext.data.JsonReader({
			root: 'listadoGestores'
		}, tipoGestorRecord)
	});

	var comboTipoGestor = new Ext.form.ComboBox({
		store: tipoGestorStore,
		displayField: 'descripcion',
		valueField: 'id',
		mode: 'remote',
		forceSelection: true,
		emptyText: 'Seleccionar',
		triggerAction: 'all',
		disabled: true,
		fieldLabel: '<s:message code="plugin.ugas.asuntos.cmbTipoGestor" text="**Tipo gestor" />'
	});

	<%-- Combo Tipo Despacho --%>

	var tipoDespachoRecord = Ext.data.Record.create([
		{name: 'cod'},
		{name: 'descripcion'}
	]);

	var tipoDespachoStore = page.getStore({
		flow: 'coreextension/getListTipoDespachoData',
		reader: new Ext.data.JsonReader({
			root: 'listadoDespachos'
		}, tipoDespachoRecord)
	});

	var comboTipoDespacho = new Ext.form.ComboBox({
		store: tipoDespachoStore,
		displayField: 'descripcion',
		valueField:'cod',
		mode: 'remote',
		disabled: true,
		forceSelection: true,
		emptyText: 'Seleccionar',
		triggerAction: 'all',
		fieldLabel: '<s:message code="plugin.ugas.asuntos.cmbTipoDespacho" text="**Tipo despacho" />'
	});

	<%-- Combo Usuario --%>

	var usuarioRecord = Ext.data.Record.create([
		{name: 'id'},
		{name: 'username'}
	]);

	var usuarioStore = page.getStore({
		flow: 'coreextension/getListUsuariosPaginatedData',
		reader: new Ext.data.JsonReader({
			root: 'listadoUsuarios'
		}, usuarioRecord)
	});

	var comboUsuario = new Ext.form.ComboBox({
		store: usuarioStore,
		allowBlank: true,
		blankElementText: '---',
		emptyText: '---',
		disabled: true,
		displayField: 'username',
		valueField: 'id',
		fieldLabel: '<s:message code="plugin.ugas.asuntos.cmbUsuario" text="**Usuario" />',
		loadingText: 'Buscando...',
		labelStyle: 'width:100px',
		width: 250,
		resizable: true,
		pageSize: 10,
		triggerAction: 'all',
		mode: 'local'
	});

	comboUsuario.on('afterrender', function(combo) {
		combo.mode = 'remote';
	});

	<%-- Events --%>

	comboTipoGestor.on('afterrender', function(combo) {
		tipoGestorStore.webflow();
	});

	tipoGestorStore.on('load', function(combo) {
		var numRecord = tipoGestorStore.findExact('descripcion', 'Apoderado', 0);
		var value = tipoGestorStore.getAt(numRecord).data[comboTipoGestor.valueField];
		var rawValue = tipoGestorStore.getAt(numRecord).data[comboTipoGestor.displayField];

		comboTipoGestor.setValue(value);
		comboTipoGestor.setRawValue(rawValue);
		comboTipoGestor.selectedIndex = numRecord;

		comboTipoDespacho.reset();
		comboUsuario.reset();
		comboTipoDespacho.setDisabled(false);
		comboUsuario.setDisabled(true);

		tipoDespachoStore.webflow({'idTipoGestor': comboTipoGestor.getValue()});
	});

	comboTipoDespacho.on('select', function() {
		usuarioStore.webflow({'idTipoDespacho': comboTipoDespacho.getValue()});

		comboUsuario.reset();
		comboUsuario.setDisabled(false);
	});

	tipoDespachoStore.on('load', function(combo) {
		var numRecord = tipoDespachoStore.findExact('cod', ${liquidacion.apoderadoDespachoId}, 0);

		if (numRecord != -1) {
			var value = tipoDespachoStore.getAt(numRecord).data[comboTipoDespacho.valueField];
			var rawValue = tipoDespachoStore.getAt(numRecord).data[comboTipoDespacho.displayField];

			comboTipoDespacho.setValue(value);
			comboTipoDespacho.setRawValue(rawValue);
			comboTipoDespacho.selectedIndex = numRecord;

			comboUsuario.reset();
			comboUsuario.setDisabled(false);

			usuarioStore.webflow({'idTipoDespacho': comboTipoDespacho.getValue()});
		}
	});

	usuarioStore.on('load', function(combo) {
		var numRecord = usuarioStore.findExact('id', ${liquidacion.apoderadoUsuarioId}, 0);

		if (numRecord != -1) {
			var value = usuarioStore.getAt(numRecord).data[comboUsuario.valueField];
			var rawValue = usuarioStore.getAt(numRecord).data[comboUsuario.displayField];

			comboUsuario.setValue(value);
			comboUsuario.setRawValue(rawValue);
			comboUsuario.selectedIndex = numRecord;
		}
	});

	<%-- Buttons --%>

	var btnGuardar = new Ext.Button({
		text: '<s:message code="app.guardar" text="**Guardar" />',
		iconCls: 'icon_edit',
		cls: 'x-btn-text-icon',
		style: 'padding-top:0px',
		handler: function() {
			Ext.Ajax.request({
				url: page.resolveUrl('liquidacion/editar'),
				params: getParametros(),
				method: 'POST',
				success: function ( result, request ) {
					page.fireEvent(app.event.DONE);
				}
			});
		}
	});

	var btnCancelar = new Ext.Button({
		text: '<s:message code="app.cancelar" text="**Cancelar" />',
		iconCls: 'icon_cancel',
		handler: function() {
			page.fireEvent(app.event.CANCEL);
		}
	});

	<%-- Panel --%>

	var panelEdicion = new Ext.form.FormPanel({
		autoHeight: true,
		bodyStyle:'padding:10px;cellspacing:20px',
		defaults: {xtype: 'panel', cellCls: 'vtop', border: false},
		items: [capitalVencidoField, capitalNoVencidoField, interesesOrdinariosField, interesesDemoraField, totalField, comboTipoGestor, comboTipoDespacho, comboUsuario],
		bbar: new Ext.Toolbar()
	});

	panelEdicion.getBottomToolbar().addButton([btnGuardar]);
	panelEdicion.getBottomToolbar().addButton([btnCancelar]);
	page.add(panelEdicion);

	<%-- Utils --%>

	var getParametros = function() {
		var parametros = {};

		parametros.id = '${liquidacion.id}';
		parametros.capitalVencido = capitalVencidoField.getValue();
		parametros.capitalNoVencido = capitalNoVencidoField.getValue();
		parametros.interesesOrdinarios= interesesOrdinariosField.getValue();
		parametros.interesesDemora = interesesDemoraField.getValue();
		parametros.total = totalField.getValue();

		if (comboUsuario.getValue() != "") {
			parametros.apoderadoDespachoId = comboTipoDespacho.getValue();
			parametros.apoderadoUsuarioId = comboUsuario.getValue();
		}

		return parametros;
	}

</fwk:page>