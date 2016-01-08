<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>

<fwk:page>

Ext.override(Ext.form.ComboBox, {
    showLoadingText: function () {
        if (this.rendered && this.innerList != null) {
            this.innerList.update(this.loadingText ? '<div class="loading-indicator">' + this.loadingText + '</div>' : '');
            this.restrictHeight();
            this.selectedIndex = -1;
        }
    }
});

Ext.override(Ext.form.ComboBox, {
onViewClick : function(doFocus){
        var index = this.view.getSelectedIndexes()[0],
            s = this.store,
            r = s.getAt(index);
        if(r){
            this.onSelect(r, index);
        }else {
        	if (!busquedaActiva)
            	this.collapse();
        }
        if(doFocus !== false){
            this.el.focus();
        }
    }
});

    var controlador = new es.pfs.plugins.masivo.ControladorAsincrono();
    var factoriaFormularios = new es.pfs.plugins.masivo.FactoriaFormularios();
    
    var uploading = false;
    	
    var panelWidth=850;
    
    var tipoResolucionRecord = Ext.data.Record.create([
		 {name:'id'}
		,{name:'codigo'}
		,{name:'descripcion'}
		,{name:'accion'}
		
	]);

	var tipoResolucionStore = page.getStore({
	       flow: 'msvprocesadoresoluciones/getTiposDeResolucion'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'data'
	    }, tipoResolucionRecord)
	       
	});
	
    var obtenerCodigoPlaza = function(idAsunto){
		Ext.Ajax.request({
			url: '/pfs/linasunto/getCodigoPlaza.htm'
				,params: {idAsunto:idAsunto.idAsunto}
				,method: 'POST'
				,fn: funcionCodigoPlazaCallBack
				,success: function (result, request){
					var r = Ext.util.JSON.decode(result.responseText);
					request.fn(r);
				}
				 ,error : function (result, request){
					alert("error recuperar plaza");
					 }
		});
    }
    
    var funcionCodigoPlazaCallBack = function(r) {
		codigoPlaza = r.codigoPlaza;
	}
    
    var tplCombo =  '<tpl for=".">'
                + '<div class="x-combo-list-item ux-icon-combo-item tipo_accion_{accion}">'
                + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{descripcion}'
                + '</div></tpl>';
	                
    var comboTipoResolucionNew = new Ext.form.ComboBox({
    	name:'comboTipoResolucionNew'
    	,store:tipoResolucionStore
    	,displayField:'descripcion'
    	,valueField:'id'
    	,mode: 'local'
    	,triggerAction: 'all'
    	,editable:false
    	,tpl: tplCombo
    	,emptyText:'Seleccionar...'
   		,fieldLabel:'<s:message code="plugin.masivo.procesadoResoluciones.comboTipoResolucion" text="**Tipo de Resolución: " />'
		,width: 250
		,forceSelection: true
		,listeners: {
 	 		select: function(combo,  record,  index ) {
 	 		controlador.recargarAyuda(comboTipoResolucionNew.getValue(), fn_recargaAyudaOk);
    		datosResolucion.removeAll(true);
    		datosResolucion.doLayout();
    		
    		datosResolucion.add(factoriaFormularios.getFormItems(comboTipoResolucionNew.getValue(), idAsunto.getValue() , codigoProcedimiento.getValue(), codigoPlaza, idProcedimiento.getValue()));
			//resolucionPanel.getBottomToolbar().setDisabled(false);
			habilitaBotones(false);
    		datosResolucion.add({xtype:'hidden',name:'idFichero',value:''});
    		datosResolucion.setVisible(true);
    		datosResolucion.doLayout();
    		factoriaFormularios.updateStores();
			}  
    	} 
    });
    
    var contenidoAyuda=new Ext.form.TextField({
        name: 'contenidoAyuda'
        ,value: '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se deber&aacute; consignar la fecha en la que la Resoluci&oacute;n adquiere firmeza.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla se le abrirá una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>'
        ,hidden:true
    });
	var btnAyuda;
	var btnAdjuntar;
	var btnGuardar;
	var btnCancelar;
	
	var fn_CreaBotones = function(){
	    btnAyuda = new Ext.Button({
	           text : '<s:message code="plugin.masivo.procesadoResoluciones.btnAyuda" text="**Ayuda" />'
	           ,iconCls:'icon_ayuda'
	           ,disabled:false
	           ,handler : function() {
				var w = new Ext.Window({
					html: contenidoAyuda.value
					,closable: true
					,minWidth:600
					,width:400
					,height:200
					,minHeight:200
					,layout:'fit'
					,border:false
					,closable:true
					,bodyStyle: 'padding: 6px;'
					,title : '<s:message code="plugin.masivo.procesadoResoluciones.btnAyuda" text="**Ayuda" />'
					,iconCls:'icon-mas'
					,modal : true
				});
				w.on(app.event.DONE, function(){
					w.close();
				});
				w.on(app.event.CANCEL, function(){
					w.close(); 
				});
				w.show();
    		}
	    });
	    
	     btnAdjuntar = new Ext.Button({
	           text : '<s:message code="plugin.masivo.procesadoResoluciones.btnAdjuntar" text="**Adjuntar" />'
	           ,iconCls:'icon_editar_propuesta'
	           ,disabled:false
	    });    
	    
	    btnGuardar = new Ext.Button({
	           text : '<s:message code="plugin.masivo.procesadoResoluciones.btnGuardar" text="**Guardar y procesar" />'
	           ,iconCls:'icon_ok'
	           ,disabled:false
	    }); 
	    
	    btnCancelar = new Ext.Button({
	           text : '<s:message code="plugin.masivo.procesadoResoluciones.btnCancelar" text="**Cancelar" />'
	           ,iconCls:'icon_cancel'     
	           ,disabled:false
	    }); 
	     
	
	
		btnAdjuntar.on('click', function(){
			creaVentanaUpload();
			upload.getForm().reset();
			win.show();
		}); 	

		btnCancelar.on('click', function(){
			listaArchivosGrid.getSelectionModel().clearSelections();
			resolucionPanel.getForm().reset();
			asuntosComboStore.removeAll(true);
			tipoResolucionStore.removeAll();
			comboTipoResolucionNew.reset();
    		datosResolucion.removeAll(true);
    		datosResolucion.doLayout();
			datosResolucion.setVisible(false);
			//resolucionPanel.getBottomToolbar().setDisabled(true);
			habilitaBotones(true);
			habilitaBotonesPopUp(true, true);
		}); 
		
		btnGuardar.on('click', function(){
			var formulario = resolucionPanel.getForm();
			if (formulario.isValid()){
				var valores = resolucionPanel.getForm().getFieldValues();
				//var val2 = Ext.encode(valores);
				Ext.Ajax.request({
					url: '/pfs/msvprocesadoresoluciones/grabarYProcesar.htm'
					,params: valores
					,method: 'POST'
					
					,success: function (result, request){
					resolucionPanel.el.unmask();
					var r = Ext.util.JSON.decode(result.responseText);
					//resolucionPanel.getForm().reset();
					//datosResolucion.setVisible(false);
					btnCancelar.fireEvent('click',btnCancelar);
					recargarGrid();
					var id = r.resolucion.idResolucion;
					setTimeout(function(){procesarResolucion(id)}, 2000);
					//setTimeout('controlador.procesarResolucion('+id, fn_procesarResolucionOk)', 3000);
					//resolucionPanel.getForm().setValues(r.resolucion);
					 }
					 ,error : function (result, request){
					 	resolucionPanel.el.unmask();
						alert("error guardarYProcesar");
					}
				});
				resolucionPanel.el.mask('Guardando datos', 'x-mask-loading');
			}else{
				Ext.Msg.alert('Error', 'Debe rellenar los campos obligatorios.');
			}
		});
		
		var botones = {
        	items:[btnGuardar, btnAdjuntar, btnCancelar, btnAyuda]
        };
        
        return botones;		
	
	};
	

	var habilitaBotones = function(valor) {
		btnAyuda.setDisabled(valor);
		btnAdjuntar.setDisabled(valor);
		btnGuardar.setDisabled(valor);
		//btnCancelar.setDisabled(false);
	}
    
    var DatosFieldSet = new Ext.form.FieldSet({
        autoHeight:'false'
        ,style:'padding:2px'
         ,border:false
        ,layout : 'column'
        ,layoutConfig:{
            columns:2
        }
        ,width:750
        ,defaults : {layout:'form',border: false,bodyStyle:'padding:3px'} 
        ,items : [ 
                 {
                     columnWidth:.5, 
                     items:[ comboTipoResolucionNew ]
                 },{
					xtype:'hidden'
					,name:'idResolucion'
					,hiddenName:'idResolucion'
        		 }                      
        ]
    }); 
    
    var filtroPlaza=new Ext.form.TextField({
        name: 'plaza'
        ,allowBlank:true
        ,fieldLabel:'<s:message code="plugin.masivo.procesadoResoluciones.filtroPlaza" text="**Plaza" />'
        ,enableKeyEvents: true
        ,width : 220
        ,style : 'margin:0px'
        //,disabled : true
        ,readOnly:true
    });    
    
    var filtroJuzgado=new Ext.form.TextField({
         name: 'juzgado'
         ,allowBlank:true
        ,fieldLabel:'<s:message code="plugin.masivo.procesadoResoluciones.filtroJuzgado" text="**Juzgado" />'
        ,enableKeyEvents: true
        ,width : 390
        ,style : 'margin:0px'
        //,disabled : true
        ,readOnly:true
    });     
    
    var filtroAuto=new Ext.form.TextField({
        name: 'auto'
        ,allowBlank:true
        ,fieldLabel:'<s:message code="plugin.masivo.procesadoResoluciones.filtroAuto" text="**Auto" />'
        ,enableKeyEvents: true
        ,width : 110
        ,style : 'margin:0px'
        //,disabled : true
        ,readOnly:true
    }); 
    
    var txtPrincipal=new Ext.form.TextField({
        name: 'principal'
        ,allowBlank:false
        ,fieldLabel:'<s:message code="plugin.masivo.procesadoResoluciones.principal" text="**Principal" />'
        ,enableKeyEvents: true
        ,width : 110
        ,style : 'margin:0px'
        ,readOnly:true
    }); 

	    
    //Template para el combo de asuntos
    var asuntoTemplate = new Ext.XTemplate(
        '<tpl for="."><div class="search-item">',
            '<p><span class="cssEstadoProcedimiento cssEstadoProcedimiento{codEstadoPrc}">&nbsp;</span>{nombre}</p>',
            '<p align="right"><i>Plaza {plaza} - Juzgado {juzgado} - Auto {auto} - {tipoPrc} - {desEstadoPrc} - {principal}&euro;</i></p>',
        '</div></tpl>'
    );


	var newAsuntoTemplate = new Ext.XTemplate(
        '<tpl for="."><div class="search-item">',
            '<p><span class="cssEstadoProcedimiento cssEstadoProcedimiento{codEstadoPrc}">&nbsp;</span>{[this.highlightMatch(values.nombre)]}</p>',
            '<p align="right"><i>Plaza {[this.highlightMatch(values.plaza)]} - Juzgado {[this.highlightMatch(values.juzgado)]} - Auto {[this.highlightMatch(values.auto)]} - {tipoPrc} - {desEstadoPrc} - {principal}&euro;</i></p>',
        '</div></tpl>', {
                highlightMatch: function (input) {
                    var searchQuery = filtroAsunto.getValue();
                    var multiSearchQuery = searchQuery.replace(new RegExp('%', 'g'),'|');
                    var searchQueryRegex = new RegExp("(" + multiSearchQuery + ")", "gi"); // case-insensitive
                    var highlightedMatch = '<span class="searchMatch">$1</span>';
                    return input.replace(searchQueryRegex, highlightedMatch);
                }
            });
            
    //Store del combo de asuntos
    var busquedaActiva = false;
    var asuntosComboStore = page.getStore({
        flow:'msvprocesadoresoluciones/getAsuntosInstant'
        ,remoteSort:false
        ,autoLoad: false
        ,reader : new Ext.data.JsonReader({
            root:'data'
            ,fields:['id','idAsunto','idProcedimiento','principal','nombre','plaza','juzgado','auto','tipoPrc','codEstadoPrc','desEstadoPrc','idTarea']
        })
    });    
    
    asuntosComboStore.on('beforeload', function(store, options){
    	if (busquedaActiva){
    		return false;
    	} else{
    		busquedaActiva = true;
			//filtroAsunto.showLoadingText();
			//filtroAsunto.list.show();
    	}
		
    });
    
    asuntosComboStore.on('load', function(store, records, options){
    	//filtroAsunto.setDisabled(false);
    	//filtroAsunto.focus();
    	//return false;
    	busquedaActiva = false;
		
    });

    //Combo de asuntos
    var filtroAsunto = new Ext.form.ComboBox({
        name: 'asunto' 
        ,allowBlank:false
        ,store:asuntosComboStore
        ,width:680
        ,fieldLabel: '<s:message code="plugin.masivo.procesadoResoluciones.filtroAsunto" text="**Asunto"/>'
        ,tpl: newAsuntoTemplate  
        ,forceSelection:true
        ,style:'padding:0px;margin:0px;'
       // ,anchor: '100%'
        ,enableKeyEvents: true
        ,disableKeyFilter: false 
        ,autoSelect: false
        ,typeAhead: false
        ,typeAheadDelay: 1000
        ,hideTrigger:true     
        ,minChars: 3000
        ,queryDelay: 1500
        ,hidden:false
        ,maxLength:256 
        ,lastQuery: ''
        ,itemSelector: 'div.search-item'
        ,loadingText: '<s:message code="app.buscando" text="**Buscando..."/>'
        ,onSelect: function(record) {
        	filtroPlaza.setValue(record.data.plaza);
        	filtroJuzgado.setValue(record.data.juzgado);
        	filtroAuto.setValue(record.data.auto);
        	txtPrincipal.setValue(record.data.principal);
			idAsunto.setValue(record.data.idAsunto);
			idProcedimiento.setValue(record.data.idProcedimiento)
			codigoProcedimiento.setValue(record.data.tipoPrc);
			estadoProcedimiento.setValue(record.data.desEstadoPrc);
			idTarea.setValue(record.data.idTarea);
			idProcedimiento.setValue(record.data.idProcedimiento);
        	filtroAsunto.setValue(record.data.nombre);
			filtroAsunto.collapse();
			comboTipoResolucionNew.getStore().removeAll();
			comboTipoResolucionNew.reset();
			datosResolucion.setVisible(false);
			tipoResolucionStore.webflow({idTarea:record.data.idTarea, idProcedimiento:record.data.idProcedimiento});
			obtenerCodigoPlaza({idAsunto:record.data.idAsunto});
			tipoFicheroStore.webflow({idAsunto: record.data.idAsunto}); 
			habilitaBotonesPopUp(false, false);
			filtroAsunto.getStore().removeAll();
			filtroAsunto.lastQuery = filtroAsunto.lastSelectionText;
         }
    });
    
    filtroAsunto.on('specialkey', function(field, event){
    	
		if (event.getKey() == event.ENTER) {
			var query = this.getValue();
			if (query != null && query.length > 2 && query != this.lastQuery){
				this.doQuery(query,true);
			}
        }
        
    });
    
    filtroAsunto.on('beforequery', function(queryEvent){
    	//return false;
    });
    
    var btnAbreAsunto = new Ext.Button({
           text : '<s:message code="plugin.masivo.procesadoTareas.btnAbreAsunto" text="**Asunto" />'
           ,iconCls:'icon_asuntos'
           ,disabled:true
           ,handler : function() {
				app.abreAsunto(idAsunto.getValue(), filtroAsunto.getValue());
    		}
    });
    
    var btnAbrePrc = new Ext.Button({
           text : '<s:message code="plugin.masivo.procesadoTareas.btnAbreProcedimiento" text="**Procedimiento" />'
           ,iconCls:'icon_procedimiento'
           ,disabled:true
           ,handler : function() {
				app.abreProcedimientoTab(idProcedimiento.getValue(), filtroAsunto.getValue()+'-'+codigoProcedimiento.getValue(), 'tareas');
    		}
    });
   
    var codigoProcedimiento=new Ext.form.TextField({    
        name: 'tipoPrc'
        ,fieldLabel:'<s:message code="plugin.masivo.procesadoResoluciones.tipoProcedimiento" text="**Tipo" />'
        ,enableKeyEvents: true
        ,width : 220
        ,style : 'margin:0px'
        ,readOnly:true
    }); 
    
    var estadoProcedimiento=new Ext.form.TextField({    
        name: 'desEstadoPrc'
        ,fieldLabel:'<s:message code="plugin.masivo.procesadoResoluciones.estadoProcedimiento" text="**Estado" />'
        ,enableKeyEvents: true
        ,width : 150
        ,style : 'margin:0px'
        ,readOnly:true
    }); 
    
    var filtroPanel1 = new Ext.form.FieldSet({
    	autoHeight:'true'
        ,style:'padding:0px'
        ,border:false
        ,layout : 'table'
        ,layoutConfig:{
            columns:3
        }
        ,width:950
        ,defaults : {layout:'form',border: false,bodyStyle:'padding: 10px 5px 0px 10px'} 
        ,items : [
                 {	 labelWidth: 50,     
                     items:[ filtroPlaza ]
                 },
                  {  labelWidth: 50,
                     items:[ filtroJuzgado ]
                 },
                  {  labelWidth: 50,   
                     items:[ filtroAuto ]
                 },{  labelWidth: 50,   
                     items:[ codigoProcedimiento ]
                 },{  labelWidth: 50,   
                     items:[ estadoProcedimiento ]
                 },{  labelWidth: 50,   
                     items:[ txtPrincipal ]
                 }
            ]
    });      
    
    var idAsunto=new Ext.form.TextField({
        name: 'idAsunto'
        ,hidden:true
    });
    
     var idProcedimiento=new Ext.form.TextField({
        name: 'idProcedimiento'
        ,hidden:true
    });     

	
    
    var idTarea=new Ext.form.TextField({
        name: 'idTarea'
        ,hidden:true
    });    

    var idProcedimiento=new Ext.form.TextField({
        name: 'idProcedimiento'
        ,hidden:true
    });    

    var filtroPanel2 = new Ext.form.FieldSet({
    	autoHeight:'true'
        ,style:'padding:0px'
        ,border:false
        ,layout : 'table'
        ,layoutConfig:{
            columns:3
        }
        ,width:950
        ,defaults : {layout:'form',border: false,bodyStyle:'padding: 10px 5px 0px 10px'} 
        ,items : [
                 {     
                 	 labelWidth: 50,
                     items:[ filtroAsunto ]
                 }, 
                 {	labelWidht: 00,
                 	items: [ btnAbreAsunto]
                 }, 
                 {	labelWidht: 00,
                 	items: [ btnAbrePrc, idAsunto, idTarea, idProcedimiento]
                 }
         ]
    });      

    var filtrosPanel = new Ext.form.FieldSet({
        autoHeight:'true'
        ,style:'padding:0px'
        ,title:'Buscador del Asunto'
         ,border:true
        ,layout : 'table'
        ,layoutConfig:{
            columns:1
        }
        ,width:950
        ,defaults : {layout:'form',border: false,bodyStyle:'padding:0px'} 
        ,items : [
                 {     
                     items:[ filtroPanel2 ]
                 },
                 {     
                     items:[ filtroPanel1 ]
                 }
        ]
    });     

 		       
    var datosResolucion = new Ext.form.FieldSet({
        autoHeight:'false'
        ,style:'padding:2px'
        ,title:'Datos de la Resolución'
        ,hidden:true
        ,border:true
        ,layout : 'column'
        ,layoutConfig:{
            columns:3
        }
        ,width:950
        ,defaults : {layout:'form',border: false,bodyStyle:'padding:3px'} 
        ,items : [ 
        
        		{
        			width:400
        			//,items:dinamicElementsLeft
               	},
               	{
               		width:400
        			//,items:dinamicElementsRight
               	},
                 {
                     //items:[btnAyuda,btnAdjuntar,btnGuardar]
                 }
        ]
    });      
 
     var ListaArchivosRT = Ext.data.Record.create([
         {name: 'idResolucion'},
         {name: 'idTipoResolucion'},
         {name: 'tipoResolucion'},
         {name: 'asunto'},
         {name: 'fechaEjecucion',type: 'date',dateFormat: 'c'},
         {name: 'estado'},
         {name: 'usuario'},
         {name: 'auto'}
    ]);
    
    var listaArchivosStore = page.getStore({
      flow:'msvprocesadoresoluciones/mostarProcesos'
      ,limit:25
      ,remoteSort:true
      ,reader: new Ext.data.JsonReader({
        root : 'listaProcesosResolucion'
      } , ListaArchivosRT)
     });
     
    listaArchivosStore.webflow();
    
    var filters = new Ext.ux.grid.GridFilters({
        encode: false, // json encode the filter query
        local: true,   // defaults to false (remote filtering)
        filters: [{
            type: 'list',
            dataIndex: 'estado',
            options: ['Procesado', 'Error', 'En proceso']
        },
		{
            type: 'date',
            dataIndex: 'fechaEjecucion'
        },
		{
            type: 'string',
            dataIndex: 'usuario'
    	}]
    });
    
    var listaArchivosCM = new Ext.grid.ColumnModel([
    	{header : '<s:message code="plugin.masivo.procesadoResoluciones.gridResoluciones.idResolucion" text="**Id Resolución" />', dataIndex : 'idResolucion' ,sortable:true, hidden:true}
        ,{header : '<s:message code="plugin.masivo.procesadoResoluciones.gridResoluciones.tipoResolucion" text="**Tipo Resolucion" />', dataIndex : 'tipoResolucion' ,sortable:true}
        ,{header : '<s:message code="plugin.masivo.procesadoResoluciones.gridResoluciones.asunto"  text="**Asunto"/>', dataIndex : 'asunto' ,sortable:true, width: 200}
		,{header : '<s:message code="plugin.masivo.procesadoResoluciones.gridResoluciones.auto"  text="**Nº Auto"/>', dataIndex : 'auto' ,sortable:true, width: 75}        
        ,{header : '<s:message code="plugin.masivo.procesadoResoluciones.gridResoluciones.fechaCrear" text="**Fecha de Carga" />', dataIndex : 'fechaEjecucion' , width: 60, sortable:true, renderer:Ext.util.Format.dateRenderer('d/m/Y H:i:s')}
        ,{header : '<s:message code="plugin.masivo.procesadoResoluciones.gridResoluciones.estado" text="**Estado" />', dataIndex : 'estado' ,sortable:true , width: 60
			,renderer: function (value, meta, record) {
				switch(record.get('estado')){
				case 'En proceso':
					meta.css = 'lista_procesos_procesando';
					break;
				case 'Procesado':
					meta.css = 'lista_procesos_procesado';
					break;
				case 'Error':
					meta.css = 'lista_procesos_error';
					break;
				default:
					meta.css = null;
					break;
                }
            	return value;
        	}              
		}
        ,{header : '<s:message code="plugin.masivo.procesadoResoluciones.gridResoluciones.usuario"  text="**Usuario"/>', dataIndex : 'usuario' ,sortable:true, width: 80}		
        ]);
    
    var recargarGrid = function(){
        listaArchivosStore.webflow();
    }
    
    var btnRecargar = new Ext.Button({
           text : '<s:message code="plugin.masivo.procesadoTareas.recargarGrid" text="**Recargar Lista" />'
           ,iconCls:'icon_refresh'
           ,disabled:false
           ,handler:function(){
                   
                   recargarGrid();
           }
    });        
    
    var listaArchivosGrid = app.crearGrid(listaArchivosStore, listaArchivosCM, {
        title : '<s:message code="plugin.masivo.procesadoResoluciones.gridArchivos.titulo" text="**Estado de cargas" />'
        ,height: 220
        ,collapsible:true
        ,autoWidth: true
        ,autoHeight:false
        ,style:'padding-right:10px'
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,plugins: [filters]
        //,bbar:[ btnRecargar]
		,bbar: new Ext.PagingToolbar({
            store: listaArchivosStore,
            pageSize: 25,
            plugins: [filters]
        })
    });    

    listaArchivosGrid.on('rowclick', function(grid, rowIndex, e) {
		var idResolucion = grid.getStore().getAt(rowIndex).get('idResolucion');
		Ext.Ajax.request({
				url: '/pfs/msvprocesadoresoluciones/cargaResolucion.htm'
				,params: {idResolucion: idResolucion}
				,method: 'POST'
				,success: function (result, request){
					var r = Ext.util.JSON.decode(result.responseText);

					//if (r.resolucion.idTarea != undefined)
						tipoResolucionStore.webflow({idTarea:r.resolucion.idTarea, idProcedimiento:r.resolucion.idProcedimiento});
					
					idAsunto.setValue(r.resolucion.idAsunto);
					idProcedimiento.setValue(r.resolucion.idProcedimiento);
					//codigoProcedimiento.setValue(r.resolucion.tipoPrc);
					comboTipoResolucionNew.setValue(r.resolucion.comboTipoResolucionNew);
					comboTipoResolucionNew.fireEvent('select',comboTipoResolucionNew);
					
					resolucionPanel.getForm().reset();
					
					resolucionPanel.getForm().setValues(r.resolucion);

					var itemsFormPanel = resolucionPanel.getForm().items.items;
					for (i = 0; i < itemsFormPanel.length; i++) {
						if ((itemsFormPanel[i].isXType('combo')) && (itemsFormPanel[i].name.substring(0,2) == "d_")) {
							itemsFormPanel[i].fireEvent('select',itemsFormPanel[i]);
						}
					} 
					actualizaBotones();	
					habilitaBotonesPopUp(false, false);				

				}
				,error : function (result, request){
					alert("error guardarYProcesar");
				}
			});
    });
    
    tipoResolucionStore.on('load', function(combo, r, index){
    	//if (comboTipoResolucionNew.getValue() != "" && comboTipoResolucionNew.getValue() != null)	
    		comboTipoResolucionNew.setValue(comboTipoResolucionNew.getValue());
    });
    
    
    var resolucionPanel = new Ext.FormPanel({
        autoHeight:'false'
        ,monitorValid : true
        ,collapsible:true
        ,style:'padding-right:10px;padding-bottom:10px'
        ,title:'Datos de la Resolución'
        ,border:true
        ,bodyStyle:'padding:10px'
		,collapsible: true
        ,autoWidth: true
        ,defaults : {}
    	,items: [filtrosPanel, DatosFieldSet, datosResolucion]
    	,bbar: fn_CreaBotones()
		,listeners: {
  			'clientvalidation' : function(form, valid) {
				var resolucion = listaArchivosGrid.getSelectionModel().getSelected();
				if(resolucion){
					var estadoResolucion = resolucion.get('estado');
					if (estadoResolucion == 'Procesado'){
		    			if (btnAdjuntar && !btnAdjuntar.isDestroyed) {
		    				btnAdjuntar.setDisabled(true);
		    			}
		    			if (btnGuardar && !btnGuardar.isDestroyed) {
		    				btnGuardar.setDisabled(true);
		    			}
					}else{  				
		    			if (btnAdjuntar && !btnAdjuntar.isDestroyed) {
		    				btnAdjuntar.setDisabled(!valid);
		    			}
		    			if (btnGuardar && !btnGuardar.isDestroyed) {
		    				btnGuardar.setDisabled(!valid);
		    			}
    				}
    			}
    		}
  		}    
    });
    
    //resolucionPanel.getBottomToolbar().setDisabled(true);
    habilitaBotones(true);
    
    var mainPanel =  new Ext.Panel({
    	header: false
        ,title:'<s:message code="plugin.analisisAsunto.titulo" text="**Analisis"/>'
        ,autoHeight:true
		,style:'padding-bottom: 15px;'
		,bodyStyle:'padding:10px' 
        ,items:[
                resolucionPanel, listaArchivosGrid
            ]
    });    

    page.add(mainPanel);    
	var nodeValue = "";  
	var upload;
	var win;
	
var tipoFicheroRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
		
	]);
		
var tipoFicheroStore =	page.getStore({
	       flow: 'adjuntoasunto/getTiposDeFicheroAdjuntoAsunto'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, tipoFicheroRecord)
	       
	});	
	
var creaVentanaUpload = function(){	
	
	var comboTipoFichero = new Ext.form.ComboBox(
			{
				xtype:'combo'
				,name:'comboTipoFichero'
				<app:test id="tipoProcedimientoCombo" addComa="true" />
				,hiddenName:'comboTipoFichero'
				,store:tipoFicheroStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'remote'
				,emptyText:'----'
				,width:250
				,resizable:true
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="asuntos.adjuntos.tipoDocumento" text="**Tipo fichero" />'
			}
		);	
		
	var date_renderer = Ext.util.Format.dateRenderer('d/m/Y');
		var fechaCaducidad = new Ext.form.DateField({
    		xtype: 'datefield'
            ,fieldLabel: '<s:message code="fichero.upload.fechaCaducidad" text="**Fecha de caducidad" />'
            ,name: 'fechaCaducidad'
            ,submitFormat: 'd/m/Y'
 			,format : 'd/m/Y'
 			,renderer: date_renderer
 			,hideMode: 'offsets'
    	});		

    fechaCaducidad.setVisible(false);
    		
    upload = new Ext.FormPanel({
            fileUpload: true
            ,height: 55
            ,autoWidth: true
            ,bodyStyle: 'padding: 10px 10px 0 10px;'
            ,defaults: {
                allowBlank: false
                ,msgTarget: 'side'
                ,height:25
            }
            ,items: [
            	comboTipoFichero
		        ,{xtype: 'fileuploadfield'
		        	,emptyText: '<s:message code="fichero.upload.fileLabel.error" text="**Seleccione un fichero" />'
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
			        		nodeValue = node.value;
		            	}
		           	}
            	}
<sec:authorize ifAllGranted="PERSONALIZACION-BCC">			     
			,fechaCaducidad
</sec:authorize>
            ]
            ,buttons: [{
                text: 'Subir',
                handler: function(){
                uploading = true;
                updateBotonGuardar();
                var formulario = resolucionPanel.getForm();
                formulario.findField('file').setRawValue(nodeValue + '&nbsp;' + '<img src="/${appProperties.appName}/img/plugin/masivo/loading.gif"/>');
                controlador.uploadFicheroAjax(upload, fn_subirFicheroOk, fn_subirFicheroError);
                win.hide();
                }
            },{
                text: 'Cancelar',
                handler: function(){
                    win.hide();
                }
            }]
        });
        
