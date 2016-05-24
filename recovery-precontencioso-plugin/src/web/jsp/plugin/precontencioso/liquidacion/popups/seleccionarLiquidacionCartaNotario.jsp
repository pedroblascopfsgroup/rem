<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<fwk:page>


	var idLiquidacionSeleccionada = '${idLiquidacionSeleccionada}';

	<%-- Nombre Notario --%>
	var notario = new Ext.form.TextField({
		name : 'notario'
		,width: 400
		,allowBlank : false
		,fieldLabel : '<s:message code="precontencioso.grid.documento.editarDocumento.notario" text="**Notario" />'
	});  
	
	<%-- Localidad Notario --%>
	var localidadNotario = new Ext.form.TextField({
		name : 'localidadNotario'
		,width: 350
		,allowBlank : false
		,fieldLabel : '<s:message code="plugin.precontencioso.liquidaciones.generar.localidadNotario" text="**Localidad Notario" />'
	});  
	
	<%-- Adjuntos adicionales --%>
	var adjuntosAdicionales = new Ext.form.TextField({
		name : 'adjuntosAdicionales'
		,width: 400
		,allowBlank : true
		,fieldLabel : '<s:message code="plugin.precontencioso.liquidaciones.generar.adjuntosAdicionales" text="**Adjuntos adicionales" />'
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

	<%-- Combo Centros --%>

	var centrosRecord = Ext.data.Record.create([
		{name: 'descripcion'}
	]);

	var centrosStore = page.getStore({
		flow: 'liquidaciondoc/obtenerCentros',
		reader: new Ext.data.JsonReader({
			root: 'centros'
		}, centrosRecord)
	});

	var comboCentros = new Ext.form.ComboBox({
		store: centrosStore,
		displayField: 'descripcion',
		valueField: 'descripcion',
		mode: 'local',
		allowBlank: false,
		forceSelection: true,
		triggerAction: 'all',
		disabled: false,
		width: 350,
		editable: true,
		emptyText:'<s:message code="rec-web.direccion.form.seleccionar" text="**Seleccionar" />',
		fieldLabel: '<s:message code="plugin.precontencioso.liquidaciones.generar.centro" text="**Centro" />'
	});
	
	comboCentros.on('afterrender', function(combo) {
		centrosStore.webflow();
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


	<%-- Buttons --%>

	var btnGuardar = new Ext.Button({
		text: '<s:message code="app.aceptar" text="**Aceptar" />',
		iconCls : 'icon_ok',
		style: 'padding-top:0px',
		handler: function() {
			if (validarForm() == '') {
				var flow='/pfs/liquidaciondoc/generarCartaNotario';
				var params={idLiquidacion: idLiquidacionSeleccionada,  notario: notario.getValue(), localidadNotario: localidadNotario.getValue(), adjuntosAdicionales: adjuntosAdicionales.getValue(), 
					codigoPropietaria: comboPropietarias.getValue(), centro: comboCentros.getValue(), localidadFirma: comboLocalidades.getValue()};
				app.openBrowserWindow(flow,params);
				page.fireEvent(app.event.DONE);
			}else{
				Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />', validarForm());
			}
		}
	});
	
	var validarForm = function() {
		var mensaje = '';
		if (comboPropietarias.getValue() == '' || comboLocalidades.getValue() == ''
				|| comboLocalidades.getValue() == '' || notario.getValue() == '' || localidadNotario.getValue() == '' ) {
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
				items: [ notario, localidadNotario, adjuntosAdicionales, comboPropietarias, comboCentros, comboLocalidades]
			}
		]
	});

	page.add(panelEdicion);

</fwk:page>