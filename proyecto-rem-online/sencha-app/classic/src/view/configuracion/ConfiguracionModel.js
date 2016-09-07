Ext.define('HreRem.view.configuracion.ConfiguracionModel', {
    extend: 'HreRem.view.common.DDViewModel',
    alias: 'viewmodel.configuracion',
    requires: ['HreRem.model.Proveedor'],
    
    stores: { 
    	
		proveedores: {    
   		 	pageSize: $AC.getDefaultPageSize(),
   		 	model: 'HreRem.model.Proveedor',
       		proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'proveedores/getProveedores',
		        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
	    	},
	    	remoteSort: true,
	    	remoteFilter: true
   		}
    	
    }
});