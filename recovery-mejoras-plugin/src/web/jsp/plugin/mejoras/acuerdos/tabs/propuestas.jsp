﻿<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){

	var panel=new Ext.Panel({
		title : '<s:message code="propuestas.titulo" text="**Propuestas"/>'
		,layout:'form'
		,border : false
		/*,layoutConfig: { columns: 1 }*/
		,autoScroll:true
		,bodyStyle:'padding:5px;margin:5px'
		,autoHeight:true
		,autoWidth : true
		,nombreTab : 'acuerdos'
		/*,items : [{items:acuerdosExpTabs
				,border:false
				,style:'margin-top: 7px; margin-left:5px'}
			]*/
	});
	
	var acuerdoSeleccionado = null;
	var indexAcuerdoSeleccionado = null;
	var countTerminos;

	var acuerdo = Ext.data.Record.create([
          {name : 'idAcuerdo'}
         ,{name : 'fechaPropuesta'}
         ,{name : 'solicitante'}
         ,{name : 'estado'}
         ,{name : 'fechaEstado'}
         ,{name : 'codigoEstado'}
         ,{name : 'motivo'}
         ,{name : 'idProponente'}
         ,{name : 'tipoDespachoProponente'}
         ,{name : 'idTipoAcuerdo'}
      ]);

   var cmAcuerdos = new Ext.grid.ColumnModel([
      {header : '<s:message code="acuerdos.codigo" text="**C&oacute;digo" />', dataIndex : 'idAcuerdo',width: 35}
      ,{header : '<s:message code="acuerdos.fechaPropuesta" text="**Fecha Propuesta" />', dataIndex : 'fechaPropuesta',width: 65}
      ,{header : '<s:message code="acuerdos.solicitante" text="**Solicitante" />', dataIndex : 'solicitante',width: 75}
      ,{header : '<s:message code="acuerdos.estado" text="**Estado" />', dataIndex : 'estado',width: 75}
      ,{header : '<s:message code="acuerdos.codigo.estado" text="**Codigo Estado" />',dataIndex : 'codigoEstado', hidden:true, fixed:true,width: 75}
      ,{header : '<s:message code="acuerdos.fechaEstado" text="**Fecha Estado" />', dataIndex : 'fechaEstado',width: 65}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.motivo" text="**Motivo" />', dataIndex : 'motivo',width: 65}
      ,{header : '<s:message code="acuerdos.codigo.idProponente" text="**Id Proponente" />',dataIndex : 'idProponente', hidden:true}
      ,{header : '<s:message code="acuerdos.codigo.tipoDespachoProponente" text="**tipo despacho" />',dataIndex : 'tipoDespachoProponente', hidden:true}
      ,{header : '<s:message code="acuerdos.codigo.idTipoAcuerdo" text="**id tipo acuerdo" />',dataIndex : 'idTipoAcuerdo', hidden:true}
   ]);
   var acuerdosStore = page.getStore({
        flow: 'propuestas/getPropuestasByExpedienteId'
        ,storeId : 'acuerdosStore'
        ,reader : new Ext.data.JsonReader(
            {root:'acuerdos'}
            , acuerdo
        )
   });  

   
   <!--    Desactivamos el boton de proponer si esxisten acuerdos en conformacion, propuesto o aceptado -->
   acuerdosStore.on('load', function () {
   
   		var btnDisbled = false
	    acuerdosStore.data.each(function() {
	    	var codEstad = this.data['codigoEstado'];
	    	if(codEstad == app.codigoAcuerdoEnConformacion || codEstad == app.codigoAcuerdoPropuesto || codEstad == app.codigoAcuerdoAceptado || codEstad == app.codigoAcuerdoVigente){
	    		btnDisbled = true;
	    	}
	    });
	    
	    if(btnDisbled){
	   		btnAltaAcuerdo.setDisabled(true);
	    }else{
	    	btnAltaAcuerdo.setDisabled(false);
	    }
	    
	    
	    if (panel != null){
		    if (acuerdosExpTabs != null){
		    	panel.remove(acuerdosExpTabs);
		    }	
			if (panelAnteriorExpTerminos != null){
				panel.remove(panelAnteriorExpTerminos);
			}
			ocultarBotones();
			despuesDeNuevoAcuerdo();
		}
	});
   
   var despuesDeNuevoAcuerdo = function(){
   		var ultimoRegistro = acuerdosStore.getCount();
   		if(ultimoRegistro > 0){
   			propuestasGrid.getSelectionModel().selectRow((ultimoRegistro-1));
			propuestasGrid.fireEvent('rowclick', propuestasGrid, (ultimoRegistro-1));
			acuerdosStore.un('load',despuesDeNuevoAcuerdo);
   		}
   }
   
   var despuesDeEvento = function(){
   		propuestasGrid.getSelectionModel().selectRow(indexAcuerdoSeleccionado);
		propuestasGrid.fireEvent('rowclick', propuestasGrid, indexAcuerdoSeleccionado);
		acuerdosStore.un('load',despuesDeEvento);
   }

  
   <!-- entidad.cacheStore(acuerdosStore); -->
   
<!--    var btnEditAcuerdo = new Ext.Button({ -->
<%--        text:  '<s:message code="app.editar" text="**Editar" />' --%>
<%--        <app:test id="EditAcuerdoBtn" addComa="true" /> --%>
<!--        ,iconCls : 'icon_edit' -->
<!--        ,cls: 'x-btn-text-icon' -->
<!--        ,handler:function(){ -->
<!--       		alert("Edit"); -->
<!--      	} -->
<!--    }); -->
 
<!--    var cargarUltimoAcuerdo = function(){ -->
<!--    		analisisTab.remove(panelAnterior); -->
<!-- 		panelAnterior = recargarAcuerdo(-2); -->
<!-- 		analisisTab.add(panelAnterior); -->
<!-- 		panel.doLayout(); -->
		
<!--    }; -->


   var btnAltaAcuerdo = new Ext.Button({
       text:  '<s:message code="app.agregar" text="**Agregar" />'
       <app:test id="AltaAcuerdoBtn" addComa="true" />
       ,iconCls : 'icon_mas'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){
      	       var w = app.openWindow({
		          flow : 'propuestas/abreCrearPropuesta'
		          ,closable:false
		          ,width : 750
		          ,title : '<s:message code="app.nuevoRegistro" text="**Nuevo registro" />'
		          ,params : {idExpediente:panel.getExpedienteId(), readOnly:"false"}
		       });
		       w.on(app.event.DONE, function(){
		          acuerdosStore.on('load',despuesDeNuevoAcuerdo);
		          acuerdosStore.webflow({id:panel.getExpedienteId()});
		          w.close();
		       });
		       w.on(app.event.CANCEL, function(){ w.close(); });
     	}
   });
	

   
   var btnProponerAcuerdo = new Ext.Button({
       text:  '<s:message code="acuerdos.proponer" text="**Proponer" />'
       <app:test id="btnProponerAcuerdo" addComa="true" />
       ,iconCls : 'icon_ok'
       ,cls: 'x-btn-text-icon'
       ,hidden:true
       ,handler:function(){
       
       		if (countTerminos > 0){
       		
       		    deshabilitarBotones();
	      	    page.webflow({
	      			flow:"propuestas/proponer"
	      			,params:{
	      				idPropuesta:acuerdoSeleccionado
	   				}
	      			,success: function(){
	           		 	acuerdosStore.on('load',despuesDeEvento);
	           		 	acuerdosStore.webflow({id:panel.getExpedienteId()});
	           		 	btnProponerAcuerdo.hide();
	           		}	
		      	});
				habilitarBotones();	

			}else{
					Ext.Msg.alert('<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.warning" text="**Aviso" />', 
	                    	       '<s:message code="plugin.mejoras.acuerdos.tabPropuestas.propuestas.terminos.grid.warning.ProponerPropuestasSinTerminos" text="**No es posible proponer un acuerdo sin terminos" />');
	        }
     	}
   });
   
   var deshabilitarBotones=function(){
   			btnProponerAcuerdo.disable();
			btnCerrarAcuerdo.disable();
   }
   var habilitarBotones=function(){
   			btnProponerAcuerdo.enable();
			btnCerrarAcuerdo.enable();
   }
   
   var ocultarBotones=function(){
   			btnProponerAcuerdo.hide();
			btnCerrarAcuerdo.hide();
   }
   
   
   var btnCerrarAcuerdo = new Ext.Button({
       text:  '<s:message code="acuerdos.cerrar" text="**Cerrar" />'
       <app:test id="btnCerrarAcuerdo" addComa="true" />
       ,iconCls : 'icon_menos'
       ,cls: 'x-btn-text-icon'
       ,hidden:true
       ,handler:function(){
	   		deshabilitarBotones();
      	    page.webflow({
      			flow:"acuerdos/finalizarAcuerdo"
      			,params:{
      				idAcuerdo:acuerdoSeleccionado
   				}
      			,success: function(){
           		 	acuerdosStore.on('load',despuesDeEvento);
           		 	acuerdosStore.webflow({id:panel.getExpedienteId()});
					btnCerrarAcuerdo.hide();
           		}	
	      	});	
			habilitarBotones();
     	}
   });
   
   


    function processResult(opt, text){
       if(opt == 'cancel'){
	      //Nada
	   }
	   if(opt == 'ok'){
	   	   deshabilitarBotones();
	       page.webflow({
      			flow:'mejacuerdo/rechazarAcuerdoMotivo'
      			,params:{
      				idAcuerdo:acuerdoSeleccionado
      				,motivo: text
   				}
   				,success: function(){
	   				acuerdosStore.on('load',despuesDeEvento);
		   		 	acuerdosStore.webflow({id:panel.getExpedienteId()});
		   		 	btnCerrarAcuerdo.hide();
   		 		}
	      	});	
      		habilitarBotones();
	   }
	}
	
	
	var propuestasGrid = app.crearGrid(acuerdosStore,cmAcuerdos,{
         title : '<s:message code="propuestas.grid.titulo" text="**Propuestas" />'
         <app:test id="propuestasGrid" addComa="true" />
         ,style:'padding-right:10px'
         ,autoHeight : true
         ,cls:'cursor_pointer'
         ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})

         ,bbar : [
         	btnAltaAcuerdo,
          	btnProponerAcuerdo,
     	   	btnCerrarAcuerdo,
	      ]

	}); 

