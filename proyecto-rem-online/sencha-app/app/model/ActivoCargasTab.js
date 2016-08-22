/**
 *  Modelo para el tab de cargas de Activos 
 */
Ext.define('HreRem.model.ActivoCargasTab', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'numeroActivo'
    		},
    		{
    			name:'conCargas'
    		},
    		{
    			name:'fechaRevisionCarga',
    			convert: function(value) {
    				if (!Ext.isEmpty(value)) {
						if  ((typeof value) == 'string') {
	    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
	    				} else {
	    					return value;
	    				}
    				}
    			}
    		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getTabActivo',
		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveActivoCarga',
            update: 'activo/saveActivoCarga',
            destroy: 'activo/getTabActivo'
        },
		extraParams: {tab: 'cargasactivo'}
    }
    
    

});