Ext.define('HreRem.view.comercial.ComercialModel', {
    extend: 'HreRem.view.common.DDViewModel',
    alias: 'viewmodel.comercial',
    requires: ['HreRem.ux.data.Proxy', 'HreRem.model.Visitas'],
    
    stores: {
    	
    	visitasComercial: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Visitas',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/visitas.json',
		        remoteUrl: 'visitas/getListVisitas'
	    	},
	    	autoLoad: true,
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	        listeners : {
	            beforeload : 'paramLoading'
	        }
    	}
    		
    }
});