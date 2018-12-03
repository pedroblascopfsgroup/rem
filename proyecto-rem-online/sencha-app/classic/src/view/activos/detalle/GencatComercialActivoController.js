Ext.define('HreRem.view.activos.detalle.GencatComercialActivoController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.gencatcomercialactivo', 
    
    
    control: {

    },
    
    cargarTabData: function (form) {
    	form.up("activosdetallemain").lookupController().cargarTabData(form);
    },
    
    onClickSolicitarVisita: function(btn) {

        var me = this;
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
    	
    }
    
});
