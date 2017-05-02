/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.Gasto', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [ 
    	{
    		name: 'numGastoHaya'
    	},
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
		},
		{
			name: 'estadoGastoDescripcion'
		},
		{
			name: 'estadoGastoCodigo'
		},
		{
			name: 'importeTotalAgrupacion'
		},
		{
			name: 'existeDocumento',
			type: 'boolean',
			convert: function(v) {
				return v === "true";		
			}	
		},
		{
			name: 'esGastoAgrupado',
			type: 'boolean',
			convert: function(v) {
				return v === "true";		
			}	
		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'gasto.json',
		api: {
            update: 'gastosproveedor/saveGastosProveedor',
			create: 'gastosproveedor/createGastosProveedor',
			destroy: 'gastosproveedor/deleteGastosProveedor'
        }
    }

});