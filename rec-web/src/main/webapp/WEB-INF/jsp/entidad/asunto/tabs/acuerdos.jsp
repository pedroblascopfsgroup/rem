<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
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
		,layout:'table'
		,border : false
		,layoutConfig: { columns: 1 }
		,autoScroll:true
		,bodyStyle:'padding:5px;margin:5px'
		,autoHeight:true
		,autoWidth : true
		,nombreTab : 'acuerdos'
	});
	
	var acuerdoSeleccionado = null;
	var indexAcuerdoSeleccionado = null;

	var acuerdo = Ext.data.Record.create([
          {name : 'idAcuerdo'}
         ,{name : 'fechaPropuesta'}
         ,{name : 'tipoAcuerdo'}
         ,{name : 'solicitante'}
         ,{name : 'estado'}
         ,{name : 'fechaEstado'}
         ,{name : 'codigoEstado'}
      ]);

   var cmAcuerdos = new Ext.grid.ColumnModel([
      {header : '<s:message code="acuerdos.codigo" text="**C&oacute;digo" />', dataIndex : 'idAcuerdo',width: 35}
      ,{header : '<s:message code="acuerdos.fechaPropuesta" text="**Fecha Propuesta" />', dataIndex : 'fechaPropuesta',width: 65}
      ,{header : '<s:message code="acuerdos.tipoAcuerdo" text="**Tipo Acuerdo" />', dataIndex : 'tipoAcuerdo',width: 100}
      ,{header : '<s:message code="acuerdos.solicitante" text="**Solicitante" />', dataIndex : 'solicitante',width: 75}
      ,{header : '<s:message code="acuerdos.estado" text="**Estado" />', dataIndex : 'estado',width: 75}
      ,{dataIndex : 'codigoEstado', hidden:true, fixed:true,width: 75}
      ,{header : '<s:message code="acuerdos.fechaEstado" text="**Fecha Estado" />', dataIndex : 'fechaEstado',width: 65}
   ]);
 
   var acuerdosStore = page.getStore({
        flow: 'acuerdos/acuerdosAsunto'
        ,storeId : 'acuerdosStore'
        ,reader : new Ext.data.JsonReader(
            {root:'acuerdos'}
            , acuerdo
        )
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
   
   entidad.cacheStore(acuerdosStore);
   
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
   		panel.remove(panelAnterior);
		panelAnterior = recargarAcuerdo(-2);
		panel.add(panelAnterior);
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
     	}
   });
   
   var deshabilitarBotones=function(){
   			btnProponerAcuerdo.disable();
           	btnIncumplirAcuerdo.disable();
           	btnRechazarAcuerdo.disable();
			btnCerrarAcuerdo.disable();
   }
   var habilitarBotones=function(){
   			btnProponerAcuerdo.enable();
           	btnIncumplirAcuerdo.enable();
           	btnRechazarAcuerdo.enable();
			btnCerrarAcuerdo.enable();
   }
   
   var ocultarBotones=function(){
   			btnProponerAcuerdo.hide();
           	btnIncumplirAcuerdo.hide();
           	btnRechazarAcuerdo.hide();
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
           		 	acuerdosStore.webflow({id:panel.getAsuntoId()});
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
   
	var btnRechazarAcuerdo = new Ext.Button({
       text:  '<s:message code="acuerdos.rechazar" text="**Rechazar" />'
       <app:test id="btnRechazarAcuerdo" addComa="true" />
       ,iconCls : 'icon_menos'
       ,cls: 'x-btn-text-icon'
       ,hidden:true
       ,handler:function(){
      	   deshabilitarBotones();
      	    page.webflow({
      			flow:"acuerdos/rechazarAcuerdo"
      			,params:{
      				idAcuerdo:acuerdoSeleccionado
   				}
      			,success: function(){
           		 	acuerdosStore.on('load',despuesDeEvento);
           		 	acuerdosStore.webflow({id:panel.getAsuntoId()});
           		 	btnAceptarAcuerdo.hide();
           		 	btnRechazarAcuerdo.hide();
           		 	btnCerrarAcuerdo.hide();
           		 	btnIncumplirAcuerdo.hide();
           		}	
	      	});	
			habilitarBotones();
     	}
	});

	var acuerdosGrid = app.crearGrid(acuerdosStore,cmAcuerdos,{
         title : '<s:message code="acuerdos.grid.titulo" text="**Acuerdos" />'
         <app:test id="acuerdosGrid" addComa="true" />
         ,style:'padding-right:10px'
         ,autoHeight : true
         ,cls:'cursor_pointer'
         ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
         ,bbar : [
	        btnAltaAcuerdo
	        ,btnProponerAcuerdo
        	,btnIncumplirAcuerdo
     	   	,btnCerrarAcuerdo
        	,btnAceptarAcuerdo
        	,btnRechazarAcuerdo
			,btnCumplimientoAcuerdo
	      ]
	}); 

	var reload = function(){
		panel.remove(panelAnterior);
		panelAnterior = recargarAcuerdo(acuerdoSeleccionado);
		panel.add(panelAnterior);
		panel.doLayout();
		acuerdosStore.webflow({id:panel.getAsuntoId()});
	}
	
	panel.add(acuerdosGrid);
	
	//Comienzan las 4 partes dependientes del acuerdo	
	var panelAnterior;
	acuerdosGrid.on('rowclick', function(grid, rowIndex, e) {
   		var rec = grid.getStore().getAt(rowIndex);
		var idAcuerdo = rec.get('idAcuerdo');
		acuerdoSeleccionado = idAcuerdo;
		indexAcuerdoSeleccionado = rowIndex;
		
		//Muestro o no los botones que corresponden
		var codigoEstado = rec.get('codigoEstado');
		
		btnEditAcuerdo.setVisible(
			//esSupervisor  && PROPUESTO
			(panel.esSupervisor() && codigoEstado == app.codigoAcuerdoPropuesto)||
			//esGestor && (PROPUESTO||VIGENTE)
			(panel.esGestor() && (codigoEstado == app.codigoAcuerdoPropuesto || codigoEstado == app.codigoAcuerdoVigente))
		);
				
		
		btnAceptarAcuerdo.setVisible(
			//esSupervisor && PROPUESTO
			(panel.esSupervisor() && codigoEstado == app.codigoAcuerdoPropuesto)
		);
		
		btnRechazarAcuerdo.setVisible(
			//esSupervisor && (PROPUESTO||VIGENTE)
			(panel.esSupervisor() && (codigoEstado == app.codigoAcuerdoPropuesto || codigoEstado == app.codigoAcuerdoVigente))
		);
		
		btnIncumplirAcuerdo.setVisible(
			//esGestor && EN CONFORMACION
			(codigoEstado == app.codigoAcuerdoEnConformacion && panel.esGestor())||
			//esSupervisor && (VIGENTE)
			(panel.esSupervisor() && codigoEstado == app.codigoAcuerdoVigente)
		);
		if((codigoEstado == app.codigoAcuerdoEnConformacion && panel.esGestor())){
			btnIncumplirAcuerdo.setText('<s:message code="acuerdos.cancelar" text="**Cancelar" />');
		}else if(panel.esSupervisor() && codigoEstado == app.codigoAcuerdoVigente){
			btnIncumplirAcuerdo.setText('<s:message code="acuerdos.incumplido" text="**Incumplido" />');
		}
		
		
		btnProponerAcuerdo.setVisible(
			//esGestor && EN CONFORMACION
			(codigoEstado == app.codigoAcuerdoEnConformacion && panel.esGestor())
		);
		
		btnCerrarAcuerdo.setVisible(
			//esSupervisor && VIGENTE
			(codigoEstado == app.codigoAcuerdoVigente && panel.esSupervisor())
		);
		
		btnCumplimientoAcuerdo.setVisible(
			codigoEstado == app.codigoAcuerdoVigente
		);
		
		panel.remove(panelAnterior);
		panelAnterior = recargarAcuerdo(idAcuerdo);
		panel.add(panelAnterior);
		panel.doLayout();
		
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
		return panel2;
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
		
		var esVisible = [
			 [btnAltaAcuerdo, data.toolbar.esGestor || data.toolbar.esSupervisor]
			,[btnCumplimientoAcuerdo, data.toolbar.esGestor || data.toolbar.esSupervisor]
		];
		entidad.setVisible(esVisible);
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
