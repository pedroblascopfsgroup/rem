Ext.define('HreRem.view.masivo.MasivoModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.masivo',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.Proceso'],
    
    stores: {
    
    	storeListadoProcesos: {		
    				
    		pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Proceso',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/procesos.json',
		        remoteUrl: 'masivo/mostrarProcesosPaginados'
	    	},  	
	    	autoLoad: true
    	},
    	
    	comboTipoOperacion: {
			
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'process/getTiposOperacion'
			},
			session: true,
			autoLoad: true,
			remoteFilter: false,
			remoteSort: false
    	}    
    
    }
 });



