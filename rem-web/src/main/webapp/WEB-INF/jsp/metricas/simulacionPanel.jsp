<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>


var labelTipoPersona = app.creaLabel(
		'<s:message code="menu.clientes.listado.filtro.tipopersona" text="**Tipo Persona" />'
		,'',{});
var labelSegmento = app.creaLabel(
		'<s:message code="metricas.grid.segmento" text="**Segmento" />'
		,'',{});

var panelIzqTipoPerSeg = new Ext.form.FieldSet({
	autoHeight: true
	,width: 300
	,border:false
	,items: [ labelTipoPersona,labelSegmento ]
});

var labelStyle = 'width:120px;font-weight:bolder';

var numberIntervalosRating = new Ext.form.NumberField({
	fieldLabel:'<s:message code="metricas.label.intervalosRating" text="**N° intevalos Rating" />'
	,allowNegative:false,allowDecimals:false
	,maxValue: 100
	,minValue: 1
	,width: 50
	,labelStyle:labelStyle
	,autoCreate: {tag: "input", type: "text",maxLength:"3", autocomplete: "off"}
});

var numberIntervalosVRC = new Ext.form.NumberField({
	fieldLabel:'<s:message code="metricas.label.intervalosVRC" text="**N° intervalos VRC" />'
	,allowNegative:false,allowDecimals:false
	,maxValue: 10
	,minValue: 1
	,width: 50
	,labelStyle:labelStyle
	,autoCreate: {tag: "input", type: "text",maxLength:"2", autocomplete: "off"}
});

var panelCentIntervalos = new Ext.form.FieldSet({
	autoHeight: true
	,width: 300
	,border: false
	,items: [ numberIntervalosRating,numberIntervalosVRC ]
});

var validarForm = function(output) {
	var errores = '';
	if(output=='pdf' && numberIntervalosRating.getValue() > 6) {
		errores += '- ' + '<s:message code="metricas.indicadores.numIntervalosRatingAPdf.error" 
                             text="**El núm. de intervalos Rating no debe ser mayor a 6 para exportar a PDF"
                             arguments="6" />' + '<br />';
	} else if (numberIntervalosRating.getValue() > 100) {
		errores += '- ' + '<s:message code="metricas.indicadores.numIntervalosRating.error" 
                            text="**El núm. de intervalos Rating no debe ser mayor a 100"
                            arguments="100" />' + '<br />';
	}
	if(numberIntervalosVRC.getValue() > 10) {
		errores += '- ' + '<s:message code="metricas.indicadores.numIntervalosVRC.error" 
                             text="**El núm. de intervalos VRC no debe ser mayor a 10"
                             arguments="10" />' + '<br />';
	}
	if(numberIntervalosVRC.getValue() == '' || numberIntervalosRating.getValue() == '') {
		errores += '- ' + '<s:message code="metricas.ratingOrVrcNulos.error" 
                            text="**Los campos Rating y VRC no pueden estar vacíos y deben ser mayor a cero" />' + '<br />';
	}
	if(labelSegmento.getValue() == '') {
		errores += '- ' + '<s:message code="metricas.tipoPerOrSegmentoNulos.error" 
                            text="**Debe seleccionar un tipo de persona y/o un segmento" />' + '<br />';
	}
	if(codTipoPersona != null && metricaActTipoPersonaIsSel == false) {
		errores += '- ' + '<s:message code="metricas.simulacion.error.defaultSinMetActiva" 
                            text="**El tipo de persona seleccionada no tiene métrica activa cargada" />' + '<br />';
	} 
	//if(codSegmento != null && metricaSegmentoIsSel == false) {
	if(codSegmento != null && metricaActSegmentoIsSel == false) {
		errores += '- ' + '<s:message code="metricas.simulacion.error.segmentoSinMetActiva" 
                            text="**El segmento seleccionado no tiene métrica activa cargada" />' + '<br />';
	}
	if(errores != '') {
		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>', errores);
		return false;
	}
	return true;
}

