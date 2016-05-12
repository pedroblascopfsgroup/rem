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
         ,{name : 'fechaLimite'}
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
      ,{header : '<s:message code="acuerdos.fechaLimite" text="**Fecha Límite" />', dataIndex : 'fechaLimite',width: 65}
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

   
   <%--    Desactivamos el boton de proponer si esxisten acuerdos en conformacion, propuesto o aceptado --%>
   acuerdosStore.on('load', function () {
		
		if( (panel.getEstadoExpediente() != app.estExpediente.ESTADO_ACTIVO && panel.getEstadoExpediente() != app.estExpediente.ESTADO_CONGELADO)||
			(panel.getFaseActualExpediente() == app.estItinerario.ESTADO_DECISION_COMITE && !panel.esGestorSupervisorActual())||
			(panel.getFaseActualExpediente() == app.estItinerario.ESTADO_FORMALIZAR_PROPUESTA))
		  {
		  	btnAltaAcuerdo.setDisabled(true);
		  } else {
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
			
			///Primer carga de la pestaña o nuevo acuerdo
			if(indexAcuerdoSeleccionado == null){
				despuesDeNuevoAcuerdo();
			}
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
		          acuerdosStore.webflow({id:panel.getExpedienteId()});
		          acuerdosStore.on('load',despuesDeNuevoAcuerdo);
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
	      				ocultarBotones();
	           		 	acuerdosStore.webflow({id:panel.getExpedienteId()});
	           		 	acuerdosStore.on('load',despuesDeEvento);
	           		}	
		      	});
				habilitarBotones();	

			}else{
					Ext.Msg.alert('<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.warning" text="**Aviso" />', 
	                    	       '<s:message code="plugin.mejoras.acuerdos.tabPropuestas.propuestas.terminos.grid.warning.ProponerPropuestasSinTerminos" text="**No es posible proponer un acuerdo sin terminos" />');
	        }
     	}
   });

   	var btnCancelarAcuerdo = new Ext.Button({
	       text:  '<s:message code="acuerdos.cancelar" text="**Cancelar" />'
	       <app:test id="btnCancelarAcuerdo" addComa="true" />
	       ,iconCls : 'icon_menos'
	       ,cls: 'x-btn-text-icon'
	       ,hidden:true
	       ,handler:function(){
	      	    deshabilitarBotones();
	      	    page.webflow({
	      			flow:"propuestas/cancelar"
	      			,params:{
	      				idPropuesta:acuerdoSeleccionado
	   				}
	      			,success: function(){
	           		 	ocultarBotones();
	           		 	acuerdosStore.webflow({id:panel.getExpedienteId()});
	           		 	acuerdosStore.on('load',despuesDeEvento);
	           		}
		      	});
				habilitarBotones();
	     	}
	});

	var btnRegistrarFinalizacionAcuerdo = new Ext.Button({
		text:  '<s:message code="plugin.mejoras.acuerdo.registrarFinalizacion" text="**Registrar finalización acuerdo" />'
		<app:test id="btnRegistrarFinalizacionAcuerdo" addComa="true" />
		,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,hidden:true
		,handler:function() {
			var w = app.openWindow({
				flow : 'propuestas/abrirFinalizacion'
				,closable:false
				,width : 750
				,title : '<s:message code="mejoras.plugin.acuerdos.finalizarAcuerdo" text="**Finalizar acuerdo" />'
				,params : {idAcuerdo: acuerdoSeleccionado}
			});

			w.on(app.event.DONE, function(){
				acuerdosStore.webflow({id:panel.getExpedienteId()});
				acuerdosStore.on('load',despuesDeEvento);
				btnRegistrarFinalizacionAcuerdo.hide();
				w.close();
			});

			w.on(app.event.CANCEL, function(){
				w.close();
			});
		}
	});
	
	var btnCumplimientoAcuerdo = new Ext.Button({
		text:  '<s:message code="plugin.mejoras.acuerdo.cumplimiento" text="**Cumplimiento acuerdo" />'
		<app:test id="CumplimientoAcuerdoBtn" addComa="true" />
		,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,hidden:true
		,handler:function(){
      		var w = app.openWindow({
		          flow : 'propuestas/openCumplimientoPropuesta'
		          ,closable:false
		          ,width : 580
		          ,title : '<s:message code="mejoras.plugin.acuerdos.completaAcuerdo" text="**Cumplimiento acuerdo" />'
		          ,params : {idPropuesta:acuerdoSeleccionado}
		       });
		       w.on(app.event.DONE, function(){
		          	acuerdosStore.webflow({id:panel.getAsuntoId()});
		          w.close();
		       });
		       w.on(app.event.CANCEL, function(){ w.close(); });
     	}
	});

	
	var btnRechazarAcuerdo = new Ext.Button({
       text:  '<s:message code="acuerdos.rechazar" text="**Rechazar" />'
       <app:test id="btnRechazarAcuerdo" addComa="true" />
       ,iconCls : 'icon_menos'
       ,cls: 'x-btn-text-icon'
       ,hidden:true
       ,handler:function(){
      	       var w = app.openWindow({
		          flow : 'propuestas/rechazarAcuerdo'
		          ,closable:false
		          ,width : 750
		          ,title : '<s:message code="app.nuevoRegistro" text="**Nuevo registro" />'
		          ,params : {idAcuerdo:acuerdoSeleccionado, readOnly:"false"}
		       });
		       w.on(app.event.DONE, function(){
		          acuerdosStore.webflow({id:panel.getExpedienteId()});
		          acuerdosStore.on('load',despuesDeNuevoAcuerdo);
		          w.close();
		       });
		       w.on(app.event.CANCEL, function(){ w.close(); });
     	}      
	});

   var deshabilitarBotones=function(){
   			btnProponerAcuerdo.disable();
   			btnCancelarAcuerdo.disable();
   			btnRechazarAcuerdo.disable();
   			btnRegistrarFinalizacionAcuerdo.disable();
   			btnCumplimientoAcuerdo.disable();
   }
   var habilitarBotones=function(){
   			btnProponerAcuerdo.enable();
   			btnCancelarAcuerdo.enable();
   			btnRechazarAcuerdo.enable();
   			btnRegistrarFinalizacionAcuerdo.enable();
   			btnCumplimientoAcuerdo.disable();
   }
   
   var ocultarBotones=function(){
   			btnProponerAcuerdo.hide();
   			btnCancelarAcuerdo.hide();
   			btnRechazarAcuerdo.hide();
   			btnRegistrarFinalizacionAcuerdo.hide();
   			btnCumplimientoAcuerdo.disable();
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
          	btnCancelarAcuerdo,
     	   	btnRegistrarFinalizacionAcuerdo,
          	btnRechazarAcuerdo,
          	btnCumplimientoAcuerdo
	      ]

	}); 
	
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
	
				ocultarBotones();

				panel.remove(acuerdosExpTabs);	
				panel.remove(panelAnteriorExpTerminos); 

				terminosExpTab = new Ext.Panel({
					title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos" text="**Solucion"/>'
				
					,id:'expediente-terminosTabs-'+entidad.get("data").id
					,autoHeight:true
					,autoWidth: true
				});
				
				acuerdosExpTabs = new Ext.TabPanel({
					id:'expediente-acuerdosTabs'+entidad.get("data").id
					,items:[
						terminosExpTab
					]
					,style:'padding-right:10px;margin-top: 20px;'
					,autoHeight:true
					,autoWidth : true
					,border: true
				  });     
				
				var rec = grid.getStore().getAt(rowIndex);
				var idAcuerdo = rec.get('idAcuerdo');
				var idProponente = rec.get('idProponente');
				var codigoEstado = rec.get('codigoEstado');
				var noPuedeModificar = true;
				var noPuedeEditarEstadoGestion = true;
				indexAcuerdoSeleccionado = rowIndex;
				acuerdoSeleccionado = idAcuerdo;
				
				
				if((idProponente == panel.getUsuarioLogado() || panel.esGestorSupervisorActual()) && codigoEstado == app.codigoAcuerdoEnConformacion){
					btnProponerAcuerdo.setVisible(true);
				}

				if((panel.esGestorSupervisorActual() && codigoEstado != app.codigoAcuerdoRechazado && codigoEstado != app.codigoAcuerdoCancelado && codigoEstado != app.codigoAcuerdoFinalizado &&  codigoEstado != app.codigoAcuerdoIncumplido && codigoEstado != app.codigoAcuerdoCumplido) || (idProponente == panel.getUsuarioLogado() && codigoEstado == app.codigoAcuerdoEnConformacion)){
					noPuedeModificar = false;
				}
				
				if(idProponente == panel.getUsuarioLogado() && codigoEstado == app.codigoAcuerdoEnConformacion){
					btnCancelarAcuerdo.setVisible(true);
				}
				
				if(panel.getFaseActualExpediente() == app.estItinerario.ESTADO_FORMALIZAR_PROPUESTA){
					noPuedeEditarEstadoGestion = false;
					if(panel.getFaseActualExpediente()){
						noPuedeModificar = false;
					}else{
						noPuedeModificar = true
					}
				}
				
				if((panel.getFaseActualExpediente() == app.estItinerario.ESTADO_REVISAR_EXPEDIENTE && codigoEstado == app.codigoAcuerdoPropuesto && panel.esGestorSupervisorActual()) ||
				   (panel.getFaseActualExpediente() == app.estItinerario.ESTADO_DECISION_COMITE && codigoEstado == app.codigoAcuerdoAceptado && panel.esGestorSupervisorActual()))
				{
					btnRechazarAcuerdo.setVisible(true);
				}
				
				var estadoVigente = false;
				
				if(panel.getFaseActualExpediente() == app.estItinerario.ESTADO_FORMALIZAR_PROPUESTA && panel.esGestorSupervisorActual() && codigoEstado == app.codigoAcuerdoVigente){
					btnRegistrarFinalizacionAcuerdo.setVisible(true);
					estadoVigente = true;
				}

				
				
				panelAnteriorExpTerminos = recargarAcuerdoTerminos(idAcuerdo,noPuedeModificar, noPuedeEditarEstadoGestion);
	    		terminosExpTab.add(panelAnteriorExpTerminos); 
	    		
	    		acuerdosExpTabs.setActiveTab(terminosExpTab);
	    		acuerdosExpTabs.setHeight('auto');
	    		
	    		var store = panelAnteriorExpTerminos.terminosAcuerdoGrid.getStore();
	    		
	    		btnCumplimientoAcuerdo.setVisible(false);
	    		
	    		store.on('load', function(){  
					for (var i=0; i < store.data.length; i++) {
						datos = store.getAt(i);
						if(datos.get('codigoTipoAcuerdo') == "PLAN_PAGO"){
							if(Boolean(estadoVigente)){
								btnCumplimientoAcuerdo.setVisible(true);
							}
							cumplimientoAcuerdo = recargarCumplimientoAcuerdo(idAcuerdo);
							terminosExpTab.add(cumplimientoAcuerdo);
							
						}
					}
					
		    		panel.add(acuerdosExpTabs);
					panel.doLayout();
					panel.show();
					
			   	});
		
	});

	
	var recargarAcuerdoTerminos = function(idAcuerdo,noPuedeModificar,noPuedeEditarEstadoGestion){
		
		<%@ include file="/WEB-INF/jsp/plugin/mejoras/acuerdos/detalleTerminos.jsp" %>

		var panTerminosExp = crearTerminosAsuntos(noPuedeModificar,true,noPuedeEditarEstadoGestion);

		return panTerminosExp;
		
	};	
	
	var recargarCumplimientoAcuerdo = function(idAcuerdo){
		<%@ include file="/WEB-INF/jsp/plugin/mejoras/acuerdos/listadoCumplimientoAcuerdo.jsp" %>	
		var cumplimiento = crearCumplimiento(idAcuerdo);
		return cumplimiento;
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
		return entidad.get("data").esSupervisor;
	}

	panel.esGestor = function(){
		return entidad.get("data").esGestor;
	}
	
	panel.getUsuarioLogado = function(){
		return entidad.get("data").usuario.id;
	}
	
	panel.esGestorSupervisorActual = function(){
		return entidad.get("data").esGestorSupervisorActual;
	}
	
	panel.getFaseActualExpediente = function(){
		return entidad.get("data").gestion.estadoItinerario;
	}
	
	panel.getEstadoExpediente = function(){
		return entidad.get("data").toolbar.estadoExpediente;	
	}

	panel.setVisibleTab = function(data){
		var visible = entidad.get("data").toolbar.tipoExpediente != 'REC';
		<sec:authorize ifAnyGranted="PERSONALIZACION-BCC, PERSONALIZACION-HY">
			if(entidad.get("data").toolbar.tipoExpediente == 'RECU' || entidad.get("data").toolbar.tipoExpediente === 'GESDEU'){
				visible = true;
			}else{
				visible = false;
			}
		</sec:authorize>
		return visible;
   	}
   	
	return panel;
})
