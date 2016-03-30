<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>

<fwk:page>
	Ext.util.CSS.createStyleSheet(".lista_procesos_procesando { background-image: url('../img/plugin/masivo/loading.gif');background-repeat:no-repeat;background-position:right;}");
	Ext.util.CSS.createStyleSheet(".lista_procesos_cargando { background-image: url('../img/plugin/masivo/loading.gif');background-repeat:no-repeat;background-position:right;}");

	var controlador = new es.pfs.plugins.masivo.ControladorAsincrono();
	
	var panelWidth=850;

	<pfs:ddCombo name="comboTiposOperacion" labelKey="plugin.masivo.procesadoTareas.comboOperacion" label="**Operacion: " propertyCodigo='id'
		value="" dd="${tiposOperacion}" width="250" />
		
<%-- 	<pfs:ddCombo name="comboPlantillas" labelKey="plugin.masivo.procesadoTareas.plantillas" label="**Plantillas: " propertyCodigo='id' propertyDescripcion='nombre'
		value="" dd="${plantillas}" width="250" /> --%>	
		
	var btnCargaFichero = new Ext.Button({
	       text : '<s:message code="plugin.masivo.procesadoTareas.cargarExcel" text="**Cargar Excel" />' + '&nbsp;'
	       ,height : 25
	       ,iconCls:'icon_mas'
	       ,disabled:true
	});	
 	
	comboTiposOperacion.on('select', function(){
 		if (comboTiposOperacion.getValue() !='' && comboTiposOperacion.getValue() != null ){
 			btnCargaFichero.setDisabled(false);
 			btnDescargarExcel.setDisabled(false);
 		}else {
 			btnCargaFichero.setDisabled(true);
 			btnDescargarExcel.setDisabled(true);
 		}
 	});
 	
 	var btnDescargarExcel = new Ext.Button({
	       text : '<s:message code="plugin.masivo.procesadoTareas.descargarExcel" text="**Descargar Excel" />' + '&nbsp;'
	       ,iconCls:'icon_exportar_csv'
	       ,height : 25
	       ,disabled:true
	       ,handler:function(){
				var flow='/pfs/msvprocesadotareasarchivo/descargarExcel';
            	var params = {idTipoOperacion:comboTiposOperacion.getValue()};
            	app.openBrowserWindow(flow,params);	       
	     	}
	});	
	
	btnCargaFichero.on('click', function(){
		
		//Pruebas. Luego descomentar. var idField = upload.getForm().findField('id');
		//idField.setValue(comboTiposOperacion.getValue());
		//var obj = upload.getForm().findField('path');
		creaVentanaUpload();
		upload.getForm().reset();
		win.show();
		//controlador.subirFichero(comboTiposOperacion.getValue());
	});	
	
