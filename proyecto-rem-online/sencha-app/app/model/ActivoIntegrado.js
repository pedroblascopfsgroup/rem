/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.ActivoIntegrado', {
    extend: 'HreRem.model.Base',
	idProperty: 'id',
	
    fields: [ 
    
	    {
	    	name: 'idActivo',
	    	critical: true
	    },
    	{	
    		name: 'codigoProveedorRem'
    	},
    	{
    		name: 'subtipoProveedor'
   	 	},
   	 	{
   	 		name: 'nombreProveedor'
   	 	},
   	 	{
   	 		name: 'nifProveedor'
   	 	},
   	 	{
   	 		name: 'observaciones'
   	 	},
    	{
    		name: 'participacion'
   		},
   		{
   			name: 'fechaInclusion',
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
   			name: 'fechaExclusion',
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
   			name: 'retenerPagos',
   			type: 'boolean'
   		},
    	{
    		name: 'motivoRetencionPago'
    	},
    	{
    		name: 'fechaRetencionPago',
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
		writeAll: false,
		localUrl: 'activointegrado.json',
		api: {
            read: 'activo/getActivoIntegrado',
            update: 'activo/updateActivoIntegrado',
			create: 'activo/createActivoIntegrado'
        }		
//        extraParams: {tab: 'ficha'}
    }

});