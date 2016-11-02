/**
 * Controlador global de aplicación que gestiona la funcionalidad de la entidad Agenda
 */
Ext.define('HreRem.controller.AgendaController', {
    extend: 'Ext.app.Controller',
    models: ['HreRem.model.Tarea', 'HreRem.model.DDBase'],
    requires : ['HreRem.view.agenda.TareaGenerica'],
    
    refs: [
				{
					ref: 'agendaMain',
					selector: 'agendamain'
				},
				{
					ref: 'agendaAlertasMain',
					selector: 'agendalertasmain'
				},
				{
					ref: 'agendaAvisosMain',
					selector: 'agendaavisosmain'
				},
				{
					ref: 'tramiteMain',
					selector: 'tramitesdetalle'
				}
	],
    
    
    control: {
    	
    	'agendamain' : {
    		abriractivo : 'abriractivo',
    		abrirtarea : 'abrirtareaagenda',
    		abrirtareahistorico : 'abrirtareahistorico',
    		nuevanotificacion : 'nuevanotificacion',
    		abrirtramite : 'abrirtramite'
    	},

		'tramitesdetalle' : {
			abrirtarea : 'abrirtarea',
			abrirtareahistorico : 'abrirtareahistorico',
			solicitarautoprorroga: 'solicitarautoprorroga',
			saltocierreconomico: 'saltocierreconomico'
		},
		
		'trabajosdetalle' : {			
			abrirtarea : 'abrirtarea',
			abrirtareahistorico : 'abrirtareahistorico'
		},
		
		'agendaalertasmain' : {
			abrirtarea : 'abrirtareaagenda',
			abriractivo : 'abriractivo'
		},
		
		'agendaavisosmain' : {
			abrirtarea : 'abrirtarea',
			abriractivo : 'abriractivo'
		}
		
    },
    
    abriractivo: function(record) {
		var me = this;
		me.getAgendaMain().lookupController().redirectTo('activos', true);
		me.getController('HreRem.controller.ActivosController').abrirDetalleActivoById(record.get("idEntidad"));   
		
		/*
    	var me = this;
    	HreRem.model.Activo.load(record.get("idEntidad"), {
    		scope: this,
		    success: function(activo) {
				me.createTab (me.getActivosMain(), 'activo', "activosdetalle",  activo);
		    }
		}); 	
    	*/
    	
    },
    
    
    nuevanotificacion: function(){
        var window;
        window = Ext.create('HreRem.view.agenda.CrearNotificacion');
	    window.show();
    },
    
        
    saltocierreconomico: function(target, idTareaExterna){
      	var me = this;
       	var window;
        	
       	window = Ext.create('HreRem.view.activos.tramites.SolicitarProrroga',{idTareaExterna : idTareaExterna});
       	target.add(window);
    	window.show();
    },
    
    abrirtareaagenda: function (record, grid, target) {
    	var me = this;
    	
        var tarea = record;
        /*
         * En caso de ser anotación abrir en la agenda, en caso contrario enlazar al listado de tareas del trámite.
         */
        if(tarea.get("subtipoTareaCodigoSubtarea") == "700"){
        	me.abrirtarea(record, grid, target);
        }else{
        	me.abrirtramite(record);
        }
    },
    
    abrirtarea: function(record, grid, target, idTrabajo, idActivo, idExpediente, numEC) {	
    		var me = this;
			// Abrimos primero el activo para evitar problemas de carga
//			var me = this;
//			
//			var arbolActivos = me.getMenuApp();
//			
//			var viewPortController = arbolActivos.lookupController();
//			viewPortController.redirectTo('activos' , true);
//			var listaActivos = viewPortController.getView().down('activoslist');
//			var activo = listaActivos.getStore().findRecord('id', record.get('idActivo'));
//			var tabActivos = viewPortController.getView().down('activosmain');
//			
//			tabActivos.lookupController().createTab('activo', activo, {
//		    title: 'Activo ' + activo.get('numActivoRem'),
//			closable: true,
//			idActivo: activo.get("id")
//		
//			}, listaActivos, "activostabdetalle");   
//			
//			var task = new Ext.util.DelayedTask(function(){    
//											
//			// Abrimos el tab de actuaciones
//	
//				var actuacionDef = tabActivos.lookupController().getViewModel().get('actuaciones').findRecord('idActuacion', record.get('idActuacion'));
//				
//			var prefix = 'actuacion';
//			var cfg  = {
//			      	title: 'Actuacion ' + actuacionDef.get('idActuacion'),
//			       	closable: true,
//			       	session: true,
//			       	idActuacion: actuacionDef.get("idActuacion"),
//			       	codigoTareaActiva: actuacionDef.get("codigoTareaActiva")
//			       	/*,
//			       	pintarfavorito: false*/	
//			    };
//			
//			
//			var id = prefix + '_' + actuacionDef.getId(),
//	        tab = tabActivos.items.getByKey(id);
//	
//			 if (!tab) {
//			 	cfg.itemId = id;
//			     cfg.xtype = 'actuaciontabmain';
//			     cfg.closable = true;
//			     cfg.session= true;
//			     //cfg.pintarfavorito = false;
//			     tab = tabActivos.add(cfg);
//			 }
//			 // Inyectamos los datos del record al form destino
//			 tab.down('cabeceratabmain').loadRecord(actuacionDef);
//			 tab.down('cabeceraactivo').loadRecord(actuacionDef);
//			 
//			 tab.down('tabpanel').setActiveTab(1)
//			 tabActivos.setActiveTab(tab);
//			 
//			 tabActivos.down('actuaciontabmain').fireEvent("pintarfav", tabActivos.down('actuaciontabmain'), tabActivos.down('actuaciontabmain').idActuacion);
//	
//			// Funcion que abre la ventana de resolver tarea
//			var tarea = record;
//	
//				
//	        var me = this;
	        var window;
//	        
//	        
//	        if(tarea.get("idTipoTarea") == "sp300"){
	        //debugger;
	        var tarea = record;
	        if(tarea.get("subtipoTareaCodigoSubtarea") == "700" || tarea.get("subtipoTareaCodigoSubtarea") == "701"){
	        	var url =  $AC.getRemoteUrl('agenda/detalleTarea');
	        	var idTarea = record.get("id");
	        	var sta = record.get("subtipoTareaCodigoSubtarea");
	        	var data;
	    		Ext.Ajax.request({
	    			
	    		     url: url,
	    		     params: {idTarea : idTarea, subtipoTarea : sta},
	    		
	    		     success: function(response, opts) {
	    		    	 data = Ext.decode(response.responseText);
	    		    	 data.data.parent = grid;
	    		    	 data.data.numActivo = record.get('codEntidad');
	    		    	 if(sta == "701"){
	    		    		 data.data.tareaEditable = false;
	    		    		 data.data.tareaFinalizable = true;
	    		    	 }
	    		         window = Ext.create('HreRem.view.agenda.TareaNotificacion',data.data);
	    		         
	    		     },
	    		     failure: function(response) {
	    		    	 window = Ext.create('HreRem.view.agenda.TareaGenerica');
	    		     },
	    		     callback: function(options, success, response){
	    		    	 target.add(window);
	    		    	 window.show();
	    		     }
	    		     
	    		 });
	    		
	        }else{
	        	var url = $AC.getRemoteUrl('agenda/getFormularioTarea');
	        	var idTarea = record.get("id");
	        	var codigoTarea = record.get("codigoTarea");
	        	var sta = record.get("subtipoTareaCodigoSubtarea");
	        	var data;
	        	var titulo;
	        	if(record.get("tipoTarea"))
	        	{	titulo = record.get("tipoTarea"); }
	        	else
	        	{	titulo = record.get("nombreTarea"); }
	        	Ext.Ajax.request({
	        			url:url,
	        			params: {idTarea : idTarea, subtipoTarea: sta},
	        			success: function(response,opts){
	        				window = Ext.create('HreRem.view.agenda.TareaGenerica',{idTarea : idTarea, codigoTarea : codigoTarea, titulo : titulo, campos:response.responseText, parent: grid, idTrabajo: idTrabajo, idActivo: idActivo, idExpediente: idExpediente, numExpediente: numEC});
	        			},
	        			callback: function(options, success, response){
	        				target.add(window);
	        				window.show();
	        			}
	        	});
	        }
	        /*else{
	        	
	        }*/
//	
//	        }else if(tarea.get("idTipoTarea") == "sp303"){
//	        	window = Ext.create('HreReos.view.activos.actuacion.tareas.forms.PropuestaComite');
//	        	
//	        }else if(tarea.get("idTipoTarea") == "sp304"){
//	        	window = Ext.create('HreReos.view.activos.actuacion.tareas.forms.ResolucionComite');
//	        
//	        }else if(tarea.get("idTipoTarea") == "sp306"){
//	        	window = Ext.create('HreReos.view.activos.actuacion.tareas.forms.ContraofertarCliente');
//	        
//	        }else{
//	        	Ext.Msg.show({
//				    message: 'Tarea no implementada.',
//				    buttons: Ext.Msg.YES,
//				    icon: Ext.Msg.WARNING}); 
//	        }
//	
//	        if(window){
//		        window.down('form').loadRecord(tarea);
		        
//	        }
//	
//	    });                                                
//	    task.delay(500);
		
//    	Ext.Msg.show({
//		    message: 'Tarea no implementada.',
//		    buttons: Ext.Msg.YES,
//		    icon: Ext.Msg.WARNING}); 
	
	},
    
    abrirtareahistorico: function(record) {	
		var me = this;
        var window;

        var tarea = record;

        	var url = $AC.getRemoteUrl('agenda/getFormularioTarea');
        	var idTarea = record.get("id");
        	var sta = record.get("subtipoTareaCodigoSubtarea");
        	var data;
        	var tarea = record;
	        if(tarea.get("subtipoTareaCodigoSubtarea") == "41" || tarea.get("subtipoTareaCodigoSubtarea") == "41"){
	        	var url =  $AC.getRemoteUrl('agenda/detalleTarea');
	        	var idTarea = record.get("id");
	        	var sta = record.get("subtipoTareaCodigoSubtarea");
	        	var data;
	    		Ext.Ajax.request({
	    			
	    		     url: url,
	    		     params: {idTarea : idTarea, subtipoTarea : sta},
	    		
	    		     success: function(response, opts) {
	    		    	 data = Ext.decode(response.responseText);
//	    		    	 data.data.parent = grid;
//	    		    	 if(sta == "41"){
//	    		    		 data.data.tareaEditable = false;
//	    		    		 data.data.tareaFinalizable = true;
//	    		    	 }
	    		         window = Ext.create('HreRem.view.agenda.TareaProrroga',data.data);
	    		         
	    		     },
	    		     failure: function(response) {
	    		    	 window = Ext.create('HreRem.view.agenda.TareaGenerica');
	    		     },
	    		     callback: function(options, success, response){
	    		    	 //target.add(window);
	    		    	 window.show();
	    		     }
	    		     
	    		 });
	    		
	        }else{
	        	Ext.Ajax.request({
	        			url:url,
	        			params: {idTarea : idTarea, subtipoTarea: sta},
	        			success: function(response,opts){
	
	        				//debugger;
	        				window = Ext.create('HreRem.view.agenda.TareaHistorico',{idTarea : idTarea, titulo : record.get("tipoTarea"), campos:response.responseText});
	        			},
	        			callback: function(options, success, response){
	        				window.show();
	        			}
	        	});
	        }

    },
    
    abrirtramite: function(record){
    	var me = this;
    	//me.getAgendaMain().lookupController().redirectTo('tramites',true);
    	me.getAgendaMain().lookupController().redirectTo('activos',true);	
    	//me.getController('HreRem.controller.ActivosController').abrirDetalleTramiteById(record.get("idEntidad"));
    	
    	var titulo = "Tramite " + record.get("contrato");
    	var idRecord = record.get("contrato");
    	
    	me.getController('HreRem.controller.ActivosController').abrirDetalleTramiteTareasById(idRecord, titulo, 'tareaslist');
    },
    
    solicitarautoprorroga: function(target, idTareaExterna){
    	var me = this;
    	var window;
    	
    	window = Ext.create('HreRem.view.activos.tramites.SolicitarProrroga',{idTareaExterna : idTareaExterna});
	   	target.add(window);
		window.show();
    	
    }
    
	
});