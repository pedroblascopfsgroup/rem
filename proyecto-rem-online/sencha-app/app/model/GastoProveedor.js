/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.GastoProveedor', {
    extend: 'HreRem.model.Base',

    fields: [ 
    
    	{	
    		name: 'idGasto'
    	},
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
    		name: 'tipoGastoCodigo'
    	},
    	{
    		name: 'subtipoGastoCodigo'
    		
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
		},
		{
			name : 'destinatarioGastoCodigo'
		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'gastosproveedor.json',
		api: {
            read: 'gastosproveedor/getTabExpediente',
            update: 'gastosproveedor/saveGastosProveedor',
            create: 'gastosproveedor/saveGastosProveedor'
        },
		
        extraParams: {tab: 'ficha'}
    }

});