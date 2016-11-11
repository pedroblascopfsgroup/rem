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
    		name: 'estadoGastoCodigo'
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
		},
		{
			name: 'autorizado',
			type: 'boolean',
			convert: function(v) {
				return v === "true";		
			}
		},
		{
			name: 'rechazado',
			type: 'boolean',
			convert: function(v) {
				return v === "true";		
			}
		},
		{
			name: 'asignadoATrabajos',
			type: 'boolean',
			convert: function(v) {
				return v === "true";		
			}
		},
		{
			name: 'asignadoAActivos',
			type: 'boolean',
			convert: function(v) {
				return v === "true";		
			}
		},
		{
			name: 'esGastoEditable',
			type: 'boolean'
		},
		{
   			name: 'buscadorCodigoRemEmisor'
   		},
   		{
   			name: 'tipoOperacionCodigo'
   		},
   		{
   			name: 'numGastoDestinatario'
   		},
   		{
   			name: 'numGastoAbonado'
   		},
   		{
   			name: 'idGastoAbonado',
   			critical: true
   		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'gastosproveedor.json',
		api: {
            read: 'gastosproveedor/getTabGasto',
            update: 'gastosproveedor/saveGastosProveedor',
			create: 'gastosproveedor/createGastosProveedor'
        },
		
        extraParams: {tab: 'ficha'}
    }

});