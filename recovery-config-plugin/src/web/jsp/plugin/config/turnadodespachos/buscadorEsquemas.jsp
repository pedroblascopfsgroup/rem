<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page import="es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoBusquedaDto" %>

<fwk:page>

	//VARS ********************************************************************
	
	var limit=25;	
	var currentRowId;
	
	//PANEL FILTROS ********************************************************************
	
	
	var estadosEsquemaData = <app:dict value="${estadosEsquema}"/>;
	var estadosEsquemaDataStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : estadosEsquemaData
	       ,root: 'diccionario'
	});
	
    var cmbEstado = app.creaCombo({
    	store : estadosEsquemaDataStore
    	,name : 'tipoImporteLit'
    	,fieldLabel : '<s:message code="plugin.config.esquematurnado.buscador.tabFiltros.estado" text="**Estado" />'
		,width : 130
    });
    
    
    	//Creamos el boton buscar
	var btnBuscar=new Ext.Button({
		text:'<s:message code="app.buscar" text="**Buscar" />'
		,iconCls:'icon_busquedas'
		,handler:function(){
			b=getParametrosDto();
			esquemasStore.webflow(b);
			page.fireEvent(app.event.DONE);
		}
	});
	var btnClean=new Ext.Button({
	
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
			resetFiltros();
		}
	});
	
	<pfsforms:textfield
		labelKey="plugin.config.esquematurnado.buscador.tabFiltros.nombreEsquema"
		label="**Nombre esquema turnado"
		name="txtNombreEsquema"
		value=""
		readOnly="false" />
	<pfsforms:textfield
		labelKey="plugin.config.esquematurnado.buscador.tabFiltros.autor"
		label="**Autor"
		name="txtAutor"
		value=""
		readOnly="false" />

	<pfs:datefield name="dateFechaCreacionEsquema" labelKey="plugin.config.esquematurnado.buscador.tabFiltros.fechaAlta" label="**Fecha alta" width="70"/>;
	<pfs:datefield name="dateFechaVigenteEsquema" labelKey="plugin.config.esquematurnado.buscador.tabFiltros.fechaVigente" label="**Fecha vigente" width="70"/>;
	<pfs:datefield name="dateFechaFinalizadoEsquema" labelKey="plugin.config.esquematurnado.buscador.tabFiltros.fechaFinalizado" label="**Fecha finalizado" width="70"/>;


	var panelFiltros = new Ext.Panel({
		title:'<s:message code="plugin.config.esquematurnado.buscador.tabFiltros.titulo" text="**Buscador de esquemas de turnado" />'
		,collapsible:true
		,collapsed: false
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,style:'padding-bottom:10px; padding-right:10px;'
		//,tbar : [buttonsL,'->', buttonsR]
		,items:[{
				layout:'form'
				,items: [cmbEstado,txtNombreEsquema,txtAutor]
				},{
				layout:'form'
				,style: 'margin-left:20px;'
				,items: [dateFechaCreacionEsquema,dateFechaVigenteEsquema,dateFechaFinalizadoEsquema]
				}]
		,listeners:{	
			beforeExpand:function(){
				esquemasGrid.setHeight(125);
			}
			,beforeCollapse:function(){
				esquemasGrid.setHeight(435);
				esquemasGrid.expand(true);			
			}
		}
		,tbar : [btnBuscar,btnClean]
	});
	//------------------------------------------------------------------------------------------
	resetFiltros = function(){
		
		//if(tabFiltros){
		//alert("entro a resetear");
			cmbEstado.reset();
			txtNombreEsquema.reset();
			txtAutor.reset();
			dateFechaCreacionEsquema.reset();
			dateFechaVigenteEsquema.reset();
			dateFechaFinalizadoEsquema.reset();
		//}
	}
	var getParametrosDto=function(){
		    var b={};
			b.tipoEstado = cmbEstado.getValue();
			b.nombreEsquemaTurnado=txtNombreEsquema.getValue();
			b.autor=txtAutor.getValue();
			b.fechaAlta=dateFechaCreacionEsquema.getValue();
			b.fechaVigente=dateFechaVigenteEsquema.getValue();
			b.fechaFinalizado=dateFechaFinalizadoEsquema.getValue();
			return b;
	}
	
	//PANEL GRID RESULTADOS ********************************************************************
	
	var ventanaEdicion = function(id) {
		var w = app.openWindow({
			flow : 'turnadodespachos/editarEsquema'
			,width :  600
			,closable: true
			,title : '<s:message code="plugin.config.esquematurnado.ventana.editar" text="**Edición esquema" />'
			,params : {id:id}
		});
		w.on(app.event.DONE, function(){
			w.close();
			esquemasStore.webflow(getParametrosDto());
		});
		w.on(app.event.CANCEL, function(){ w.close(); });
	};

	var btnNuevo = new Ext.Button({
			text : '<s:message code="app.nuevo" text="**Nuevo" />'
			,iconCls : 'icon_mas'
			,handler : function(){
				ventanaEdicion(null);
			}
	});
	var btnBorrar = new Ext.Button({
			text : '<s:message code="app.borrar" text="**Borrar" />'
			,iconCls : 'icon_menos'
			,handler : function(){ 
				Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="plugin.config.esquematurnado.buscador.grid.boton.borrar.confirm" text="**Se va a eliminar el esquema seleccionado. ¿Desea continuar?" />' 
					,function(boton){
						if (boton=='yes') {
			      			page.webflow({
				      			flow:'turnadodespachos/borrarEsquema'
				      			,params: {id:currentRowId}
				      			,success: function(){
			            		   page.fireEvent(app.event.DONE);
			            		   esquemasStore.webflow(getParametrosDto());
			            		}	
				      		});
						}
					}, this);
			}
	});
	btnBorrar.setDisabled(true);

	var btnCopiar = new Ext.Button({
			text : '<s:message code="app.copiar" text="**Copiar" />'
			,iconCls : 'icon_copy'
			,handler : function(){ 
				Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="plugin.config.esquematurnado.buscador.grid.boton.copiar.confirm" text="**La acción copiará el esquema seleccionado. ¿Desea continuar?" />' 
					,function(boton){
						if (boton=='yes') {
			      			page.webflow({
				      			flow:'turnadodespachos/copiarEsquema'
				      			,params: {id:currentRowId}
				      			,success: function(){
			            		   page.fireEvent(app.event.DONE);
			            		   esquemasStore.webflow(getParametrosDto());
			            		}	
				      		});
						}
					}, this);
			}
	});

	<sec:authorize ifAllGranted="ROLE_ESQUEMA_TURNADO_ACTIVAR">
	var btnActivar = new Ext.Button({
			text : '<s:message code="app.activar" text="**Activar" />'
			,iconCls : 'icon_play'
			,handler : function(){ 

				Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="plugin.config.esquematurnado.buscador.grid.boton.activar.confirm" text="**La acción activará el esquema seleccionado. ¿Desea continuar?" />' 
					,function(boton){
						if (boton=='yes') {

							Ext.Ajax.request({
								url: page.resolveUrl('turnadodespachos/checkActivarEsquema')
								,params: {id:currentRowId}
								,method: 'POST'
								,success: function (result, request){

									var r = Ext.util.JSON.decode(result.responseText);

									if (!r.resultado) {
										Ext.Msg.alert('<s:message code="fwk.constant.alert" text="**Alerta"/>','<s:message code="plugin.config.esquematurnado.buscador.grid.boton.activar.problem" text="**No se puede dar por terminado el esquema vigente porque existen letrados que contienen Tipos que no existen en el nuevo esquema." />');
										return;
									}

									// Reiniciar letrados
									Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="plugin.config.esquematurnado.buscador.grid.boton.activar.reiniciarDatos" text="**¿Desea reiniciar los datos de todos los letrados con esta operación?" />' 
										,function(boton){

											var limpiarDatosLetrados = false;
											if (boton=='yes') {
												limpiarDatosLetrados = true;
											}

											// Activa el esquema
											page.webflow({
												flow:'turnadodespachos/activarEsquema'
												,params: {id:currentRowId,limpiarDatos:limpiarDatosLetrados}
													,success: function(){
													page.fireEvent(app.event.DONE);
													esquemasStore.webflow(getParametrosDto());
												}	
											});

										}, this);
								}
							}, this);
						}
				});
			}
	});
	btnActivar.setDisabled(true);
	</sec:authorize>
	
	<sec:authorize ifAllGranted="ROLE_ESQUEMA_TURNADO_EDITAR">
	var arrayAcciones = new Array();
	arrayAcciones[arrayAcciones.length] = {
		text:'<s:message code="plugin.config.esquematurnado.buscador.grid.boton.descargar" text="**Descargar configuración de letrados" />'
		,iconCls : 'icon_cambio_gestor'
		,handler:function(){
			var flow='/${appProperties.appName}/turnadodespachos/descargarConfiguracionDespachos';
		    var params = "";
		    	
		    app.openBrowserWindow(flow,params);
		    page.fireEvent(app.event.DONE);           	
		}
	};
	
	arrayAcciones[arrayAcciones.length] = {
		text:'<s:message code="plugin.config.esquematurnado.buscador.grid.boton.cargar" text="**Cargar configuración de letrados" />'
		,iconCls : 'icon_cambio_gestor'
		,handler:function(){
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
					,name: 'file'
					,path:'root'
					,buttonText: ''
					,buttonCfg: {
					    iconCls: 'icon_mas'
					}
				    ,bodyStyle: 'width:50px;'
			   	}
			    ,{
			    	xtype: 'hidden', name:'id', value:0
			    }]
			    ,buttons: [{
					text: 'Subir',
           			handler: function(){
           				var params = "";            	
                		if(upload.getForm().isValid()){
	                		upload.getForm().submit({
	                    		url:'/${appProperties.appName}/turnadodespachos/cargarConfiguracionDespachos.htm'
	                    		,waitMsg: '<s:message code="plugin.config.esquematurnado.buscador.grid.boton.cargar.procesando" text="**Procesando la información..." />'
	                    		,params:params
	                    		,success: function(upload, o){
	                    			
	                    			var resultado = Ext.decode(o.response.responseText);
								
									if (resultado.okko != "ok") {
	                    				Ext.Msg.alert('<s:message code="plugin.config.esquematurnado.buscador.grid.boton.cargar.cargaConfiguracion" text="*** Carga de configuración de letrados" />',
	                    				'<s:message code="plugin.config.esquematurnado.buscador.grid.boton.cargar.cargaConfiguracion.error" text="** Se ha producido algun error al procesar el fichero de configuración" /><br/><br/>' + resultado.okko);
	                    			} 
	                    			else {
	                    				Ext.Msg.alert('<s:message code="plugin.config.esquematurnado.buscador.grid.boton.cargar.cargaConfiguracion" text="*** Carga de configuración de letrados" />',
	                    				'<s:message code="plugin.config.esquematurnado.buscador.grid.boton.cargar.cargaConfiguracion.ok" text="*** Se ha procesado correctamente la información." />');
	                    			}
	                    			win.close();
	                    		}
                			});
               			}
          			}
      			},
			    {
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
	}};
	
	var menuAcciones = {
		text : '<s:message code="plugin.config.esquematurnado.buscador.grid.boton.acciones" text="**Acciones" />'
		,menu : arrayAcciones
	};
	</sec:authorize>

	btnBorrar.setDisabled(true);
	btnActivar.setDisabled(true);
	
	var esquema = Ext.data.Record.create([
		 {name:'id'}
		 ,{name:'descripcion'}
		 ,{name:'estado_cod'}
		 ,{name:'estado_des'}
		 ,{name:'usuario'}
		 ,{name:'fechaalta'}
		 ,{name:'fechainivig'}
		 ,{name:'fechafinvig'}
		 ,{name:'borrable', type:'boolean'}
		 ,{name:'activable', type:'boolean'}
	]);				
	
	var esquemasStore = page.getStore({
		 flow: 'turnadodespachos/buscarEsquemas' 
		,limit: limit
		,remoteSort: true
		,reader: new Ext.data.JsonReader({
	    	 root : 'esquemas'
	    	,totalProperty : 'total'
	     }, esquema)
	});	
	
	var pagingBar=fwk.ux.getPaging(esquemasStore);
	
	var esquemasCm = new Ext.grid.ColumnModel([	    
		{header: 'Id', dataIndex: 'id', hidden: true}
		,{header: '<s:message code="plugin.config.esquematurnado.buscador.grid.descripcion" text="**Descripcion"/>', dataIndex: 'descripcion', sortable: true}
		,{header: '<s:message code="plugin.config.esquematurnado.buscador.grid.estado_cod" text="**Cod Estado"/>', dataIndex: 'id', hidden: true}
		,{header: '<s:message code="plugin.config.esquematurnado.buscador.grid.estado_des" text="**Estado"/>', dataIndex: 'estado_des', sortable: true}
		,{header: '<s:message code="plugin.config.esquematurnado.buscador.grid.fechaSolicitud" text="F.Alta"/>', dataIndex: 'fechaalta', sortable: true}
		,{header: '<s:message code="plugin.config.esquematurnado.buscador.grid.usuario" text="**Usuario"/>', dataIndex: 'usuario', sortable: true}
		,{header: '<s:message code="plugin.config.esquematurnado.buscador.grid.fechainivig" text="**F.Inicio Vigencia"/>', dataIndex: 'fechainivig', sortable: true}
		,{header: '<s:message code="plugin.config.esquematurnado.buscador.grid.fechafinvig" text="**F.Fin Vigencia"/>', dataIndex: 'fechafinvig', sortable: true}
	]);
	
	var sm = new Ext.grid.RowSelectionModel({
		checkOnly : false
		,singleSelect: true
        ,listeners: {
            rowselect: function(p, rowIndex, r) {
            	if (!this.hasSelection()) {
            		return;
            	}
            	var borrable = r.data.borrable;
            	var activable = r.data.activable;
				btnBorrar.setDisabled(!borrable);
				<sec:authorize ifAllGranted="ROLE_ESQUEMA_TURNADO_ACTIVAR">				
				btnActivar.setDisabled(!activable);
				</sec:authorize>
            }
         }
	});
	
	var esquemasGrid = new Ext.grid.EditorGridPanel({
		store: esquemasStore
		,cm: esquemasCm
		,title:'<s:message code="plugin.config.esquematurnado.buscador.tituloGrid" text="**Esquemas encontrados"/>'
		,stripeRows: true
		,autoHeight:true
		,resizable:false
		,collapsible : false
		,titleCollapse : false
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding: 10px;'
		,viewConfig : {forceFit : true}
		,monitorResize: true
		//,clicksToEdit:0
		,selModel: sm
		,bbar : [pagingBar,btnNuevo,btnCopiar,btnBorrar
			<sec:authorize ifAllGranted="ROLE_ESQUEMA_TURNADO_ACTIVAR">,btnActivar</sec:authorize>
			<sec:authorize ifAllGranted="ROLE_ESQUEMA_TURNADO_EDITAR">,menuAcciones</sec:authorize>]
	});
	
	esquemasGrid.on({
		rowdblclick: function(grid, rowIndex, e) {
		   	var rec = grid.getStore().getAt(rowIndex);
		   	currentRowId = rec.get('id');
		   	if (currentRowId!=null){
				ventanaEdicion(currentRowId);
			}
		}
		,rowclick : function(grid, rowIndex, e) {
			var rec = grid.getStore().getAt(rowIndex);
			currentRowId = rec.get('id');
       	}
	});
	
	
	//PANEL PRINCIPAL ********************************************************************
	var mainPanel = new Ext.Panel({
		items : [panelFiltros,esquemasGrid]
	    ,bodyStyle:'padding:15px'
	    ,autoHeight : true
	    ,border: false
	   });
	   
	
	esquemasStore.webflow({});
	page.add(mainPanel);

</fwk:page>


