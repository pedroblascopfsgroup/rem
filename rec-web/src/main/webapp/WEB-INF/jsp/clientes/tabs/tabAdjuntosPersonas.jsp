<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function() {

	var panel = new Ext.Panel({
		title : '<s:message code="adjuntos.tabTitle" text="**Adjuntos" />'
		,bodyStyle:'padding:10px'
		,height: 445
		,nombreTab : 'datosPanel'
	});

	panel.on('render', function(){

		var subir = new Ext.Button({
			text : '<s:message code="app.agregar" text="**Agregar" />'
			,iconCls : 'icon_mas'
			,cls: 'x-btn-text-icon'
		});
	
		var Adjunto = Ext.data.Record.create([
			{name : 'id'}
			,{name : 'nombre'}
			,{name : 'tipo'}
			,{name : 'length'}
			,{name : 'contentType'}
		]);
	
		var store = page.getStore({
			flow : 'clientes/consultaAdjuntosPersona'
			,reader : new Ext.data.JsonReader({
				root : 'adjuntos'
				,totalProperty : 'total'
			},Adjunto)
		});
	
		var recargarAdjuntos = function () {
			store.webflow({id:${persona.id}});
		};
	
		recargarAdjuntos();
	
		var borrar = app.crearBotonBorrar({
			page : page
			,flow : 'clientes/borrarAdjuntoPersona'
			,params : {personaId : ${persona.id} }
			,success : function(){
				recargarAdjuntos();
			}
		});
		
	
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
			        },{xtype: 'hidden', name:'id', value:'${persona.id}'}]
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
	
		var cm = new Ext.grid.ColumnModel([
			{header : '<s:message code="adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre'}
			,{header : '<s:message code="adjuntos.descripcion" text="**Descripcion" />', dataIndex : 'descripcion'}
			,{header : '<s:message code="adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer}
			,{header : '<s:message code="adjuntos.tipo" text="**Fecha" />', dataIndex : 'contentType'}
		]);
	
		var grid = app.crearGrid(store, cm, {
			title : '<s:message code="adjuntos.grid" text="**Ficheros adjuntos" />'
			,bbar : [subir, borrar]
			,height: 400
			,collapsible:true
			,width : 600
			,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		}); 
	
		grid.on('rowdblclick', function(grid, rowIndex, e) {
			var rec = grid.getStore().getAt(rowIndex);
			window.open("/pfs/bajarAdjuntoPersona.htm?id="+rec.get('id')+"&nombre="+rec.data.nombre+"&extension="+rec.data.contentType);
		});
	
		panel.add(grid);
	});
	
	return panel;
})()
