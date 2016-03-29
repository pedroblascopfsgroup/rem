﻿<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%--JSP creado como copia de acuerdos.jsp con algun cambio
	para mostrar acuerdos dentro de la cabecera de los asuntos de tipo acuerdo --%>
	
	var panelAcu=new Ext.Panel({
		layout:'form'
		,border : false
		,autoScroll:true
		,bodyStyle:'padding:0px;margin:0px'
		,autoHeight:true
		,autoWidth : true
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
 
   var acuerdosStoreAcu = page.getStore({
        flow: 'plugin/mejoras/acuerdos/plugin.mejoras.acuerdos.acuerdosAsunto'
        ,storeId : 'acuerdosStoreAcu'
        ,reader : new Ext.data.JsonReader(
            {root:'acuerdos'}
            , acuerdo
        )
   });  
   
   
   <%--    Desactivamos el boton de proponer si esxisten acuerdos en conformacion, propuesto o aceptado --%>
   acuerdosStoreAcu.on('load', function () {
   		var btnDisbled = false
	    acuerdosStoreAcu.data.each(function() {
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
	    
	    
	    if (panelAcu != null){
		    if (acuerdosTabs != null){
		    	panelAcu.remove(acuerdosTabs);
		    }	
			if (panelAnterior != null){
				panelAcu.remove(panelAnterior);
			}
			if (panelAnteriorTerminos != null){
				panelAcu.remove(panelAnteriorTerminos);
			}
			if(cumplimientoAcuerdo != null){
				panelAcu.remove(cumplimientoAcuerdo);
			}
			despuesDeNuevoAcuerdo();
			ocultarBotones();
		}
	});
   
   var despuesDeNuevoAcuerdo = function(){
   		var ultimoRegistro = acuerdosStoreAcu.getCount();
   		if(ultimoRegistro > 0){
   			acuerdosGrid.getSelectionModel().selectRow((ultimoRegistro-1));
			acuerdosGrid.fireEvent('rowclick', acuerdosGrid, (ultimoRegistro-1));
			acuerdosStoreAcu.un('load',despuesDeNuevoAcuerdo);
   		}
   }
   
   var despuesDeEvento = function(){
   		acuerdosGrid.getSelectionModel().selectRow(indexAcuerdoSeleccionado);
		acuerdosGrid.fireEvent('rowclick', acuerdosGrid, indexAcuerdoSeleccionado);
		acuerdosStoreAcu.un('load',despuesDeEvento);
   }

  
   <%-- entidad.cacheStore(acuerdosStore); --%>
   
<%--    var btnEditAcuerdo = new Ext.Button({ --%>
<%--        text:  '<s:message code="app.editar" text="**Editar" />' --%>
<%--        <app:test id="EditAcuerdoBtn" addComa="true" /> --%>
<%--        ,iconCls : 'icon_edit' --%>
<%--        ,cls: 'x-btn-text-icon' --%>
<%--        ,handler:function(){ --%>
<%--       		alert("Edit"); --%>
<%--      	} --%>
<%--    }); --%>
 
   var cargarUltimoAcuerdo = function(){
   		analisisTab.remove(panelAnterior);
		panelAnterior = recargarAcuerdo(-2);
		analisisTab.add(panelAnterior);
		panelAcu.doLayout();
		
   };


   var btnAltaAcuerdo = new Ext.Button({
       text:  '<s:message code="app.agregar" text="**Agregar" />'
       <app:test id="AltaAcuerdoBtn" addComa="true" />
       ,iconCls : 'icon_mas'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){
      	       var w = app.openWindow({
		          flow : 'plugin/mejoras/acuerdos/plugin.mejoras.acuerdos.altaAcuerdo'
		          ,closable:false
		          ,width : 750
		          ,title : '<s:message code="app.nuevoRegistro" text="**Nuevo registro" />'
		          ,params : {idAsunto:panelAcu.getAsuntoId(), readOnly:"false"}
		       });
		       w.on(app.event.DONE, function(){
		          acuerdosStoreAcu.on('load',despuesDeNuevoAcuerdo);
		          acuerdosStoreAcu.webflow({id:panelAcu.getAsuntoId()});
		          w.close();
		       });
		       w.on(app.event.CANCEL, function(){ w.close(); });
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
		          flow : 'editacuerdo/open'
		          ,closable:false
		          ,width : 580
		          ,title : '<s:message code="mejoras.plugin.acuerdos.completaAcuerdo" text="**Cumplimiento acuerdo" />'
		          ,params : {idAcuerdo:acuerdoSeleccionado}
		       });
		       w.on(app.event.DONE, function(){
<%-- 		          acuerdosStoreAcu.on('load',despuesDeNuevoAcuerdo); --%>
		          	acuerdosStoreAcu.webflow({id:panelAcu.getAsuntoId()});
		          w.close();
<%-- 		          cargarUltimoAcuerdo(); --%>
		       });
		       w.on(app.event.CANCEL, function(){ w.close(); });
     	}
	});
	
	var btnRegistrarFinalizacionAcuerdo = new Ext.Button({
		text:  '<s:message code="plugin.mejoras.acuerdo.registrarFinalizacion" text="**Registrar finalización acuerdo" />'
		<app:test id="btnRegistrarFinalizacionAcuerdo" addComa="true" />
		,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,hidden:true
		,handler:function(){
		
		
			Ext.Ajax.request({
				url: page.resolveUrl('mejacuerdo/obtenerListadoValidacionTramiteCorrespondienteDerivaciones')
				,method: 'POST'
				,params:{
							idAcuerdo : acuerdoSeleccionado
						}
				,success: function (result, request){
											
					var derivacionesConfig = Ext.util.JSON.decode(result.responseText);
					
					var tramiteRestrictivosinResolver = false;
					<%-- Primero mostramos tramitres restrictivos que no permiten guardar --%>
					for (var i=0; i < derivacionesConfig.derivacionesTerminosAcuerdo.length; i++) {
							if(derivacionesConfig.derivacionesTerminosAcuerdo[i].restrictivo){
								tramiteRestrictivosinResolver = true;
								Ext.Msg.alert('<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.warning" text="**Aviso" />', derivacionesConfig.derivacionesTerminosAcuerdo[i].restrictivoTexto );
							}
					}
					
					<%-- Si no tenemos tramites restrictivos sin resolver mostramos los posibles tramites sin resolver no restrictivos y abrimos la ventana --%>
					if(!tramiteRestrictivosinResolver){
					
						for (var i=0; i < derivacionesConfig.derivacionesTerminosAcuerdo.length; i++) {
								if(!derivacionesConfig.derivacionesTerminosAcuerdo[i].restrictivo){
									tramiteRestrictivosinResolver = true;
									Ext.Msg.alert('<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.warning" text="**Aviso" />', derivacionesConfig.derivacionesTerminosAcuerdo[i].restrictivoTexto );
								}
						}
					
						var w = app.openWindow({
				       	   flow : 'mejacuerdo/openFinalizacionAcuerdo'
				          ,closable:false
				          ,width : 680
				          ,title : '<s:message code="mejoras.plugin.acuerdos.finalizarAcuerdo" text="**Finalizar acuerdo" />'
				          ,params : {idAcuerdo:acuerdoSeleccionado}
				       	});
				       	w.on(app.event.DONE, function(){
				       	  btnRegistrarFinalizacionAcuerdo.setVisible(false);
<%-- 				          acuerdosStoreAcu.on('load',despuesDeNuevoAcuerdo); --%>
				          acuerdosStoreAcu.webflow({id:panelAcu.getAsuntoId()});
				          w.close();
				          cargarUltimoAcuerdo();
				       	});
				       	w.on(app.event.CANCEL, function(){
				        	w.close();
				       	});
				       	
					}

					
				}
				,error: function(){
	
				}       				
			});

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
       		
       		Ext.Ajax.request({
				url: page.resolveUrl('mejacuerdo/tieneConfiguracionProponerAcuerdo')
				,method: 'POST'
				,success: function (result, request){
					var respuesta = Ext.util.JSON.decode(result.responseText);
					if(Boolean(respuesta.okko)){
						deshabilitarBotones();
			      	    page.webflow({
			      			flow:"plugin/mejoras/acuerdos/plugin.mejoras.acuerdos.proponerAcuerdo"
			      			,params:{
			      				idAcuerdo:acuerdoSeleccionado
			   				}
			      			,success: function(){
			           		 	acuerdosStoreAcu.on('load',despuesDeEvento);
			           		 	acuerdosStoreAcu.webflow({id:panelAcu.getAsuntoId()});
			           		 	btnProponerAcuerdo.hide();
			           		 	btnIncumplirAcuerdo.hide();
			           		}
			           		,error: function(){

							}	
				      	});
						habilitarBotones();
					}else{
						Ext.Msg.alert('<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.warning" text="**Aviso" />', 
	                    	       '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.termjinos.grid.warning.ProponerAcuerdoSinDespachoConfiguracion" text="**No es posible proponer el acuerdo, el usuario no pertenece a un despacho que permita proponer" />');
					}
				}
				,error: function(){
	
				}       				
			});	

			}else{
					Ext.Msg.alert('<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.warning" text="**Aviso" />', 
	                    	       '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.termjinos.grid.warning.ProponerAcuerdoSinTerminos" text="**No es posible proponer un acuerdo sin terminos" />');
	        }
     	}
   });
   
   var deshabilitarBotones=function(){
   			btnProponerAcuerdo.disable();
           	btnIncumplirAcuerdo.disable();
           	btnRechazarAcuerdo.disable();
           	btnVigenteAcuerdo.disable();
			btnCerrarAcuerdo.disable();
			btnRegistrarFinalizacionAcuerdo.disable();
   }
   var habilitarBotones=function(){
   			btnProponerAcuerdo.enable();
           	btnIncumplirAcuerdo.enable();
           	btnRechazarAcuerdo.enable();
           	btnVigenteAcuerdo.enable();
			btnCerrarAcuerdo.enable();
			btnRegistrarFinalizacionAcuerdo.enable();
   }
   
   var ocultarBotones=function(){
   			btnProponerAcuerdo.hide();
           	btnIncumplirAcuerdo.hide();
           	btnRechazarAcuerdo.hide();
           	btnVigenteAcuerdo.hide();
			btnCerrarAcuerdo.hide();
			btnAceptarAcuerdo.hide();
			btnRegistrarFinalizacionAcuerdo.hide();
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
           		 	acuerdosStoreAcu.on('load',despuesDeEvento);
           		 	acuerdosStoreAcu.webflow({id:panelAcu.getAsuntoId()});
					btnCerrarAcuerdo.hide();
           		 	btnIncumplirAcuerdo.hide();
					btnRechazarAcuerdo.hide();
           		}	
	      	});	
			habilitarBotones();
     	}
   });

	var btnIncumplirAcuerdo = new Ext.Button({
	       text:  '<s:message code="acuerdos.incumplido" text="**Incumplido" />'
	       <app:test id="btnIncumplirAcuerdo" addComa="true" />
	       ,iconCls : 'icon_menos'
	       ,cls: 'x-btn-text-icon'
	       ,hidden:true
	       ,handler:function(){
	      	    deshabilitarBotones();
	      	    page.webflow({
	      			flow:"plugin/mejoras/acuerdos/plugin.mejoras.acuerdos.cancelarAcuerdo"
	      			,params:{
	      				idAcuerdo:acuerdoSeleccionado
	   				}
	      			,success: function(){
	           		 	acuerdosStoreAcu.on('load',despuesDeEvento);
	           		 	acuerdosStoreAcu.webflow({id:panelAcu.getAsuntoId()});
	           		 	ocultarBotones();
	           		}
		      	});
				habilitarBotones();
	     	}
	});
	

	var btnAceptarAcuerdo = new Ext.Button({
       text:  '<s:message code="app.aceptar" text="**Aceptar" />'
       <app:test id="btnAceptarAcuerdo" addComa="true" />
       ,iconCls : 'icon_ok'
       ,cls: 'x-btn-text-icon'
       ,hidden:true
       ,handler:function(){
       if (countTerminos > 0){
            
            deshabilitarBotones();
      	    page.webflow({
      			flow:"plugin/mejoras/acuerdos/plugin.mejoras.acuerdos.aceptarAcuerdo"
      			,params:{
      				idAcuerdo:acuerdoSeleccionado
   				}
      			,success: function(){
           		 	acuerdosStoreAcu.on('load',despuesDeEvento);
           		 	acuerdosStoreAcu.webflow({id:panelAcu.getAsuntoId()});
           		 	btnAceptarAcuerdo.hide();
           		 	btnRechazarAcuerdo.hide();
           		 	btnIncumplirAcuerdo.setVisible(false);
           		}	
	      	});
			habilitarBotones();
				
       }else{
       		Ext.Msg.alert('<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.warning" text="**Aviso" />', 
	   		'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.termjinos.grid.warning.AceptarAcuerdoSinTerminos" text="**No es posible aceptar un acuerdo sin terminos" />');
       }
     	}
   });
   
   	var btnVigenteAcuerdo = new Ext.Button({
       text:  '<s:message code="acuerdos.aprobar" text="**Aprobar" />'
       <app:test id="btnVigenteAcuerdo" addComa="true" />
       ,iconCls : 'icon_ok'
       ,cls: 'x-btn-text-icon'
       ,hidden:true
       ,handler:function(){
	       if (countTerminos > 0){
	            
	            deshabilitarBotones();
	      	    page.webflow({
	      			flow:"plugin/mejoras/acuerdos/plugin.mejoras.acuerdos.vigenteAcuerdo"
	      			,params:{
	      				idAcuerdo:acuerdoSeleccionado
	   				}
	      			,success: function(){
<%-- 	           		 	acuerdosStoreAcu.on('load',despuesDeEvento); --%>
	           		 	acuerdosStoreAcu.webflow({id:panelAcu.getAsuntoId()});
	           		 	btnAceptarAcuerdo.hide();
	           		 	btnRechazarAcuerdo.hide();
	           		 	btnVigenteAcuerdo.hide();
	           		 	btnIncumplirAcuerdo.setVisible(false);
	           		}	
		      	});
				habilitarBotones();	
				
	       }else{
	       		Ext.Msg.alert('<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.warning" text="**Aviso" />', 
		   		'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.termjinos.grid.warning.VigenteAcuerdoSinTerminos" text="**No es posible aprobar un acuerdo sin terminos" />');
	       }

     	}
   });
   
	var btnRechazarAcuerdo = new Ext.Button({
       text:  '<s:message code="acuerdos.rechazar" text="**Rechazar" />'
       <app:test id="btnRechazarAcuerdo" addComa="true" />
       ,iconCls : 'icon_menos'
       ,cls: 'x-btn-text-icon'
       ,hidden:true      
	});

