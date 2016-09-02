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
	    	name: 'sujetoTramiteTanteo'
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
	    	name: 'posesionInical'
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
	    }
	    

    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'condicionesExpediente.json',
		
		api: {
            read: 'expedientecomercial/getTabExpediente',
            update: 'expedientecomercial/saveCondicionesExpediente'
        },
		
        extraParams: {tab: 'condiciones'}
    }    

});
          