<sec:authorize ifAllGranted="PERSONALIZACION-BCC">		    
		comboTipoFichero.on('select', function(){
		
			Ext.Ajax.request({
				url: page.resolveUrl('adjuntoasunto/isFechaCaducidadVisible')
				,params: {codigoFichero:this.value}
				,method: 'POST'
				,success: function (result, request)
				{
					var r = Ext.util.JSON.decode(result.responseText);
					
					if(r.fechaCaducidadVisible) {
						fechaCaducidad.setVisible(true);
						fechaCaducidad.allowBlank = false;
					}		
					else {
						fechaCaducidad.setVisible(false);
						fechaCaducidad.allowBlank = true;
					}									
				}
			});
		});
</sec:authorize>   
            
        win =new Ext.Window({
                 width:400
                ,minWidth:400
                ,height:180
                ,minHeight:180
                ,layout:'fit'
                ,border:false
                ,closable:true
                ,title:'<s:message code="adjuntos.nuevo" text="**Agregar fichero" />'
                ,iconCls:'icon-upload'
                ,items:[upload]
                ,modal : true
        });
}        

var fn_subirFicheroOk = function(r){
    //recargarGrid();
    uploading = false;
    updateBotonGuardar();
    var id = r.resultado;
    resolucionPanel.getForm().findField('idFichero').setValue(id);
    resolucionPanel.getForm().findField('file').setRawValue(nodeValue + '&nbsp;' + '<img src="/${appProperties.appName}/img/plugin/masivo/Ok-icon.png"/>');
    //win.hide();
    //recargarGrid();
    //alert("id:" + id);
    
}

