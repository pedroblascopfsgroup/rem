<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="utf-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){
	var panel = new Ext.Panel({
		title : '<s:message code="adjuntos.tabTitle" text="**Adjuntos" />'
		,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;margin-bottom:5px'
		,autoHeight : true
		,nombreTab : 'tabAdjuntosContratos'
	});
	
	panel.getContratoId = function(){
		return entidad.get("data").id;
	}

	var comprobarAdjuntosRecord = Ext.data.Record.create([
		{name:'mensaje'}
	]);

	var comprobarAdjuntosStore = page.getStore({
		eventName: 'resultado'
		,flow: 'generico/mensajeAdjuntos'
		,storeId: 'comprobarAdjuntosStore'
		,reader: new Ext.data.JsonReader({
			root: 'data'
		}, comprobarAdjuntosRecord)
	});    
  
	comprobarAdjuntosStore.on('load', function(store, data, options){
		var rec = comprobarAdjuntosStore.getAt(0);
		if (rec != null){
			var mensaje = rec.get('mensaje');
			if (mensaje != null && mensaje != '') {
				Ext.Msg.alert('Error', mensaje);  
			}else{
				fwk.toast('<s:message code="adjuntos.allfinished" text="**Todas las subidas completadas" />');      
			}
		}
	});  

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
		,{name : 'descripcion'}
	]);

	var store = page.getStore({
		flow : 'plugin/mejoras/contratos/plugin.mejoras.contratos.consultaAdjuntosContrato'
		,storeId : 'consultaAdjuntosContratoStore'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},Adjunto)
	});

	var recargarAdjuntos = function () {
		//store.webflow({id:${contrato.id}});
		//ANGEL TODO: ver como realizar la recarga, no cachear!!
		entidad.refrescar();
		entidad.cacheOrLoad(data, store, {id : data.id});
	};

	//recargarAdjuntos();

	var borrar = app.crearBotonBorrar({
		page : page
		,flow : 'contratos/borrarAdjuntoContrato'
		,params : {contratoId : panel.getContratoId }
		,success : function(){
			recargarAdjuntos();
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
            },{xtype: 'hidden', name:'id', value:panel.getContratoId()}]
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
		,{header : '<s:message code="plugin.mejoras.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType'}
	]);

	var editarDescripcionAdjuntoContrato = new  Ext.Button({
		text:'<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcion" text="**Editar descripcion"/>'
		,iconCls : 'icon_edit'
		,handler : function() {
			if (grid.getSelectionModel().getCount()>0){
				if (grid.getSelectionModel().getSelected().get('id')!= ''){
					var idContrato = grid.getSelectionModel().getSelected().get('id');
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
	var grid = app.crearGrid(store, cm, {
		title : '<s:message code="adjuntos.grid" text="**Ficheros adjuntos" />'
		,bbar : [<sec:authorize ifNotGranted="SOLO_CONSULTA">subir, borrar, editarDescripcionAdjuntoContrato</sec:authorize>]
		,height: 448
		,width : 600
		,collapsible:true
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	}); 
	grid.on('rowdblclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
		window.open("/pfs/bajarAdjuntoContrato.htm?id="+rec.get('id'));
	});

	grid.on('rowclick', function(grid, rowIndex,e){
		var rec = grid.getStore().getAt(rowIndex);
		var id = rec.get('id');
		if(id==null || id=='') {
			editarDescripcionAdjuntoContrato.disable();
		} else {
			editarDescripcionAdjuntoContrato.enable();
		}
	});	
	panel.add(grid);
	panel.getValue = function(){
	}
	panel.setValue = function(){
		var data = entidad.get("data");
		entidad.cacheOrLoad(data, store, {id : data.id});
	}
	

	return panel;
	
})
