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
		title : '<s:message code="acuerdos.titulo" text="**Acuerdos"/>'
		,layout:'form'
		,border : false
		/*,layoutConfig: { columns: 1 }*/
		,autoScroll:true
		,bodyStyle:'padding:5px;margin:5px'
		,autoHeight:true
		,autoWidth : true
		,nombreTab : 'acuerdos'
		/*,items : [{items:acuerdosTabs
				,border:false
				,style:'margin-top: 7px; margin-left:5px'}
			]*/
	});
	
	var acuerdoSeleccionado = null;
	var indexAcuerdoSeleccionado = null;
	var countTerminos = 999;

	var acuerdo = Ext.data.Record.create([
          {name : 'idAcuerdo'}
         ,{name : 'fechaPropuesta'}
         ,{name : 'tipoAcuerdo'}
         ,{name : 'solicitante'}
         ,{name : 'estado'}
         ,{name : 'fechaEstado'}
         ,{name : 'codigoEstado'}
         ,{name : 'motivo'}
      ]);

   var cmAcuerdos = new Ext.grid.ColumnModel([
      {header : '<s:message code="acuerdos.codigo" text="**C&oacute;digo" />', dataIndex : 'idAcuerdo',width: 35}
      ,{header : '<s:message code="acuerdos.fechaPropuesta" text="**Fecha Propuesta" />', dataIndex : 'fechaPropuesta',width: 65}
      <sec:authorize ifNotGranted="OCULTA_TIPO_ACUERDO">
      ,{header : '<s:message code="acuerdos.tipoAcuerdo" text="**Tipo Acuerdo" />', dataIndex : 'tipoAcuerdo',width: 100}
      </sec:authorize>
      ,{header : '<s:message code="acuerdos.solicitante" text="**Solicitante" />', dataIndex : 'solicitante',width: 75}
      ,{header : '<s:message code="acuerdos.estado" text="**Estado" />', dataIndex : 'estado',width: 75}
      ,{header : '<s:message code="acuerdos.codigo.estado" text="**Codigo Estado" />',dataIndex : 'codigoEstado', hidden:true, fixed:true,width: 75}
      ,{header : '<s:message code="acuerdos.fechaEstado" text="**Fecha Estado" />', dataIndex : 'fechaEstado',width: 65}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.motivo" text="**Motivo" />', dataIndex : 'motivo',width: 65}
   ]);
 
   var acuerdosStore = page.getStore({
        flow: 'plugin/mejoras/acuerdos/plugin.mejoras.acuerdos.acuerdosAsunto'
        ,storeId : 'acuerdosStore'
        ,reader : new Ext.data.JsonReader(
            {root:'acuerdos'}
            , acuerdo
        )
   });  
   
   acuerdosStore.on('load', function () {
   		
   		var btnDisbled = false
	    acuerdosStore.data.each(function() {
	    	var codEstad = this.data['codigoEstado'];
	    	if(codEstad == app.codigoAcuerdoEnConformacion || codEstad == app.codigoAcuerdoPropuesto || codEstad == app.codigoAcuerdoAceptado ){
	    		btnDisbled = true;
	    	}
	    });
	    
	    if(btnDisbled){
	   		btnAltaAcuerdo.setDisabled(true);
	    }else{
	    	btnAltaAcuerdo.setDisabled(false);
	    }
	});
   
   var despuesDeNuevoAcuerdo = function(){
   		var ultimoRegistro = acuerdosStore.getCount();
		acuerdosGrid.getSelectionModel().selectRow((ultimoRegistro-1));
		acuerdosGrid.fireEvent('rowclick', acuerdosGrid, (ultimoRegistro-1));
		acuerdosStore.un('load',despuesDeNuevoAcuerdo);
   }
   
   var despuesDeEvento = function(){
   		acuerdosGrid.getSelectionModel().selectRow(indexAcuerdoSeleccionado);
		acuerdosGrid.fireEvent('rowclick', acuerdosGrid, indexAcuerdoSeleccionado);
		acuerdosStore.un('load',despuesDeEvento);
   }

  
   <!-- entidad.cacheStore(acuerdosStore); -->
   
   var btnEditAcuerdo = new Ext.Button({
       text:  '<s:message code="app.editar" text="**Editar" />'
       <app:test id="EditAcuerdoBtn" addComa="true" />
       ,iconCls : 'icon_edit'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){
      		alert("Edit");
     	}
   });
 
   var cargarUltimoAcuerdo = function(){
   		analisisTab.remove(panelAnterior);
		panelAnterior = recargarAcuerdo(-2);
		analisisTab.add(panelAnterior);
		panel.doLayout();
		
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
		          ,params : {idAsunto:panel.getAsuntoId(), readOnly:"false"}
		       });
		       w.on(app.event.DONE, function(){
		          acuerdosStore.on('load',despuesDeNuevoAcuerdo);
		          acuerdosStore.webflow({id:panel.getAsuntoId()});
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
		          ,width : 750
		          ,title : '<s:message code="mejoras.plugin.acuerdos.completaAcuerdo" text="**completar acuerdo" />'
		          ,params : {idAcuerdo:acuerdoSeleccionado}
		       });
		       w.on(app.event.DONE, function(){
		          acuerdosStore.on('load',despuesDeNuevoAcuerdo);
		          acuerdosStore.webflow({id:panel.getAsuntoId()});
		          w.close();
		          cargarUltimoAcuerdo();
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
	      			flow:"acuerdos/proponerAcuerdo"
	      			,params:{
	      				idAcuerdo:acuerdoSeleccionado
	   				}
	      			,success: function(){
	           		 	acuerdosStore.on('load',despuesDeEvento);
	           		 	acuerdosStore.webflow({id:panel.getAsuntoId()});
	           		 	btnProponerAcuerdo.hide();
	           		 	btnIncumplirAcuerdo.hide();
	           		}	
		      	});
				habilitarBotones();	

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
<!-- 			btnCerrarAcuerdo.disable(); -->
   }
   var habilitarBotones=function(){
   			btnProponerAcuerdo.enable();
           	btnIncumplirAcuerdo.enable();
           	btnRechazarAcuerdo.enable();
<!-- 			btnCerrarAcuerdo.enable(); -->
   }
   
   var ocultarBotones=function(){
   			btnProponerAcuerdo.hide();
           	btnIncumplirAcuerdo.hide();
           	btnRechazarAcuerdo.hide();
<!-- 			btnCerrarAcuerdo.hide(); -->
   }
   
   
