<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

//------------------------------------------------
// Fecha extraccion
//------------------------------------------------
    var filtroFecha= new Ext.ux.form.XDateField({
        fieldLabel:'<s:message code="analisis.busqueda.fechaExtraccion" text="**Fecha de extracción" />'
        ,name:'fechaExtraccion'
        ,style:'margin:0px'
        ,maxValue : new Date()
    });

//------------------------------------------------
// Segmentos
//------------------------------------------------
	var segmentos=<app:dict value="${segmentos}" />;
    var comboSegmentos = app.creaDblSelect(segmentos, '<s:message code="menu.clientes.listado.filtro.segmento" text="**Segmento" />',{width: 250});

//------------------------------------------------
// tipos de contratos
//------------------------------------------------
    var tiposContratos=<app:dict value="${tiposContratos}" />;
    var comboTiposContratos = app.creaDblSelect(tiposContratos, '<s:message code="analisis.busqueda.tiposContratos" text="**Tipos de Contratos" />',{width: 250});

//------------------------------------------------
// fase y subfases
//------------------------------------------------

    var fases = <app:dict value="${fases}" blankElement="true" blankElementValue="" blankElementText="---" />;
    
    var comboFases = app.creaCombo({triggerAction: 'all'
                                    ,data:fases
                                    ,value:fases.diccionario[0].codigo
                                    ,name : 'fase'
                                    ,fieldLabel : '<s:message code="analisis.busqueda.fases" text="**Fase" />'});

    var subfaseRecord = Ext.data.Record.create([
         {name:'codigo'}
        ,{name:'descripcion'}
    ]);
    
    var optionsSubfaseStore = page.getStore({
           flow: 'analisis/buscarSubfases'
           ,reader: new Ext.data.JsonReader({
             root : 'subfases'
        }, subfaseRecord)
           
    });
    
    var recargarComboSubfases = function(){
        if (comboFases.getValue()!=null && comboFases.getValue()!=''){
            optionsSubfaseStore.webflow({codigo:comboFases.getValue()});
        }else{
            optionsSubfaseStore.webflow({codigo:'0'});
        }
    };
    
    recargarComboSubfases();   
    
    var comboSubfases = app.creaDblSelect(fases
                                       ,'<s:message code="analisis.busqueda.subfases" text="**Subfases" />'
                                       ,{store:optionsSubfaseStore, funcionReset:recargarComboSubfases, width: 250});

    comboFases.on('select', function() {
        comboSubfases.reset();
        recargarComboSubfases()
    });
//------------------------------------------------
// jerarquia y zonas
//------------------------------------------------
	var zonas=<app:dict value="${zonas}" />;

	var jerarquia = <app:dict value="${niveles}" blankElement="true" blankElementValue="" blankElementText="---" />;
	
	var comboJerarquia = app.creaCombo({triggerAction: 'all'
										<app:test id="jerarquiaCombo" addComa="true" />
										,data:jerarquia
										,value:jerarquia.diccionario[0].codigo
										,name : 'jerarquia'
										,fieldLabel : '<s:message code="menu.clientes.listado.filtro.jerarquia" text="**Jerarquia" />'});


    var zonasRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
    
    var optionsZonasStore = page.getStore({
	       flow: 'clientes/buscarZonas'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, zonasRecord)
	       
	});
	
    var recargarComboZonas = function(){
		if (comboJerarquia.getValue()!=null && comboJerarquia.getValue()!=''){
			optionsZonasStore.webflow({id:comboJerarquia.getValue()});
		}else{
			optionsZonasStore.webflow({id:0});
		}
	};
	
    var comboZonas = app.creaDblSelect(zonas
                                       ,'<s:message code="menu.clientes.listado.filtro.centro" text="**Centro" />'
                                       ,{store:optionsZonasStore,
                                         width: 250,   
                                         funcionReset:recargarComboZonas});

    recargarComboZonas();
    comboJerarquia.on('select',function() {
            comboZonas.reset();
            recargarComboZonas();
            recargarComboSalidaJerarquico();
    });    
    

//------------------------------------------------
// Criterio de salida
//------------------------------------------------

	var salidas = <app:dict value="${criteriosAnalisis}" blankElement="true" blankElementValue="" blankElementText="---" />;
    
    var comboSalida = app.creaCombo({triggerAction: 'all'
                                    ,data:salidas
                                    ,value:salidas.diccionario[0].codigo
                                    ,name : 'salida'
                                    ,fieldLabel : '<s:message code="analisis.busqueda.salida" text="**Criterio de salida" />'});

    var comboSalidaJerarquico = app.creaCombo({triggerAction: 'all'
                                    ,data:jerarquia
                                    ,value:jerarquia.diccionario[0].codigo
                                    ,name : 'salidaJerarquica'
									,disabled:true
                                    ,fieldLabel : '<s:message code="analisis.busqueda.salida.jerarquico" text="**Criterio de salida jerárquico" />'});

	comboSalida.on('select',function() {
            comboSalidaJerarquico.reset();
    });   

    var recargarComboSalidaJerarquico = function(){
        if (comboJerarquia.getValue() !=null && comboJerarquia.getValue()!=''){
            g1 = comboJerarquia;
            g2 = comboSalidaJerarquico;
        }
    };

    comboSalida.on('select',
        function() {
            if(comboSalida.getValue() == '<fwk:const value="es.capgemini.pfs.mapaGlobalOficina.model.DDCriterioAnalisis.CRITERIO_SALIDA_JERARQUICO" />') {
                comboSalidaJerarquico.enable();
            } else {
				//comboSalidaJerarquico.setValue('');
                comboSalidaJerarquico.disable();
            }
    });  