/*
	comboPlantillas.on('select', function(){
 		if (comboPlantillas.getValue() !='' && comboPlantillas.getValue() != null){
 			btnDescargarExcel.setDisabled(false);
 		}else {
 			btnDescargarExcel.setDisabled(true);
 		}
 	});
*/
		
	var DatosFieldSet = new Ext.form.FieldSet({
		autoHeight:'false'
		,style:'padding:2px'
 		,border:false
		,layout : 'column'
		,layoutConfig:{
			columns:3
		}
		,width:1000
		,defaults : {layout:'form',border: false,bodyStyle:'padding:3px'} 
		,items : [ 
				 { 	columnWidth:.37,
				 	items:[ comboTiposOperacion]
				 },
				 {
				 	columnWidth:.15, 
				 	items:[ btnCargaFichero]
				 },
				 {
				 	columnWidth:.15, 
				 	items:[ btnDescargarExcel]
				 } 

		]
	}); 	
	
	 var ListaArchivosRT = Ext.data.Record.create([
    	 {name: 'id'},
         {name: 'nombre'},
         {name: 'idTtipoOperacion'},
         {name: 'tipoOperacion'},
         {name: 'idEstado'},
         {name: 'estado'},
         {name: 'usuario'},
         {name: 'fecha',type: 'date',dateFormat: 'c'}
	]);
	
	var listaArchivosStore = page.getStore({
	
      flow:'msvprocesadotareasarchivo/mostrarProcesos'
      ,limit:25
      ,remoteSort:true
      ,reader: new Ext.data.JsonReader({
        root : 'listaArchivos'
      } , ListaArchivosRT)
     });
     
    listaArchivosStore.webflow();

	listaArchivosStore.on('load', function(store, data, options){actualizarBotones();});
	
	var rellenaArray = function(array){
		var tiposOperacion = [];
	    for (var i = 0; i < array.length; i++){
	   		var obj = array[i];
	   		tiposOperacion.push(obj.descripcion);
	    };
	    return tiposOperacion;
	} 
    
    var filters = new Ext.ux.grid.GridFilters({
        encode: false, // json encode the filter query
        local: false,   // defaults to false (remote filtering)
        filters: [{
            type: 'list',
            dataIndex: 'estado',
            options: ['Cargando', 'Error', 'Pte. Validar','Validado','Pte. Procesar','En proceso','Procesado','Procesado con errores']
        },
		{
            type: 'list',
            dataIndex: 'tipoOperacion',
            options: rellenaArray(comboTiposOperacionDiccionario.diccionario)
        },
		{
            type: 'string',
            dataIndex: 'usuario'
    	},
    	{
            type: 'date',
            dataIndex: 'fecha',
            beforeText: 'Menor que',
            afterText: 'Mayor que',
            onText: 'Igual a'
        }]
    });
	var listaArchivosCM = new Ext.grid.ColumnModel([
		{header : '<s:message code="plugin.masivo.procesadoTareas.gridArchivos.id" text="**Id" />', dataIndex : 'id' ,sortable:true, hidden: true}
		,{header : '<s:message code="plugin.masivo.procesadoTareas.gridArchivos.tipoOperacion"  text="**Tipo operación"/>', dataIndex : 'tipoOperacion' ,sortable:true
			, filterable: true
		}
		,{header : '<s:message code="plugin.masivo.procesadoTareas.gridArchivos.estado" text="**Estado" />', dataIndex : 'estado' ,sortable:true
			,renderer: function (value, meta, record) {
				switch(record.get('estado')){
					case 'Procesando ...':
						meta.css = 'lista_procesos_procesando';
						break;
					case 'Cargando':
						meta.css = 'lista_procesos_cargando';
						break;
					default:
						meta.css = null;
						break;
                }				

                    return value;
                }              
		}
		,{header : '<s:message code="plugin.masivo.procesadoTareas.gridArchivos.nombre" text="**Nombre archivo" />', dataIndex : 'nombre' ,sortable:true}
		,{header : '<s:message code="plugin.masivo.procesadoTareas.gridArchivos.usuario" text="**Usuario" />', dataIndex : 'usuario' ,sortable:true}
		,{header : '<s:message code="plugin.masivo.procesadoTareas.gridArchivos.fecha" text="**Fecha de Creación" />', dataIndex : 'fecha' ,sortable:true, renderer:Ext.util.Format.dateRenderer('d/m/Y H:i:s')}
		]);
	