<!-- 	var reload = function(){ -->
<!-- 		if (analisisTab != null){ -->
<!-- 			analisisTab.remove(panelAnterior); -->
<!-- 		} -->
<!-- 		panelAnterior = recargarAcuerdo(acuerdoSeleccionado); -->
		
<!-- 		if (analisisTab !=null) { -->
<!-- 			analisisTab.add(panelAnterior); -->
<!-- 		} -->
<!-- 		panel.doLayout(); -->
<!-- 		acuerdosStore.webflow({id:panel.getExpedienteId()}); -->
<!-- 	} -->
	
<!-- 	/* -->
<!-- 	var reloadTerminos = function(){ -->
<!-- 		panel.remove(panelAnteriorExpTerminos); -->

<!-- 		panelAnteriorExpTerminos = recargarAcuerdo(acuerdoSeleccionado); -->
<!-- 		panel.add(panelAnteriorExpTerminos); -->
<!-- 		panel.doLayout(); -->
<!-- 		acuerdosStore.webflow({id:panel.getExpedienteId()}); -->
<!-- 	} -->
<!-- 	*/ -->
	
	panel.add(propuestasGrid);


	// Variables para las pestañas de análisis y términos
	var analisisTab;	
	var terminosExpTab;
	var acuerdosExpTabs;                                                                                                                                                       

	//Comienzan las 4 partes dependientes del acuerdo	
	var panelAnterior;
	var panelAnteriorExpTerminos;
	var cumplimientoAcuerdo;
	
	
	propuestasGrid.on('rowclick', function(grid, rowIndex, e) {


				panel.remove(acuerdosExpTabs);	
				panel.remove(panelAnteriorExpTerminos); 

				terminosExpTab = new Ext.Panel({
					title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos" text="**Términos"/>'
					,id:'expediente-terminosTabs-'+entidad.get("data").id
					,autoHeight:true
					,autoWidth: true
				});
				
				acuerdosExpTabs = new Ext.TabPanel({
					id:'expediente-acuerdosTabs'+entidad.get("data").id
					,items:[
						terminosExpTab
					]
					,autoHeight:true
					,autoWidth : true
					,border: true
				  });     
				
				var rec = grid.getStore().getAt(rowIndex);
				var idAcuerdo = rec.get('idAcuerdo');
				var idProponente = rec.get('idProponente');
				var codigoEstado = rec.get('codigoEstado');
				var noPuedeModificar = true;
				acuerdoSeleccionado = idAcuerdo;
				
				
				if((idProponente == panel.getUsuarioLogado() || panel.esGestorSupervisorActual()) && codigoEstado == app.codigoAcuerdoEnConformacion){
					btnProponerAcuerdo.setVisible(true);
				}

				if(panel.esGestorSupervisorActual() || (idProponente == panel.getUsuarioLogado() && codigoEstado == app.codigoAcuerdoEnConformacion)){
					noPuedeModificar = false;
				}
				
				panelAnteriorExpTerminos = recargarAcuerdoTerminos(idAcuerdo,noPuedeModificar);
	    		terminosExpTab.add(panelAnteriorExpTerminos); 
	    		
	    		acuerdosExpTabs.setActiveTab(terminosExpTab);
	    		acuerdosExpTabs.setHeight('auto');
	    		
	    		panel.add(acuerdosExpTabs);
				panel.doLayout();
				panel.show();
		
	});
   
	//fin 4 partes

