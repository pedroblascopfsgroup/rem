<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<fwk:page>


	var idLiquidacionSeleccionada = '${idLiquidacionSeleccionada}';
	var ocultarCombo = function() {
		var ocultar = '${ocultarCombo}';
		if(ocultar == 'false') {
			return false;
		}else{
			return true;
		}
	} ;
	
	<%-- Combo Plantillas --%>

	var plantillasRecord = Ext.data.Record.create([
		{name: 'id'},
		{name : 'codigo'},
		{name: 'descripcion'}
	]);

	var plantillasStore = page.getStore({
		flow: 'liquidaciondoc/getPlantillasLiquidacion',
		reader: new Ext.data.JsonReader({
			root: 'plantillas'
		}, plantillasRecord)
	});

	var comboPlantillas = new Ext.form.ComboBox({
		store: plantillasStore,
		displayField: 'descripcion',
		valueField: 'id',
		mode: 'local',
		allowBlank: false,
		forceSelection: true,
		triggerAction: 'all',
		disabled: false,
		hidden: ocultarCombo(),
		width: 250,
		editable: true,
		emptyText:'<s:message code="rec-web.direccion.form.seleccionar" text="**Seleccionar" />',
		fieldLabel: '<s:message code="plugin.precontencioso.liquidaciones.generar.certSaldo" text="**Certificados de saldo" />'
	});
	
	comboPlantillas.on('afterrender', function(combo) {
		plantillasStore.webflow();
	});

	<%-- Combo Propietarias --%>

	var propietariasRecord = Ext.data.Record.create([
		{name : 'codigo'},
		{name: 'descripcion'}
	]);

	var propietariasStore = page.getStore({
		flow: 'liquidaciondoc/obtenerPropietarias',
		reader: new Ext.data.JsonReader({
			root: 'propietarias'
		}, propietariasRecord)
	});

	var comboPropietarias = new Ext.form.ComboBox({
		store: propietariasStore,
		displayField: 'descripcion',
		valueField: 'codigo',
		mode: 'local',
		allowBlank: false,
		forceSelection: true,
		triggerAction: 'all',
		disabled: false,
		width: 400,
		editable: true,
		emptyText:'<s:message code="rec-web.direccion.form.seleccionar" text="**Seleccionar" />',
		fieldLabel: '<s:message code="plugin.precontencioso.liquidaciones.generar.entidad" text="**Entidad propietaria" />'
	});
	
	comboPropietarias.on('afterrender', function(combo) {
		propietariasStore.webflow();
	});

	<%-- Combo Localidades Firma --%>

	var localidadesRecord = Ext.data.Record.create([
		{name: 'descripcion'}
	]);

	var localidadesStore = page.getStore({
		flow: 'liquidaciondoc/obtenerLocalidadesFirma',
		reader: new Ext.data.JsonReader({
			root: 'localidadesFirma'
		}, localidadesRecord)
	});

	var comboLocalidades = new Ext.form.ComboBox({
		store: localidadesStore,
		displayField: 'descripcion',
		valueField: 'descripcion',
		mode: 'local',
		allowBlank: false,
		forceSelection: true,
		triggerAction: 'all',
		disabled: false,
		width: 150,
		editable: true,
		emptyText:'<s:message code="rec-web.direccion.form.seleccionar" text="**Seleccionar" />',
		fieldLabel: '<s:message code="plugin.precontencioso.liquidaciones.generar.localidadFirma" text="**Localidad firma" />'
	});
	
	comboLocalidades.on('afterrender', function(combo) {
		localidadesStore.webflow();
	});

	var notario = new Ext.form.TextField({
		name : 'notario'
		,width: 400
		,allowBlank : true
		,value : '<s:message text="${dtoDoc.notario}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.editarDocumento.notario" text="**Notario" />'
	});  
	

	<%-- Buttons --%>

	var btnGuardar = new Ext.Button({
		text: '<s:message code="app.aceptar" text="**Aceptar" />',
		iconCls : 'icon_ok',
		style: 'padding-top:0px',
		handler: function() {
			if (validarForm() == '') {
				var flow='/pfs/liquidaciondoc/generarCertSaldo';
				var params={idLiquidacion: idLiquidacionSeleccionada, idPlantilla: comboPlantillas.getValue(), 
					codigoPropietaria: comboPropietarias.getValue(), localidadFirma: comboLocalidades.getValue(), notario: notario.getValue()};
				app.openBrowserWindow(flow,params);
				page.fireEvent(app.event.DONE);
			}else{
				Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />', validarForm());
			}
		}
	});
	
	var validarForm = function() {
		var mensaje = '';
		if ((comboPlantillas.getValue() == '' && !ocultarCombo()) ||
				comboPropietarias.getValue() == '' || comboLocalidades.getValue() == '') {
			mensaje = 'Debe rellenar los campos obligatorios';
		}
		return mensaje;
	}

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
				items: [ comboPlantillas, comboPropietarias, comboLocalidades, notario]
			}
		]
	});

	page.add(panelEdicion);

</fwk:page>