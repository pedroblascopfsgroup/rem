<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<fwk:page>

	<%-- Fields --%>

	<pfsforms:numberfield name="capitalVencidoField" labelKey="plugin.precontencioso.grid.liquidacion.capitalVencido" label="**Capital vencido" 
	value="${liquidacion.capitalVencido}" 
	obligatory="true" 
	allowDecimals="true" />

	<pfsforms:numberfield name="capitalNoVencidoField" labelKey="plugin.precontencioso.grid.liquidacion.capitalNoVencido" label="**Capital no vencido" 
	value="${liquidacion.capitalNoVencido}" 
	obligatory="true" 
	allowDecimals="true" />

	<pfsforms:numberfield name="interesesOrdinariosField" labelKey="plugin.precontencioso.grid.liquidacion.interesesOrdinarios" label="**Intereses ordinarios" 
	value="${liquidacion.interesesOrdinarios}" 
	obligatory="true" 
	allowDecimals="true" />

	<pfsforms:numberfield name="interesesDemoraField" labelKey="plugin.precontencioso.grid.liquidacion.interesesDemora" label="**Intereses demora" 
	value="${liquidacion.interesesDemora}" 
	obligatory="true" 
	allowDecimals="true" />

	<pfsforms:numberfield name="totalField" labelKey="plugin.precontencioso.grid.liquidacion.total" label="**Total" 
	value="${liquidacion.total}" 
	obligatory="true" 
	allowDecimals="true" />
	
	<pfsforms:numberfield name="comisionesField" labelKey="plugin.precontencioso.grid.liquidacion.comisiones" label="**Comisiones" 
		value="${liquidacion.comisiones}" 
		obligatory="true" 
		allowDecimals="true" />
		
	<pfsforms:numberfield name="gastosField" labelKey="plugin.precontencioso.grid.liquidacion.gastos" label="**Gastos" 
		value="${liquidacion.gastos}" 
		obligatory="true" 
		allowDecimals="true" />
		
	<pfsforms:numberfield name="impuestosField" labelKey="plugin.precontencioso.grid.liquidacion.impuestos" label="**Impuestos" 
		value="${liquidacion.impuestos}" 
		obligatory="true" 
		allowDecimals="true" />	

	var capitalVencidoOriginalField = new Ext.form.NumberField({
		fieldLabel: '<s:message code="plugin.precontencioso.grid.liquidacion.capitalVencidoOriginal" text="**Capital Vencido Original" />',
		value: '${liquidacion.capitalVencidoOriginal}',
		disabled: true,
		allowDecimals: true
	});

	var capitalNoVencidoOriginalField = new Ext.form.NumberField({
		fieldLabel: '<s:message code="plugin.precontencioso.grid.liquidacion.capitalNoVencidoOriginal" text="**Capital No Vencido Original" />',
		value: '${liquidacion.capitalNoVencidoOriginal}',
		disabled: true,
		allowDecimals: true
	});

	var interesesOrdinariosOriginalField = new Ext.form.NumberField({
		fieldLabel: '<s:message code="plugin.precontencioso.grid.liquidacion.interesesOrdinariosOriginal" text="**Intereses Ordinarios Original" />',
		value: '${liquidacion.interesesOrdinariosOriginal}',
		disabled: true,
		allowDecimals: true
	});

	var interesesDemoraOriginalField = new Ext.form.NumberField({
		fieldLabel: '<s:message code="plugin.precontencioso.grid.liquidacion.interesesDemoraOriginal" text="**Intereses Demora Original" />',
		value: '${liquidacion.interesesDemoraOriginal}',
		disabled: true,
		allowDecimals: true
	});

	var totalOriginalField = new Ext.form.NumberField({
		fieldLabel: '<s:message code="plugin.precontencioso.grid.liquidacion.totalOriginal" text="**Total Original" />',
		value: '${liquidacion.totalOriginal}',
		disabled: true,
		allowDecimals: true
	});

	var comisionesOriginalField = new Ext.form.NumberField({
		fieldLabel: '<s:message code="plugin.precontencioso.grid.liquidacion.comisionesOriginal" text="**Comisiones Original" />',
		value: '${liquidacion.comisionesOriginal}',
		disabled: true,
		allowDecimals: true
	});
	
	var gastosOriginalField = new Ext.form.NumberField({
		fieldLabel: '<s:message code="plugin.precontencioso.grid.liquidacion.gastosOriginal" text="**Gastos Original" />',
		value: '${liquidacion.gastosOriginal}',
		disabled: true,
		allowDecimals: true
	});
	
	var impuestosOriginalField = new Ext.form.NumberField({
		fieldLabel: '<s:message code="plugin.precontencioso.grid.liquidacion.impuestosOriginal" text="**Impuestos Original" />',
		value: '${liquidacion.impuestosOriginal}',
		disabled: true,
		allowDecimals: true
	});
	
		

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
		var numRecord = tipoGestorStore.findExact('descripcion', '${tipoGestorApoderado.descripcion}', 0);
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
		var numRecord = tipoDespachoStore.findExact('cod', '${liquidacion.apoderadoDespachoId}', 0);

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
		var numRecord = usuarioStore.findExact('id', '${liquidacion.apoderadoUsuarioId}', 0);

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
			if (validarForm() == '') {
				Ext.Ajax.request({
					url: page.resolveUrl('liquidacion/editar'),
					params: getParametros(),
					method: 'POST',
					success: function ( result, request ) {
						page.fireEvent(app.event.DONE);
					}
				});
			} else {
				Ext.Msg.alert('<s:message code="app.error" text="**Error" />', validarForm());
			}
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

	var panelEdicion = new Ext.Panel({
		layout: 'table',
		layoutConfig: { columns: 2 },
		autoHeight: true,
		autoWidth: true,
		bodyStyle: 'padding:10px; cellspacing:20px',
		defaults: {xtype: 'fieldset', cellCls: 'vtop', border: false},
		bbar: [btnGuardar, btnCancelar],
		items: [
			{
				items: [ capitalVencidoField, capitalNoVencidoField, interesesOrdinariosField, interesesDemoraField, totalField,comisionesField,gastosField,impuestosField , comboTipoGestor, comboTipoDespacho, comboUsuario ]
			}, {
				items: [ capitalVencidoOriginalField, capitalNoVencidoOriginalField, interesesOrdinariosOriginalField, interesesDemoraOriginalField, totalOriginalField,comisionesOriginalField,gastosOriginalField,impuestosOriginalField]
			}
		]
	});

	page.add(panelEdicion);

	<%-- Utils   --%>

	var validarForm = function() {
		var mensaje = '';

		if (capitalVencidoField.getActiveError() != '') {
			mensaje = mensaje + capitalVencidoField.getActiveError() + ' <s:message code="plugin.precontencioso.grid.liquidacion.capitalVencido" /> \n'
		}

		if (capitalNoVencidoField.getActiveError() != '') {
			mensaje = mensaje + capitalNoVencidoField.getActiveError() + ' <s:message code="plugin.precontencioso.grid.liquidacion.capitalNoVencido" /> \n'
		}

		if (interesesOrdinariosField.getActiveError() != '') {
			mensaje = mensaje + interesesOrdinariosField.getActiveError() + ' <s:message code="plugin.precontencioso.grid.liquidacion.interesesOrdinarios" /> \n'
		}

		if (interesesDemoraField.getActiveError() != '') {
			mensaje = mensaje + interesesDemoraField.getActiveError() + ' <s:message code="plugin.precontencioso.grid.liquidacion.interesesDemora" /> \n'
		}

		if (totalField.getActiveError() != '') {
			mensaje = mensaje + totalField.getActiveError() + ' <s:message code="plugin.precontencioso.grid.liquidacion.total" /> \n'
		}

		return mensaje;
	}

	var getParametros = function() {
		var parametros = {};

		parametros.id = '${liquidacion.id}';
		parametros.capitalVencido = capitalVencidoField.getValue();
		parametros.capitalNoVencido = capitalNoVencidoField.getValue();
		parametros.interesesOrdinarios= interesesOrdinariosField.getValue();
		parametros.interesesDemora = interesesDemoraField.getValue();
		parametros.total = totalField.getValue();
		parametros.comisiones = comisionesField.getValue();
		parametros.gastos = gastosField.getValue();
		parametros.impuestos = impuestosField.getValue();

		if (comboUsuario.getValue() != "") {
			parametros.apoderadoDespachoId = comboTipoDespacho.getValue();
			parametros.apoderadoUsuarioId = comboUsuario.getValue();
		}

		return parametros;
	}

</fwk:page>