/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.GastoProveedor', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [ 
    	{
    		name: 'numFactura'
    	},
    	{
    		name: 'tipo'
    	},
    	{
    		name: 'subtipo'
    		
    	},
		{
			name : 'concepto'
		},
		{
			name : 'proveedor'
		},
		{
			name : 'fechaEmision',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name : 'importe'
		},
		{
			name : 'fechaTopePago',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name : 'fechaPago',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name : 'periodicidad'
		},
		{
			name : 'destinatario'
		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'gastosproveedor.json',
		api: {
            read: 'gastosproveedor/getTabExpediente'
        },
		
        extraParams: {tab: 'ficha'}
    }

});