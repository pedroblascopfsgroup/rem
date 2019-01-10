Ext.define('HreRem.view.activos.detalle.GencatComercialActivoController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.gencatcomercialactivo', 
    requires: ['HreRem.controller.ActivosController'],
    
    
    control: {

    	'documentoscomunicaciongencatlist': {
		abrirFormulario: 'abrirFormularioAdjuntarDocumentoComunicacion',
		//onClickRemove: 'borrarDocumentoAdjunto',
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
			xtype: 'gencatcomercialactivoform',
			reference: 'gencatcomercialactivoformhistoricoref',
			formDeHistorico: true,
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
	
	abrirFormularioCrearNotificacion: function(grid) {
		
		var me = this;
		
		var idActivo = me.getViewModel().get("activo.id");
		var data = {
			idActivo: idActivo, 
			parent: grid
		};
		Ext.create("HreRem.view.common.adjuntos.VentanaCrearNotificacion", data).show();
		
	},
	
	onClickAdjuntarDocumentoNotificaciones: function(btn) {
		
		var me = this;
		var idActivo = me.getViewModel().get("activo.id");
		var data = {
			entidad: 'gencat', 
			idEntidad: idActivo
		};
		Ext.create("HreRem.view.common.adjuntos.AdjuntarDocumentoNotificacionGencat", data).show();
	},
	
	onClickGuardarNotificacion: function(btn) {
		
		var me = this;
		
		var window = btn.up('[reference=ventanacrearnotificacionRef]');
		
		var form = window.down('[reference=crearNotificacionFormRef]');
		
		if(form.isValid()){
    		
            form.submit({
                waitMsg: HreRem.i18n('msg.mask.loading'),
                params: {
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
    		    	     
  }
    
});
