Ext.define('HreRem.view.trabajos.TrabajosModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.trabajos',
    
    requires: ['HreRem.ux.data.Proxy', 'HreRem.model.BusquedaTrabajoGrid'],
    
 	stores: {
       
    	  gridBusquedaTrabajos: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.BusquedaTrabajoGrid',
	    	proxy: {
		        type: 'uxproxy',		     
				remoteUrl: 'trabajo/getBusquedaTrabajosGrid',
				actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'} 
	    	},	    		
	    	remoteSort: true,
	    	remoteFilter: true,	    	
	    	autoLoad: false,
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