/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.GastoProveedor', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [ 
    	{
    		name: 'numGastoHaya'
   	 	},
   	 	{
   	 		name: 'numGastoGestoria'
   	 	},
   	 	{
   	 		name: 'idEmisor'
   	 	},
   	 	{
   	 		name: 'codigoProveedor'
   	 	},
    	{
    		name: 'nifEmisor'
   		},
   		{
   			name: 'buscadorNifEmisor'
   		},
   		{
   			name: 'buscadorNifPropietario'
   		},
   		{
   			name: 'nombreEmisor'
   		},
    	{
    		name: 'referenciaEmisor'
    	},
    	{
    		name: 'propietario'
    	},
    	{
    		name: 'tipoGasto'
    	},
    	{
    		name: 'subtipoGasto'
    		
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
		},
		{
			name : 'nifPropietario'
		},
		{
			name : 'nombrePropietario'
		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'gastosproveedor.json',
		api: {
            read: 'gastosproveedor/getTabExpediente',
            update: 'gastosproveedor/saveGastosProveedor'
        },
		
        extraParams: {tab: 'ficha'}
    }

});