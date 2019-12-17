/**
 *  Modelo para el tab de cargas de Activos 
 */
Ext.define('HreRem.model.ActivoCargasTab', {
    extend: 'HreRem.model.Base',
    idProperty: 'idActivo',

    fields: [    
  
    		{
    			name:'numeroActivo'
    		},
    		{
    			name:'conCargas'
    		},{
    			name:'estadoCargas'
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
    		},
    		{
				name: 'unidadAlquilable',
				type: 'boolean'
    		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getTabActivo',
		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveActivoCargaTab',
            update: 'activo/saveActivoCargaTab',
            destroy: 'activo/getTabActivo'
        },
		extraParams: {tab: 'cargasactivo'}
    }
    
    

});