<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<fwk:page>


	<%-- Combo Tipo Gestor --%>
	
	var idLiquidacionSeleccionada = '${idLiquidacionSeleccionada}';
	var ocultarCombo = function() {
		var ocultar = '${ocultarCombo}';
		if(ocultar == 'false') {
			return false;
		}else{
			return true;
		}
	} ;
	
	var labelInformativa = new Ext.form.Label({
		text: 'Se va a generar un pdf de la liquidacion seleccionada'
		,style:'font-weight:bolder; font-size:11; margin:10px 10px 10px 10px;'
	});
	
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
		allowBlank: false,
		forceSelection: true,
		triggerAction: 'all',
		disabled: false,
		hidden: ocultarCombo(),
		fieldLabel: '<s:message code="plugin.precontencioso.liquidaciones.generar.plantillas" text="**Plantillas" />'
	});
	
	comboPlantillas.on('afterrender', function(combo) {
		plantillasStore.webflow();
	});

	<%-- Buttons --%>

	var btnGuardar = new Ext.Button({
		text: '<s:message code="app.aceptar" text="**Aceptar" />',
		iconCls : 'icon_ok',
		style: 'padding-top:0px',
		handler: function() {
			if (validarForm() == '') {
				var flow='/pfs/liquidacion/generar';
				var params={idLiquidacion: idLiquidacionSeleccionada, idPlantilla: comboPlantillas.getValue()};
				app.openBrowserWindow(flow,params);
				page.fireEvent(app.event.DONE);
			}else{
				Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />', validarForm());
			}
		}
	});
	
	var validarForm = function() {
		var mensaje = '';
		if (comboPlantillas.getValue() == '' && !ocultarCombo()) {
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
		autoHeight: true,
		autoWidth: true,
		bodyStyle: 'padding:10px; cellspacing:20px',
		defaults: {xtype: 'fieldset', cellCls: 'vtop', border: false},
		bbar: [btnGuardar, btnCancelar],
		items: [comboPlantillas, labelInformativa]
	});

	page.add(panelEdicion);

</fwk:page>