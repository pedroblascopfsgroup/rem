Ext.define('HreRem.view.common.adjuntos.AdjuntarDocumentoExpedienteModel', {
	extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.adjuntardocumentoexpediente',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.SubtipoDocumento'],
        
    stores: {
    	
    	
    	storeActivos: {
			model: 'HreRem.model.ActivosExpediente',
	    	proxy: {
	    		type: 'uxproxy', 
	    		remoteUrl: 'expedientecomercial/getActivosExpediente',
	    		extraParams: {idExpediente: '{expediente.id}'}
	    	},
	    	autoLoad: false
    	},
    	
    	
    	comboTipoDocumento : {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposDocumentoExpediente'}
			}
    	},
    	
    	comboSubtipoDocumento : {
			model: 'HreRem.model.SubtipoDocumento',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'subtiposDocumentoExpediente'}
			}
    	}
	   
    }
});