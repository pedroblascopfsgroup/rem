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
   	 		name: 'codigoProveedorRem'
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
			name : 'fechaRecPropiedad',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name : 'fechaRecGestoria',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name : 'fechaRecHaya',
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
			name: 'esGastoAgrupado',
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
   		},
   		
   		{
   			name: 'gastoSinActivos'
   		},
   		{
			name: 'enviado',
			type: 'boolean',
			convert: function(v) {
				return v === "true";		
			}
		},
		{
   			name: 'codigoImpuestoIndirecto'
   		},
   		{
   			name: 'devengoPosteriorTraspaso'
   		},
		{
			name: 'identificadorUnico'
		},
   		{
   			name: 'numeroDeGastoRefacturable'
   		},
   		{
   			name:'isGastoRefacturable'
   		},
   		{
   			name: 'checkboxActivoRefacturable'
   		},
   		{
   			name: 'gastoRefacturadoGrid'
   		},
   		{
   			name: 'listaTotalGastosRefacturados'
   		},
   		{
   			name: 'gastoRefacturable',
			type: 'boolean'
		}, 
		{
   			name: 'idGastoRefacturable'
   		},
   		{
   			name: 'gastosRefacturadosGasto'
   		},
   		{
   			name:'numeroGastoRefacturableExistente'
   		},
   		{
   			name: 'bloquearDestinatario',
   			type: 'boolean'
   		},
   		{
   			name: 'bloquearEdicionFechasRecepcion',
   			type: 'boolean'
   		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'gastosproveedor.json',
		timeout: 120000,
		api: {
            read: 'gastosproveedor/getTabGasto',
            update: 'gastosproveedor/saveGastosProveedor',
			create: 'gastosproveedor/createGastosProveedor'
        },
		
        extraParams: {tab: 'ficha'}
    }

});