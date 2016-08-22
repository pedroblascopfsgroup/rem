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
		        remoteUrl: 'process/mostrarProcesos'
	    	},  	
	    	autoLoad: true
    	},
    	
    	comboTipoOperacion: {
			
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'process/getTiposOperacion'
			}
    	}    
    
    }
 });