//------------------------------------------------
// Validar
//------------------------------------------------
	var validarForm = function(){
        if(comboSalida.getValue() == '<fwk:const value="es.capgemini.pfs.mapaGlobalOficina.model.DDCriterioAnalisis.CRITERIO_SALIDA_JERARQUICO" />') {
            if (comboJerarquia.getValue() == '' ){
                Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="analisis.busqueda.jerarquico.completar"/>')
                return false;
            }
            if(comboSalidaJerarquico.getValue() == '') {
                Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="analisis.busqueda.salida.jerarquico.completar"/>')
                return false;
            }
            l1 = new Number(comboJerarquia.getValue());
            l2 = new Number(comboSalidaJerarquico.getValue());
            if(l1 > l2) {
                Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="analisis.busqueda.salida.jerarquico.menor"/>')
                return false;
            }
        } else if(comboSalida.getValue() == '') {
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="analisis.busqueda.salida.completar"/>')
                return false;
		}

        if (filtroFecha.getValue() == ''){
            Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="analisis.busqueda.salida.jerarquico.completar.fecha"/>')
            return false;
        } else {
            return true;
        }
		if (comboSegmentos.getValue() != '' ){
			return true;
		}
        if (comboTiposContratos.getValue() != '' ){
            return true;
        }
		if (comboZonas.getValue() != '' ){
			return true;
		}
		if (comboFases.getValue() != '' ){
			return true;
		}
        if (comboSubfases.getValue() != '' ){
            return true;
        }
        if (comboJerarquia.getValue() != '' ){
            return true;
        }

        Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.clientes.listado.criterios"/>')
		return false;
	}
	
//------------------------------------------------
// Buscar (por ahora no se pidio)
//------------------------------------------------

    var Analisis = Ext.data.Record.create([
        {name:'id'}
    ]);
    
    var analisisStore = page.getStore({
        flow:'analisis/listadoMapaGlobal'
        ,limit:10
        ,reader: new Ext.data.JsonReader({
            root : 'analisis'
        }, Analisis)
    });



	//REVISAR PARAMETROS
	var buscarFunc = function(){
		if (validarForm()){
			clientesStore.webflow({
                nombre:filtroFecha.getValue()
				,codigoSegmentos:comboSegmentos.getValue()
                ,tiposContratos:comboTiposContratos.getValue()
                ,fase:comboFases.getValue()
                ,codigoSubfase:comboSubfases.getValue()
				,jerarquia:comboJerarquia.getValue()
                ,codigoZona:comboZonas.getValue()
			});
		}
	};
	
    var btnBuscar=app.crearBotonBuscar({
        handler : buscarFunc
    });
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
                    ,codigoSegmentos:comboSegmentos.getValue()
                    ,tiposContratos:comboTiposContratos.getValue()
                    ,codigoFase:comboFases.getValue()
                    ,codigoSubfases:comboSubfases.getValue()
                    ,jerarquia:comboJerarquia.getValue()
                    ,codigoZonas:comboZonas.getValue()
                    ,criterioSalida:comboSalida.getValue()
                    ,criterioSalidaJerarquico:comboSalidaJerarquico.getValue()
					,tipo:'generarCsv'
                  };
            exportar(params,tipo);
        }
	};

	var exportarFuncCSV = function() {
			exportarFunc('generaCSV');
		};

    var btnExportarCSV=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar" text="**Exportar a CSV" />'
        ,iconCls:'icon_exportar_csv'
        ,handler : exportarFuncCSV
    });

	var exportarFuncPDF = function() {
			exportarFunc('generaPDF');
		};

	<sec:authorize ifAllGranted="EXPORTAR_ANALISIS_PDF">
		var exportarFuncXLS = function() {
				exportarFunc('generaXLS');
			};
	</sec:authorize>

    var btnExportarPDF=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportarPdf" text="**Exportar a PDF" />'
        ,iconCls:'icon_pdf'
        ,handler : exportarFuncPDF
    });

	<sec:authorize ifAllGranted="EXPORTAR_ANALISIS_PDF">
	    var btnExportarXLS=new Ext.Button({
	        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a XLS" />'
	        ,iconCls:'icon_exportar_csv'
	        ,handler : exportarFuncXLS
	    });
	</sec:authorize>


	var objetoResultado = Ext.data.Record.create([
		     {name : 'codigoResultado' }
		     ,{name : 'mensajeError' }
		     ,{name : 'nResultados' }
		]);
	
		
		var objetoResultadoStore = page.getStore({
			flow : 'analisis/listadoMapaGlobal'
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
	        var flow='analisis/exportAnalisisData';
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
        ,comboSegmentos
        ,comboTiposContratos
        ,comboFases
        ,comboSubfases
		,comboJerarquia
		,comboZonas
        ,comboSalida
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
        ,autoWidth:true
		,style:'margin-right:20px;margin-left:10px'
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[{
				layout:'form'
				,bodyStyle:'padding:5px;cellspacing:10px'
				,items:[ filtroFecha, comboSegmentos, comboTiposContratos, comboFases, comboSubfases, comboJerarquia, comboZonas, comboSalida, comboSalidaJerarquico]
			} 
			,{
				items : [ {html :'&nbsp;',border:false},{html :'&nbsp;',border:false}]
			}
		]
        ,tbar : [btnReset, <sec:authorize ifAllGranted="EXPORTAR_ANALISIS_PDF">btnExportarXLS,</sec:authorize> btnExportarCSV, btnExportarPDF, '->', app.crearBotonAyuda(muestraAyuda)]
	});

	//añadimos al padre y hacemos el layout
	page.add(filtroForm);   

</fwk:page>
