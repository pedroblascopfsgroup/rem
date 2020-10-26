Ext.define('HreRem.view.common.adjuntos.AdjuntarFotoModel', {
	extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.adjuntarfoto',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase'],
    
    stores: {
    	storeDescripcionAdjuntarFoto: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'descripcionesFoto'}
			},
			autoLoad: false,
			remoteFilter: false,
			filters: {
    			property: 'codigoSubtipoActivo',
    			value: '{codigoSubtipoActivo}' 
    		}
    	}	   
    }
});