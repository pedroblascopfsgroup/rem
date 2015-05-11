<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(){
	
	Ext.util.CSS.createStyleSheet("Button.icon_buildingEdit { background-image: url('../img/plugin/nuevoModeloBienes/building_edit.png');}");
	
	var panel=new Ext.Panel({
		title:'<s:message code="menu.clientes.consultacliente.solvenciaTab.title" text="**Solvencia"/>'
		,height: 445
		,autoWidth:true			
		,bodyStyle : 'padding:10px'
		,nombreTab : 'solvenciaPanel'
	});
	
	panel.on('render', function()
	{
		var labelStyle='font-weight:bolder;width:150px'
		var show=false;
		
		var fec = '${persona.fechaVerifSolvencia}';
		var fecSp=fec.split(" ")[0];
		var fechaVerif = new Ext.ux.form.StaticTextField({
			fieldLabel:'<s:message code="menu.clientes.consultacliente.solvenciatab.fechaverif" text="**Fecha Verificacion"/>'
			,labelStyle:labelStyle
			,style:'margin-left:5px'			
			,name:'fechaVerifSolvencia'
			,value:'<fwk:date value="${persona.fechaVerifSolvencia}" />'
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
			,value: '<s:message text="${persona.observacionesSolvencia}" javaScriptEscape="true" />'
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
							,params : {idPersona:"${persona.id}"}
						});
						w.on(app.event.DONE, function(){
							w.close();
							refrescarSolvencia();
						});
						w.on(app.event.CANCEL, function(){ w.close(); });
		        }
			});
		</sec:authorize>
		<sec:authorize ifAllGranted="EDITAR_SOLVENCIA">
			<%-- fase 2  --%>
			var btnAgregarBien = new Ext.Button({
		           	text: '<s:message code="app.agregar" text="**Agregar" />'
		           	,iconCls : 'icon_mas'
					,cls: 'x-btn-text-icon'
					<app:test id="btnAgregarBien" addComa="true" />
		           	,handler:function(){
						var w = app.openWindow({
							//flow : 'plugin/nuevoModeloBienes/bienes/NMBBienes'
							flow : 'editbien/nuevoBienIdPersona'
							,width:760
							,title : '<s:message code="clientes.consultacliente.solvenciaTab.editarBienes" text="**Editar bienes" />' 
							,params : {idPersona:"${persona.id}"}
						});
						w.on(app.event.DONE, function(){
							w.close();
							bienesST.webflow({id:"${persona.id}"});
						});
						w.on(app.event.CANCEL, function(){ w.close(); });
		        }
			});
			var btnBorrarBien = app.crearBotonBorrar({
				text : '<s:message code="app.borrar" text="**BorrarBien" />'
				<app:test id="btnBorrarBien" addComa="true" />
				,flow : 'clientes/borrarBien'
				,success : function(){
					bienesST.webflow({id:"${persona.id}"});
				}
				,page : page
			});
			var btnAgregarIngreso = new Ext.Button({
		           	text: '<s:message code="app.agregar" text="**Agregar" />'
					<app:test id="btnAgregarIngreso" addComa="true" />
		           	,iconCls : 'icon_mas'
					,cls: 'x-btn-text-icon'
		           	,handler:function(){
						var w = app.openWindow({
							flow : 'clientes/ingresos'
							,width:400
							,title : '<s:message code="clientes.consultacliente.solvenciaTab.editarIngresos" text="**Editar ingresos" />'
							,params : {idPersona:"${persona.id}"}
						});
						w.on(app.event.DONE, function(){
							w.close();
							ingresoST.webflow({id:"${persona.id}"});
						});
						w.on(app.event.CANCEL, function(){ w.close(); });
		        }
			});
			var btnEditarIngreso = app.crearBotonEditar({
	            text:'<s:message code="app.editar" text="**Editar" />'
				<app:test id="btnEditarIngreso" addComa="true" />
				,flow : 'clientes/ingresos'
				,title : '<s:message code="clientes.consultacliente.solvenciaTab.editarIngresos" text="**Editar ingresos" />'
				,params : {idPersona:"${persona.id}"}
				,width:400
				,success : function(){
					ingresoST.webflow({id:"${persona.id}"});
				}
				
			});
			var btnBorrarIngreso = app.crearBotonBorrar({
				text : '<s:message code="app.borrar" text="**Borrar" />'
				<app:test id="btnBorrarIngreso" addComa="true" />
				,flow : 'clientes/borrarIngreso'
				,success : function(){
					ingresoST.webflow({id:"${persona.id}"});
				}
				,page : page
			});
		</sec:authorize>
		
		<sec:authorize ifAllGranted="SOLVENCIA_NUEVO">
			var btnAgregarBien = new Ext.Button({
		           	text: '<s:message code="app.agregar" text="**Agregar" />'
		           	,iconCls : 'icon_mas'
					,cls: 'x-btn-text-icon'
					<app:test id="btnAgregarBien" addComa="true" />
		           	,handler:function(){
						var w = app.openWindow({
							//flow : 'plugin/nuevoModeloBienes/bienes/NMBBienes'
							flow : 'editbien/nuevoBienIdPersona'
							,width:760
							,title : '<s:message code="clientes.consultacliente.solvenciaTab.editarBienes" text="**Editar bienes" />' 
							,params : {idPersona:"${persona.id}"}
						});
						w.on(app.event.DONE, function(){
							w.close();
							bienesST.webflow({id:"${persona.id}"});
						});
						w.on(app.event.CANCEL, function(){ w.close(); });
		        }
			});
		</sec:authorize>
		<sec:authorize ifAllGranted="SOLVENCIA_BORRAR">	
			var btnBorrarBien = app.crearBotonBorrar({
				text : '<s:message code="app.borrar" text="**BorrarBien" />'
				<app:test id="btnBorrarBien" addComa="true" />
				,flow : 'clientes/borrarBien'
				,success : function(){
					bienesST.webflow({id:"${persona.id}"});
				}
				,page : page
			});
		</sec:authorize>
		<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
			var btnEditarBien = app.crearBotonEditar({
	            text:'<s:message code="plugin.nuevoModeloBienes.tabSolvencia.grid.btnModifica" text="**Editar" />'
				<app:test id="btnEditarBien" addComa="true" />
				,flow : 'editbien/openByIdBienAndIdPersona'
				,title : '<s:message code="clientes.consultacliente.solvenciaTab.editarBienes" text="**Editar bienes" />' 
				,params : {idPersona:"${persona.id}"}
				,width:760
				,success : function(){
					bienesST.webflow({id:"${persona.id}"});
				}
			});
		</sec:authorize>
		<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
			var btnEditarBien = new Ext.Button({
		        text:'<s:message code="plugin.nuevoModeloBienes.tabSolvencia.grid.btnAbrir" text="**Abrir" />'
				<app:test id="btnAgregarIngreso" addComa="true" />
	           	,iconCls : 'icon_edit'
				,cls: 'x-btn-text-icon'
	           	,handler:function(){
					var rec = bienesGrid.getSelectionModel().getSelected();
		            if (!rec) return;
		            var idBien=rec.get("id");
		            var desc = idBien + ' ' +  rec.get('tipo');
		            app.abreBien(idBien,desc);
	       		}
			});
		</sec:authorize>
		<%-- Fase 2 --%>
		<sec:authorize ifAllGranted="EDITAR_SOLVENCIA">
			var btnEditarBien = new Ext.Button({
		        text:'<s:message code="plugin.nuevoModeloBienes.tabSolvencia.grid.btnModifica" text="**Editar" />'
				,iconCls : 'icon_edit'
				,cls: 'x-btn-text-icon' 
				,handler:function(){
						var rec = bienesGrid.getSelectionModel().getSelected();
		            	if (!rec) return;
		            	var idBien=rec.get("id");
						var w = app.openWindow({
							flow : 'editbien/openByIdBienAndIdPersona'
							,width:760
							,title : '<s:message code="clientes.consultacliente.solvenciaTab.editarBienes" text="**Editar bienes" />'
							,params : {idPersona:"${persona.id}", id:idBien}
						});
						w.on(app.event.DONE, function(){
							w.close();
							bienesST.webflow({id:"${persona.id}"});
						});
						w.on(app.event.CANCEL, function(){ w.close();}); 
				}
			});
		</sec:authorize>
		<%-- fin --%>
		<sec:authorize ifAllGranted="INGRESOS_EDITAR">
			var btnAgregarIngreso = new Ext.Button({
		           	text: '<s:message code="app.agregar" text="**Agregar" />'
					<app:test id="btnAgregarIngreso" addComa="true" />
		           	,iconCls : 'icon_mas'
					,cls: 'x-btn-text-icon'
		           	,handler:function(){
						var w = app.openWindow({
							flow : 'clientes/ingresos'
							,width:400
							,title : '<s:message code="clientes.consultacliente.solvenciaTab.editarIngresos" text="**Editar ingresos" />'
							,params : {idPersona:"${persona.id}"}
						});
						w.on(app.event.DONE, function(){
							w.close();
							ingresoST.webflow({id:"${persona.id}"});
						});
						w.on(app.event.CANCEL, function(){ w.close(); });
		        }
			});
			var btnEditarIngreso = app.crearBotonEditar({
	            text:'<s:message code="app.editar" text="**Editar" />'
				<app:test id="btnEditarIngreso" addComa="true" />
				,flow : 'clientes/ingresos'
				,title : '<s:message code="clientes.consultacliente.solvenciaTab.editarIngresos" text="**Editar ingresos" />'
				,params : {idPersona:"${persona.id}"}
				,width:400
				,success : function(){
					ingresoST.webflow({id:"${persona.id}"});
				}
				
			});
			var btnBorrarIngreso = app.crearBotonBorrar({
				text : '<s:message code="app.borrar" text="**Borrar" />'
				<app:test id="btnBorrarIngreso" addComa="true" />
				,flow : 'clientes/borrarIngreso'
				,success : function(){
					ingresoST.webflow({id:"${persona.id}"});
				}
				,page : page
			});
		</sec:authorize>
		<sec:authorize ifAllGranted="VERIFICAR_BIEN">
			var btnVerificarBien = new Ext.Button({
                text : '<s:message code="clientes.consultacliente.solvenciaTab.verificarBien" text="**Verificar bien" />'
                ,iconCls:'icon_comunicacion'
                ,cls: 'x-btn-text-icon'
                ,handler : function(){
                    var rec = bienesGrid.getSelectionModel().getSelected();
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
                          bienesST.webflow({id:"${persona.id}"});
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
					var rec = bienesGrid.getSelectionModel().getSelected();
					if (!rec){
						Ext.Msg.alert('<s:message code="app.error" text="**Error"/>','<s:message code="plugin.nuevoModeloBienes.tabSolvencia.btnMarcarBien.debeSeleccionar" text="**Debe seleccionar el bien que desea Marcar o Desmarcar"/>');
						return;
					}	
					Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="plugin.nuevoModeloBienes.tabSolvencia.btnMarcarBien.mensajeConfirmacion" text="**¿Seguro que desea marcar la solvencia seleccionada?" />', this.decide, this);
				}
				,decide : function(boton){
					if (boton=='yes') this.marcar();
				}
				,marcar : function(){
					page.webflow({
						 flow : 'plugin/nuevoModeloBienes/clientes/marcarBien'
						,params : {idBien:bienesGrid.getSelectionModel().getSelected().get("id")}
						,success : function(){
							bienesST.webflow({id:"${persona.id}"});	
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
                	,{name:'codigoInterno'}
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
			,pageSize : 20
			,reader : new Ext.data.JsonReader({root : 'bienes'}, bien)
		});
			
		var bienesCm = new Ext.grid.ColumnModel([
		     {header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.id" text="**Id"/>', dataIndex: 'id', hidden: true}
		    <sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
		  	  	,{header: '<s:message code="plugin.nuevoModeloBienes.columnaCodigoInterno" text="**CodInterno"/>', sortable: true, dataIndex: 'codigoInterno'}
		    </sec:authorize>
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
			,{header: '<s:message code="clientes.consultacliente.solvenciaTab.fechaVerificacion" text="**Fecha Verificacióm"/>', dataIndex: 'fechaVerificacion'}
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
				,params : {id : '${persona.id}'}
			});
		};
		var bienesGrid=app.crearGrid(bienesST,bienesCm,{
			title:'<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.title" text="**Bienes"/>'
			,style : 'margin-bottom:10px;padding-right:10px'
	        ,iconCls : 'icon_bienes'
			,height:208
		    ,bbar:new Ext.Toolbar()
			<app:test id="bienesGrid" addComa="true" />
		});
		
		var bandera = 1;
		<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
			bienesGrid.getBottomToolbar().addButton([btnEditarBien]);
			bandera=2;
		</sec:authorize>
		if (bandera=1){
			<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
				bienesGrid.getBottomToolbar().addButton([btnEditarBien]);
			</sec:authorize>
		}
		<sec:authorize ifAllGranted="SOLVENCIA_NUEVO">
			bienesGrid.getBottomToolbar().addButton([btnAgregarBien]);
		</sec:authorize>
		<sec:authorize ifAllGranted="SOLVENCIA_BORRAR">
			bienesGrid.getBottomToolbar().addButton([btnBorrarBien]);
		</sec:authorize>
		
		<%-- FASE 2 --%>
		<sec:authorize ifAllGranted="EDITAR_SOLVENCIA">
			bienesGrid.getBottomToolbar().addButton([btnAgregarBien]);
			bienesGrid.getBottomToolbar().addButton([btnBorrarBien]);
		</sec:authorize>
		
		<sec:authorize ifAllGranted="BOTON_MARCAR_BIENES_PARA_EXTERNOS">
			bienesGrid.getBottomToolbar().addButton(btnMarcarGarantia);
		</sec:authorize>
		
		<sec:authorize ifAllGranted="VERIFICAR_BIEN">
			bienesGrid.getBottomToolbar().addButton(btnVerificarBien);
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
			,bbar:new Ext.Toolbar()			
			
		}
		var ingresosGrid=new Ext.grid.GridPanel(cfgIngresos);
		
		<sec:authorize ifAllGranted="INGRESOS_EDITAR">
			ingresosGrid.getBottomToolbar().addButton([btnAgregarIngreso]);
			ingresosGrid.getBottomToolbar().addButton([btnEditarIngreso]);
			ingresosGrid.getBottomToolbar().addButton([btnBorrarIngreso]);
		</sec:authorize>
		
		<%-- FASE 2 --%>
		<sec:authorize ifAllGranted="EDITAR_SOLVENCIA">
			ingresosGrid.getBottomToolbar().addButton([btnAgregarIngreso]);
			ingresosGrid.getBottomToolbar().addButton([btnEditarIngreso]);
			ingresosGrid.getBottomToolbar().addButton([btnBorrarIngreso]);
		</sec:authorize>
		
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
		//-------
		var panelInferior=new Ext.Panel({
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
					items:ingresosGrid
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
	        <%-- fase 2 --%>
	        <sec:authorize ifAllGranted="EDITAR_SOLVENCIA">	
				btnBorrarBien.disable();
				bienesGrid.on('rowclick',function(grid, rowIndex, e){
					var rec = grid.getStore().getAt(rowIndex);
			        var origen= rec.get('origen');
					if(origen=='Manual'){
						btnBorrarBien.enable();
					} else {
						btnBorrarBien.disable();
					}
				});
			</sec:authorize>
			<%-- Fin --%>
	        <sec:authorize ifAllGranted="SOLVENCIA_BORRAR">	
				btnBorrarBien.disable();
				bienesGrid.on('rowclick',function(grid, rowIndex, e){
					var rec = grid.getStore().getAt(rowIndex);
			        var origen= rec.get('origen');
					if(origen=='Manual'){
						btnBorrarBien.enable();
					} else {
						btnBorrarBien.disable();
					}
				});
			</sec:authorize>
        	bienesGrid.on('rowclick',function(grid, rowIndex, e){
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
                
		ingresoST.webflow({id:"${persona.id}"});
		bienesST.webflow({id:"${persona.id}"});

		panel.add(bienesGrid);
		panel.add(panelInferior);
		
	});
				
	return panel;
})()


