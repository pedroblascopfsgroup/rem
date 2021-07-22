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
		    	name: 'codMotivoAnulacionAlq'
		    },
		    {
		    	name: 'descMotivoAnulacionAlq'
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
    			name: 'fechaContabilizacionReserva',
    			type: 'date',
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
				name:'estadoPbcR'
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
    			name: 'subcarteraCodigo'
			},
			{
    			name: 'isSubcarteraApple',
    			calculate: function(data) { 
    				return data.entidadPropietariaCodigo == CONST.CARTERA['CERBERUS'] && data.subcarteraCodigo == CONST.SUBCARTERA['APPLEINMOBILIARIO'];
    			},
				depends: ['subcarteraCodigo','entidadPropietariaCodigo']
    		},
    		{
    			name: 'mostrarPbcReserva',
    			calculate: function(data) { 
    				return (data.entidadPropietariaCodigo == CONST.CARTERA['CERBERUS'] && (data.subcarteraCodigo == CONST.SUBCARTERA['APPLEINMOBILIARIO'] || data.subcarteraCodigo == CONST.SUBCARTERA['DIVARIANARROW'] || data.subcarteraCodigo == CONST.SUBCARTERA['DIVARIANREMAINING']))
							 || data.entidadPropietariaCodigo == CONST.CARTERA['BBVA'];
    			},
				depends: ['subcarteraCodigo','entidadPropietariaCodigo']
    		},
    		{
    			name:'estaFirmado',
    			type: 'boolean'
			},
			{
				name: 'esCarteraLiberbank',
				calculate: function(data) { 
    				return CONST.CARTERA['LIBERBANK'] === data.entidadPropietariaCodigo;
    			},
    			depends: 'entidadPropietariaCodigo'
    		},
    		{
    			name: 'idOfertaAnterior'
    		},
    		{
    			name:'noEsOfertaFinalGencat',
    			type: 'boolean'
    		},
    		{
    			name: 'fechaEnvioAdvisoryNote',
    			type:'date', 
        		dateFormat: 'c'
    		},
    		{
    			name: 'fechaRecomendacionCes',
    			type:'date', 
        		dateFormat: 'c'
    		},
    		{
    			name: 'fechaContabilizacionVenta',
    			type:'date', 
        		dateFormat: 'c'
    		},
			{
				name: 'esCarteraLiberbankVenta',
				calculate: function(data) { 
					if((data.tipoExpedienteCodigo == CONST.TIPOS_EXPEDIENTE_COMERCIAL['VENTA']) && (CONST.CARTERA['LIBERBANK'] === data.entidadPropietariaCodigo)){
						return true;
					}
					return false;
				},
				depends: ['tipoExpedienteCodigo','entidadPropietariaCodigo']
			},
    		{
				name:'fechaAprobacionProManzana',
				convert: function(value) {
	    				if (!Ext.isEmpty(value)) {
							if  ((typeof value) == 'string') {
		    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
		    				} else {
		    					return value;
		    				}
	    				}
	    		}
    		},
    		{
    			name: 'tituloCarteraLiberbankVenta',
    			calculate: function(data) {
    				if((data.tipoExpedienteCodigo == CONST.TIPOS_EXPEDIENTE_COMERCIAL['VENTA']) && (CONST.CARTERA['LIBERBANK'] === data.entidadPropietariaCodigo)){
    					return 'Comité';
    				}
    				return 'Comité sancionador';
    			},
    			depends: ['tipoExpedienteCodigo','entidadPropietariaCodigo']
    		},
    		{
    			name: 'comiteComboboxLabel',
    			calculate: function(data) {
    				if((data.tipoExpedienteCodigo == CONST.TIPOS_EXPEDIENTE_COMERCIAL['VENTA']) && (CONST.CARTERA['LIBERBANK'] === data.entidadPropietariaCodigo)){
    					return 'Comité sancionador';
    				}
    				return 'Comité seleccionado';
    			},
    			depends: ['tipoExpedienteCodigo','entidadPropietariaCodigo']
    		},
    		{
    			name:'finalizadoCierreEconomico',
    			type: 'boolean'
			},
			{
    			name: 'codigoEstadoBc'
    		},
    		{
    			name: 'estadoPbcCn'
    		},
    		{
    			name: 'estadoPbcArras'
    		},
    		{
    			name: 'fechaReservaDeposito',
				type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaContabilizacion',
				type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaFirmaContrato',
				type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'isEmpleadoCaixa',
    			type: 'boolean'
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
		//localUrl: 'expedienteComercial.json',
		api: {
            read: 'expedientecomercial/getTabExpediente',
            update: 'expedientecomercial/saveFichaExpediente'
        },
        extraParams: {tab: 'ficha'}
    }
});