var actualizarBotones = function(){
		var registro = listaArchivosGrid.getSelectionModel().getSelected();
		var estado = '';
		if (registro){
			estado = listaArchivosGrid.getSelectionModel().getSelected().get('estado');
		}
		//var rec = grid.getStore().getAt(rowIndex);
		//var estado= rec.get('estado');
		
		switch(estado){
			case 'Cargando':
				btnValidar.setDisabled(true);
				btnLiberar.setDisabled(true);
				btnEliminar.setDisabled(false);
				btnDescargaErrores.setDisabled(true);		
				break;	
			case 'Pte. Validar':
				btnValidar.setDisabled(false);
				btnLiberar.setDisabled(true);
				btnEliminar.setDisabled(false);
				btnDescargaErrores.setDisabled(true);
				break;
			case 'Validado':
				btnValidar.setDisabled(true);
				btnLiberar.setDisabled(false);
				btnEliminar.setDisabled(false);
				btnDescargaErrores.setDisabled(true);
				break;	
			case 'Pte. Procesar':
				btnValidar.setDisabled(true);
				btnLiberar.setDisabled(true);
				btnEliminar.setDisabled(true);
				btnDescargaErrores.setDisabled(true);
				break;
			case 'En proceso':
				btnValidar.setDisabled(true);
				btnLiberar.setDisabled(true);
				btnEliminar.setDisabled(true);
				btnDescargaErrores.setDisabled(true);
				break;
			case 'Procesado':
				btnValidar.setDisabled(true);
				btnLiberar.setDisabled(true);
				btnEliminar.setDisabled(true);
				btnDescargaErrores.setDisabled(true);
				break;
			case 'Error':
				btnValidar.setDisabled(true);
				btnLiberar.setDisabled(true);
				btnEliminar.setDisabled(false);
				btnDescargaErrores.setDisabled(false);
				break;
			case 'Procesado con errores':
				btnValidar.setDisabled(true);
				btnLiberar.setDisabled(true);
				btnEliminar.setDisabled(false);
				btnDescargaErrores.setDisabled(false);
				break;
			default:
				btnValidar.setDisabled(true);
				btnLiberar.setDisabled(true);
				btnEliminar.setDisabled(true);
				btnDescargaErrores.setDisabled(true);
				break;				
		}
}
	
	var recargarGrid = function(){
		desactivarBotones();
		listaArchivosStore.webflow();
		actualizarBotones();
	}
	
	var desactivarBotones = function(){
		btnValidar.setDisabled(true);
		btnLiberar.setDisabled(true);
		btnEliminar.setDisabled(false);
		btnDescargaErrores.setDisabled(false);
	}
	
	
	var btnValidar = new Ext.Button({
	       text : '<s:message code="plugin.masivo.procesadoTareas.grid.botonValidar" text="**Validar" />'
	       ,iconCls:'icon_historial'
	       ,disabled:true
	       ,handler:function(){
	       		if (listaArchivosGrid.getSelectionModel().getCount()>0){
	       			var id = listaArchivosGrid.getSelectionModel().getSelected().get('id');
	       			listaArchivosGrid.getSelectionModel().getSelected().set('estado', 'Procesando ...');
	       			controlador.validarFichero(id, fn_validaFicheroOk);
				}
				else{
				Ext.Msg.alert('<s:message code="plugin.masivo.procesadoTareas.grid.botonValidar" text="**Validar" />','<s:message code="plugin.masivo.procesadoTareas.grid.botonValidar.novalor" text="**Debe seleccionar un valor de la lista" />');
				}			
	     	}
	});    
    
	var btnLiberar = new Ext.Button({
	       text : '<s:message code="plugin.masivo.procesadoTareas.grid.botonLiberar" text="**Liberar" />'
	       ,iconCls:'icon_ok'
	       ,disabled:true
	       ,handler:function(){
	       		if (listaArchivosGrid.getSelectionModel().getCount()>0){	       			
    				Ext.Msg.confirm('Liberar Fichero','¿Desea iniciar el procesado del fichero seleccionado? Una vez iniciado, <br/> este proceso no podrá ser detenido manualmente.',function(boton){
                        if(boton == 'yes'){
                        	var id = listaArchivosGrid.getSelectionModel().getSelected().get('id');
                        	listaArchivosGrid.getSelectionModel().getSelected().set('estado', 'Procesando ...');
                         	controlador.liberarFichero(id, fn_liberarFicheroOk);
                        }else{
                        	return true;
                        }
                	});	       			
	       			
				}
				else{
					Ext.Msg.alert('<s:message code="plugin.masivo.procesadoTareas.grid.botonValidar" text="**Validar" />','<s:message code="plugin.masivo.procesadoTareas.grid.botonValidar.novalor" text="**Debe seleccionar un valor de la lista" />');
				}				
	     	}
	});
	
	var btnEliminar = new Ext.Button({
	       text : '<s:message code="plugin.masivo.procesadoTareas.grid.botonEliminar" text="**Eliminar" />'
	       ,iconCls:'icon_rechazar_decision'
	       ,disabled:true
	       ,handler:function(){
	       		if (listaArchivosGrid.getSelectionModel().getCount()>0){
	       			var id = listaArchivosGrid.getSelectionModel().getSelected().get('id');
	       			controlador.eliminarFichero(id, fn_eliminarFicheroOk);
				}
				else{
					Ext.Msg.alert('<s:message code="plugin.masivo.procesadoTareas.grid.botonValidar" text="**Validar" />','<s:message code="plugin.masivo.procesadoTareas.grid.botonValidar.novalor" text="**Debe seleccionar un valor de la lista" />');
				}				
	     	}
	});	
	
	var btnDescargaErrores = new Ext.Button({
	       text : '<s:message code="plugin.masivo.procesadoTareas.grid.botonDescargarErrores" text="**Descargar errores" />'
	       ,iconCls:'icon_procedimiento'
	       ,disabled:true
	       ,handler:function(){
	       		if (listaArchivosGrid.getSelectionModel().getCount()>0){
	       			var id = listaArchivosGrid.getSelectionModel().getSelected().get('id');
    				var params = {idProceso : id};
    				var flow='/pfs/msvprocesadotareasarchivo/descargarFicheroErrores';
					app.openBrowserWindow(flow,params);
				}
				else{
					Ext.Msg.alert('<s:message code="plugin.masivo.procesadoTareas.grid.botonValidar" text="**Validar" />','<s:message code="plugin.masivo.procesadoTareas.grid.botonValidar.novalor" text="**Debe seleccionar un valor de la lista" />');
				}			
	     	}
	});	
	
	var btnRecargar = new Ext.Button({
	       text : '<s:message code="plugin.masivo.procesadoTareas.recargarGrid" text="**Recargar Lista" />'
	       ,iconCls:'icon_refresh'
	       ,disabled:false
	       ,handler:function(){
	       		
	       		recargarGrid();
	       }
	});		
	
	var listaArchivosGrid = app.crearGrid(listaArchivosStore, listaArchivosCM, {
		title : '<s:message code="plugin.masivo.procesadoTareas.gridArchivos.titulo" text="**Lista de archivos en procesamiento" />'
		,height: 405
		,collapsible:true
		,autoWidth: true
		,style:'padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,plugins: [filters]
		<%--,bbar:[btnValidar, btnLiberar, btnEliminar, btnDescargaErrores, '&nbsp;&nbsp;&nbsp;', btnRecargar] --%>
		,bbar: new Ext.PagingToolbar({
            store: listaArchivosStore,
            pageSize: 25,
            plugins: [filters],
            items: ['&nbsp;&nbsp;&nbsp;', btnValidar, btnLiberar, btnEliminar, btnDescargaErrores]
        })
	});
	
	listaArchivosGrid.on('rowclick', function(grid, rowIndex, e) {
		actualizarBotones();
	});
	
    var operacionPanel = new Ext.FormPanel({
        autoHeight:'false'
        ,style:'padding-right:10px;padding-bottom:10px'
        ,title:'Operaciones y Plantillas'
        ,border:true
        ,bodyStyle:'padding:10px'
        ,autoWidth: true
        ,collapsible:true
        ,defaults : {} ,    
    items: [DatosFieldSet]
    });
    	
	var mainPanel =  new Ext.Panel({
		header: false
		,title:'<s:message code="plugin.analisisAsunto.titulo" text="**Analisis"/>'
		,autoHeight:true
		,style:'padding-bottom: 15px;'
		,bodyStyle:'padding:10px' 
		,items:[
				operacionPanel, listaArchivosGrid
			]
	});	

	page.add(mainPanel);	

