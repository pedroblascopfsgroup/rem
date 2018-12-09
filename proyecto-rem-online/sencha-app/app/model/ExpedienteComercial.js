/**
 * This view is used to present the details of a single Expediente Comercial.
 */
Ext.define('HreRem.model.ExpedienteComercial', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    alias: 'viewmodel.expedientecomercial',

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
		    	name: 'fechaAnulacion',
    			type:'date',
    			dateFormat: 'c'
		    },
		    {
		    	name: 'codMotivoAnulacion'
		    },
		    {
		    	name: 'descMotivoAnulacion'
		    },
		    {
		    	name: 'codMotivoRechazoExp'
		    },
		    {
		    	name: 'descMotivoRechazoExp'
		    },
		    {
		    	name: 'fechaDevolucionEntregas',
    			type:'date',
    			dateFormat: 'c'
		    },
		    {
		    	name: 'fechaContabilizacionPropietario',
    			type:'date',
    			dateFormat: 'c'
		    },
		    {
		    	name: 'fechaPosicionamiento',
    			type:'date',
    			dateFormat: 'c'
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
    			name: 'fechaVenta',
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
    			name:'entidadPropietariaCodigo'
    		},
    		{
    			name: 'esBankia',
				calculate: function(data) {
        			return data.entidadPropietariaCodigo == CONST.CARTERA['BANKIA'];
        		},
    			depends: 'entidadPropietariaCodigo'
    		},
    		{
    			name: 'tipoExpedienteCodigo'
    		},
    		{
    			name: 'tipoExpedienteDescripcion'
    		}, 
    		{
    			name: 'tieneReserva',
       			type: 'boolean'
    		},
    		{
    			name: 'definicionOfertaFinalizada',
       			type: 'boolean'
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
    			name: 'fechaSancionComite',
    			type:'date', 
        		dateFormat: 'c'
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
    		},
    		{
    			name:'tipoAlquiler'
    		},
    		{
    			name:'tipoInquilino'
    		},
    		{
    			name: 'alquilerOpcionCompra'
    		},
    		{
    			name: 'codigoEstado'
    		},
    		{
    			name: 'estadoDevolucionCodigo'
    		},
    		{
    			name: 'isCarteraBankia',
    			calculate: function(data) { 
    				return data.entidadPropietariaCodigo == CONST.CARTERA['BANKIA'];
    			},
    			depends: 'entidadPropietariaCodigo'
    		},
    		{
    			name: 'bloqueado',
    			type: 'boolean'
    		},
    		{
    			name: 'definicionOfertaScoring',
       			type: 'boolean'
    		},
       		{
       			name: 'codigoEstado'
    		},
    		{
    			name: 'subcarteraCodigo'
    		}
    		 
    ],
    formulas: {
    	esExpedienteBloqueado: function(get) {
		     	
		     	var bloqueado = get('expediente.bloqueado');
		     	return bloqueado === "true";
		     	
		 }
    },
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'expedienteComercial.json',
		api: {
            read: 'expedientecomercial/getTabExpediente',
            update: 'expedientecomercial/saveFichaExpediente'
        },
        extraParams: {tab: 'ficha'}
    }
});