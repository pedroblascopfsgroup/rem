<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>


/*
 * Grid de Métricas por defecto
 */

var codTipoPersona = null;				// Variable que almacena el tipo de persona seleccionado
										// en el grid default
var metricaTipoPersonaIsSel = false;	// Si está a true significa que el row seleccionado del grid
										// de tipo de persona tiene métrica nueva
var metricaActTipoPersonaIsSel = false;	// Si está a true significa que el row seleccionado del grid
										// de tipo de persona tiene métrica activa
var codSegmento = null;					// Variable que almacena el segmento seleccionado en el grid
										// de segmentos
var metricaSegmentoIsSel = false;		// Si est a true significa que el row seleccionado del grid
										// de segmento tiene métrica nueva
var metricaActSegmentoIsSel = false;	// Si est a true significa que el row seleccionado del grid
										// de segmento tiene métrica activa


var metricaDefectoRecord = Ext.data.Record.create([
	 {name:'codTipoPer'}
    ,{name:'tipoPersona'}
    ,{name:'configVigente'}
    ,{name:'fechaConfigVigente'}
    ,{name:'configNueva'}
]);

var metricasDefectoStore = page.getStore({
    eventName: 'listado'
    ,flow: 'metricas/metricasDefectoData'
    ,reader: new Ext.data.JsonReader({
        root: 'data'
      }, metricaDefectoRecord)
});

var recargarMetricasDefault = function() {
	metricasDefectoStore.webflow();
};
recargarMetricasDefault();

var metricasDefectoCm = new Ext.grid.ColumnModel([
	 {dataIndex:'codTipoPer', hidden:true, fixed:true}
    ,{header: '<s:message code="metricas.grid.tipoPersona" text="**Tipo persona" />', width: 100, dataIndex:'tipoPersona'}
    ,{header: '<s:message code="metricas.grid.vigente" text="**Configuración vigente" />', width: 160,  dataIndex: 'configVigente'}
    ,{header: '<s:message code="metricas.grid.fecha" text="**Fecha conf. vigente" />', width: 80,  dataIndex: 'fechaConfigVigente'}
	,{header: '<s:message code="metricas.grid.nueva" text="**Nueva configuración" />', width: 200,  dataIndex: 'configNueva'}
]);


var btnAgregarMetricaDefecto = new Ext.Button({
    text:'<s:message code="metricas.boton.agregar" text="**Añadir métrica" />'
    ,iconCls: 'icon_mas'
});
var btnBorrarMetricaDefecto = new Ext.Button({
    text:'<s:message code="metricas.boton.borrar" text="**Borrar métrica" />'
    ,iconCls: 'icon_menos'
});
var btnDescargarMetricaDefecto = new Ext.Button({
    text:'<s:message code="metricas.boton.descargar" text="**Descargar métrica" />'
    ,iconCls: 'icon_exportar_csv'
    ,handler: function() { }
});
var btnActivarMetricaDefecto = new Ext.Button({
    text:'<s:message code="metricas.boton.activar" text="**Activar métrica" />'
    ,iconCls: 'icon_ok'
    ,handler: function() { }
});

var metricasDefectoGrid = app.crearGrid(metricasDefectoStore, metricasDefectoCm, {
    title: '<s:message code="metricas.defecto" text="**Métricas por defecto" />'
    ,style: 'margin-bottom:10px;padding-right:10px'
    ,height: 130
    ,cls: 'cursor_pointer'
    ,bbar: [ btnAgregarMetricaDefecto,btnBorrarMetricaDefecto,btnDescargarMetricaDefecto,btnActivarMetricaDefecto ]
});

metricasDefectoGrid.on('rowclick', function(grid, rowIndex, e){
	var rec = grid.getStore().getAt(rowIndex);
	var codTipoPersonaRec = rec.get('codTipoPer');
	if(codTipoPersonaRec==null || codTipoPersonaRec=='') {
		codTipoPersona = null;
	} else {
		codTipoPersona = rec.get('codTipoPer');
		if(rec.get('configNueva')!=null && rec.get('configNueva')!='') {
			metricaTipoPersonaIsSel = true;
		} else {
			metricaTipoPersonaIsSel = false;
		}
	}
	if(rec.get('configVigente')==null || rec.get('configVigente')=='') {
		metricaActTipoPersonaIsSel = false;
	} else {
		metricaActTipoPersonaIsSel = true;
	}
	labelTipoPersona.setValue(rec.get('tipoPersona'));
	labelSegmento.setValue('<s:message code="metricas.todos" text="**Todos" />');
	// Se limpia la selección del grid segmento para no confundir lo que se está configurando
	metricasSegmentoGrid.getSelectionModel().clearSelections();
	metricaSegmentoIsSel = false;
	codSegmento = null;
});


// Eventos botones

