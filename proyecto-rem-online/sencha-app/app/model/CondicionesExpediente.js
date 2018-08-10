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
	    	name: 'mesesDeposito'
	    },
	    {
	    	name: 'importeDeposito'
	    },
	    {
	    	name: 'depositoActualizable'
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
          