var upload;
var win;
var creaVentanaUpload = function(){

	
	    upload = new Ext.FormPanel({
		        fileUpload: true
		        ,height: 55
		        ,autoWidth: true
		        ,bodyStyle: 'padding: 10px 10px 0 10px;'
		        ,defaults: {
		            allowBlank: false
		            ,msgTarget: 'side'
					,height:45
		        }
		        ,items: [
		        		{
						xtype:'hidden'
						,name:'idProceso'
						,hiddenName:'idProceso'
						}
						,{
						xtype:'hidden'
						,name:'idTipoOperacion'
						,hiddenName:'idTipoOperacion'
						}
		        		,{
			            xtype: 'fileuploadfield'
			            ,emptyText: '<s:message code="fichero.upload.fileLabel.error" text="**Debe seleccionar un fichero" />'
			            ,fieldLabel: '<s:message code="fichero.upload.fileLabel" text="**Fichero" />'
			            ,name: 'path'
			            ,path:'root'
			            ,buttonText: ''
			            ,buttonCfg: {
			                iconCls: 'icon_mas'
			            }
			            ,bodyStyle: 'width:50px;'
			            ,listeners: {
				            'fileselected': function(fb, v){
				            	var node = Ext.DomQuery.selectNode('input[id='+fb.id+']');
					        	node.value = v.replace("C:\\fakepath\\","");
				            }
			            }
		        }]
		        ,buttons: [{
		            text: 'Subir',
		            handler: function(){
		            if(upload.getForm().isValid()){
		            controlador.nuevoProceso(comboTiposOperacion.getValue(),upload.getForm(), fn_nuevoProcesoOk);
		            win.hide();
		            }
		            }
		        },{
		            text: 'Cancelar',
		            handler: function(){
		                win.hide();
		            }
		        }]
		    });

		win =new Ext.Window({
		         width:400
				,minWidth:400
		        ,height:125
				,minHeight:125
		        ,layout:'fit'
		        ,border:false
		        ,closable:true
		        ,title:'<s:message code="adjuntos.nuevo" text="**Agregar fichero" />'
				,iconCls:'icon-upload'
				,items:[upload]
				,modal : true
		});
}
		
