<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<fwk:page>
	var style='margin-bottom:1px;margin-top:1px;width:250px';
	var labelStyle='font-weight:bolder;margin-bottom:1px;margin-top:1px;';
	var labelStyle2='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:30px';
	
	var cambioGestor=false;
	var cambioSupervisor=false;
	
	<c:if test="${cambioGestor!=null}">
		cambioGestor=true;
	</c:if> 
	<c:if test="${cambioSupervisor!=null}">
		cambioSupervisor=true;
	</c:if> 
	
	var txtNombreAsunto = app.creaText('asunto',
		'<s:message code="edicionAsunto.asunto" text="**Asunto" />',
		<c:if test="${asuntoEditar!=null}" >
			'<s:message text="${asuntoEditar.nombre}" javaScriptEscape="true" />',
		</c:if>
		<c:if test="${asuntoEditar==null}" >
			'<s:message text="${expediente.descripcionExpediente}" javaScriptEscape="true" />',			
		</c:if>
		{style:style,labelStyle:labelStyle,disabled:cambioGestor||cambioSupervisor});
		
	/*Jerarquía*/
	var zonas=<app:dict value="${zonas}" />;
	var jerarquia = <app:dict value="${niveles}" blankElement="true" blankElementValue="" blankElementText="---" />;
	
	var comboJerarquia = app.creaCombo({
		triggerAction: 'all'
		,disabled:cambioGestor||cambioSupervisor
		,labelStyle:labelStyle
		,autoWidth:true
		,style:style 
		,data:jerarquia
		,value:jerarquia.diccionario[0].codigo
		,name : 'jerarquia'
		,fieldLabel : '<s:message code="menu.clientes.listado.filtro.jerarquia" text="**Jerarquia" />'});
	              
    var zonasRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
    
    var optionsZonasStore = page.getStore({
	       flow: 'clientes/buscarAllZonas'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, zonasRecord)
	       
	});
    
    
	var comboZonas = app.creaDblSelect(zonas, '<s:message code="menu.clientes.listado.filtro.centro" text="**Centro" />',{store:optionsZonasStore, funcionReset:recargarComboZonas,disabled:cambioGestor||cambioSupervisor,labelStyle:labelStyle2});
	/*Fin jerarquia*/

	var recargarCombosGestoresProcuradores=function(){
		if(comboZonas.getValue()!=''){
			//recargar combo despachos externos
			optionsDespachosStore.webflow({
				zonas:comboZonas.getValue()
				,tipoDespacho:'<fwk:const value="es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO" />'
			});
			//recargar combo despachos procuradores
			optionsDespachosProcuradoresStore.webflow({
				zonas:comboZonas.getValue()
				,tipoDespacho:'<fwk:const value="es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno.CODIGO_DESPACHO_PROCURADOR" />'
			});
			comboDespachosExternos.clearValue();
			comboDespachosProcuradores.clearValue();
			comboGestores.clearValue();
			comboSupervisores.clearValue();
			comboProcuradores.clearValue();
		}	
	}
	comboZonas.on('change',function(){
		
	});
	var recargarComboZonas = function(){
		if (comboJerarquia.getValue()!=null && comboJerarquia.getValue()!=''){
			optionsZonasStore.webflow({id:comboJerarquia.getValue()});
		}else{
			optionsZonasStore.webflow({id:0});
			comboZonas.setValue('');
			optionsZonasStore.removeAll();
		}
	}
	
	var limpiarYRecargar = function(){
		app.resetCampos([comboZonas]);
		recargarComboZonas();
	}
	
	comboJerarquia.on('select',limpiarYRecargar);
	
	recargarComboZonas();	
	
	var despachosRecord = Ext.data.Record.create([
		 {name:'id'}
		,{name:'tipo'}
		,{name:'codigo'}
		,{name:'nombre'}
	]);
    
    var optionsDespachosStore = page.getStore({
	       flow: 'asuntos/buscarDespachosPorZona'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'despachos'
	    }, despachosRecord)
	       
	});
	var comboDespachosExternos = new Ext.form.ComboBox({
				store:optionsDespachosStore
				,displayField:'nombre'
				,valueField:'codigo'
				,mode: 'local'
				,editable: false	
				,autoWidth:true
				,resizable: true			
				,triggerAction: 'all'
				,emptyText:'---'
				,labelStyle:labelStyle
				,disabled:cambioGestor||cambioSupervisor
				,style:style
				,fieldLabel : '<s:message code="asuntos.alta.despacho" text="**Despacho"/>'
				<c:if test="${asuntoEditar!=null}" >
					,value:'${asuntoEditar.gestor.despachoExterno.id}'
				</c:if>
				<app:test id="comboDespachosAA" addComa="true"/>
	});	
	comboDespachosExternos.on('focus',recargarCombosGestoresProcuradores);	
	
	var optionsDespachosProcuradoresStore = page.getStore({
	       flow: 'asuntos/buscarDespachosPorZona'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'despachos'
	    }, despachosRecord)
	       
	});
	var comboDespachosProcuradores = new Ext.form.ComboBox({
				store:optionsDespachosProcuradoresStore
				,displayField:'nombre'
				,valueField:'codigo'
				,mode: 'local'
				,editable: false	
				,autoWidth:true
				,resizable: true			
				,triggerAction: 'all'
				,labelStyle:labelStyle
				,emptyText:'---'
				,allowBlank:true
				,disabled:cambioSupervisor
				,style:style
				,fieldLabel : '<s:message code="asuntos.alta.despacho" text="**Despacho"/>'
				<c:if test="${asuntoEditar!=null}" >
					,value:'${asuntoEditar.procurador.despachoExterno.id}'
				</c:if>
	});
	
	<c:if test="${appProperties.runInSelenium==false}">
		// Si estamos corriendo tests selenium esta función debe ser global para que
		// pueda ser llamada desde el JUnit 
		var</c:if> recargarComboGestores = function(){
		optionsGestoresStore.webflow({id:comboDespachosExternos.getValue()});
		optionsSupervisoresStore.webflow({id:comboDespachosExternos.getValue()});
		comboGestores.enable();
		comboGestores.focus();
		comboSupervisores.enable();
	}
	
	var recargarComboProcuradores = function(){
		optionsProcuradoresStore.webflow({id:comboDespachosProcuradores.getValue()});
		comboProcuradores.enable();
		comboProcuradores.focus();
	}
	
	var bloquearComboGestores = function(){
		comboGestores.disable();
		comboGestores.reset();
		comboSupervisores.disable();
		comboSupervisores.reset();
		
	}
	
	comboDespachosExternos.on('focus',bloquearComboGestores);
	
	comboDespachosExternos.on('select',recargarComboGestores);
	
	//not yet
	//comboDespachosProcuradores.on('focus',bloquearComboGestores);
	
	
	comboDespachosProcuradores.on('select',recargarComboProcuradores);
	
	
	var Procurador = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var optionsProcuradoresStore = page.getStore({
	       flow: 'asuntos/buscarGestores'
	      // ,params: {id:comboDespachosExternos.getValue()}
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'gestores'
	    }, Procurador)
	       
	});
	
	var comboProcuradores = new Ext.form.ComboBox({
				store:optionsProcuradoresStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,forceSelection:true 
				,disabled:true
				,mode: 'remote'
				,autoWidth:true
				,resizable: true			
				,emptyText:'---'
				,triggerAction: 'all'
				,editable: false
				,labelStyle:labelStyle
				,style:style
				,disabled:true
				,fieldLabel : '<s:message code="asuntos.alta.gestor" text="**Gestor"/>'
				,name: 'comboGestores'
				<app:test id="comboGestoresAA" addComa="true"/>
				
	});
	
	
	var Gestor = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var optionsGestoresStore = page.getStore({
	       flow: 'asuntos/buscarGestores'
	      // ,params: {id:comboDespachosExternos.getValue()}
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'gestores'
	    }, Gestor)
	       
	});
	
	var comboGestores = new Ext.form.ComboBox({
				store:optionsGestoresStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,forceSelection:true 
				,disabled:true
				,mode: 'remote'
				,autoWidth:true
				,resizable: true			
				,emptyText:'---'
				,triggerAction: 'all'
				,editable: false
				,labelStyle:labelStyle
				,style:style
				,disabled:!cambioGestor
				,fieldLabel : '<s:message code="asuntos.alta.gestor" text="**Gestor"/>'
				,name: 'comboGestores'
				<app:test id="comboGestoresAA" addComa="true"/>
				
	});


	var labelTipoGestor = new Ext.form.Label({
		text:'[Externo]'
		,style:'valgin:center'
	});
	
	var optionsSupervisoresStore = page.getStore({
	       flow: 'asuntos/buscarSupervisoresDespachos'
	      // ,params: {id:comboDespachosExternos.getValue()}
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'gestores'
	    }, Gestor)
	       
	});
	
	var comboSupervisores = new Ext.form.ComboBox({
				store:optionsSupervisoresStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,forceSelection:true 
				,disabled:true
				,emptyText:'---'
				,autoWidth:true
				,resizable: true			
				,mode: 'remote'
				,triggerAction: 'all'
				,editable: false
				,labelStyle:labelStyle
				,style:style
				,disabled:!cambioSupervisor
				,fieldLabel : '<s:message code="asuntos.alta.supervisor" text="**Supervisor"/>'
				,name: 'comboSupervisores'
				<app:test id="comboSupervisoresAA" addComa="true"/>
	});
	
	<c:if test="${asuntoEditar!=null}" >
		var setGestorValue = function(){
			comboGestores.setValue('${asuntoEditar.gestor.id}');
			comboGestores.setDisabled(cambioSupervisor)
			optionsGestoresStore.un('load',setGestorValue);
		}
	
		var setSupervisorValue = function(){
			comboSupervisores.setValue('${asuntoEditar.supervisor.id}');
			if(cambioGestor)
				comboSupervisores.disable();
			else
				comboSupervisores.enable();
			optionsSupervisoresStore.un('load',setSupervisorValue);
		}
		var setProcuradorValue = function (){
			comboProcuradores.setValue('${asuntoEditar.procurador.id}');
			comboProcuradores.setDisabled(cambioSupervisor);
			optionsProcuradoresStore.un('load',setProcuradorValue);
		}
		var setDespachoExternoValue = function(){
			comboDespachosExternos.setValue('${asuntoEditar.gestor.despachoExterno.id}');
			comboDespachosExternos.setDisabled(cambioSupervisor || cambioGestor);
			optionsDespachosStore.un('load',setDespachoExternoValue);	
		}
		var setDespachoProcuradorValue=function(){
			comboDespachosProcuradores.setValue('${asuntoEditar.procurador.despachoExterno.id}');
			comboDespachosProcuradores.setDisabled(cambioSupervisor);
			optionsDespachosProcuradoresStore.un('load',setDespachoProcuradorValue);
		}
		optionsGestoresStore.on('load',setGestorValue);
		optionsSupervisoresStore.on('load',setSupervisorValue);
		optionsDespachosProcuradoresStore.on('load',setDespachoProcuradorValue);
		optionsProcuradoresStore.on('load',setProcuradorValue);
		optionsDespachosStore.on('load',setDespachoExternoValue);
		//recargar combo despachos externos
		optionsDespachosStore.webflow({
			zonas:'${asuntoEditar.gestor.despachoExterno.zona.codigo}'
			,tipoDespacho:'<fwk:const value="es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO" />'
		})
		<c:if test="${asuntoEditar.procurador!=null}" >
		//recargar combo despachos procuradores, si el asunto tiene procurador
		optionsDespachosProcuradoresStore.webflow({
			zonas:'${asuntoEditar.procurador.despachoExterno.zona.codigo}'
			,tipoDespacho:'<fwk:const value="es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno.CODIGO_DESPACHO_PROCURADOR" />'
		});
		optionsProcuradoresStore.webflow({
			id: '${asuntoEditar.procurador.despachoExterno.codigo}'
		});
		</c:if>
		optionsGestoresStore.webflow({id:${asuntoEditar.gestor.despachoExterno.id}});
		optionsSupervisoresStore.webflow({id:${asuntoEditar.gestor.despachoExterno.id}});
		
	</c:if>
	

	
	
	var tituloobservaciones = new Ext.form.Label({
   		text:'<s:message code="clientes.umbral.observaciones" text="**Observaciones" />'
		,style:'font-weight:bolder; font-size:11'
	}); 
	var observaciones = new Ext.form.TextArea({
		fieldLabel:'<s:message code="clientes.umbral.observaciones" text="**Observaciones" />'
		,width:810
		//,hideLabel:true
		,height:200
		,labelSeparator:''
		,labelStyle:labelStyle
		,disabled:cambioGestor||cambioSupervisor
		<c:if test="${asuntoEditar!=null}" >
			,value:'<s:message text="${asuntoEditar.observacion}" javaScriptEscape="true" />'
		</c:if>	
		<app:test id="observaciones" addComa="true"/>	
	});
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			
			page.submit({
				formPanel: panelAlta
				,eventName : 'saveAsunto'
				,params: {
					idGestor:comboGestores.getValue() 
					,idSupervisor:comboSupervisores.getValue()
					,nombreAsunto:txtNombreAsunto.getValue()
                    <c:if test="${idExpediente!=null}" >
					   ,idExpediente:${idExpediente}
                    </c:if>     
					,observaciones:observaciones.getValue()
					<c:if test="${asuntoEditar!=null}" >
						,idAsunto: ${asuntoEditar.id}
					</c:if>
					,idProcurador:comboProcuradores.getValue()					
				}
				,success :  function(){ 
                  				page.fireEvent(app.event.DONE);
                  			}
			});
		}
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});

	var panelDespachosGestores=new Ext.Panel({
		layout:'table'
		,layoutConfig:{columns:3}
		,autoHeight:true
		,border:false
		,style:'padding-left:10px'
		,cellCls:'vtop'
		,width:900
		,defaults:{xtype:'fieldset',height:120}
		,items:[
			{
				title:'<s:message code="asuntos.despachoExterno" text="**Despacho Externo" />'
				,items:[comboDespachosExternos,comboGestores,comboSupervisores]
			}
			,{
				border:false
				,style:'width:5px'
			},
			{
				title:'<s:message code="asuntos.despachoProcurador" text="**Despacho Procurador" />'
				,items:[comboDespachosProcuradores,comboProcuradores]
			}
		]
	});
	var panelAlta = new Ext.form.FormPanel({
		bodyStyle : 'padding-left:5px;padding-top:5px'
		,layout:'anchor'
		,autoHeight : true
		,defaults:{
			border:false
		}
		,items : [
		 	{ xtype : 'errorList', id:'errL' }
		 	,{
		 		autoHeight:true
		 		,border:false
		 		,defaults:{border:false,xtype:'fieldset',autoHeight:true}
		 		,items:[ 
		 			{
						layout:'table'
						,layoutConfig:{columns:3}
						,autoHeight:true
						,border:false
						,style:'padding-left:10px'
						,cellCls:'vtop'
						,width:900
						,defaults:{xtype:'fieldset',border:false,autoHeight:true}
						,items:[
							{
								items:[txtNombreAsunto,comboJerarquia]
							//}
							//,{
							//	style:'width:5px'
							},
							{
								items:[comboZonas]
								,style:'padding:5px'
							}
						]
					}
					,panelDespachosGestores
		 			,{
						items:[observaciones]
						,labelAlign:'top'
					}
		 		]
		 	}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});
	//Cargo el combo de Despachos de procuraores si se hace un cambio de gestor
	panelAlta.on('afterrender',function(){
		if (cambioGestor) {
			//recargar combo despachos procuradores
			optionsDespachosProcuradoresStore.webflow({
				//asuntoEditar.comite.zona.codigo
				zonas: '${asuntoEditar.comite.zona.codigo}',
				tipoDespacho: '<fwk:const value="es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno.CODIGO_DESPACHO_PROCURADOR" />'
			});
			comboDespachosProcuradores.reset();
			comboDespachosExternos.reset();
			
		};
	
	});
	page.add(panelAlta);

</fwk:page>