Ext.define('HreRem.model.MovimientosLlave', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
     		{
    			name:'id'
    		},
    		{
    			name:'idLlave'
    		},
    		{
    			name:'numLlave'
    		},
    		{
    			name:'codigoTipoTenedor'
    		},
    		{
    			name:'descripcionTipoTenedor'
    		},
    		{
    			name:'codTenedor'
    		},
    		{
    			name:'nomTenedor'
    		},
    		{
    			name:'fechaEntrega',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaDevolucion',
    			type:'date',
    			dateFormat: 'c'
    		},
	        {
	            name: 'descripcionTipoTenedorPoseedor'
	        },
	        {
	            name: 'nombrePoseedor'
	        },
        	{
	            name: 'descripcionTipoTenedorPedidor'
	        },
	        {
	            name: 'nombrePedidor'
	        },
	        {
	            name: 'envio'
	        },
	        {
	            name: 'fechaEnvio',
    			type:'date',
    			dateFormat: 'c'
	        },
	        {
	            name: 'fechaRecepcion',
    			type:'date',
    			dateFormat: 'c'
	        },
	        {
	            name: 'observaciones'
	        },
	        {
	            name: 'estado'
	        }
    ],
    
    proxy: {
		type: 'uxproxy',
		writeAll: true,
		api: {
			read: 'activo/getListMovimientosByLlave',
            create: 'activo/createMovimientoLlave',
            update: 'activo/saveMovimientoLlave',
            destroy: 'activo/deleteMovimientoLlave'
        }
    }  
});