btnAgregarMetricaDefecto.on('click', function() {
	if(codTipoPersona == null) {
		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',
                      '<s:message code="metricas.grid.tipoPersona.agregar.error" text="**Debe seleccionar un tipo de persona primero." />');
	} else {
		
			var upload = new Ext.FormPanel({
		        fileUpload: true
		        ,height: 55
		        ,autoWidth: true
		        ,bodyStyle: 'padding: 10px 10px 0 10px;'
		        ,defaults: {
		            allowBlank: false
		            ,msgTarget: 'side'
					,height:45
		        }
		        ,items: [{
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
		        },{xtype: 'hidden', name:'codTipoPer', value:codTipoPersona}]
		        ,buttons: [{
		            text: 'Subir',
		            handler: function(){
		                if(upload.getForm().isValid()){
			                upload.getForm().submit({
			                    url:'/${appProperties.appName}/metricas/uploadMetricaDefault.htm'
			                    ,waitMsg: '<s:message code="fichero.upload.subiendo" text="**Subiendo fichero..." />'
			                    ,success: function(upload, o){			                    
									win.close();
									recargarMetricasDefault();
									metricasDefectoGrid.getSelectionModel().clearSelections();
									labelTipoPersona.setValue('');
									labelSegmento.setValue('');
			                    }
			                });
		                }
		            }
		        },{
		            text: 'Cancelar',
		            handler: function(){
		                win.close();
		            }
		        }]
		    });		
		
		var win =new Ext.Window({
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
		win.show();
		codTipoPersona = null;
	}
});

btnActivarMetricaDefecto.on('click', function() {
	if(codTipoPersona == null || metricaTipoPersonaIsSel == false) {
		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',
                      '<s:message code="metricas.grid.seleccionar.error" text="**Debe seleccionar una métrica primero." />');
	} else {
		page.webflow({
			flow: 'metricas/activarMetrica'
			,params:{codigoTipoPersona:codTipoPersona}
			,success: function() {
				recargarMetricasDefault();
			}
		});
	}
});

btnBorrarMetricaDefecto.on('click', function() {
	if(codTipoPersona == null || metricaActTipoPersonaIsSel == false) {
		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',
                      '<s:message code="metricas.grid.borrarMetDefecto.error" text="**Debe seleccionar una persona con métrica activa primero." />');
	} else {
		page.webflow({
			flow: 'metricas/borrarMetrica'
			,params:{codigoTipoPersona:codTipoPersona}
			,success: function() {
				recargarMetricasDefault();
			}
		});
	}
});


btnDescargarMetricaDefecto.on('click', function() {
	if(codTipoPersona == null) {
		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',
                      '<s:message code="metricas.grid.seleccionar.error" text="**Debe seleccionar una métrica primero." />');
	} else if(metricaActTipoPersonaIsSel == false) {
		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',
                      '<s:message code="metricas.error.noArchivo" text="**No hay archivo para descargar." />');
	} else {
		window.open("/pfs/descargarMetrica.htm?&codigoTipoPersona="+codTipoPersona);
	}
});



/*
 * Grid de Métricas por segmento
 */

var metricaSegmentoRecord = Ext.data.Record.create([
	 {name:'codSegmento'}
    ,{name:'segmento'}
    ,{name:'configVigente'}
    ,{name:'fechaConfigVigente'}
    ,{name:'configNueva'}
]);

var metricasSegmentoStore = page.getStore({
    eventName: 'listado'
    ,flow: 'metricas/metricasSegmentoData'
    ,reader: new Ext.data.JsonReader({
        root: 'data'
      }, metricaSegmentoRecord)
});

metricasSegmentoStore.webflow();


var metricasSegmentoCm = new Ext.grid.ColumnModel([
	 {dataIndex:'codSegmento', hidden:true, fixed:true}
    ,{header: '<s:message code="metricas.grid.segmento" text="**Segmento" />', width: 100, dataIndex:'segmento'}
    ,{header: '<s:message code="metricas.grid.vigente" text="**Configuración vigente" />', width: 160,  dataIndex: 'configVigente'}
    ,{header: '<s:message code="metricas.grid.fecha" text="**Fecha conf. vigente" />', width: 80,  dataIndex: 'fechaConfigVigente'}
	,{header: '<s:message code="metricas.grid.nueva" text="**Nueva configuración" />', width: 200,  dataIndex: 'configNueva'}
]);


var btnAgregarMetricaSegmento = new Ext.Button({
    text:'<s:message code="metricas.boton.agregar" text="**Añadir métrica" />'
    ,iconCls: 'icon_mas'
    ,handler: function() { }
});
var btnBorrarMetricaSegmento = new Ext.Button({
    text:'<s:message code="metricas.boton.borrar" text="**Borrar métrica" />'
    ,iconCls: 'icon_menos'
    ,handler: function() { }
});
var btnDescargarMetricaSegmento = new Ext.Button({
    text:'<s:message code="metricas.boton.descargar" text="**Descargar métrica" />'
    ,iconCls: 'icon_exportar_csv'
    ,handler: function() { }
});
var btnActivarMetricaSegmento = new Ext.Button({
    text:'<s:message code="metricas.boton.activar" text="**Activar métrica" />'
    ,iconCls: 'icon_ok'
    ,handler: function() { }
});