var fn_nuevoProcesoOk = function(r){
	var idProceso = r.resultadoNuevoProceso.idProceso;
	var idTipoOperacion = r.resultadoNuevoProceso.idTipoOperacion;
	//alert(idProceso + "/" + idTipoOperacion);
	recargarGrid();
	controlador.uploadExcelAjax(idTipoOperacion, idProceso, upload, fn_subirExcelOk, fn_subirExcelError);
	//controlador.uploadFicheroAjax(upload, fn_subirExcelOk, fn_subirExcelError);
	
}

var fn_subirExcelOk = function(r){
	recargarGrid();
	//var id = r.resultadoCambioEstado.idProceso;
	win.hide();
	//alert("id:" + id);
	
}

var fn_subirExcelError = function(r){
	Ext.Msg.alert('Error al subir el fichero', 'El fichero no se ha podido subir para su procesado.');
	recargarGrid();
}

var fn_validaFicheroOk = function(r){
	recargarGrid();
	//var id = r.resultadoCambioEstado.idProceso;
	//alert("fn_validaFicheroOk. id:" + id);	
}

var fn_liberarFicheroOk = function(r){
	recargarGrid();
	//var id = r.resultadoIdProceso.idProceso;
	//alert("fn_liberarFicheroOk. id:" + id);	
}

var fn_eliminarFicheroOk = function(r){
	recargarGrid();
	//var id = r.resultadoIdProceso.idProceso;
	//alert("fn_eliminarFicheroOk. id:" + id);
}



</fwk:page>