<!-- 	var recargarAcuerdo = function(idAcuerdo){ -->
<%-- 		var url = '/${appProperties.appName}/acuerdos/detalleAcuerdo.htm', --%>
<!-- 		config = config || {}; -->
<!-- 		var autoLoad = {url : url+"?"+Math.random() -->
<!-- 				,scripts: true -->
<!-- 				,params: {id:idAcuerdo,idAsunto:panel.getExpedienteId()} -->
<!-- 				}; -->
<!-- 		var cfg = { -->
<!-- 			autoLoad : autoLoad -->
<!-- 			,border:false -->
<!-- 			,bodyStyle:'padding:5px' -->
<!-- 			,defaults:{ -->
<!--             	border:false             -->
<!--         		} -->
<!-- 		}; -->
<!-- 		var panel2 = new Ext.Panel(cfg); -->



<!-- 		panel2.show(); -->
<!-- 		panel2.on(app.event.DONE, function(){ -->
<!-- 		          reload(); -->
<!-- 		       }); -->
<!-- 		return panel2 -->


<!-- 	}; -->

	
	var recargarAcuerdoTerminos = function(idAcuerdo,noPuedeModificar){
		
		<%@ include file="/WEB-INF/jsp/plugin/mejoras/acuerdos/detalleTerminos.jsp" %>

		var panTerminosExp = crearTerminosAsuntos(noPuedeModificar,true);

		return panTerminosExp;
		
	};	
	
	
	panel.getValue = function(){
		var estado = entidad.get("acuerdos");
		rowsSelected = propuestasGrid.getSelectionModel().getSelections();
		if (rowsSelected != ''){
			return { 
				idAcuerdo : rowsSelected[0].get('idAcuerdo')
			}
		} else {
			if (estado){
				return { 
					idAcuerdo : estado.idAcuerdo
				}
			}
		}
	}
	
	panel.setValue = function(){
		var data = entidad.get("data");
		entidad.cacheOrLoad(data,acuerdosStore, {id : data.id });
	}

	panel.getExpedienteId = function(){
		return entidad.get("data").id;
	}

	panel.esSupervisor = function(){
		return entidad.get("data").toolbar.esSupervisor;
	}

	panel.esGestor = function(){
		return entidad.get("data").toolbar.esGestor;
	}
	
	panel.getUsuarioLogado = function(){
		return entidad.get("data").usuario.id;
	}
	
	panel.esGestorSupervisorActual = function(){
		return entidad.get("data").esGestorSupervisorActual;
	}

	return panel;
})