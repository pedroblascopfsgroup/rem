Ext.define('HreRem.view.trabajos.TrabajosModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.trabajos',
    
    requires: ['HreRem.ux.data.Proxy', 'HreRem.model.BusquedaTrabajo'],
    
 	stores: {
        
        trabajos: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.BusquedaTrabajo',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/trabajos.json',
		        remoteUrl: 'trabajo/findAll',
		        actionMethods: {read: 'POST'} // Necesario para que el filtro no se mande en la URL lo que provoca un problema de encoding
	    	},	    		
	    	remoteSort: true,
	    	remoteFilter: true,	    	
	    	autoLoad: true,
	        listeners : {
	            beforeload : 'paramLoading'	        
	        }
    	},
    	
    	filtroComboSubtipoTrabajo: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'subtiposTrabajo'}
			}  
    		
    		
    	},    	
    	
    	filtroComboEstadoTrabajo: {    		
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadoTrabajo'}
			}
    	}
 	}
    

    
});