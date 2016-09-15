/**
 * This view is used to present the details of a single Expediente Comercial.
 */
Ext.define('HreRem.model.ExpedienteComercial', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [ 
    		
		    {
		    	name: 'idExpediente'
		    },
		    {
    			name:'numExpediente'
    		},
		    {
		    	name: 'idOferta'
		    },
		    {
		    	name: 'idAgrupacion'
		    }, 
		    {
		    	name: 'numAgrupacion'
		    },  
		    {
		    	name: 'idActivo'
		    }, 
		    {
		    	name: 'numActivo'
		    },
		    {
		    	name: 'numEntidad'
		    },
    		{
    			name: 'fechaAlta',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaAltaOferta',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaSancion',
    			type:'date',
    			dateFormat: 'c'		
    		},
    		{
    			name: 'fechaReserva',
    			type:'date',
    			dateFormat: 'c'   			
    		},
    		{
    			name: 'mediador'
    		},
    		{
    			name: 'propietario'
    		},
    		{
    			name: 'comprador'
    		},
    		{
    			name: 'estado'
    		},
    		{
    			name: 'importe'
    		},
    		{
    			name:'entidadPropietariaDescripcion'
    		},
    		{
    			name: 'tipoExpedienteCodigo'
    		},
    		{
    			name: 'tipoExpedienteDescripcion'
    		}, 
    		{
    			name: 'tieneReserva'	
    		},
    		{
    			name: 'fechaInicioAlquiler',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaFinAlquiler',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'importeRentaAlquiler'	
    		},
    		{
    			name: 'numContratoAlquiler'	
    		},
    		{
    			name: 'situacionContratoAlquiler'	
    		},
    		{
    			name: 'fechaPlazoOpcionCompraAlquiler',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'primaOpcionCompraAlquiler'	
    		},
    		{
    			name: 'precioOpcionCompraAlquiler'	
    		},
    		{
    			name: 'condicionesOpcionCompraAlquiler'	
    		},
    		{
    			name: 'conflictoIntereses'	
    		},
    		{
    			name: 'riesgoReputacional'	
    		}
    		
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'expedienteComercial.json',
		
		api: {
            read: 'expedientecomercial/getTabExpediente'
        },
		
        extraParams: {tab: 'ficha'}
    }    

});