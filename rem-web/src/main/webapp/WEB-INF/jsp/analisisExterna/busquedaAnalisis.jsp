<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

//------------------------------------------------
// Parametros de entrada
//------------------------------------------------
	var config = {width: 250, labelStyle:"width:150px;font-weight:bolder"};
	
    var filtroFecha= new Ext.ux.form.XDateField({
        fieldLabel:'<s:message code="analisis.busqueda.fechaExtraccion" text="**Fecha de extracción" />'
        ,name:'fechaExtraccion'
        ,style:'margin:0px'
        ,maxValue : new Date()
    });
	filtroFecha.labelStyle = config.labelStyle;

	var tipoProcedimientos=<app:dict value="${tipoProcedimientos}" />;
    var comboTipoProcedimientos = app.creaDblSelect(tipoProcedimientos, '<s:message code="analisis.busqueda.filtro.tipoProcedimiento" text="**Tipo de actuación" />',config);
	
	var despachos=<app:dict value="${despachos}" />;
    var comboDespachos = app.creaDblSelect(despachos, '<s:message code="analisis.busqueda.filtro.despacho" text="**Despacho" />',config);


	var DiccionarioRecord = Ext.data.Record.create([
		{name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var gestoresStore = page.getStore({
		eventName : 'listado'
		,flow:'analisisExterna/busquedaGestoresDespachos'
		,reader: new Ext.data.JsonReader({
	        root: 'diccionario'
		}, DiccionarioRecord)
	});	
	
	
	config.store = gestoresStore;	
    var comboGestores = app.creaDblSelect(null, '<s:message code="analisis.busqueda.filtro.gestor" text="**Gestor" />',config);

	var supervisoresStore = page.getStore({
		eventName : 'listado'
		,flow:'analisisExterna/busquedaSupervisoresDespachos'
		,reader: new Ext.data.JsonReader({
	        root: 'diccionario'
		}, DiccionarioRecord)
	});	

	config.store = supervisoresStore;
    var comboSupervisores = app.creaDblSelect(null, '<s:message code="analisis.busqueda.filtro.supervisor" text="**Supervisor" />',config);

	config.store = null;
	var fases=<app:dict value="${fases}" />;
    var comboFases = app.creaDblSelect(fases, '<s:message code="analisis.busqueda.filtro.faseProcesal" text="**Fase procesal" />',config);


	
	var plazos=  <app:dict value="${plazos}" blankElement="true" blankElementValue="" blankElementText="---" />;
    var comboPlazo = app.creaComboOffset({triggerAction: 'all'
                                    ,data:plazos   
                                    ,value:plazos.diccionario[0].codigo                                 
                                    ,name : 'plazo'
                                    ,fieldLabel : '<s:message code="analisis.busqueda.filtro.plazoAceptacion" text="**Aceptado hace" />'});
	comboPlazo.labelStyle = config.labelStyle;


	var checkProcedimientoActivo = new Ext.form.Checkbox({
			fieldLabel:'<s:message code="analisis.busqueda.filtro.procedimientoActivo" text="**Solo actuaciones activas" />'
            ,name : 'procedimientoActivo'
	});
	checkProcedimientoActivo.labelStyle = config.labelStyle;


  
	comboDespachos.on('render', function(){
		comboDespachos.getStore().on('add', function(){
			limpiarGestorSupervisor();
		});
		comboDespachos.getStore().on('remove', function(){
			limpiarGestorSupervisor();
		});
	});

	var idTimer = null;

	limpiarGestorSupervisor = function(){
		comboGestores.reset();
		comboSupervisores.reset();
		
		if (idTimer != null) clearTimeout(idTimer);
		idTimer = setTimeout (recargaGestorSupervisor, 1000);		
	};



	recargaGestorSupervisor = function(){
		idTimer = null;
		gestoresStore.webflow({listadoDespachos:comboDespachos.getValue()});
		supervisoresStore.webflow({listadoDespachos:comboDespachos.getValue()});
	};


//------------------------------------------------
// Criterio de salida
//------------------------------------------------

	var salidas=<app:dict value="${salidas}" />;
    var comboTipoSalida = app.creaComboOffset({triggerAction: 'all'
                                    ,data:salidas                                    
                                    ,name : 'salida'
                                    ,fieldLabel : '<s:message code="analisis.busqueda.filtro.tipoSalida" text="**Criterio de salida" />'});                                    
	comboTipoSalida.labelStyle = config.labelStyle;



//------------------------------------------------
// Validar
//------------------------------------------------
	var validarForm = function(){
	
	    if(comboTipoSalida.getValue() == '') {
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="analisis.busqueda.salida.completar"/>')
                return false;
		}

        if (filtroFecha.getValue() == ''){
            Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="analisis.busqueda.salida.jerarquico.completar.fecha"/>')
            return false;
        } else {
            return true;
        }
		if (comboTipoProcedimientos.getValue() != '' ){
			return true;
		}
        if (comboDespachos.getValue() != '' ){
            return true;
        }
		if (comboGestores.getValue() != '' ){
			return true;
		}
		if (comboSupervisores.getValue() != '' ){
			return true;
		}
		if (comboFases.getValue() != '' ){
			return true;
		}
        if (comboPlazo.getValue() != '' ){
            return true;
        }

        Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.clientes.listado.criterios"/>')
		return false;
	}


//------------------------------------------------
// Exportar
//------------------------------------------------
	
	var exportarFunc = function(tipo) {
        if (validarForm()){
            var fecha = '';
            if(filtroFecha.getValue()!= '') {
                fecha = filtroFecha.getValue().format('d/m/Y');
            }
            var params = {
                    fecha: fecha
                    ,idTipoProcedimientos:comboTipoProcedimientos.getValue()
                    ,codigoDespachos:comboDespachos.getValue()
                    ,idUsuariosGestor:comboGestores.getValue()
                    ,idUsuariosSupervisor:comboSupervisores.getValue()
                    ,codigosFase:comboFases.getValue()
                    ,codigoPlazo:comboPlazo.getValue()
                    ,bProcedimientoActivo:checkProcedimientoActivo.getValue()
                    ,tipoSalida:comboTipoSalida.getValue()
					,tipo:'generarCsv'
					,REPORT_NAME:'analisisExterna.xls'
                  };
            exportar(params,tipo);
        }
	};

	var btnExportarXLS = new Ext.Button({
		text: '<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a XLS" />'
		,iconCls: 'icon_exportar_csv'
		,handler: function() {
			exportarFunc('generaXLS');
        }
	});

	var btnExportarPDF = new Ext.Button({
		text: '<s:message code="menu.clientes.listado.filtro.exportar.pdf" text="**Exportar a PDF" />'
		,iconCls: 'icon_pdf'
		,handler: function() {
			exportarFunc('generaPDF');
        }
	});

	var objetoResultado = Ext.data.Record.create([
		     {name : 'codigoResultado' }
		     ,{name : 'mensajeError' }
		     ,{name : 'nResultados' }
		]);
	
		
		var objetoResultadoStore = page.getStore({
			flow : 'analisisExterna/cuentaResultados'
			,reader: new Ext.data.JsonReader({
		    	root : 'resultados'
		    }, objetoResultado)
		});

	
	var codigoOk = '<fwk:const value="es.capgemini.pfs.utils.ObjetoResultado.RESULTADO_OK" />';
	var codigoError = '<fwk:const value="es.capgemini.pfs.utils.ObjetoResultado.RESULTADO_ERROR" />';
	var parametros;

	objetoResultadoStore.on('load', function(){
		
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
			var flow='analisisExterna/analisisExterna';
	        app.openBrowserWindow(flow,params);
		}
	});	



    function exportar(params,tipo){
        params.tipo=tipo;
		parametros = params;
		objetoResultadoStore.webflow(params);
      };
	
	
	

//------------------------------------------------
// Limpiar
//------------------------------------------------
	var btnReset = app.crearBotonResetCampos([
        filtroFecha
        ,comboTipoProcedimientos    
        ,comboDespachos
        ,comboGestores
        ,comboSupervisores
        ,comboFases
        ,comboPlazo
        ,checkProcedimientoActivo
        ,comboTipoSalida
	]);

//------------------------------------------------
// Ayuda
//------------------------------------------------
	var muestraAyuda=function(){
		
	}

//------------------------------------------------
// Formulario
//------------------------------------------------
	var filtroForm = new Ext.Panel({
		title : '<s:message code="analisis.busqueda.filtro" text="**Filtro de analisis" />'
		,collapsible : true
		,titleCollapse : true
		,layout:'table'
        ,autoHeight : true
        ,autoScroll: false
        ,autoWidth:true
		,style:'margin-right:20px;margin-left:10px'
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			{
				layout:'form'
				,bodyStyle:'padding:5px;cellspacing:10px'
				,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', width:600}
				,autoWidth:true
				,items:[ 
				{
					layout:'form'
					,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', width:150}
					,items :[filtroFecha]
				}				
				,comboTipoProcedimientos
				,comboDespachos
				,comboGestores
				,comboSupervisores
				,comboFases 
				,checkProcedimientoActivo
				,{
					layout:'form'
					,autoWidth:true
					,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', width:200}
					,items :[comboPlazo, comboTipoSalida]
				}
				]
			} 
			,{
				items : [ {html :'&nbsp;',border:false},{html :'&nbsp;',border:false}]
			}
		]
        ,tbar : [btnReset, btnExportarXLS, btnExportarPDF, '->', app.crearBotonAyuda(muestraAyuda)]
	});

	//añadimos al padre y hacemos el layout
	page.add(filtroForm);   

</fwk:page>
