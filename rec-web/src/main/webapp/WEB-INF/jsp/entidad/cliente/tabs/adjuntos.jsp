<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

(function(page, entidad) {
	
	var panel = new Ext.Panel({
		title : '<s:message code="adjuntos.tabTitle" text="**Adjuntos" />'
		,bodyStyle:'padding:10px'
		,height: 445
		,nombreTab : 'datosPanel'
	});
	
	panel.getPersonaId = function(){
        return entidad.get("data").id;
	}

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
		,{name : 'fechaCrear'}
		,{name : 'tipoFichero'}
	]);
	
	var store = page.getStore({
		flow : 'plugin/mejoras/clientes/plugin.mejoras.clientes.consultaAdjuntosPersona'
		,storeId : 'storeAdjuntosPersona'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},Adjunto)
	});

	var recargarAdjuntos = function () {
		entidad.refrescar();
		store.webflow({id:panel.getPersonaId()});
	};

	var borrar = app.crearBotonBorrar({
		page : page
		,flow : 'clientes/borrarAdjuntoPersona'
		,params : {personaId : panel.getPersonaId}
		,success : function(){
			recargarAdjuntos();
		}
	});
	
	var comprobarAdjuntosRecord = Ext.data.Record.create([
		 {name:'mensaje'}
	]);

	var comprobarAdjuntosStore = page.getStore({
		eventName: 'resultado'
		,storeId : 'adjuntos'
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
	
	var tipoDocRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
		
	]);
	
	var tipoDocStore =	page.getStore({
	       flow: 'adjuntoasunto/getTiposDeDocumentoAdjuntoProcedimiento'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, tipoDocRecord)
	});
	
	subir.on('click', function(){
		tipoDocStore.webflow({tipoEntidad:'<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_PERSONA" />'});
		
		var comboTipoFichero = new Ext.form.ComboBox(
			{
				xtype:'combo'
				,name:'comboTipoDoc'
				<app:test id="tipoDocCombo" addComa="true" />
				,hiddenName:'comboTipoDoc'
				,store:tipoDocStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'remote'
				,emptyText:'----'
				,width:250
				,resizable:true
				,triggerAction: 'all'
				,fieldLabel : 'Tipo documento'
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
		
		var upload = new Ext.FormPanel({
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
			}
<sec:authorize ifAllGranted="PERSONALIZACION-BCC">			     
	    	,fechaCaducidad
</sec:authorize>		        
			,{xtype: 'hidden', name:'id', value:panel.getPersonaId()}]
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
	
		var win =new Ext.Window({
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
		win.show();
	});
	
	var cm = new Ext.grid.ColumnModel([
		{header : '<s:message code="adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre'}
		,{header : '<s:message code="adjuntos.descripcion" text="**Descripcion" />', dataIndex : 'descripcion'}
		,{header : '<s:message code="adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer}
		,{header : '<s:message code="plugin.mejoras.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType'}
		,{header : '<s:message code="plugin.mejoras.asuntos.adjuntos.fechaSubida" text="**Fecha de subida" />', dataIndex : 'fechaCrear'}
		,{header : '<s:message code="plugin.mejoras.adjuntos.tipoFichero" text="**Tipo Documento" />', dataIndex : 'tipoFichero'}
	]);
	
	var editarDescripcionAdjuntoPersona = new  Ext.Button({
		text:'<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcion" text="**Editar descripcion"/>'
		,iconCls : 'icon_edit'
		,handler : function() {
			if (grid.getSelectionModel().getCount()>0){
				if (grid.getSelectionModel().getSelected().get('id')!= ''){
					var idPersona = grid.getSelectionModel().getSelected().get('id');
					var parametros = {
						idPersona : idPersona
					};
					var w= app.openWindow({
                        flow: 'plugin/mejoras/asuntos/plugin.mejoras.asuntos.editarDescripAdjPersona'
                        ,closable: true
                        ,width : 700
                        ,title : '<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcionPersona" text="**Editar descripción del adjunto de la persona" />'
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
					Ext.Msg.alert('<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcionPersona" text="**Editar descripcion del adjunto del expediente" />','<s:message code="plugin.mejoras.asunto.adjuntos.noValor" text="**Debe seleccionar un valor de la lista" />');
				}
			}	
		}
	});
	
	var grid = app.crearGrid(store, cm, {
		title : '<s:message code="adjuntos.grid" text="**Ficheros adjuntos" />'
		,bbar : [<sec:authorize ifNotGranted="SOLO_CONSULTA">subir, borrar, editarDescripcionAdjuntoPersona</sec:authorize>]
		,height: 400
		,collapsible:true
		,width : 600
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	}); 
	
	grid.on('rowdblclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
		window.open("/pfs/bajarAdjuntoPersona.htm?id="+rec.get('id')+"&nombre="+rec.data.nombre+"&extension="+rec.data.contentType);
	});
	
	grid.on('rowclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		var id = rec.get('id');
		if(id==null || id=='') {
			editarDescripcionAdjuntoPersona.disable();
		} else {
			editarDescripcionAdjuntoPersona.enable();
		}
	});
	
	<sec:authorize ifAllGranted='BOTON_BORRAR_INVISIBLE'>
		borrar.setVisible(false);
		editarDescripcionAdjuntoPersona.setVisible(false);
	</sec:authorize>
	
	panel.add(grid);
	entidad.cacheStore(grid.getStore());

	panel.getValue = function(){
	}
	
	panel.setValue = function(){
		var data = entidad.get("data");
		entidad.cacheOrLoad(data,grid.getStore(), {id:data.id});
		editarDescripcionAdjuntoPersona.disable();
	}

	
	
	return panel;
})
