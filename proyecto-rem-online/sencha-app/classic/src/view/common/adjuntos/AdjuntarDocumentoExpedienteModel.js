Ext.define('HreRem.view.common.adjuntos.AdjuntarDocumentoExpedienteModel', {
	extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.adjuntardocumentoexpediente',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase'],
    
    stores: {
    	
    	
    	comboTipoDocumento : {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposDocumentoExpediente'}
			}
    	},
    	
    	comboSubtipoDocumento : {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'subtiposDocumentoExpediente'}
			}
    	}
	   
    }
});