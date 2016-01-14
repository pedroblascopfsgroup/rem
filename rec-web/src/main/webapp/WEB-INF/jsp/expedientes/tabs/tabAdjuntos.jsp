<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

(function(){

	var comprobarAdjuntosRecord = Ext.data.Record.create([
		 {name:'mensaje'}
	]);

	var comprobarAdjuntosStore = page.getStore({
	    eventName: 'resultado'
	    ,flow: 'generico/mensajeAdjuntos'
	    ,reader: new Ext.data.JsonReader({
	        root: 'data'
	      }, comprobarAdjuntosRecord)
	});		
	
	comprobarAdjuntosStore.on('load', function(store, data, options)
	{
		var rec = comprobarAdjuntosStore.getAt(0);
		if (rec != null)
		{
			var mensaje = rec.get('mensaje');
			if (mensaje != null && mensaje != '')
			{
				Ext.Msg.alert('Error', mensaje);	
			}
			else
			{
				fwk.toast('<s:message code="adjuntos.allfinished" text="**Todas las subidas completadas" />');			
			}
		}
	});	

	var idPersona;
	var idcontrato;

	var subirParams = {
		text : '<s:message code="app.agregar" text="**Agregar" />'
		,iconCls : 'icon_mas'
		,cls: 'x-btn-text-icon'
	};

	var subir = new Ext.Button(subirParams);
	var subirAdjuntoPersona = new Ext.Button(subirParams);
	subirAdjuntoPersona.disable();
	var subirAdjuntoContrato = new Ext.Button(subirParams);
	subirAdjuntoContrato.disable();


	var Adjunto = Ext.data.Record.create([
		{name : 'id'}                                                                                                                              
		,{name : 'nombre'}                                                                                                                              
		,{name : 'tipo'}                                                                                                                              
		,{name : 'length'}                                                                                                                              
		,{name : 'contentType'}
	]);

	var AdjuntosPersonas = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'idEntidad'}
		,{name : 'descripcionEntidad'}
		,{name : 'nombre'}
		,{name : 'tipo'}
		,{name : 'length'}
		,{name : 'contentType'}
	]);

	var AdjuntosContratos = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'idEntidad'}
		,{name : 'descripcionEntidad'}
		,{name : 'nombre'}
		,{name : 'tipo'}
		,{name : 'length'}
		,{name : 'contentType'}
	]);
	                                                                                                                              
	
	var store = page.getStore({
		flow : 'expedientes/consultaAdjuntosExpediente'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},Adjunto)
	});

	var storePersonas = page.getStore({
		flow : 'expedientes/consultaAdjuntosPersonasDelExpediente'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},AdjuntosPersonas)
	});

	var storeContratos = page.getStore({
		flow : 'expedientes/consultaAdjuntosContratosDelExpediente'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},AdjuntosContratos)
	});

	var recargarAdjuntos = function (){
		store.webflow({id:${expediente.id}});
		storePersonas.webflow({id:${expediente.id}});
		storeContratos.webflow({id:${expediente.id}});
	};

	recargarAdjuntos();

	var borrar = app.crearBotonBorrar({
		page : page
		,flow : 'expedientes/borrarAdjuntoExpedientes'
		,params : {expedienteId : ${expediente.id} }
		,success : function(){
			recargarAdjuntos();
		}
	});
	<sec:authorize ifAllGranted='BOTON_BORRAR_INVISIBLE'>borrar.setVisible(false);</sec:authorize>

	subir.on('click', function(){
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
		        },{xtype: 'hidden', name:'id', value:'${expediente.id}'}]
		        ,buttons: [{
		            text: 'Subir',
		            handler: function(){
		                if(upload.getForm().isValid()){
			                upload.getForm().submit({
			                    url:'/${appProperties.appName}/expedientes/uploadAdjuntoExpedientes.htm'
			                    ,waitMsg: '<s:message code="fichero.upload.subiendo" text="**Subiendo fichero..." />'
			                    ,success: function(upload, o){			                    
			                    	win.close();
			                        comprobarAdjuntosStore.webflow();						
									recargarAdjuntos();
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
	});


	subirAdjuntoPersona.on('click', function(){
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
		        },{xtype: 'hidden', name:'id', value:idPersona}]
		        ,buttons: [{
		            text: 'Subir',
		            handler: function(){
		                if(upload.getForm().isValid()){
			                upload.getForm().submit({
			                    url:'/${appProperties.appName}/clientes/uploadAdjuntosPersona.htm'
			                    ,waitMsg: '<s:message code="fichero.upload.subiendo" text="**Subiendo fichero..." />'
			                    ,success: function(upload, o){			                    
			                    	win.close();
			                        comprobarAdjuntosStore.webflow();						
									recargarAdjuntos();
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
	});

	subirAdjuntoContrato.on('click', function(){
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
		        },{xtype: 'hidden', name:'id', value:idContrato}]
		        ,buttons: [{
		            text: 'Subir',
		            handler: function(){
		                if(upload.getForm().isValid()){
			                upload.getForm().submit({
			                    url:'/${appProperties.appName}/clientes/uploadAdjuntosContrato.htm'
			                    ,waitMsg: '<s:message code="fichero.upload.subiendo" text="**Subiendo fichero..." />'
			                    ,success: function(upload, o){			                    
			                    	win.close();
			                        comprobarAdjuntosStore.webflow();						
									recargarAdjuntos();
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
	});
	
	
	

	var cm = new Ext.grid.ColumnModel([
		{header : '<s:message code="adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre'}
		,{header : '<s:message code="adjuntos.descripcion" text="**Descripcion" />', dataIndex : 'descripcion'}
		,{header : '<s:message code="adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer}
		,{header : '<s:message code="adjuntos.tipo" text="**Fecha" />', dataIndex : 'contentType'}
	]);

	var cmPersonas = new Ext.grid.ColumnModel([
		{header : '<s:message code="asuntos.adjuntos.cliente" text="**Cliente" />', dataIndex : 'descripcionEntidad', id:'colCodigoEntidad'}
		,{header : '<s:message code="asuntos.adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre'}
		,{header : '<s:message code="asuntos.adjuntos.descripcion" text="**Descripcion" />', dataIndex : 'descripcion'}
		,{header : '<s:message code="asuntos.adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer, align:'right'}
		,{header : '<s:message code="asuntos.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType'}
	]);

	var cmContratos = new Ext.grid.ColumnModel([
		{header : '<s:message code="asuntos.adjuntos.contrato" text="**Contrato" />', dataIndex : 'descripcionEntidad', id:'colCodigoEntidad'}
		,{header : '<s:message code="asuntos.adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre'}
		,{header : '<s:message code="asuntos.adjuntos.descripcion" text="**Descripcion" />', dataIndex : 'descripcion'}
		,{header : '<s:message code="asuntos.adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer, align:'right'}
		,{header : '<s:message code="asuntos.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType'}
	]);

	var gridHeight = 150;
	var grid = app.crearGrid(store, cm, {
		title : '<s:message code="adjuntos.grid" text="**Ficheros adjuntos" />'
		,bbar : [subir, borrar]
		,height: 180
		,autoWidth: true
		,collapsible:true
		,style:'padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	}); 
	grid.on('expand', function(){
				grid.setHeight(340);				
				gridPersonas.collapse(true);				
				gridContratos.collapse(true);
	});
	var gridPersonas = app.crearGrid(storePersonas, cmPersonas, {
		title : '<s:message code="asuntos.adjuntos.grid.personas" text="**Ficheros adjuntos Personas" />'
		,bbar : [subirAdjuntoPersona]
		,height: gridHeight
		,autoWidth: true
		,collapsible:true
		,style:'padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	gridPersonas.on('expand', function(){
				gridPersonas.setHeight(340);				
				grid.collapse(true);				
				gridContratos.collapse(true);
	});

	var gridContratos = app.crearGrid(storeContratos, cmContratos, {
		title : '<s:message code="asuntos.adjuntos.grid.contratos" text="**Ficheros adjuntos Contratos" />'
		,bbar : [subirAdjuntoContrato]
		,height: gridHeight
		,autoWidth: true
		,collapsible:true
		,style:'padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	gridContratos.on('expand', function(){
				gridContratos.setHeight(340);				
				grid.collapse(true);				
				gridPersonas.collapse(true);
	});
	
	grid.on('rowdblclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		window.open("/pfs/bajarAdjuntoExpediente.htm?&id="+rec.get('id'));
		
	});

	gridPersonas.on('rowdblclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		if(e.getTarget().className.indexOf('colCodigoEntidad') != -1) {
			var descripcionEntidad = rec.get('descripcionEntidad');
			var id = rec.get('idEntidad');
			if(id!=null && id!='') {
				// Abrimos el cliente
				app.abreCliente(id, descripcionEntidad);
			}
		} else {
			var id = rec.get('id');
			if(id!=null && id!='') {
				// Abrimos el adjunto
				window.open("/pfs/bajarAdjuntoPersona.htm?&id="+id);
			}
		}
	});

	gridPersonas.on('rowclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		var descripcionEntidad = rec.get('descripcionEntidad');
		if(descripcionEntidad==null || descripcionEntidad=='') {
			subirAdjuntoPersona.disable();
		} else {
			subirAdjuntoPersona.enable();
			idPersona = rec.get('idEntidad');
		}
	});

	gridContratos.on('rowdblclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		if(e.getTarget().className.indexOf('colCodigoEntidad') != -1) {
			var descripcionEntidad = rec.get('descripcionEntidad');
			var id = rec.get('idEntidad');
			<c:if test="${!usuario.usuarioExterno}">
				if(id!=null && id!='') {
					// Abrimos el contrato
					app.abreContrato(id, descripcionEntidad);
				}
			</c:if>
		} else {
			var id = rec.get('id');
			if(id!=null && id!='') {
				// Abrimos el adjunto
				window.open("/pfs/bajarAdjuntoContrato.htm?&id="+id);
			}
		}
	});

	gridContratos.on('rowclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		var descripcionEntidad = rec.get('descripcionEntidad');
		if(descripcionEntidad==null || descripcionEntidad=='') {
			subirAdjuntoContrato.disable();
		} else {
			subirAdjuntoContrato.enable();
			idContrato = rec.get('idEntidad');
		}
	});

	var panel = new Ext.Panel({
		title : '<s:message code="adjuntos.tabTitle" text="**Adjuntos" />'
		,autoHeight: true
		,items : [
				{items:[grid],border:false,style:'margin-top: 7px; margin-left:5px'}
				,{items:[gridPersonas],border:false,style:'margin-top: 7px; margin-left:5px'}
				,{items:[gridContratos],border:false,style:'margin-top: 7px; margin-left:5px'}
			]
		,nombreTab : 'adjuntos'
	});

	return panel;
})()
