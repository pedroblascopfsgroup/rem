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
	var idExpediente;
	var idcontrato;

	var subirParams = {
		text : '<s:message code="app.agregar" text="**Agregar" />'
		,iconCls : 'icon_mas'
		,cls: 'x-btn-text-icon'
	};

	var subir = new Ext.Button(subirParams);
	var subirAdjuntoPersona = new Ext.Button(subirParams);
	subirAdjuntoPersona.disable();
	var subirAdjuntoExpediente = new Ext.Button(subirParams);
	subirAdjuntoExpediente.disable();
	var subirAdjuntoContrato = new Ext.Button(subirParams);
	subirAdjuntoContrato.disable();

	var Adjunto = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'nombre'}
		,{name : 'tipo'}
		,{name : 'length'}
		,{name : 'contentType'}
		,{name : 'descripcion'}
		,{name : 'fechaCrear'}
		,{name : 'puedeBorrar'}
	]);

	var AdjuntosPersonas = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'idEntidad'}
		,{name : 'descripcionEntidad'}
		,{name : 'nombre'}
		,{name : 'tipo'}
		,{name : 'length'}
		,{name : 'contentType'}
		,{name : 'descripcion'}
		,{name : 'fechaCrear'}
	]);

	var AdjuntosExpedientes = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'idEntidad'}
		,{name : 'descripcionEntidad'}
		,{name : 'nombre'}
		,{name : 'tipo'}
		,{name : 'length'}
		,{name : 'contentType'}
		,{name : 'descripcion'}
		,{name : 'fechaCrear'}
	]);

	var AdjuntosContratos = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'idEntidad'}
		,{name : 'descripcionEntidad'}
		,{name : 'nombre'}
		,{name : 'tipo'}
		,{name : 'length'}
		,{name : 'contentType'}
		,{name : 'descripcion'}
		,{name : 'fechaCrear'}
	]);

	var store = page.getStore({
		flow : 'plugin/mejoras/asuntos/plugin.mejoras.asuntos.consultaAdjuntos'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},Adjunto)
	});

	var storePersonas = page.getStore({
		flow : 'plugin/mejoras/asuntos/plugin.mejoras.asuntos.consultaAdjuntosPersonas'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},AdjuntosPersonas)
	});

	var storeExpedientes = page.getStore({
		flow : 'plugin/mejoras/asuntos/plugin.mejoras.asuntos.consultaAdjuntosExpedientes'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},AdjuntosExpedientes)
	});

	var storeContratos = page.getStore({
		flow : 'plugin/mejoras/asuntos/plugin.mejoras.asuntos.consultaAdjuntosContratos'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},AdjuntosContratos)
	});

	var recargarAdjuntos = function (){
		store.webflow({id:${asunto.id}});
		storePersonas.webflow({id:${asunto.id}});
		storeExpedientes.webflow({id:${asunto.id}});
		storeContratos.webflow({id:${asunto.id}});
	};

	recargarAdjuntos();

	var borrar = app.crearBotonBorrar({
		page : page
		,flow : 'asunto/borrarAdjunto'
		,params : {asuntoId : ${asunto.id} }
		,success : function(){
			recargarAdjuntos();
		}
	});
	<sec:authorize ifAllGranted='BOTON_BORRAR_INVISIBLE'>borrar.setVisible(false);</sec:authorize>
	
	borrar.disable();

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
		        },{xtype: 'hidden', name:'id', value:'${asunto.id}'}]
		        ,buttons: [{
		            text: 'Subir',
		            handler: function(){
		                if(upload.getForm().isValid()){
			                upload.getForm().submit({
			                    url:'/${appProperties.appName}/asuntos/uploadAdjuntoAsuntos.htm'
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

	subirAdjuntoExpediente.on('click', function(){
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
		        },{xtype: 'hidden', name:'id', value:idExpediente}]
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
		{header : '<s:message code="asuntos.adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre'}
		,{header : '<s:message code="asuntos.adjuntos.descripcion" text="**Descripcion" />', dataIndex : 'descripcion'}
		,{header : '<s:message code="asuntos.adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer, align:'right'}
		,{header : '<s:message code="asuntos.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType'}
		,{header : '<s:message code="plugin.mejoras.asuntos.adjuntos.fechaSubida" text="**Fecha de subida" />', dataIndex : 'fechaCrear'}
	]);

	var cmPersonas = new Ext.grid.ColumnModel([
		{header : '<s:message code="asuntos.adjuntos.cliente" text="**Cliente" />', dataIndex : 'descripcionEntidad', id:'colCodigoEntidad'}
		,{header : '<s:message code="asuntos.adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre'}
		,{header : '<s:message code="asuntos.adjuntos.descripcion" text="**Descripcion" />', dataIndex : 'descripcion'}
		,{header : '<s:message code="asuntos.adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer, align:'right'}
		,{header : '<s:message code="asuntos.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType'}
		,{header : '<s:message code="plugin.mejoras.asuntos.adjuntos.fechaSubida" text="**Fecha de subida" />', dataIndex : 'fechaCrear'}
		
	]);

	var cmExpedientes = new Ext.grid.ColumnModel([
		{header : '<s:message code="asuntos.adjuntos.expediente" text="**Expediente" />', dataIndex : 'descripcionEntidad', id:'colCodigoEntidad'}
		,{header : '<s:message code="asuntos.adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre'}
		,{header : '<s:message code="asuntos.adjuntos.descripcion" text="**Descripcion" />', dataIndex : 'descripcion'}
		,{header : '<s:message code="asuntos.adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer, align:'right'}
		,{header : '<s:message code="asuntos.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType'}
		,{header : '<s:message code="plugin.mejoras.asuntos.adjuntos.fechaSubida" text="**Fecha de subida" />', dataIndex : 'fechaCrear'}
		
	]);

	var cmContratos = new Ext.grid.ColumnModel([
		{header : '<s:message code="asuntos.adjuntos.contrato" text="**Contrato" />', dataIndex : 'descripcionEntidad', id:'colCodigoEntidad'}
		,{header : '<s:message code="asuntos.adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre'}
		,{header : '<s:message code="asuntos.adjuntos.descripcion" text="**Descripcion" />', dataIndex : 'descripcion'}
		,{header : '<s:message code="asuntos.adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer, align:'right'}
		,{header : '<s:message code="asuntos.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType'}
		,{header : '<s:message code="plugin.mejoras.asuntos.adjuntos.fechaSubida" text="**Fecha de subida" />', dataIndex : 'fechaCrear'}
		
	]);
	
	var editarDescripcionAdjuntoAsunto = new  Ext.Button({
		text:'<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcion" text="**Editar descripcion"/>'
		,iconCls : 'icon_edit'
		,handler : function() {
			if (grid.getSelectionModel().getCount()>0){
			if (grid.getSelectionModel().getSelected().get('id')!= ''){
    			var idAsunto = grid.getSelectionModel().getSelected().get('id');
    			var parametros = {
								idAsunto : idAsunto
					};
    			var w= app.openWindow({
                                         flow: 'plugin/mejoras/asuntos/plugin.mejoras.asuntos.editarDescripAdjAsunto'
                                         ,closable: true
                                         ,width : 700
                                         ,title : '<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcionAsunto" text="**Editar descripci�n del adjunto del asunto" />'
                                         ,params: parametros
                        });
           	 		w.on(app.event.DONE, function(){
								w.close();
								recargarAdjuntos() ;
								
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
			
			}else{
				Ext.Msg.alert('<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcionAsunto" text="**Editar descripci�n del adjunto del asunto" />','<s:message code="plugin.mejoras.asunto.adjuntos.noValor" text="**Debe seleccionar un valor de la lista" />');
			}
		}	
		}
	});
	
	editarDescripcionAdjuntoAsunto.disable();

	var gridHeight = 150;
	var grid = app.crearGrid(store, cm, {
		title : '<s:message code="asuntos.adjuntos.grid" text="**Ficheros adjuntos" />'
		,bbar : [<sec:authorize ifAnyGranted="ROLE_PUEDE_VER_BOTONES_ASUNTO_TAB_ADJUNTO">subir, borrar,editarDescripcionAdjuntoAsunto</sec:authorize>]
		,height: 180
		,collapsible:true
		,autoWidth: true
		,style:'padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	grid.on('expand', function(){
				grid.setHeight(340);				
				gridPersonas.collapse(true);				
				gridExpedientes.collapse(true);
				gridContratos.collapse(true);
			});
			
	var editarDescripcionAdjuntoPersona = new  Ext.Button({
		text:'<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcion" text="**Editar descripcion"/>'
		,iconCls : 'icon_edit'
		,handler : function() {
			if (gridPersonas.getSelectionModel().getCount()>0){
			if (gridPersonas.getSelectionModel().getSelected().get('id')!= ''){
    			var idPersona = gridPersonas.getSelectionModel().getSelected().get('id');
    			var parametros = {
								idPersona : idPersona
					};
    			var w= app.openWindow({
                                         flow: 'plugin/mejoras/asuntos/plugin.mejoras.asuntos.editarDescripAdjPersona'
                                         ,closable: true
                                         ,width : 700
                                         ,title : '<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcionPersona" text="**Editar descripci�n del adjunto de la persona" />'
                                         ,params: parametros
                        });
           	 		w.on(app.event.DONE, function(){
								w.close();
								recargarAdjuntos() ;
								
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
			
			}else{
				Ext.Msg.alert('<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcionPersona" text="**Editar descripci�n del adjunto del expediente" />','<s:message code="plugin.mejoras.asunto.adjuntos.noValor" text="**Debe seleccionar un valor de la lista" />');
			}
		}	
		}
	});
	
	editarDescripcionAdjuntoPersona.disable();
	
	var gridPersonas = app.crearGrid(storePersonas, cmPersonas, {
		title : '<s:message code="asuntos.adjuntos.grid.personas" text="**Ficheros adjuntos Personas" />'
		,bbar : [<sec:authorize ifAnyGranted="ROLE_PUEDE_VER_BOTONES_ASUNTO_TAB_ADJUNTO_PERSONAS">subirAdjuntoPersona,editarDescripcionAdjuntoPersona</sec:authorize>]
		,height: gridHeight
		,autoWidth: true
		,collapsible:true
		,style:'padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	gridPersonas.on('expand', function(){
				gridPersonas.setHeight(340);				
				gridExpedientes.collapse(true);
				gridContratos.collapse(true);
				grid.collapse(true);
			});


	var editarDescripcionAdjuntoExpediente = new  Ext.Button({
		text:'<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcion" text="**Editar descripcion"/>'
		,iconCls : 'icon_edit'
		,handler : function() {
			if (gridExpedientes.getSelectionModel().getCount()>0){
				if (gridExpedientes.getSelectionModel().getSelected().get('id')!=''){
    			var idAdjunto = gridExpedientes.getSelectionModel().getSelected().get('id');
    			var parametros = {
								idAdjunto : idAdjunto
					};
    			var w= app.openWindow({
                                         flow: 'plugin/mejoras/asuntos/plugin.mejoras.asuntos.editarDescripAdjExpediente'
                                         ,closable: true
                                         ,width : 700
                                         ,title : '<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcionExpediente" text="**Editar descripci�n del adjunto del expediente" />'
                                         ,params: parametros
                        });
           	 		w.on(app.event.DONE, function(){
								w.close();
								recargarAdjuntos() ;
								
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
			
			}else{
				Ext.Msg.alert('<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcionExpediente" text="**Editar descripci�n del adjunto del expediente" />','<s:message code="plugin.mejoras.asunto.adjuntos.noValor" text="**Debe seleccionar un valor de la lista" />');
			}
		}
		}	
		
	});
	editarDescripcionAdjuntoExpediente.disable();
	
	var gridExpedientes = app.crearGrid(storeExpedientes, cmExpedientes, {
		title : '<s:message code="asuntos.adjuntos.grid.expediente" text="**Ficheros adjuntos del Expediente" />'
		,bbar : [<sec:authorize ifAnyGranted="ROLE_PUEDE_VER_BOTONES_ASUNTO_TAB_ADJUNTO_EXPE">subirAdjuntoExpediente,editarDescripcionAdjuntoExpediente</sec:authorize>]
		,height: gridHeight
		,autoWidth: true
		,collapsible:true
		,style:'padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	gridExpedientes.on('expand', function(){
				gridExpedientes.setHeight(340);				
				gridPersonas.collapse(true);
				gridContratos.collapse(true);
				grid.collapse(true);
			});


	var editarDescripcionAdjuntoContrato = new  Ext.Button({
		text:'<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcion" text="**Editar descripcion"/>'
		,iconCls : 'icon_edit'
		,handler : function() {
			if (gridContratos.getSelectionModel().getCount()>0){
			if (gridContratos.getSelectionModel().getSelected().get('id')!= ''){
    			var idContrato = gridContratos.getSelectionModel().getSelected().get('id');
    			var parametros = {
								idContrato : idContrato
					};
    			var w= app.openWindow({
                                         flow: 'plugin/mejoras/asuntos/plugin.mejoras.asuntos.editarDescripAdjContrato'
                                         ,closable: true
                                         ,width : 700
                                         ,title : '<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcionContrato" text="**Editar descripci�n del adjunto del contrato" />'
                                         ,params: parametros
                        });
           	 		w.on(app.event.DONE, function(){
								w.close();
								recargarAdjuntos() ;
								
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
			
			}else{
				Ext.Msg.alert('<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcionContrato" text="**Editar descripci�n del adjunto del expediente" />','<s:message code="plugin.mejoras.asunto.adjuntos.noValor" text="**Debe seleccionar un valor de la lista" />');
			}
		}	
		}
	});
	
	editarDescripcionAdjuntoContrato.disable();
	var gridContratos = app.crearGrid(storeContratos, cmContratos, {
		title : '<s:message code="asuntos.adjuntos.grid.contratos" text="**Ficheros adjuntos Contratos" />'
		,bbar : [<sec:authorize ifAnyGranted="ROLE_PUEDE_VER_BOTONES_ASUNTO_TAB_ADJUNTO_CONTRATO">subirAdjuntoContrato,editarDescripcionAdjuntoContrato</sec:authorize>]
		,height: gridHeight
		,autoWidth: true
		,collapsible:true
		,style:'padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	gridContratos.on('expand', function(){
				gridContratos.setHeight(340);				
				gridPersonas.collapse(true);
				gridExpedientes.collapse(true);
				grid.collapse(true);
			});

	grid.on('rowdblclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		window.open("/pfs/bajarAdjuntoAsunto.htm?asuntoId=${asunto.id}&id="+rec.get('id')+"&nombre="+rec.data.nombre+"&extension="+rec.data.contentType);
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
				window.open("/pfs/bajarAdjuntoPersona.htm?&id="+id+"&nombre="+rec.data.nombre+"&extension="+rec.data.contentType);
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
		var id = rec.get('id');
		if(id ==null || id ==''){
			editarDescripcionAdjuntoPersona.disable();
		}else{
			editarDescripcionAdjuntoPersona.enable();
		}
		
		
	});

	gridExpedientes.on('rowdblclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		if(e.getTarget().className.indexOf('colCodigoEntidad') != -1) {
			var descripcionEntidad = rec.get('descripcionEntidad');
			var id = rec.get('idEntidad');
			<c:if test="${!usuario.usuarioExterno}">
				if(id!=null && id!='') {
					// Abrimos el expediente
					app.abreExpediente(id, descripcionEntidad);
				}
			</c:if>
		} else {
			// Abrimos el adjunto
			var id = rec.get('id');
			if(id!=null && id!='') {
				window.open("/pfs/bajarAdjuntoExpediente.htm?&id="+id+"&nombre="+rec.data.nombre+"&extension="+rec.data.contentType);
			}
		}
	});

	grid.on('rowclick', function(grid, rowIndex,e){
		var rec = grid.getStore().getAt(rowIndex);
		var id = rec.get('id');
		var puedeBorrar = rec.get('puedeBorrar');
		if(id==null || id=='') {
			editarDescripcionAdjuntoAsunto.disable();
			
		} else {
			editarDescripcionAdjuntoAsunto.enable();
		}
		if (puedeBorrar){
			borrar.enable();
		}else {
			borrar.disable();
		}
	});
	
	gridExpedientes.on('rowclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		var descripcionEntidad = rec.get('descripcionEntidad');
		var id = rec.get('id');
		if(descripcionEntidad==null || descripcionEntidad=='') {
			subirAdjuntoExpediente.disable();
			
		} else {
			subirAdjuntoExpediente.enable();
			idExpediente = rec.get('idEntidad');
		}
		if(id==null || id=='') {
			editarDescripcionAdjuntoExpediente.disable();
		}else{
			editarDescripcionAdjuntoExpediente.enable();
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
				window.open("/pfs/bajarAdjuntoContrato.htm?&id="+id+"&nombre="+rec.data.nombre+"&extension="+rec.data.contentType);
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
		var id = rec.get('id');
		if(id==null || id=='') {
			editarDescripcionAdjuntoContrato.disable();
		}else{
			editarDescripcionAdjuntoContrato.enable();
		}
		
	});

	var panel = new Ext.Panel({
		title: '<s:message code="asuntos.adjuntos.tabTitle" text="**Adjuntos" />'
		,autoHeight: true
		,items : [
				{items:[grid],border:false,style:'margin-top: 7px; margin-left:5px'}
				,{items:[gridExpedientes],border:false,style:'margin-top: 7px; margin-left:5px'}
				,{items:[gridPersonas],border:false,style:'margin-top: 7px; margin-left:5px'}
				,{items:[gridContratos],border:false,style:'margin-top: 7px; margin-left:5px'}
			]
		,nombreTab : 'tabAdjuntosAsunto'			
	});

	return panel;
})()