var metricasSegmentoGrid = app.crearGrid(metricasSegmentoStore, metricasSegmentoCm, {
    title: '<s:message code="metrica.segmento" text="**Métricas por segmento" />'
    ,style: 'margin-bottom:10px;padding-right:10px'
    ,height: 200
    ,cls: 'cursor_pointer'
    ,bbar: [ btnAgregarMetricaSegmento,btnBorrarMetricaSegmento,btnDescargarMetricaSegmento,btnActivarMetricaSegmento ]
});


metricasSegmentoGrid.on('rowclick', function(grid, rowIndex, e){
	var rec = grid.getStore().getAt(rowIndex);
	var codSegmentoRec = rec.get('codSegmento');
	if(codSegmentoRec==null || codSegmentoRec=='') {
		codSegmento = null;
	} else {
		codSegmento = rec.get('codSegmento');
		if(rec.get('configNueva') != null && rec.get('configNueva')!='') {
			metricaSegmentoIsSel = true;
		} else {
			metricaSegmentoIsSel = false;
		}
	}
	if(rec.get('configVigente')==null || rec.get('configVigente')=='') {
		metricaActSegmentoIsSel = false;
	} else {
		metricaActSegmentoIsSel = true;
	}
    labelTipoPersona.setValue('<s:message code="metricas.todos" text="**Todos" />');
	labelSegmento.setValue(rec.get('segmento'));
	// Se limpia la selección del grid default para no confundir lo que se está configurando
	metricasDefectoGrid.getSelectionModel().clearSelections();
	metricaTipoPersonaIsSel = false;
	codTipoPersona = null;
});


// Eventos botones

btnAgregarMetricaSegmento.on('click', function() {
	if(codSegmento == null) {
		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',
                      '<s:message code="metricas.grid.segmento.agregar.error" text="**Debe seleccionar un segmento primero." />');
	} else {
		var upload = new Ext.FormPanel({
		        fileUpload: true
		        ,height: 55
		        ,autoWidth: true
		        ,bodyStyle: 'padding: 10px 10px 0 10px;'
		        ,defaults: {
		            allowBlank: false
		            ,msgTarget: 'side'
					,height:45
		        }
		        ,items: [{
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
		        },{xtype: 'hidden', name:'codSegmento', value:codSegmento}]
		        ,buttons: [{
		            text: 'Subir',
		            handler: function(){
		                if(upload.getForm().isValid()){
			                upload.getForm().submit({
			                    url:'/${appProperties.appName}/metricas/uploadMetricaDefault.htm'
			                    ,waitMsg: '<s:message code="fichero.upload.subiendo" text="**Subiendo fichero..." />'
			                    ,success: function(upload, o){			                    
									win.close();
									metricasSegmentoStore.webflow();
									metricasSegmentoGrid.getSelectionModel().clearSelections();
									labelTipoPersona.setValue('');
									labelSegmento.setValue('');
			                    }
			                });
		                }
		            }
		        },{
		            text: 'Cancelar',
		            handler: function(){
		                win.close();
		            }
		        }]
		    });		    
	    
		var win =new Ext.Window({
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
		win.show();
		codSegmento = null;
	}
});

btnActivarMetricaSegmento.on('click', function() {
	if(codSegmento == null || metricaSegmentoIsSel == false) {
		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',
                      '<s:message code="metricas.grid.seleccionar.error" text="**Debe seleccionar una métrica primero." />');
	} else {
		page.webflow({
			flow: 'metricas/activarMetrica'
			,params:{codigoSegmento:codSegmento}
			,success: function() {
				metricasSegmentoStore.webflow();
			}
		});
	}
});

btnBorrarMetricaSegmento.on('click', function() {
	if(codSegmento == null || metricaActSegmentoIsSel == false) {
		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',
                      '<s:message code="metricas.grid.borrarMetSegmento.error" text="**Debe seleccionar un segmento con métrica activa primero." />');
	} else {
		page.webflow({
			flow: 'metricas/borrarMetrica'
			,params:{codigoSegmento:codSegmento}
			,success: function() {
				metricasSegmentoStore.webflow();
			}
		});
	}
});


btnDescargarMetricaSegmento.on('click', function() {
	if(codSegmento == null) {
		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',
                      '<s:message code="metricas.grid.seleccionar.error" text="**Debe seleccionar una métrica primero." />');
	} else if(metricaActSegmentoIsSel == false) {
		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',
                      '<s:message code="metricas.error.noArchivo" text="**No hay archivo para descargar." />');
	} else {
		window.open("/pfs/descargarMetrica.htm?&codigoSegmento="+codSegmento);
	}
});



/*
 * Panel con ambos grids
 */

var panelMetricasGrids = new Ext.Panel({
	autoHeight: true
	,autoWidth: true
	,bodyStyle: 'padding:5px;'
	//,layout: 'table'
	,layoutConfig: {columns:1}
	,border:false
	,defaults: {border: true, cellCls: 'vtop'}
	,items: [
			{items:[metricasDefectoGrid],border:false}
			,{items:[metricasSegmentoGrid],border:false, style:'margin-top:15px'}
		]
});
