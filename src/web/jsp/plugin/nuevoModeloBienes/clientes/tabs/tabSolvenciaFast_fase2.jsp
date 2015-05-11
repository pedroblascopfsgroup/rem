﻿<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

(function(page, entidad){

	var panel=new Ext.Panel({
		title:'<s:message code="menu.clientes.consultacliente.solvenciaTab.title" text="**Solvencia"/>'
		,height: 445
		,autoWidth:true			
		,bodyStyle : 'padding:10px'
		,nombreTab : 'solvenciaPanel'
	});
	
	var labelStyle='font-weight:bolder;width:150px'
	var show=false;
	
	var fechaVerif = new Ext.ux.form.StaticTextField({
		fieldLabel:'<s:message code="menu.clientes.consultacliente.solvenciatab.fechaverif" text="**Fecha Verificacion"/>'
		,labelStyle:labelStyle
		,style:'margin-left:5px'			
		,name:'fechaVerifSolvencia'
		,value:''
	});
		
	var tituloobservaciones = new Ext.form.Label({
		text:'<s:message code="menu.clientes.consultacliente.antecedentestab.observaciones" text="**Observaciones" />'
		,style:'font-weight:bolder; font-size:11' 
		}); 
		
	var observaciones = new Ext.form.TextArea({
		fieldLabel:'<s:message code="menu.clientes.consultacliente.solvenciaTab.textarea" text="**Solvencia" />'
		<app:test id="observacionesSolvencia" addComa="true" />
		,readOnly:true
		,hideLabel: true
		,labelStyle:labelStyle
		,style:'margin-left:5px; width:auto'
		,width:'90%'
		,maxLength:250
		,name : 'observacionesSolvencia'
		,value: ''
	});

	<sec:authorize ifAllGranted="VIGENCIA_SOLVENCIA">
		var btnEditarSolvencia = new Ext.Button({
			 text: '<s:message code="app.editar" text="**Editar" />'
				<app:test id="btnEditarSolvencia" addComa="true" />
			 ,iconCls : 'icon_edit'
				,cls: 'x-btn-text-icon'
				,style:'margin-left:2px;padding-top:0px'
			 ,handler:function(){
					var w = app.openWindow({
						flow : 'clientes/solvencia'
						,width:650
						,title : '<s:message code="app.editarRegistro" text="**Editar" />'
						,params : {idPersona: getpersonaId()}
					});
					w.on(app.event.DONE, function(){
						w.close();
						//TODO:refrescarSolvencia();
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
			}
		});
	</sec:authorize>
		
	<sec:authorize ifAllGranted="EDITAR_SOLVENCIA">
		var btnAgregarBien = new Ext.Button({
			text: '<s:message code="app.agregar" text="**Agregar" />'
			,iconCls : 'icon_mas'
			,cls: 'x-btn-text-icon'
			,handler:function(){
					var w = app.openWindow({
						flow : 'plugin/nuevoModeloBienes/bienes/NMBBienes'
						,width:760
						,title : '<s:message code="clientes.consultacliente.solvenciaTab.editarBienes" text="**Editar bienes" />' 
						,params : {idPersona:getPersonaId()}
					});
					w.on(app.event.DONE, function(){
						w.close();
						bienesST.webflow({id:getPersonaId()});
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
			}
		});
		
		var btnBorrarBien = app.crearBotonBorrar({
			text : '<s:message code="app.borrar" text="**BorrarBien" />'
			<app:test id="btnBorrarBien" addComa="true" />
			,flow : 'clientes/borrarBien'
			,success : function(){
				bienesST.webflow({id:getPersonaId()});
			}
			,page : page
		});
		
		var btnAgregarIngreso = new Ext.Button({
			text: '<s:message code="app.agregar" text="**Agregar" />'
			,iconCls : 'icon_mas'
			,cls: 'x-btn-text-icon'
			,handler:function(){
				var w = app.openWindow({
					flow : 'clientes/ingresos'
					,width:400
					,title : '<s:message code="clientes.consultacliente.solvenciaTab.editarIngresos" text="**Editar ingresos" />'
					,params : {idPersona:getPersonaId()}
				});
				w.on(app.event.DONE, function(){
					w.close();
					ingresoST.webflow({id:getPersonaId()});
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
			}
		});
		

		var btnEditarIngreso = new Ext.Button({
			 text: '<s:message code="app.editar" text="**Editar" />'
			 ,iconCls : 'icon_edit'
			 ,cls: 'x-btn-text-icon'
			 ,handler:function(){
					var id = panel.ingresosGrid.getSelectionModel().getSelected().get('id');
					var parametros = {
							idPersona: getPersonaId(),
							id: id
					};
					var w = app.openWindow({
						flow : 'clientes/ingresos'
						,width:760
						,title : '<s:message code="clientes.consultacliente.solvenciaTab.editarIngresos" text="**Editar ingresos" />'
						,params : parametros
					});
					w.on(app.event.DONE, function(){
						w.close();
						ingresoST.webflow({id:getPersonaId()});
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
			}
		});
		
		var btnBorrarIngreso = app.crearBotonBorrar({
			text : '<s:message code="app.borrar" text="**Borrar" />'
			<app:test id="btnBorrarIngreso" addComa="true" />
			,flow : 'clientes/borrarIngreso'
			,success : function(){
				ingresoST.webflow({id:getPersonaId()});
			}
			,page : page
		});
	</sec:authorize>
	
	var btnEditarBien = new Ext.Button({
		 text: '<s:message code="app.editar" text="**Editar" />'
		 ,iconCls : 'icon_edit'
		 ,cls: 'x-btn-text-icon'
		 ,handler:function(){
				var rec = panel.bienesGrid.getSelectionModel().getSelected();
				if (!rec) return;
					var id = rec.get("id");
				var parametros = {
						idPersona: getPersonaId(),
						id: id
				};
				var w = app.openWindow({
					flow : 'plugin/nuevoModeloBienes/bienes/NMBBienes'
					,width:760
					,title : '<s:message code="clientes.consultacliente.solvenciaTab.editarBienes" text="**Editar bienes" />'  
					,params : parametros
				});
				w.on(app.event.DONE, function(){
					w.close();
					bienesST.webflow({id:getPersonaId()});
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
		}
	});
		
	<sec:authorize ifAllGranted="VERIFICAR_BIEN">
	//AGREGAR FUNCION de visibilidad de este boton VERIFICAR_BIEN	
		var btnVerificarBien = new Ext.Button({
			text : '<s:message code="clientes.consultacliente.solvenciaTab.verificarBien" text="**Verificar bien" />'
			,iconCls:'icon_comunicacion'
			,cls: 'x-btn-text-icon'
			//Por ahora dejamos el boton deshabilitado, pues PFS no dispondrá momento de servidor SMTP para enviar mails de verificacion
			//,disabled:true
			,handler : function(){
				var rec = panel.bienesGrid.getSelectionModel().getSelected();
				if (!rec) return;
				//Validacion de configuracion
				var config=rec.get("idconfigmail");
				var emilio=rec.get("email");
				if(config=="" || emilio==""){
					//no hay configuracion
					var title='<s:message code="app.error" text="**Error"/>'
					var msg='<s:message code="bienes.error.mailverificacion" text="**Error de configuracion para el tipo de bien"/>'
					Ext.Msg.alert(title,msg);	
					return;
				}
				
				//---------------------------
				var bienId = rec.get("id");
				panel.container.mask('<s:message code="clientes.consultacliente.solvenciaTab.verificandoBien" text="**Verificando bien" />');
				page.webflow({
				  flow: 'clientes/verificarBien', 
				  params : {id:bienId},
				  success: function() {
					  panel.container.unmask();
					  bienesST.webflow({id:getPersonaId()});
				  },
				  error : function() {
					panel.container.unmask();
				  }
				});
			}
		});  
	</sec:authorize>

	<sec:authorize ifAllGranted="BOTON_MARCAR_BIENES_PARA_EXTERNOS">
		var btnMarcarGarantia = new Ext.Button({
			 text : '<s:message code="plugin.nuevoModeloBienes.tabSolvencia.btnMarcarBien" text="**Marcar / Desmarcar" />'
			,iconCls : 'icon_buildingEdit'
			,cls: 'x-btn-text-icon'
			,disabled:true
			,handler : function(){
				var rec = panel.bienesGrid.getSelectionModel().getSelected();
				if (!rec){
					Ext.Msg.alert('<s:message code="app.error" text="**Error"/>','<s:message code="plugin.nuevoModeloBienes.tabSolvencia.btnMarcarBien.debeSeleccionar" text="**Debe seleccionar el bien que desea Marcar o Desmarcar"/>');
					return;
				}	
				Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="plugin.nuevoModeloBienes.tabSolvencia.btnMarcarBien.mensajeConfirmacion" text="**Seguro que desea marcar la solvencia seleccionada?" />', this.decide, this);
			}
			,decide : function(boton){
				if (boton=='yes') this.marcar();
			}
			,marcar : function(){
				page.webflow({
					 flow : 'plugin/nuevoModeloBienes/clientes/marcarBien'
					,params : {idBien:panel.bienesGrid.getSelectionModel().getSelected().get("id")}
					,success : function(){
						bienesST.webflow({id:getPersonaId()});	
					}
				})
			}
		});
	</sec:authorize>
	
	var bien = Ext.data.Record.create([
		{name:'id'}
		,{name:'tipo'}
		,{name:'detalle'}
		,{name:'participacion'}
		,{name:'poblacion'}
		,{name:'importeCargas'}
		,{name:'valorActual'}
		,{name:'refCatastral'}		
		,{name:'superficie'}		
		,{name:'poblacion'}		
		,{name:'datosRegistrales'}
		,{name:'descripcion'}	
		,{name:'fechaVerificacion'}		
		<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
			,{name:'origen'}
		</sec:authorize>	
		,{name:'email'}		
		,{name:'idconfigmail'}
		<sec:authorize ifAllGranted="BOTON_MARCAR_BIENES_PARA_EXTERNOS">
			,{name:'marca'}
		</sec:authorize>
		<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
			,{name:'contratos'}
		</sec:authorize>		
	]);

	var bienesST = page.getStore({
		flow : 'clientes/bienesData'
		,storeId : 'bienesST'
		,pageSize : 20
		,reader : new Ext.data.JsonReader({root : 'bienes'}, bien)
	});
		
	var bienesCm = new Ext.grid.ColumnModel([
		{header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.id" text="**Id"/>', dataIndex: 'id', hidden: true}
		,{header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.tipo" text="**Tipo"/>', width: 200, sortable: true, dataIndex: 'tipo'}
		<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
			,{header: '<s:message code="plugin.nuevoModeloBienes.columnaOrigenBien" text="**Carga"/>', sortable: true, dataIndex: 'origen'}
		</sec:authorize>
		,{header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.detalle" text="**Detalle"/>', dataIndex: 'descripcion'}
		,{header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.participacion" text="**Participacion"/>', 
			dataIndex: 'participacion', renderer: function (val){if (val=="---"){return "";} var result = app.format.formatNumber(val,2);return String.format("{0} %",result);}, align:'right'}
		,{header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.valor" text="**Valor"/>', dataIndex: 'valorActual',renderer: app.format.moneyRenderer, align:'right'}
		,{header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.cargas" text="**Cargas"/>', dataIndex: 'importeCargas',renderer: app.format.moneyRenderer, align:'right'}
		,{header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.refcatastral" text="**Referencia Catastral"/>', dataIndex: 'refCatastral',hidden:true}
		,{header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.superficie" text="**Superficie"/>', dataIndex: 'superficie', renderer: app.format.sqrMtsRenderer, align:'right'}
		,{header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.poblacion" text="**Poblacion"/>', dataIndex: 'poblacion', align:'right'}
		,{header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.datosregistrales" text="**Datos Registrales"/>', dataIndex: 'datosRegistrales',hidden:true}
		,{header: '<s:message code="clientes.consultacliente.solvenciaTab.fechaVerificacion" text="**Fecha Verificación"/>', dataIndex: 'fechaVerificacion'}
		<sec:authorize ifAllGranted="BOTON_MARCAR_BIENES_PARA_EXTERNOS">
			,{header: '<s:message code="plugin.nuevoModeloBienes.columnaMarcaBien" text="**Marcado"/>', sortable: true, dataIndex: 'marca', 
					 renderer: function (val){if (val==1) {return "SI";} else {return "NO"}} }
		</sec:authorize>	
		<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
			,{header: '<s:message code="plugin.nuevoModeloBienes.columnaContratosBien" text="**Contratos"/>', sortable: true, dataIndex: 'contratos'}
		</sec:authorize>
	]);

	var refrescarSolvencia = function(){
		formObservaciones.load({
			url : app.resolveFlow('clientes/solvenciaObservacionData')
			,params : {id :getPersonaId()}
		});
	};
	panel.bienesGrid=app.crearGrid(bienesST,bienesCm,{
		title:'<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.title" text="**Bienes"/>'
		,style : 'margin-bottom:10px;padding-right:10px'
		,iconCls : 'icon_bienes'
		,height:208
		,bbar:new Ext.Toolbar()
		<app:test id="bienesGrid" addComa="true" />
	});
	
	panel.bienesGrid.getBottomToolbar().addButton([btnEditarBien]);
	
	<sec:authorize ifAllGranted="EDITAR_SOLVENCIA">
		panel.bienesGrid.getBottomToolbar().addButton([btnAgregarBien, btnBorrarBien]);
	</sec:authorize>
	
	<sec:authorize ifAllGranted="BOTON_MARCAR_BIENES_PARA_EXTERNOS">
		panel.bienesGrid.getBottomToolbar().addButton(btnMarcarGarantia);
	</sec:authorize>
	
	<sec:authorize ifAllGranted="VERIFICAR_BIEN">
		panel.bienesGrid.getBottomToolbar().addButton(btnVerificarBien);
	</sec:authorize>
	
	var ingreso = Ext.data.Record.create([
		{name:'id'}
		,{name:'tipoIngreso'}
		,{name:'detalle'}
		,{name:'periodicidad'}
		,{name:'bruto'}
	]);

	var ingresoST = page.getStore({
		flow : 'clientes/ingresosData'
		,storeId : 'ingresoST'
		,pageSize : 20
		,reader : new Ext.data.JsonReader({root : 'ingresos'}, ingreso)
		,remoteSort : false			
	});

	var ingresosCm = new Ext.grid.ColumnModel([
		{	header: '<s:message code="menu.clientes.consultacliente.solvenciatab.ingresos.tipo" text="**Tipo"/>', 
			width: 150, sortable: true, dataIndex: 'tipoIngreso'},
		{	header: '<s:message code="menu.clientes.consultacliente.solvenciatab.ingresos.periodicidad" text="**Periodicidad"/>',
			width: 50, sortable: true, dataIndex: 'periodicidad',align:'right'},
		{	header: '<s:message code="menu.clientes.consultacliente.solvenciatab.ingresos.bruto" text="**Bruto"/>', 
			width: 100, sortable: true, dataIndex: 'bruto',renderer: app.format.moneyRenderer, align:'right'}
		]
		
	);
	
	var cfgIngresos = {
		title: '<s:message code="menu.clientes.consultacliente.solvenciatab.ingresos.title" text="**Ingresos"/>'
		<app:test id="ingresosGrid" addComa="true" />
		,store: ingresoST
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,cm: ingresosCm
		,height:164
		,width:370
		,sm: new Ext.grid.RowSelectionModel({singleSelect: true})
		,iconCls : 'icon_ingresos'			
		,viewConfig:{forceFit:true}
		,monitorResize: true			
		<sec:authorize ifAllGranted="EDITAR_SOLVENCIA">,bbar:[btnAgregarIngreso,btnEditarIngreso,btnBorrarIngreso]</sec:authorize>
	}
	
	panel.ingresosGrid=new Ext.grid.GridPanel(cfgIngresos);

	//AGREGAR FUNCION VIGENCIA_SOLVENCIA
	var formObservaciones = new Ext.form.FormPanel({
		bodyStyle:'padding:5px'
		,border:false
		,autoWidth:true			
		,items:[fechaVerif,tituloobservaciones,observaciones]
	});

	var panelVigenciaDatos = new Ext.form.FieldSet({
		title:'<s:message code="menu.clientes.consultacliente.solvenciatab.panelvigencia" text="**Vigencia Datos"/>'
		,bodyStyle:'padding-left:5px;padding-top:5px'
		,autoWidth:true
		,autoHeight:true
		,items:[    
			formObservaciones
			<sec:authorize ifAllGranted="VIGENCIA_SOLVENCIA">,btnEditarSolvencia</sec:authorize>
		]
	});

	panelInferior=new Ext.Panel({
		layout:'column'
		,layoutConfig:{
			columns:2
		}
		,autoHeight:true
		,border:false
		,bodyStyle:'padding-top:10px'
		,autoWidth:true
		,defaults:{columnWidth:.5}
		,items:[{
				items:panel.ingresosGrid
				,layout:'fit'
				,border:false
				,style:'padding-right:10px'
			}
			,{
				items:[panelVigenciaDatos]
				,border:false
			}
		]
	});
	
	<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
		<sec:authorize ifAllGranted="EDITAR_SOLVENCIA">
			btnBorrarBien.disable();
			panel.bienesGrid.on('rowclick',function(grid, rowIndex, e){
				var rec = grid.getStore().getAt(rowIndex);
				var origen= rec.get('origen');
				if(origen=='Manual'){
					btnBorrarBien.enable();
				} else {
					btnBorrarBien.disable();
				}
			});
		</sec:authorize>
		panel.bienesGrid.on('rowclick',function(grid, rowIndex, e){
			var rec = grid.getStore().getAt(rowIndex);
			var origen= rec.get('origen');
			if(origen=='Automática'){
				<sec:authorize ifAllGranted="BOTON_MARCAR_BIENES_PARA_EXTERNOS">
					btnMarcarGarantia.enable();
				</sec:authorize>
			} else {
				<sec:authorize ifAllGranted="BOTON_MARCAR_BIENES_PARA_EXTERNOS">
					btnMarcarGarantia.disable();
				</sec:authorize>
			}
		});
	</sec:authorize>
	
	entidad.cacheStore(panel.bienesGrid.getStore());
	entidad.cacheStore(panel.ingresosGrid.getStore());

	panel.add(panel.bienesGrid);
	panel.add(panelInferior);
	
	panel.setValue = function(){
		var data = entidad.get("data");
		entidad.cacheOrLoad(data,panel.bienesGrid.getStore(), {id:data.id});
		entidad.cacheOrLoad(data,panel.ingresosGrid.getStore(), {id:data.id});

		fechaVerif.setValue(getFechaVerifSolvencia());
		observaciones.setValue(getObservacionesSolvencia());
	}

	getFechaVerifSolvencia = function(){return entidad.get("data").solvencia.fechaVerifSolvencia;}			
	getObservacionesSolvencia = function(){return entidad.get("data").solvencia.observacionesSolvencia;}
	function getPersonaId(){
		if (entidad){
			return entidad.get("data").id; //XXX
		}
	}
		
    panel.getValue = function(){
		return {};
    }
    
	return panel;
})






