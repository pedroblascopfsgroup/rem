Ext.define('HreRem.view.activos.detalle.GencatComercialActivoController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.gencatcomercialactivo', 
    
    
    control: {

    	'documentosactivogencatlist': {
            abrirFormulario: 'abrirFormularioAdjuntarComunicacionActivo',
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
			xtype: 'gencatcomercialactivoform',
			reference: 'gencatcomercialactivoformhistoricoref',
			formDeHistorico: true,
			idHComunicacion: record.id
		};
    	
    	fieldsetHistorico.add(nuevoFormHistorico);
    	
    },
    
    abrirFormularioAdjuntarComunicacionActivo: function(grid) {
    	console.log("salu3");
    	//TODO: Adjuntar documentos en la comunicacion o en el histórico de una comunicación
		var me = this/*,
		idActivo = me.getViewModel().get("activo.id");
    	Ext.create("HreRem.view.common.adjuntos.AdjuntarDocumentoActivoProyecto", {entidad: 'promocion', idEntidad: idActivo, parent: grid}).show();*/
		
	},
    
    downloadDocumentoComunicacionActivo: function(grid, record) {
		
		var me = this,
		config = {};
		console.log("salu2");
		//TODO: Descargar documento del listado pasado por parámetro
		/*config.url=$AC.getWebPath()+"promocion/bajarAdjuntoActivoPromocion."+$AC.getUrlPattern();
		config.params = {};
		config.params.id=record.get('id');
		config.params.idActivo=record.get("idActivo");
		config.params.nombreDocumento=record.get("nombre");
		me.fireEvent("downloadFile", config);*/
	}
    
});
