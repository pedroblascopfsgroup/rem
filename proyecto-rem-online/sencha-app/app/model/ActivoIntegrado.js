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
	    	name: 'idProveedor'
	    },
    	{	
    		name: 'codigoProveedorRem'
    	},
    	{
    		name: 'subtipoProveedorDescripcion'
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
			type: 'date',
			dateFormat: 'c'
   		},
   		{
   			name: 'fechaExclusion',
			type: 'date',
			dateFormat: 'c'
   		},
		{
			name: 'pagosRetenidos'
		},
   		{
   			name: 'retenerPagos',
			critical: true,
			type: 'boolean',
			calculate: function(data){
				return data.pagosRetenidos == 1;
			},
			depends: 'pagosRetenidos'
   		},
    	{
    		name: 'motivoRetencionPago'
    	},
    	{
    		name: 'fechaRetencionPago',
			type: 'date',
			dateFormat: 'c'
    	},
		{  
	    	name:'estadoProveedorDescripcion'
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