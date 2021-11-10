Ext.define('HreRem.view.common.TareaController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.tarea',
    
    
    cancelarTarea: function(button) {
        	
		button.up('window').destroy();
        	
     },
     
     guardarTarea: function(button) {
        	
        	var me = this,
        	tarea = button.up("tareabase"),
        	record;
        	var panelExpediente = null;

//        	Ext.Msg.show({
//			    title:'Guardar solicitud',
//			    message: '¿Está seguro que desea guardar los cambios?',
//			    buttons: Ext.Msg.YESNO,
//			    icon: Ext.Msg.QUESTION,
//			    fn: function(btn) {
//	        		if (btn === 'yes') { 
	        			if(tarea.down('form').getForm().isValid()) {
		        			tarea.mask("Guardando....");
		        			if(tarea.getInitialConfig().codigoTarea == CONST.TAREAS['T015_DEFINICIONOFERTA']){
		        				panelExpediente = button.up('activosmain').down('panel[title=Expediente '+tarea.numExpediente+']')
		        				if(!Ext.isEmpty(panelExpediente)){
		        					if(tarea.down('form').down('genericcombo[name=tipoTratamiento]').getValue() == CONST.TIPO_INQUILINO['SCORING']){
		        						panelExpediente.down('scoringexpediente').tab.setVisible(true); 
		        						panelExpediente.lookupReference("fechaReserva").setFieldLabel(HreRem.i18n('fieldlabel.fecha.scoring'));
		        						panelExpediente.lookupReference("fechaReserva").setVisible(true);
		        					} else if(tarea.down('form').down('genericcombo[name=tipoTratamiento]').getValue() == CONST.TIPO_INQUILINO['SEGURO_RENTAS']){
		        						panelExpediente.down('segurorentasexpediente').tab.setVisible(true);
		        						panelExpediente.lookupReference("fechaReserva").setFieldLabel(HreRem.i18n('fieldlabel.fecha.segurorentas'));
		        						panelExpediente.lookupReference("fechaReserva").setVisible(true);
		        					}
		        				}
		        			}
			        		var task = new Ext.util.DelayedTask(function(){    			
			        			
			        			var siguienteTarea = tarea.evaluar();
			        			
//			        			if(Ext.isEmpty(siguienteTarea)) {
//			        				tarea.unmask();
//			        				tarea.mostrarValidacionesPost();
//			        				tarea.unmask();
//			        				tarea.destroy();
//			        			}else {		        				
//			        				tarea.down("form").updateRecord();
//			        				record = tarea.down("form").getRecord();
//			        				tarea.fireEvent("avanzaBPM", record, siguienteTarea);
//			        				tarea.unmask();
//			        				tarea.destroy();
//			        			}
							});
							
							task.delay(500);
	        			}
	
//	        		}
//	        		
//			    }
//			});
        	
        	
        	

       },
       
       finalizarTarea: function(button) {
       	
       	var me = this,
       	tarea = button.up("tareabase"),
       	valoresTarea = tarea.down('form').getValues();
       	var url = $AC.getRemoteUrl('notificacion/finalizarNotificacion');

    	Ext.Ajax.request({
    			url:url,
    			params: {idTarea : valoresTarea.idTarea},
    			success: function(response,opts){
    				var me;
    			},
    			callback: function(options, success, response){
        			tarea.mask("Guardando....");
        			
	        		var task = new Ext.util.DelayedTask(function(){    			
	    				tarea.unmask();
	    				tarea.destroy();

					});
					
					task.delay(500);
    			}
    	});       	
    	
	        			
//	        			if(tarea.down('form').getForm().isValid()) {
//	        				
//
//	        			}


      },
       
       getValidacionPrevia: function(window) {
       		window.mask("Validando...");
       		var me = this;
	       	var url = $AC.getRemoteUrl('agenda/getValidacionPrevia');
	        Ext.Ajax.request({
	    			url:url,
	    			params: {idTarea : window.idTarea},
	    			success: function(response,opts){
	    				var me;
	    			},
	    			callback: function(options, success, response){
	    				me.errorValidacion = response.responseText;
	    				
						me.json = Ext.decode(me.errorValidacion);
						me.errorMensaje = me.json.data;				
						me.getViewModel().set("errorValidacion", me.errorMensaje);
	    				window.unmask();
	    			}
	    	});       	
	       	
       	
       },
       
       getValidacionGuardado: function(window,button) {
    	   var me = this;
    	   
    	   var url = $AC.getRemoteUrl('agenda/getValidacionGuardado');
    	   Ext.Ajax.request({
    		  url:url,
    		  params:  {idTarea : window.idTarea},
    		  success: function(response,opts){
    			  var me;
    		  },
    		  callback: function(options, success, response){
    			  me.errorValidacion = response.responseText;
    			  
    			  me.json = Ext.decode(me.errorValidacion);
    			  me.errorMensaje = me.json.data;
    			  
    			  me.getViewModel().set("errorValidacionGuardado", me.errorMensaje);
    		  }
    	   });
       },
       
       getAdvertenciaTarea: function(window) {
			var me = this;
			var codigoProcedimientoAdvertencia = [
				'T002_AnalisisPeticion', 'T002_SolicitudDocumentoGestoria', // 1as tareas T. Obtenci�n documental
				'T003_AnalisisPeticion', 'T003_EmisionCertificado',         // 1as tareas T. Obtenci�n doc. CEE
				'T004_AnalisisPeticion',                                    // 1a tarea T. Actuaci�n T�cnica
				'T005_AnalisisPeticion', 'T005_EmisionTasacion',            // 1as tareas T. Tasaci�n
				'T006_AnalisisPeticion', 'T006_EmisionInforme',             // 1as tareas T. Informe
				'T007_DescargaListadoMensual',                              // 1a tarea T. Facturaci�n
				'T008_SolicitudDocumento'];                                 // 1a tareas T. C�dula
				
				
			//Advertencia de que existen otros trabajos del mismo Tipo/Subtipo
			var url = $AC.getRemoteUrl('agenda/getAdvertenciaTarea');
			
			Ext.Ajax.request({
			  url:url,
			  params:  {idTarea : window.idTarea},
			  success: function(response,opts){
				  //TODO: Aqu� debe mostrarse el mensaje de alerta para existencia de otros subtipos de trabajo
				  var codigoTramite = Ext.JSON.decode(response.responseText).codigoTramite;
				  var codigoTareaProcedimiento = Ext.JSON.decode(response.responseText).codigoTareaProcedimiento;
				  var advertencia = Ext.JSON.decode(response.responseText).advertenciaExisteTrabajo;
				  
				  if(codigoTramite != "T001"){
				  	  //La advertencia solo se muestra en tr�mites derivados de trabajos (cualquiera menos el 1o)
					  if(codigoProcedimientoAdvertencia.indexOf(codigoTareaProcedimiento) > -1){
				  		//La advertencia solo se muestra en la 1as tareas de cada tr�mite
					  	me.getViewModel().set("textoAdvertenciaTarea", advertencia);
					  }
				  }
			  }
			});
       },
       
       getAdvertenciaTareaComercial: function(window) {
       		var me = this;				
			//Advertencia de que existen otros trabajos del mismo Tipo/Subtipo
			var url = $AC.getRemoteUrl('agenda/getAdvertenciaTareaComercial');
			Ext.Ajax.request({
			  url:url,
			  params:  {idTarea : window.idTarea},
			  success: function(response,opts){
				  var advertencia = Ext.JSON.decode(response.responseText).textoAdvertencia;
				  me.getViewModel().set("textoAdvertenciaTarea", advertencia);
			  }
			});
		},

		verBotonEnlaceTrabajo: function(window, invisible) {
		
			  	
			var me = this;
			
			//INVisibilizar boton enlace a Trabajo
			var url = $AC.getRemoteUrl('agenda/getCodigoTramiteTarea');
			Ext.Ajax.request({
			  url:url,
			  params:  {idTarea : window.idTarea},
			  success: function(response,opts){
				  //TODO: Aqui debe mostrarse el mensaje de alerta para existencia de otros subtipos de trabajo
				  var codigoTramite = Ext.JSON.decode(response.responseText).codigoTramite;
				  
				  if(invisible){
					  	me.getView().down('[handler=enlaceAbrirTrabajo]').hide();
				  }
				  
				  if(codigoTramite == "T001"){
				  	  //Se visibiliza boton-enlace solo cuando es cualquier tramite menos el 1o (admision)
				  	  //Esta regla prima sobre otras
					  	me.getView().down('[handler=enlaceAbrirTrabajo]').hide();
					  	me.getView().down('[handler=enlaceAbrirExpediente]').hide();
				  }
				  
				  if(codigoTramite == "T013" || codigoTramite == "T014" || codigoTramite == "T015"){
				  	  //Se visibiliza boton-enlace EXPEDIENTE
				  	  //Se oculta el trabajo
				  	  	me.getView().down('[handler=enlaceAbrirTrabajo]').hide();
					  	me.getView().down('[handler=enlaceAbrirExpediente]').show();
				  }
				  if(codigoTramite == "T016"){
				  //Se visibiliza boton-enlace EXPEDIENTE
				  //Se oculta el trabajo
					me.getView().down('[handler=enlaceAbrirTrabajo]').hide();
				  }
				  
			  }
			});
			
		},
		
		verBotonEnlaceActivo: function(window, invisible) {
		
			   	
			var me = this;
			
			//INVisibilizar boton enlace a Activo
			if(invisible){
			 	me.getView().down('[handler=enlaceAbrirTrabajo]').hidden = true;
			}
			
		},

		verBotonEnlaceExpediente: function(window, invisible) {
		
			    	
			var me = this;
			
			//INVisibilizar boton enlace a Expediente
			if(invisible){
			 	me.getView().down('[handler=enlaceAbrirExpediente]').hidden = true;
			}
			
		},
		
		enlaceAbrirTrabajo: function(button) {

			var me = this,
			window = button.up('window'),
			idTrabajo = window.idTrabajo;

			if(Ext.isEmpty(idTrabajo)) {
				
				window.mask();
						
				//Llamada Ajax para obtener el idTrabajo relacionado con la tarea (idTarea)
			    var url = $AC.getRemoteUrl('agenda/getIdTrabajoTarea');
			    Ext.Ajax.request({
				  url:url,
				  params:  {idTarea : me.getView().idTarea},
				  success: function(response,opts){
					  idTrabajo = Ext.JSON.decode(response.responseText).idTrabajoTarea;					  
					  me.getView().fireEvent('abrirDetalleTrabajoById', idTrabajo, null, button.reflinks);
				  },
				  callback: function(options, success, response){
					  window.unmask();
				  }
			    });
			} else {
				me.getView().fireEvent('abrirDetalleTrabajoById', idTrabajo, null, button.reflinks);			
			}
				
				
		},
	
	enlaceAbrirExpediente: function(button) {

		var me = this,
		window = button.up('window'),
		idExpediente = window.idExpediente;
		numExpediente = window.numExpediente;

		if(Ext.isEmpty(idExpediente) || Ext.isEmpty(numExpediente)) {
			
			window.mask();
					
			//Llamada Ajax para obtener el idExpediente relacionado con la tarea (idTarea)
		    var url = $AC.getRemoteUrl('agenda/getNumIdExpediente');
		    Ext.Ajax.request({
			  url:url,
			  params:  {idTarea : me.getView().idTarea},
			  success: function(response,opts){
				  idExpediente = Ext.JSON.decode(response.responseText).idExpediente;
				  numExpediente = Ext.JSON.decode(response.responseText).numExpediente;					  
				  titulo = "Expediente " + numExpediente;
				  me.getView().fireEvent('abrirDetalleExpedienteById', idExpediente, titulo, button.reflinks);
			  },
			  callback: function(options, success, response){
				  window.unmask();
			  }
		    });
		    
		} else {
			titulo = "Expediente " + numExpediente;
			me.getView().fireEvent('abrirDetalleExpedienteById', idExpediente, titulo, button.reflinks);			
		}
			
			
	},
		
	enlaceAbrirActivo: function(button) {

		var me = this,
		window = button.up('window');
		
		var idActivo = button.idActivo ? button.idActivo : window.idActivo;
		
		button.up('window').mask();
		
		me.redirectTo('activos',true);
		///Si es una notificación tiene idActivo, si es una tarea de activo lo obtenemos a través de una llamada AJAX.
		if(Ext.isEmpty(idActivo)){
			//Llamada Ajax para obtener el idActivo relacionado con la tarea (idTarea)
		    var url = $AC.getRemoteUrl('agenda/getIdActivoTarea');
		    Ext.Ajax.request({
			  url:url,
			  params:  {idTarea : me.getView().idTarea},
			  success: function(response,opts){
				  
				  idActivo = Ext.JSON.decode(response.responseText).idActivoTarea;
				  
				  me.getView().fireEvent('abrirDetalleActivoPrincipal', idActivo, button.reflinks);

			  },
			  callback: function(options, success, response){

				  button.up('window').unmask();

			  }
			  
		    });
		}else{
			  me.getView().fireEvent('abrirDetalleActivoPrincipal', idActivo, button.reflinks);
			  button.up('window').unmask();
		}
	},
	
	enlaceAbrirActivoNotificacion: function(button) {
		var me = this,
		window = button.up('window');
		
		var idActivo = button.idActivo ? button.idActivo : window.idActivo;
		var numAgr = me.getView().numAgrupacion;
		var idAgr;
		
		button.up('window').mask();
		
		me.redirectTo('activos',true);

		if(!Ext.isEmpty(numAgr) && numAgr != null) {
			
			var url = $AC.getRemoteUrl('agenda/getIdAgrByNumAgr');
		    Ext.Ajax.request({
			  url:url,
			  params:  {idNumAgr : me.getView().numAgrupacion},
			  success: function(response,opts){
				  idAgr = Ext.JSON.decode(response.responseText).idAgrTarea;
				  
				 if(idAgr != null){
					 me.getView().fireEvent('abrirDetalleAgrupacionById', idAgr, null);
				 }else{
					 me.errorMensaje="Id Agrupacion no encontrado";
					 me.getViewModel().set("errorValidacion", me.errorMensaje);
				 }
			  },
			  callback: function(options, success, response){
				  button.up('window').unmask();
			  }
		    });
		} else if(Ext.isEmpty(idActivo)){

			var url = $AC.getRemoteUrl('agenda/getIdActivoByNumActivo');
		    Ext.Ajax.request({
			  url:url,
			  params:  {idNumAct : me.getView().numActivo},
			  success: function(response,opts){
				  idActivo = Ext.JSON.decode(response.responseText).idActivoTarea;
				  
				 if(idActivo != null){
					 me.getView().fireEvent('abrirDetalleActivoPrincipal', idActivo, button.reflinks);
				 }else{
					 me.errorMensaje="Id Activo no encontrado";
					 me.getViewModel().set("errorValidacion", me.errorMensaje);
				 }
			  },
			  callback: function(options, success, response){

				  button.up('window').unmask();

			  }
			  
		    });
		}else{
			  me.getView().fireEvent('abrirDetalleActivoPrincipal', idActivo, button.reflinks);
			  button.up('window').unmask();
		}
	},
	
    onChangeChainedCombo: function(combo) {
    	var me = this,
    	chainedCombo = me.lookupReference(combo.chainedReference);    	
    	me.getViewModel().notify();
    	if(!Ext.isEmpty(chainedCombo.getValue())) {
			chainedCombo.clearValue();
    	}
		
		chainedCombo.getStore().load({ 			
			callback: function(records, operation, success) {
   				if(!Ext.isEmpty(records) && records.length > 0) {
   					if (chainedCombo.selectFirst == true) {
	   					chainedCombo.setSelection(1);
	   				};
   					chainedCombo.setDisabled(false);
   				} else {
   					chainedCombo.setDisabled(true);
   				}
			}
		});
		
		if (me.lookupReference(chainedCombo.chainedReference) != null) {
			var chainedDos = me.lookupReference(chainedCombo.chainedReference);
			if(!chainedDos.isDisabled()) {
				chainedDos.clearValue();
				chainedDos.getStore().removeAll();
				chainedDos.setDisabled(true);
			}
		}

    }
    
});
