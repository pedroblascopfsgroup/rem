<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<fwk:page>


	<%-- Combo Tipo Gestor --%>

	var plantillasRecord = Ext.data.Record.create([
		{name: 'id'},
		{name : 'codigo'},
		{name: 'descripcion'}
	]);

	var plantillasStore = page.getStore({
		flow: 'liquidacion/getPlantillasLiquidacion',
		reader: new Ext.data.JsonReader({
			root: 'plantillas'
		}, plantillasRecord)
	});

	var comboPlantillas = new Ext.form.ComboBox({
		store: plantillasStore,
		displayField: 'descripcion',
		valueField: 'id',
		mode: 'remote',
		forceSelection: true,
		emptyText: 'Seleccionar',
		triggerAction: 'all',
		disabled: false,
		fieldLabel: '<s:message code="plugin.precontencioso.liquidaciones.generar.plantillas" text="**Plantillas" />'
	});
	
	comboPlantillas.on('afterrender', function(combo) {
		plantillasStore.webflow();
	});

	<%-- Buttons --%>

	var btnGuardar = new Ext.Button({
		text: '<s:message code="app.guardar" text="**Guardar" />',
		iconCls: 'icon_edit',
		cls: 'x-btn-text-icon',
		style: 'padding-top:0px',
		handler: function() {
			var flow='/pfs/liquidacion/generar';
			var params={idLiquidacion:idLiquidacionSeleccionada()};
			app.openBrowserWindow(flow,params);
			page.fireEvent(app.event.DONE);
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
		autoHeight: true,
		autoWidth: true,
		bodyStyle: 'padding:10px; cellspacing:20px',
		defaults: {xtype: 'fieldset', cellCls: 'vtop', border: false},
		bbar: [btnGuardar, btnCancelar],
		items: [comboPlantillas]
	});

	page.add(panelEdicion);

</fwk:page>