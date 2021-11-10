/**
 * This view is used to present the details of a single Oferta.
 */

Ext.define('HreRem.model.CondicionesExpediente', {
    extend: 'HreRem.model.Base',

    fields: [
    
	    {
	    	name: 'idCondiciones'
	    },
	    {
	    	name: 'solicitaFinanciacion'
	    },
	    {
	    	name: 'fechaInicioExpediente',
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
	    	name: 'fechaInicioFinanciacion',
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
	    	name: 'entidadFinanciera'
	    },
	    {
	    	name: 'estadosFinanciacion'
	    },
	    {
	    	name: 'fechaFinFinanciacion',
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
	    	name: 'tipoCalculo'
	    },
	    {
	    	name: 'porcentajeReserva'
	    },
	    {
	    	name: 'plazoFirmaReserva'
	    },
	    {
	    	name: 'importeReserva'
	    },
	    {
	    	name: 'tipoImpuestoCodigo'
	    },
	    {
	    	name: 'tipoAplicable'
	    },
	    {
	    	name: 'renunciaExencion'
	    },
	   	{
	    	name: 'reservaConImpuesto'
	    },
	    {
	    	name: 'gastosPlusvalia'
	    },
	    {
	    	name: 'plusvaliaPorCuentaDe'
	    },
	    {
	    	name: 'gastosNotaria'
	    },
	    {
	    	name: 'notariaPorCuentaDe'
	    },
	    {
	    	name: 'gastosOtros'
	    },
	    {
	    	name: 'gastosCompraventaOtrosPorCuentaDe'
	    },
	    {
	    	name: 'gastosIbi'
	    },
	    {
	    	name: 'gastosComunidad'
	    },
	    {
	    	name: 'gastosSuministros'
	    },
	    {
	    	name: 'ibiPorCuentaDe'
	    },
	    {
	    	name: 'comunidadPorCuentaDe'
	    },
	    {
	    	name: 'suministrosPorCuentaDe'
	    },
	    {
	    	name: 'fechaUltimaActualizacion',
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
	    	name: 'impuestos'
	    },
	    {
	    	name: 'impuestosPorCuentaDe'
	    },
	    {
	    	name: 'comunidades'
	    },
	    {
	    	name: 'comunidadesPorCuentaDe'
	    },
	    {
	    	name: 'cargasOtros'
	    },
	    {
	    	name: 'cargasPendientesOtrosPorCuentaDe'
	    },
	    {
	    	name: 'fechaTomaPosesion',
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
	    	name: 'sujetoTramiteTanteo',
			type: 'boolean'
	    },
	    {
	    	name: 'estadoTramite'
	    },
	    {
	    	name: 'ocupado'
	    },
	    {
	    	name: 'conTitulo'
	    },
	    {
	    	name: 'tipoTitulo'
	    },
	    {
	    	name: 'estadoTituloCodigo'
	    },
	    {
	    	name: 'posesionInicial'
	    },
	    {
	    	name: 'situacionPosesoriaCodigo'
	    },
	    {
	    	name: 'renunciaSaneamientoEviccion'
	    },
	    {
	    	name: 'renunciaSaneamientoVicios'
	    },
	    {
	    	name: 'procedeDescalificacion'
	    },
	    {
	    	name: 'procedeDescalificacionPorCuentaDe'
	    },
	    {
	    	name: 'licencia'
	    },
	    {
	    	name: 'licenciaPorCuentaDe'
	    },
	    {
	    	name: 'operacionExenta'
	    },
	    {
	    	name: 'inversionDeSujetoPasivo'
	    },
	    {
	    	name: 'mesesFianza'
	    },
	    {
	    	name: 'importeFianza'
	    },
	    {
	    	name: 'fianzaActualizable'
	    },
	    {
	    	name: 'avalista'
	    },
	    {
	    	name: 'documentoFiador'
	    },
	    {
	    	name: 'codigoEntidad'
	    },
	    {
	    	name: 'numeroAval'
	    },
	    {
	    	name: 'importeAval'
	    },
	    {
	    	name: 'renunciaTanteo'
	    },
	    {
	    	name: 'carencia'
	    },
	    {
	    	name: 'bonificacion'
	    },
	    {
	    	name: 'gastosRepercutibles'
	    },
	    {
	    	name: 'mesesCarencia'
	    },
	    {
	    	name: 'importeCarencia'
	    },
	    {
	    	name: 'mesesBonificacion'
	    },
	    {
	    	name: 'importeBonificacion'
	    },
	    {
	    	name: 'duracionBonificacion'
	    },
	    {
	    	name: 'repercutiblesComments'
	    },
	    {
	    	name: 'entidadComments'
	    },
	    {
			name: 'siCarencia',
			calculate: function(data) { 
				return data.carencia == 'true';
			},
			depends: 'carencia'
			
		},
		{
			name: 'siBonificacion',
			calculate: function(data) { 
				return data.bonificacion == 'true';
			},
			depends: 'bonificacion'
			
		},
		{
			name: 'esOtros',
			calculate: function(data) {
				return data.codigoEntidad == '19'
			},
			depends: 'codigoEntidad'
		},
		{
			name: 'esRepercutible',
			calculate: function(data) {
				return data.gastosRepercutibles == 'true';
			},
			depends: 'gastosRepercutibles'
		},
		{
			name: 'checkFijo'
		},
		{
			name: 'fechaFijo',
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
			name: 'incrementoRentaFijo'
		},
		{
			name: 'checkPorcentual'
		},
		{
			name: 'checkIPC'
		},
		{
			name: 'porcentaje'  
		},
		{
			name: 'checkRevisionMercado'  
		},
		{
			name: 'revisionMercadoFecha',
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
			name: 'revisionMercadoMeses'  
		},
		{
			name: 'depositoReserva'  
		},
		{
			name: 'tributosSobrePropiedad'  
		},
		{
			name: 'necesidadIf',
			type: 'boolean'
		},
		{
			name: 'fianzaExonerada',
			type: 'boolean'
		},
		{
			name: 'fechaIngresoFianzaArrendatario',
			type:'date',
    		dateFormat: 'c'
		},
		{
			name:'derechoCesionSubarriendo',
			type: 'boolean'
		},
		{
			name:'vulnerabilidadDetectada',
			type: 'boolean'
		},
		{
			name:'regimenFianzaCCAACodigo'
		},
		{
			name:'certificaciones',
			type: 'boolean'
		},
		{
			name:'ofrNuevasCondiciones',
			type: 'boolean'
		},
		{
			name:'fianzaContratosSubrogados',
			type: 'boolean'
		},
		{
			name:'adecuaciones',
			type: 'boolean'
		},
		{
			name:'cntSuscritoPosteridadAdj',
			type: 'boolean'
		},
		{
			name:'antiguoDeudorLocalizable',
			type: 'boolean'
		},
		{
			name:'entregasCuenta',
			type: 'boolean'
		},
		{
			name:'rentasCuenta',
			type: 'boolean'
		},
		{
			name:'importeEntregasCuenta'
		},
		{
			name:'obligadoCumplimientoac56b6334c00c42d7dccbad5d00b3a693f5dd986'
		},
		{
			name:'fechaPreavisoVencimientoCnt',
			type:'date',
    		dateFormat: 'c'
		},
		{
			name:'metodoActualizacionRentaCod'
		},
		{
			name:'checkIGC',
			type: 'boolean'
		},
		{
			name:'obligadoCumplimiento'
		},
		{
			name:'periodicidadMeses'
		},
		{
			name:'fechaActualizacion',
			type:'date',
    		dateFormat: 'c'
		},
		{
			name:'tipoGrupoImpuestoCod'
		},
		{
			name:'tipoGrupoImpuestoCodAlq'
		},
	    {
	    	name: 'tipoImpuestoCodigoAlq'
	    },
	    {
	    	name: 'mesesDuracion'
	    }
	    
    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'condicionesExpediente.json',
		timeout: 60000,
		
		api: {
            read: 'expedientecomercial/getTabExpediente',
            update: 'expedientecomercial/saveCondicionesExpediente'
        },
		
        extraParams: {tab: 'condiciones'}
    }    

});
          