<%--     function processResult(opt, text){ --%>
<%--        if(opt == 'cancel'){ --%>
<%-- 	      //Nada --%>
<%-- 	   } --%>
<%-- 	   if(opt == 'ok'){ --%>
<%-- 	   	   deshabilitarBotones(); --%>
<%-- 	       page.webflow({ --%>
<%--       			flow:'mejacuerdo/rechazarAcuerdoMotivo' --%>
<%--       			,params:{ --%>
<%--       				idAcuerdo:acuerdoSeleccionado --%>
<%--       				,motivo: text --%>
<%--    				} --%>
<%--    				,success: function(){ --%>
<%-- 	   				acuerdosStoreAcu.on('load',despuesDeEvento); --%>
<%-- 		   		 	acuerdosStoreAcu.webflow({id:panel.getAsuntoId()}); --%>
<%-- 		   		 	btnAceptarAcuerdo.hide(); --%>
<%-- 		   		 	btnRechazarAcuerdo.hide(); --%>
<%-- 		   		 	btnCerrarAcuerdo.hide(); --%>
<%-- 		   		 	btnIncumplirAcuerdo.hide(); --%>
<%-- 		   		 	btnVigenteAcuerdo.hide(); --%>
<%--    		 		} --%>
<%-- 	      	});	 --%>
<%--       		habilitarBotones(); --%>
<%-- 	   } --%>
<%-- 	} --%>
    
	btnRechazarAcuerdo.on('click',function(){
	
				var w = app.openWindow({
		       	   flow : 'mejacuerdo/openRechazarAcuerdo'
		          ,closable:false
		          ,width : 550
		          ,title : '<s:message code="mejoras.plugin.acuerdos.rechazarAcuerdo" text="**Rechazar acuerdo" />'
		          ,params : {idAcuerdo:acuerdoSeleccionado}
		       	});
		       	w.on(app.event.DONE, function(){
					w.close();
					acuerdosStoreAcu.on('load',despuesDeEvento);
		   		 	acuerdosStoreAcu.webflow({id:panelAcu.getAsuntoId()});
		   		 	btnAceptarAcuerdo.hide();
		   		 	btnRechazarAcuerdo.hide();
		   		 	btnCerrarAcuerdo.hide();
		   		 	btnIncumplirAcuerdo.hide();
		   		 	btnVigenteAcuerdo.hide();
		       	});
		       	w.on(app.event.CANCEL, function(){
		        	w.close();
		       	});
	
<%-- 		  Ext.MessageBox.prompt('Motivo rechazo', 'Introduzca los motivos por los que rechaza el acuerdo:', processResult); --%>
       		
	});
	
	//del acuerdosGeneric
	var acuerdosGrid = app.crearGrid(acuerdosStoreAcu,cmAcuerdos,{
		id: 'datosAcuerdo'
         ,title : '<s:message code="acuerdos.grid.titulo" text="**Acuerdos" />'
         <app:test id="acuerdosGrid" addComa="true" />
         ,style:'padding-right:10px'
         ,autoHeight : true
         ,cls:'cursor_pointer'
         ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	}); 

	var reload = function(){
		if (analisisTab != null){
			analisisTab.remove(panelAnterior);
		}
		panelAnterior = recargarAcuerdo(acuerdoSeleccionado);
		
		if (analisisTab !=null) {
			analisisTab.add(panelAnterior);
		}
		panelAcu.doLayout();
		acuerdosStoreAcu.webflow({id:panelAcu.getAsuntoId()});
	}

	panelAcu.add(acuerdosGrid);


	// Variables para las pestañas de análisis y términos
	var analisisTab;	
	var terminosTab;
	var acuerdosTabs;                                                                                                                                                       

	//Comienzan las 4 partes dependientes del acuerdo	
	var panelAnterior;
	var panelAnteriorTerminos;
	var cumplimientoAcuerdo;
	
	
	acuerdosGrid.on('rowclick', function(grid, rowIndex, e) {
	   	var rec = grid.getStore().getAt(rowIndex);
		var idAcuerdo = rec.get('idAcuerdo');
		var idTipoDespacho = rec.get('tipoDespachoProponente');
		var idUserProponente = rec.get('idProponente');
		var idTipoAcuerdo = rec.get('idTipoAcuerdo');
		acuerdoSeleccionado = idAcuerdo;
		indexAcuerdoSeleccionado = rowIndex;
		<%--panelAcu.el.mask('<s:message code="fwk.ui.form.cargando" text="**Cargando" />','x-mask-loading'); --%>
		//Muestro o no los botones que corresponden
		var codigoEstado = rec.get('codigoEstado');
		
		///Ocultamos todos los botones
		ocultarBotones();
	
		/////Llamada ajax para obtener el proponente, validador y decisor del acuerdo y el id y tipo de gestor del usuario logado
       	
       	Ext.Ajax.request({
			url: page.resolveUrl('mejacuerdo/getConfigUsersAcuerdoAsunto')
			,method: 'POST'
			,params:{
						idTipoDespachoProponente : idTipoDespacho
						,idAsunto:panelAcu.getAsuntoId()
					}
			,success: function (result, request){
						
				
				var config = Ext.util.JSON.decode(result.responseText);
				var tipoDespachoPropAcuerdo = config.tiposDespachosAcuerdoAsunto.proponente;
				var tipoDespachoValidadorAcuerdo = config.tiposDespachosAcuerdoAsunto.validador;
				var tipoDespachoDecisorAcuerdo = config.tiposDespachosAcuerdoAsunto.decisor;
				var userLogado = config.userLogado.id;
				var tipoDespachoLogado = config.userLogado.idTipoDespacho;
				var noPuedeModificar = true;
				

				if(idUserProponente == userLogado && codigoEstado == app.codigoAcuerdoEnConformacion){
					btnProponerAcuerdo.setVisible(true);
					btnIncumplirAcuerdo.setText('<s:message code="acuerdos.cancelar" text="**Cancelar" />');
					btnIncumplirAcuerdo.setVisible(true);
					
					noPuedeModificar = false;
					
					if(tipoDespachoLogado == tipoDespachoDecisorAcuerdo){
						btnVigenteAcuerdo.setVisible(true);
						btnProponerAcuerdo.setVisible(false);
					}else if(tipoDespachoLogado == tipoDespachoValidadorAcuerdo){
						btnAceptarAcuerdo.setVisible(true);
						btnProponerAcuerdo.setVisible(false);
					} 
					
				}
				
				if((tipoDespachoLogado == tipoDespachoValidadorAcuerdo || tipoDespachoLogado == tipoDespachoDecisorAcuerdo) && codigoEstado == app.codigoAcuerdoPropuesto){
					btnAceptarAcuerdo.setVisible(true);
					btnRechazarAcuerdo.setVisible(true);
					
					noPuedeModificar = false;
				}

				if(tipoDespachoLogado == tipoDespachoDecisorAcuerdo && codigoEstado == app.codigoAcuerdoAceptado){
					btnVigenteAcuerdo.setVisible(true);
					btnRechazarAcuerdo.setVisible(true);
					
					noPuedeModificar = false;
				}
				
				var estadoVigente = false;
				
				btnRegistrarFinalizacionAcuerdo.setVisible(false);
				if(tipoDespachoLogado == tipoDespachoPropAcuerdo && codigoEstado == app.codigoAcuerdoVigente){
					
					btnRegistrarFinalizacionAcuerdo.setVisible(true);
					estadoVigente = true;
					
				}
				
				var noPuedeEditarEstGest = true;
				if(codigoEstado == app.codigoAcuerdoVigente && tipoDespachoLogado == tipoDespachoPropAcuerdo){
					noPuedeEditarEstGest = false;
				}
				
				panelAcu.remove(acuerdosTabs);	
				panelAcu.remove(panelAnterior);
				panelAcu.remove(panelAnteriorTerminos);
				panelAcu.remove(cumplimientoAcuerdo);
		
				analisisTab = new Ext.Panel({
					title:'<s:message code="plugin.mejoras.acuerdos.tabAnalisis" text="**Análisis"/>'
					,id:'asunto-analisisTabs-${asunto.id}'
					,autoHeight:true
				});
			
				terminosTab = new Ext.Panel({
					<%-- title:'<s:message code="plugin.mejoras.acuerdos.tabTerminosAcuerdos" text="**Términos"/>'
					,--%>id:'asunto-terminosTabs-${asunto.id}'
					,layout:'form'
					,border : false
					,autoScroll:true
					,bodyStyle:'padding:0px;margin:0px'
					,autoHeight:true
					,autoWidth : true
				});
		
				acuerdosTabs = new Ext.Panel({
					id:'asunto-acuerdosTabs-${asunto.id}'
					,items:[
						terminosTab<%--, analisisTab --%>
					]
					,layout:'form'
					,border : false
					,autoScroll:true
					,bodyStyle:'padding:0px;margin:0px'
					,autoHeight:true
					,autoWidth : true
				  });     
				    
		
				panelAnterior = recargarAcuerdo(idAcuerdo);
				panelAnteriorTerminos = recargarAcuerdoTerminos(idAcuerdo,noPuedeModificar,noPuedeEditarEstGest);
				
				analisisTab.add(panelAnterior);
				terminosTab.add(panelAnteriorTerminos);
				
				<%--acuerdosTabs.setActiveTab(terminosTab); --%>
				acuerdosTabs.add(terminosTab);                                                                                                                                                           
				acuerdosTabs.setHeight('auto');	
				
				var store = panelAnteriorTerminos.terminosAcuerdoGrid.getStore();
				
				btnCumplimientoAcuerdo.setVisible(false);
				
				store.on('load', function(){  
					for (var i=0; i < store.data.length; i++) {
						datos = store.getAt(i);
						
						if(datos.get('codigoTipoAcuerdo') == "PLAN_PAGO"){
							if(Boolean(estadoVigente)){
								btnCumplimientoAcuerdo.setVisible(true);
							}
							cumplimientoAcuerdo = recargarCumplimientoAcuerdo(idAcuerdo);
							terminosTab.add(cumplimientoAcuerdo);
							
						}
					}
					
					panelAcu.add(acuerdosTabs);
					//panelAcu.add(panelAnterior);
					panelAcu.doLayout();
					panelAcu.show();
			   	});
				

				
			}
			,error: function(){

			}       				
		});
	
	    
		
	});
   
	//fin 4 partes

	var recargarAcuerdo = function(idAcuerdo){
		var url = '/${appProperties.appName}/acuerdos/detalleAcuerdo.htm',
		config = config || {};
		var autoLoad = {url : url+"?"+Math.random()
				,scripts: true
				,params: {id:idAcuerdo,idAsunto:panelAcu.getAsuntoId()}
				};
		var cfg = {
			autoLoad : autoLoad
			,border:false
			,bodyStyle:'padding:5px'
			,defaults:{
            	border:false            
        		}
		};
		var panel2 = new Ext.Panel(cfg);



		panel2.show();
		panel2.on(app.event.DONE, function(){
		          reload();
		       });
		return panel2


	};

	
	var recargarAcuerdoTerminos = function(idAcuerdo,noPuedeModificar, noPuedeEditarEstadoGestion){
	
		<%@ include file="/WEB-INF/jsp/plugin/mejoras/acuerdos/detalleTerminos.jsp" %>

		var panTerminos = crearTerminosAsuntos(noPuedeModificar,false, noPuedeEditarEstadoGestion);
		ocultarBotones();
		return panTerminos;
		
	};	
	
	
	var recargarCumplimientoAcuerdo = function(idAcuerdo){
		<%@ include file="/WEB-INF/jsp/plugin/mejoras/acuerdos/listadoCumplimientoAcuerdo.jsp" %>	
		var cumplimiento = crearCumplimiento(idAcuerdo);
		return cumplimiento;
	};
	

	
	
	panelAcu.getValue = function(){
		var estado = entidad.get("acuerdos");
		rowsSelected = acuerdosGrid.getSelectionModel().getSelections();
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
	
	panelAcu.setValue = function(){
		var data = entidad.get("data");
		entidad.cacheOrLoad(data, acuerdosStoreAcu, {id: data.id });
		btnCumplimientoAcuerdo.setVisible(false);
		btnAltaAcuerdo.hide();
	}

	panelAcu.getAsuntoId = function(){
		return entidad.get("data").id;
	}

	panelAcu.esSupervisor = function(){
		return entidad.get("data").toolbar.esSupervisor;
	}

	panelAcu.esGestor = function(){
		return entidad.get("data").toolbar.esGestor;
	}

	panelAcu.setVisibleTab = function(data){
		return data.aceptacion.estaAceptado;
	}

	