<!--    var btnCerrarAcuerdo = new Ext.Button({ -->
<%--        text:  '<s:message code="acuerdos.cerrar" text="**Cerrar" />' --%>
<%--        <app:test id="btnCerrarAcuerdo" addComa="true" /> --%>
<!--        ,iconCls : 'icon_menos' -->
<!--        ,cls: 'x-btn-text-icon' -->
<!--        ,hidden:true -->
<!--        ,handler:function(){ -->
<!-- 	   		deshabilitarBotones(); -->
<!--       	    page.webflow({ -->
<!--       			flow:"acuerdos/finalizarAcuerdo" -->
<!--       			,params:{ -->
<!--       				idAcuerdo:acuerdoSeleccionado -->
<!--    				} -->
<!--       			,success: function(){ -->
<!--            		 	acuerdosStore.on('load',despuesDeEvento); -->
<!--            		 	acuerdosStore.webflow({id:panel.getAsuntoId()}); -->
<!-- 					btnCerrarAcuerdo.hide(); -->
<!--            		 	btnIncumplirAcuerdo.hide(); -->
<!-- 					btnRechazarAcuerdo.hide(); -->
<!--            		}	 -->
<!-- 	      	});	 -->
<!-- 			habilitarBotones(); -->
<!--      	} -->
<!--    }); -->

	var btnIncumplirAcuerdo = new Ext.Button({
	       text:  '<s:message code="acuerdos.incumplido" text="**Incumplido" />'
	       <app:test id="btnIncumplirAcuerdo" addComa="true" />
	       ,iconCls : 'icon_menos'
	       ,cls: 'x-btn-text-icon'
	       ,hidden:true
	       ,handler:function(){
	      	    deshabilitarBotones();
	      	    page.webflow({
	      			flow:"acuerdos/cancelarAcuerdo"
	      			,params:{
	      				idAcuerdo:acuerdoSeleccionado
	   				}
	      			,success: function(){
	           		 	acuerdosStore.on('load',despuesDeEvento);
	           		 	acuerdosStore.webflow({id:panel.getAsuntoId()});
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
      	    deshabilitarBotones();
      	    page.webflow({
      			flow:"acuerdos/aceptarAcuerdo"
      			,params:{
      				idAcuerdo:acuerdoSeleccionado
   				}
      			,success: function(){
           		 	acuerdosStore.on('load',despuesDeEvento);
           		 	acuerdosStore.webflow({id:panel.getAsuntoId()});
           		 	btnAceptarAcuerdo.hide();
           		 	btnRechazarAcuerdo.hide();
           		}	
	      	});
			habilitarBotones();	
     	}
   });
   
   	var btnVigenteAcuerdo = new Ext.Button({
       text:  '<s:message code="app.vigente" text="**Vigente" />'
       <app:test id="btnVigenteAcuerdo" addComa="true" />
       ,iconCls : 'icon_ok'
       ,cls: 'x-btn-text-icon'
       ,hidden:true
       ,handler:function(){
      	    deshabilitarBotones();
      	    page.webflow({
      			flow:"acuerdos/vigenteAcuerdo"
      			,params:{
      				idAcuerdo:acuerdoSeleccionado
   				}
      			,success: function(){
           		 	acuerdosStore.on('load',despuesDeEvento);
           		 	acuerdosStore.webflow({id:panel.getAsuntoId()});
           		 	btnAceptarAcuerdo.hide();
           		 	btnRechazarAcuerdo.hide();
           		}	
	      	});
			habilitarBotones();	
     	}
   });
   
	var btnRechazarAcuerdo = new Ext.Button({
       text:  '<s:message code="acuerdos.rechazar" text="**Rechazar" />'
       <app:test id="btnRechazarAcuerdo" addComa="true" />
       ,iconCls : 'icon_menos'
       ,cls: 'x-btn-text-icon'
       ,hidden:true      
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
		   		 	acuerdosStore.webflow({id:panel.getAsuntoId()});
		   		 	btnAceptarAcuerdo.hide();
		   		 	btnRechazarAcuerdo.hide();
<!-- 		   		 	btnCerrarAcuerdo.hide(); -->
		   		 	btnIncumplirAcuerdo.hide();
   		 		}
	      	});	
      		habilitarBotones();
	   }
	}
    
	btnRechazarAcuerdo.on('click',function(){
	
		  Ext.MessageBox.prompt('Motivo rechazo', 'Introduzca los motivos por los que rechaza el acuerdo:', processResult);
       		
	});
	
	var acuerdosGrid = app.crearGrid(acuerdosStore,cmAcuerdos,{
         title : '<s:message code="acuerdos.grid.titulo" text="**Acuerdos" />'
         <app:test id="acuerdosGrid" addComa="true" />
         ,style:'padding-right:10px'
         ,autoHeight : true
         ,cls:'cursor_pointer'
         ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})

         ,bbar : [
         	btnAltaAcuerdo,
          	<sec:authorize ifAllGranted="PROPONER-ACUERDO">
	        	btnProponerAcuerdo,	
	        </sec:authorize>
        	btnIncumplirAcuerdo,
<!--      	   	btnCerrarAcuerdo, -->
        	btnAceptarAcuerdo,
        	btnRechazarAcuerdo,
        	<sec:authorize ifAllGranted="DECIDIR-ACUERDO">
				btnCumplimientoAcuerdo,
				btnVigenteAcuerdo,
			</sec:authorize>
	      ]

	}); 

	var reload = function(){
		analisisTab.remove(panelAnterior);
		panelAnterior = recargarAcuerdo(acuerdoSeleccionado);
		analisisTab.add(panelAnterior);
		panel.doLayout();
		acuerdosStore.webflow({id:panel.getAsuntoId()});
	}
	
	/*
	var reloadTerminos = function(){
		panel.remove(panelAnteriorTerminos);

		panelAnteriorTerminos = recargarAcuerdo(acuerdoSeleccionado);
		panel.add(panelAnteriorTerminos);
		panel.doLayout();
		acuerdosStore.webflow({id:panel.getAsuntoId()});
	}
	*/
	
	panel.add(acuerdosGrid);


	// Variables para las pestañas de análisis y términos
	var analisisTab;	
	var terminosTab;
	var acuerdosTabs;                                                                                                                                                       

	//Comienzan las 4 partes dependientes del acuerdo	
	var panelAnterior;
	var panelAnteriorTerminos;
	
	
	acuerdosGrid.on('rowclick', function(grid, rowIndex, e) {
	
   		var rec = grid.getStore().getAt(rowIndex);
		var idAcuerdo = rec.get('idAcuerdo');
		acuerdoSeleccionado = idAcuerdo;
		indexAcuerdoSeleccionado = rowIndex;
		panel.el.mask('<s:message code="fwk.ui.form.cargando" text="**Cargando" />','x-mask-loading');
		//Muestro o no los botones que corresponden
		var codigoEstado = rec.get('codigoEstado');
		
		btnEditAcuerdo.setVisible(
			//esSupervisor  && PROPUESTO
			(panel.esSupervisor() && codigoEstado == app.codigoAcuerdoPropuesto)||
			//esGestor && (PROPUESTO||VIGENTE)
			(panel.esGestor() && (codigoEstado == app.codigoAcuerdoPropuesto || codigoEstado == app.codigoAcuerdoAceptado))
		);
				

		<sec:authorize ifAllGranted="VALIDAR-ACUERDO">
			btnAceptarAcuerdo.setVisible(
				(codigoEstado == app.codigoAcuerdoPropuesto)
			);	
	    </sec:authorize>
	    
<!-- 	    SE PONE VISIBLE EL BOTON SI EL ACUERDO ESTA PROPUESTO Y TIENE EL PERFIL DE PROPONENTE -->
<!-- 		btnAceptarAcuerdo.setVisible( -->
<!-- 			//esSupervisor && PROPUESTO -->
<!-- 			(panel.esSupervisor() && codigoEstado == app.codigoAcuerdoPropuesto) -->
<!-- 		); -->
		
<!-- 		btnRechazarAcuerdo.setVisible( -->
<!-- 			//esSupervisor && (PROPUESTO||VIGENTE) -->
<!-- 			((panel.esSupervisor() && (codigoEstado == app.codigoAcuerdoPropuesto || codigoEstado == app.codigoAcuerdoAceptado))) -->
<%-- 			<sec:authorize ifAllGranted="CIERRE_ACUERDO_LIT_DESDE_APP_EXTERNA">			 --%>
<!-- 			&& false -->
<%-- 			</sec:authorize> --%>
<!-- 		); -->
		
<!-- 		btnIncumplirAcuerdo.setVisible( -->
<!-- 			//esGestor && EN CONFORMACION -->
<!-- 			((codigoEstado == app.codigoAcuerdoEnConformacion && panel.esGestor())|| -->
<!-- 			//esSupervisor && (VIGENTE) -->
<!-- 			(panel.esSupervisor() && codigoEstado == app.codigoAcuerdoAceptado)) -->
<%-- 			<sec:authorize ifAllGranted="CIERRE_ACUERDO_LIT_DESDE_APP_EXTERNA">			 --%>
<!-- 			&& false -->
<%-- 			</sec:authorize> --%>
<!-- 		); -->

<!-- 		if((codigoEstado == app.codigoAcuerdoEnConformacion && panel.esGestor())){ -->
<%-- 			btnIncumplirAcuerdo.setText('<s:message code="acuerdos.cancelar" text="**Cancelar" />'); --%>
<!-- 		}else if(panel.esSupervisor() && codigoEstado == app.codigoAcuerdoAceptado){ -->
<%-- 			btnIncumplirAcuerdo.setText('<s:message code="acuerdos.incumplido" text="**Incumplido" />'); --%>
<!-- 		} -->
		
		
		btnProponerAcuerdo.setVisible(
			//esGestor && EN CONFORMACION
			(codigoEstado == app.codigoAcuerdoEnConformacion && panel.esGestor())
		);
		
<!-- 		btnCerrarAcuerdo.setVisible( -->
<!-- 			//esSupervisor && VIGENTE -->
<!-- 			((codigoEstado == app.codigoAcuerdoAceptado && panel.esSupervisor())) -->
<%-- 			<sec:authorize ifAllGranted="CIERRE_ACUERDO_LIT_DESDE_APP_EXTERNA">			 --%>
<!-- 			&& false -->
<%-- 			</sec:authorize> --%>
<!-- 		); -->
		
		<!-- 		btnCumplimientoAcuerdo.setVisible( -->
<!-- 			(codigoEstado == app.codigoAcuerdoAceptado) -->
<%-- 			<sec:authorize ifAllGranted="CIERRE_ACUERDO_LIT_DESDE_APP_EXTERNA">			 --%>
<!-- 			&& false -->
<%-- 			</sec:authorize> --%>
<!-- 		); -->
		
		
		var decisorAcu = false;
		<sec:authorize ifAllGranted="DECIDIR-ACUERDO">
			decisorAcu = true;
		</sec:authorize>
		
		btnVigenteAcuerdo.setVisible(
			(codigoEstado == app.codigoAcuerdoAceptado) && decisorAcu
		);
		
		btnCumplimientoAcuerdo.setVisible(
			(codigoEstado == app.codigoAcuerdoVigente) && decisorAcu
		);
		
		btnIncumplirAcuerdo.setVisible(
			(codigoEstado == app.codigoAcuerdoVigente) && decisorAcu
		);
		
		
<!-- 		btnCerrarAcuerdo.setVisible( -->
<!-- 			(codigoEstado == app.codigoAcuerdoAceptado) && decisorAcu -->
<!-- 		); -->
		
		
		///Si es validador puede rechazar si esta propuesto
		<sec:authorize ifAllGranted="VALIDAR-ACUERDO">
			btnRechazarAcuerdo.setVisible(
				(codigoEstado == app.codigoAcuerdoPropuesto)
			);	
	    </sec:authorize>
	    
	    ////Si es decisor puede rechazar si esta propuesto
	    <sec:authorize ifAllGranted="DECIDIR-ACUERDO">
			btnRechazarAcuerdo.setVisible(
				(codigoEstado == app.codigoAcuerdoPropuesto)
			);	
	    </sec:authorize>
	    



		panel.remove(acuerdosTabs);	
		panel.remove(panelAnterior);
		panel.remove(panelAnteriorTerminos);

		analisisTab = new Ext.Panel({
			title:'<s:message code="plugin.mejoras.acuerdos.tabAnalisis" text="**Análisis"/>'
			,autoHeight:true
		});
	
		terminosTab = new Ext.Panel({
			title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos" text="**Términos"/>'
			,autoHeight:true
		});

		acuerdosTabs = new Ext.TabPanel({
			id:'asunto-acuerdosTabs-${asunto.id}'
			,items:[
				terminosTab, analisisTab
			]
			,autoHeight:true
			,autoWidth : true
			,border: true
		  });       
		acuerdosTabs.setActiveTab(terminosTab);                                                                                                                                                           
		acuerdosTabs.setHeight('auto');

		panelAnterior = recargarAcuerdo(idAcuerdo);
		panelAnteriorTerminos = recargarAcuerdoTerminos(idAcuerdo);	
		analisisTab.add(panelAnterior);
		terminosTab.add(panelAnteriorTerminos);
		
		panel.add(acuerdosTabs);
		//panel.add(panelAnterior);
		panel.doLayout();
		panel.show();
		
	});
   
	//fin 4 partes

	var recargarAcuerdo = function(idAcuerdo){
		var url = '/${appProperties.appName}/acuerdos/detalleAcuerdo.htm',
		config = config || {};
		var autoLoad = {url : url+"?"+Math.random()
				,scripts: true
				,params: {id:idAcuerdo,idAsunto:panel.getAsuntoId()}
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

	
	var recargarAcuerdoTerminos = function(idAcuerdo){

		<%@ include file="/WEB-INF/jsp/plugin/mejoras/acuerdos/detalleTerminos.jsp" %>

		var panTerminos = crearTerminosAsuntos();
		return panTerminos;
		
	};	
	
	panel.getValue = function(){
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
	
	panel.setValue = function(){
		var data = entidad.get("data");
		entidad.cacheOrLoad(data,acuerdosStore, {id : data.id });
		
		<%--
		var estado = entidad.get("acuerdos");
		if (estado){
			panel.remove(panelAnterior);

			panelAnterior = recargarAcuerdo(estado.idAcuerdo);
			panel.add(panelAnterior);
			panel.doLayout();
		} else {
			// vaciar el grid
			panel.remove(panelAnterior);
		}
		 --%>
		
<!-- 		var esVisible = [ -->
<!-- 			 [btnAltaAcuerdo, data.toolbar.esGestor || data.toolbar.esSupervisor] -->
<!-- 			,[btnCumplimientoAcuerdo, data.toolbar.esGestor || data.toolbar.esSupervisor] -->
<!-- 		]; -->

		entidad.setVisible(esVisible);
		//Por defecto establecemos el botón como no visible
		btnCumplimientoAcuerdo.setVisible(false);
		//terminosTab.hide();
		//analisisTab.hide();
	}

	panel.getAsuntoId = function(){
		return entidad.get("data").id;
	}

	panel.esSupervisor = function(){
		return entidad.get("data").toolbar.esSupervisor;
	}

	panel.esGestor = function(){
		return entidad.get("data").toolbar.esGestor;
	}

	panel.setVisibleTab = function(data){
		return data.aceptacion.estaAceptado;
	}

	return panel;
})