var getParametros = function() {
	var segmento = '';
	var tipoPersona = '';
	if(labelSegmento.getValue() != '<s:message code="metricas.todos" text="**Todos" />') {
		segmento = codSegmento;
		tipoPersona = codTipoPersona; //comboTipoPersona.getValue();
	} else {
		tipoPersona = codTipoPersona;
	}
	return {
		codigoTipoPersona: tipoPersona
		,codigoSegmento: segmento
		,cantidadIntervaloRating: numberIntervalosRating.getValue()
		,cantidadIntervaloVRC: numberIntervalosVRC.getValue()
	}
}

var flow = 'metricas/exportSimulacion';

var btnGenerarInfomePDF = new Ext.Button({
	text: '<s:message code="metricas.boton.generarInformePDF" text="**Generar informe  PDF" />'
	,iconCls: 'icon_pdf'
    ,handler: function() {
		if(validarForm('pdf')) {
	    	var params = getParametros();
			params.output = 'pdf';
			parametros = params;
			exportar(params);
	        //app.openBrowserWindow(flow,params);
		}
      }
});

var btnGenerarInfomeXLS = new Ext.Button({
	text: '<s:message code="metricas.boton.generarInformeXLS" text="**Generar informe Excel" />'
	,iconCls: 'icon_exportar_csv'
    ,handler: function() {
		if(validarForm('xls')) {
	    	var params = getParametros();
			params.output = 'xls';
			parametros = params;
			exportar(params);
	        //app.openBrowserWindow(flow,params);
		}
      }
});


	function exportar(params,tipo){
		app.contenido.el.mask('<s:message code="scoring.simulacion.calculando" text="**Calculando simulación"/>');
        params.tipo=tipo;
		parametros = params;
		objetoResultadoStore.webflow(params);
      };


	var objetoResultado = Ext.data.Record.create([
		     {name : 'codigoResultado' }
		     ,{name : 'mensajeError' }
		     ,{name : 'nResultados' }
		]);

	var objetoResultadoStore = page.getStore({
		flow : 'metricas/exportSimulacionCheck'
		,reader: new Ext.data.JsonReader({
	    	root : 'resultados'
	    }, objetoResultado)
	});

	var codigoOk = '<fwk:const value="es.capgemini.pfs.utils.ObjetoResultado.RESULTADO_OK" />';
	var codigoError = '<fwk:const value="es.capgemini.pfs.utils.ObjetoResultado.RESULTADO_ERROR" />';
	var parametros;


	objetoResultadoStore.on('load', function(){
		app.contenido.el.unmask();
		var rec = objetoResultadoStore.getAt(0);
		var codigoResultado = rec.get('codigoResultado');

		if (codigoResultado == codigoError)
		{
			var mensaje = rec.get('mensajeError');
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',mensaje);
			return;
		}
		else if (codigoResultado == codigoOk && parametros != null)
		{	        
			var params = parametros;
			parametros = null;
	        app.openBrowserWindow(flow,params);
		}
	});	





var panelDerBoton = new Ext.Panel({
	autoHeight: true
	,autoWidth: true
	,layout: 'table'
	,border:false
	,layoutConfig: {columns:1}
	,defaults: {xtype:'panel', border: false, cellCls: 'vtop'}
	,items: [
		{items:[btnGenerarInfomePDF], border:false, style:'margin-bottom:5px'}
		,{items:[btnGenerarInfomeXLS], border:false}
      ]
});

var panelSimulacion = new Ext.form.FieldSet({
	title: '<s:message code="metricas.simulacion" text="**Simulación" />'
	,autoHeight: true
	,autoWidth: true
	,layout: 'table'
	,layoutConfig: {columns:3}
	,defaults: {xtype:'panel', border: false, cellCls: 'vtop'}
	,items: [
		{items:[panelIzqTipoPerSeg], border:false}
		,{items:[panelCentIntervalos], border:false}
		,{items:[panelDerBoton], border:false}
	   ]
});