var fn_subirFicheroError = function(r){
	uploading = false;
	updateBotonGuardar();
	resolucionPanel.getForm().findField('file').setRawValue(nodeValue + '&nbsp;' + '<img src="/${appProperties.appName}/img/plugin/masivo/Close-2-icon.png"/>');
	//Ext.Msg.alert('Error al subir el fichero', 'El fichero no se ha podido subir para su procesado.');
	//recargarGrid();
}

var procesarResolucion = function(id){
	controlador.procesarResolucion(id, fn_procesarResolucionOk);
}
var fn_procesarResolucionOk = function(r){
	var estado = r.resolucion.estado;
	var idResolucion = r.resolucion.idResolucion;
	var index = listaArchivosStore.find('idResolucion',idResolucion);
	var record = listaArchivosStore.getAt(index);
	record.set('estado', estado);
	record.commit();
	//recargarGrid();
}


var fn_recargaAyudaOk = function(r){
	var textoAyuda = r.resultadoDatosayuda.html;
	textoAyuda = textoAyuda.replace(/&gt;/g, ">");
	textoAyuda = textoAyuda.replace(/&lt;/g, "<");
	contenidoAyuda.setValue(textoAyuda);
	//alert(textoAyuda);
	//alert("fn_recargaAyudaOk. id:" + id);	
}

var actualizaBotones = function(){
	var resolucion = listaArchivosGrid.getSelectionModel().getSelected();
	if(resolucion){
		var estadoResolucion = resolucion.get('estado');
		if (estadoResolucion == 'Procesado'){
			btnAdjuntar.setDisabled(true);
			btnGuardar.setDisabled(true);
		}else{
			btnAdjuntar.setDisabled(false);
			btnGuardar.setDisabled(false);
		}
	}
	
}

var habilitaBotonesPopUp = function(asunto, proc) {
	btnAbreAsunto.setDisabled(asunto);
	btnAbrePrc.setDisabled(proc);
}

var updateBotonGuardar  = function(){
	if (uploading){
		btnGuardar.setDisabled(true);
	}else{
		btnGuardar.setDisabled(false);
	}
}


</fwk:page>