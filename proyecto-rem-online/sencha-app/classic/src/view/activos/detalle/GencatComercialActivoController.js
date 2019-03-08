
Ext.define('HreRem.view.activos.detalle.GencatComercialActivoController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.gencatcomercialactivo', 
    requires: ['HreRem.controller.ActivosController', 'HreRem.view.activos.detalle.GencatComercialActivoFormHist'],
    
    
    control: {

    	'documentoscomunicaciongencatlist': {
		abrirFormulario: 'abrirFormularioAdjuntarDocumentoComunicacion',
		onClickRemove: 'borrarDocumentoAdjunto',
		download: 'downloadDocumentoComunicacionActivo',
		afterupload: function(grid) {
		grid.getStore().load(); 
		}
        },

	'documentoscomunicacionhistoricogencatlist': {
		abrirFormulario: 'abrirFormularioAdjuntarComunicacionHistoricoActivo',
		//onClickRemove: 'borrarDocumentoAdjunto',
		download: 'downloadDocumentoComunicacionActivo',
		afterupload: function(grid) {
		grid.getStore().load();
		}
	},
		
	'notificacionesactivolist': {
		abrirFormulario: 'abrirFormularioCrearNotificacion',
		//onClickRemove: 'borrarDocumentoAdjunto',
		aftercreate: function(grid) {
			grid.getStore().load(); 
		}
    	},
    	
    'documentosactivogencatlist': {
            //  abrirFormulario: 'abrirFormularioAdjuntarComunicacionActivo', 
            //onClickRemove: 'borrarDocumentoAdjunto',
            download: 'downloadDocumentoComunicacionActivo'//,
            /*afterupload: function(grid) {
            	grid.getStore().load();
            }*/
        }

    },
    
    cargarTabData: function (form) {
    	form.up("activosdetallemain").lookupController().cargarTabData(form);
    },
    
    onClickSolicitarVisita: function(btn) {

        var me = this;
        //TODO: Funcionalidad del botón de solicitar visitas de GENCAT
        console.log("onClickSolicitarVisita");

    },
    
    onHistoricoComunicacionesDoubleClick: function(dv, record, item, index, e) {
    	
    	var me = this;
    	
    	var fieldsetHistorico = dv.up().up();
    	var formHistorico = fieldsetHistorico.down('[reference=gencatcomercialactivoformhistoricoref]');
    	if (formHistorico != null) {
    		fieldsetHistorico.remove(formHistorico);
    	}
    	
    	var nuevoFormHistorico = {	
			xtype: 'gencatcomercialactivoformhist',
			reference: 'gencatcomercialactivoformhistoricoref',
			idHComunicacion: record.id
		};
    	
    	fieldsetHistorico.add(nuevoFormHistorico);
    	
    },
    
    abrirFormularioAdjuntarDocumentoComunicacion: function(grid) {
    	
		var me = this;
		var idActivo = me.getViewModel().get("activo.id");
		var data = {
			entidad: 'gencat', 
			idEntidad: idActivo, 
			parent: grid
		};
		Ext.create("HreRem.view.common.adjuntos.AdjuntarDocumentoComunicacionGencat", data).show();
		
	},
	
	abrirFormularioAdjuntarComunicacionHistoricoActivo: function(grid) {
    	
		var me = this;
		var idActivo = me.getViewModel().get("activo.id");
		var data = {
			entidad: 'gencat', 
			idEntidad: idActivo, 
			parent: grid,
			idHComunicacion: grid.up("gencatcomercialactivoform").idHComunicacion
		};
		Ext.create("HreRem.view.common.adjuntos.AdjuntarDocumentoComunicacionHistoricoGencat", data).show();
		
	},
    
    downloadDocumentoComunicacionActivo: function(grid, record) {
		
		var me = this,
		config = {};
		
		config.url= $AC.getWebPath() + "gencat/bajarAdjuntoComunicacion." + $AC.getUrlPattern();
		config.params = {};
		config.params.id=record.get('id');
		config.params.nombreDocumento=record.get("nombre");
		
		me.fireEvent("downloadFile", config);
	},
	
    onClickAbrirExpedienteComercial: function() { 
		    	
		    	var me = this;
		    	var gencat = me.getViewModel().data.gencat;
		    	var numOfertaGencat = gencat.data.ofertaGencat;
		    	var data; 
		    	
		    	var url =  $AC.getRemoteUrl('expedientecomercial/getExpedienteByIdOferta');
		  
		    	Ext.Ajax.request({
				     url: url,
				     method: 'POST',
				     params: {numOferta : numOfertaGencat},
				     success: function(response, opts) {
				    	data = Ext.decode(response.responseText);
				    	if(data.data){
				 		   me.getView().fireEvent('abrirDetalleExpedienteOferta', data.data);
				    	}
				    	else {
				    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				    	}
				    },
				    
				     failure: function (a, operation) {
				 				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				 	}
			 });
		    		    	     
    },	
	
	abrirFormularioCrearNotificacion: function(grid) {
		
		var me = this;
		
		var idActivo = me.getViewModel().get("activo.id");
		var data = {
			idActivo: idActivo, 
			parent: grid
		};
		Ext.create("HreRem.view.common.adjuntos.VentanaCrearNotificacion", data).show();
		
	},
	
	//Sin utilizar desde HREOS-5509
//	onClickAdjuntarDocumentoNotificaciones: function(btn) {
//		
//		var me = this;
//		var idActivo = me.getViewModel().get("activo.id");
//		var data = {
//			entidad: 'gencat', 
//			idEntidad: idActivo
//		};
//		Ext.create("HreRem.view.common.adjuntos.AdjuntarDocumentoNotificacionGencat", data).show();
//	},
	
	onClickGuardarNotificacion: function(btn) {
		
		var me = this;
		
		var window = btn.up('[reference=ventanacrearnotificacionRef]');
		
		var form = window.down('[reference=crearNotificacionFormRef]');
		
		if(form.isValid()){
    		
            form.submit({
                waitMsg: HreRem.i18n('msg.mask.loading'),
                params: {
                	idEntidad: window.idActivo,
                	idActivo: window.idActivo
                },
                success: function(fp, o) {

                	if(o.result.success == "false") {
                		window.fireEvent("errorToast", o.result.errorMessage);
                	}
                	else {
                		window.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
                	}
                	
                	if(!Ext.isEmpty(window.parent)) {
                		window.parent.fireEvent("aftercreate", window.parent);
                	}
                	window.close();
                },
                failure: function(fp, o) {
                	window.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
                }
            });
        }
	
		me.fireEvent("downloadFile", config);
	},
	
  onClickAbrirVisitaActivo: function() {
	  
	  	var me = this;
	  	var gencat = me.getViewModel().data.gencat;
	  	var numVisita =  gencat.data.idVisita;
		var url =  $AC.getRemoteUrl('visitas/getVisitaByIdVisitaGencat');
		Ext.Ajax.request({
		     url: url,
		     method: 'POST',
		     params: {numVisita: numVisita},
		     success: function(response, opts) {
		    	 var record = JSON.parse(response.responseText);
		    		if(record.success === 'true') {
						var ventana = Ext.create('HreRem.view.comercial.visitas.VisitasComercialDetalle',{detallevisita: record});
						me.getView().up('mainviewport').add(ventana);
						ventana.show();
					} else {
						me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					}
		    },
		    failure: function (a, operation) {
		    	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		 	}
		});
		
		
	}
  
  
  
  
	,borrarDocumentoAdjunto: function(grid, record) {
		var me = this,
		idActivo = me.getViewModel().get("activo.id");
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		record.erase({
			params: {idEntidad: idActivo},
            success: function(record, operation) {
            	 grid.fireEvent("afterdelete", grid);
            	 grid.getStore().load();
             	 grid.disableRemoveButton(true);
           		 me.getView().unmask();
           		 me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
            },
            failure: function(record, operation) {
				 grid.fireEvent("afterdelete", grid);
				 me.getView().unmask();
                 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
            }
            
        });	
	},	
	onGridReclamacionesActivoRowClick: function(grid , record , tr , rowIndex){
    	if ($AU.userIsRol(CONST.PERFILES['HAYAGESTFORMADM']) || $AU.userIsRol(CONST.PERFILES['GESTIAFORM']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER'])) {
    		grid.getPlugin('rowEditing').editor.form.findField('fieldToDisable').enable();
        } else {
            grid.getPlugin('rowEditing').editor.form.findField('fieldToDisable').disable();
    	}
    },

    ondblClickAbreExpediente: function(grid, record) {
    	var me = this;
    	var gencat = me.getViewModel().data.gencat;
    	var numOfertaGencat = record.data.numOferta;
    	var data; 
    	
    	var url =  $AC.getRemoteUrl('expedientecomercial/getExpedienteByIdOferta');
  
    	Ext.Ajax.request({
		     url: url,
		     method: 'POST',
		     params: {numOferta : numOfertaGencat},
		     success: function(response, opts) {
		    	data = Ext.decode(response.responseText);
		    	if(data.data){
		 		   me.getView().fireEvent('abrirDetalleExpedienteOferta', data.data);
		    	}
		    	else {
		    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    	}
		    },
		    
		     failure: function (a, operation) {
		 				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		 	}
	 });
	},	
	onBeforeEditReclamacionesActivo: function(editor, context, eOpts) {
		if(context.record.get('IsUserAllowed')) {
			return true;
		} else {
			return false;
		}
	},
	comprobarCampoNifNombre: function(combo, value) {
		var me = this;
		var campoNif = me.lookupReference('nuevoCompradorNifref');
		var campoNombre = me.lookupReference('nuevoCompradorNombreref');
		var campoSancion = me.lookupReference('sancionRef');
		var campoFechaSancion = me.lookupReference('fechaSancionRef');
		
		if (campoSancion.getValue() == CONST.DD_SAN_SANCION['COD_EJERCE']) {
			campoFechaSancion.allowBlank = false;
			campoNombre.allowBlank = false;
			campoNif.allowBlank = false;
		} else if (campoSancion.getValue() == CONST.DD_SAN_SANCION['COD_NO_EJERCE']) {
			campoFechaSancion.allowBlank = false;
			campoNombre.allowBlank = true;
			campoNif.allowBlank = true;
		}else {
			campoFechaSancion.allowBlank = true;
		}
	},
	
comprobarFormatoNIF: function(value) {
		var me = this;
		value = me.lookupReference('nuevoCompradorNifref');
		if (value.length == 9) { // Comprobamos NIF y NIE
			var validChars = 'TRWAGMYFPDXBNJZSQVHLCKET';
			var nifRexp = /^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
			var nieRexp = /^[XYZ]{1}[0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
			var str = value.toString().toUpperCase();
   
			var continuar = true;
			if (!nifRexp.test(str) && !nieRexp.test(str))
				continuar = false;

			if (continuar) {
				var nie = str.replace(/^[X]/, '0').replace(
						/^[Y]/, '1').replace(/^[Z]/, '2');

				var letter = str.substr(-1);
				var charIndex = parseInt(nie.substr(0, 8)) % 23;

				if (validChars.charAt(charIndex) === letter)
					return true;
			}
		}

		if (value.length == 9) { // Comprobamos CIF
			var CIF_REGEX = /^([ABCDEFGHJKLMNPQRSUVW])(\d{7})([0-9A-J])$/;
			var str = value.toString().toUpperCase();
		    var auxMatch = str.match(CIF_REGEX);
		    var letter  = auxMatch[1],
		        number  = auxMatch[2],
		        control = auxMatch[3];

		    var even_sum = 0;
		    var odd_sum = 0;
		    var n;

		    for ( var i = 0; i < number.length; i++) {
		      n = parseInt( number[i], 10 );
		      if ( i % 2 === 0 ) {
		        n *= 2;
		        odd_sum += n < 10 ? n : n - 9;
		      } else {
		        even_sum += n;
		      }

		    }

		    var control_digit = (10 - (even_sum + odd_sum).toString().substr(-1) );
		    var control_letter = 'JABCDEFGHI'.substr( control_digit, 1 );

		    if ( letter.match( /[ABEH]/ ) && control == control_digit) {
		      return true;

		    } else if ( letter.match( /[KPQS]/ ) && control == control_letter) {
		      return true;

		    } else if (control == control_digit || control == control_letter) {
		      return true;
		    }
		}

		return HreRem
				.i18n('msg.error.comprador.nif.incorrecto');
 	},
	
 	onExisteDocumentoAnulacion: function(btn, newValue, oldValue, opts){
 		if(newValue){
 			var me = this;
 	 		
 	 		var idActivo = me.getViewModel().get("activo.id");
 	 		
 	 		Ext.Ajax.request({
 	 			url: $AC.getRemoteUrl('gencat/comprobacionDocumentoAnulacion'),
 	 			params: {idActivo: idActivo},
 	 		     method: 'GET',
 	 		     success: function(response, opts){
 	 		    	data = Ext.decode(response.responseText);
 	 		    	if(data.data == 'false'){
 	 		    		me.fireEvent("errorToast", HreRem.i18n("msg.falta.documento.anulacion"));
 	 		    		me.lookupReference('checkComunicadoAnulacion').setValue(false);
 						Ext.getCmp('checkComunicadoAnulacion').setValue(false);
 	 		    	 }
 	 		    	 
 	 				},
 	 		    
 	 		     failure: function (a, operation) {
 	 		 				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
 	 		 	},
 	 		    callback: function(record, operation) {
 	 				me.getView().unmask();
 	 		    }
 	 		 });
 		}

 		
 	}
});
