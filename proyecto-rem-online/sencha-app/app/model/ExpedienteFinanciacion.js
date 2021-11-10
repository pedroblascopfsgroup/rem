/**
 * This view is used to present the details of a single Oferta.
 */

Ext.define('HreRem.model.ExpedienteFinanciacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    
	    {
	    	name: 'numExpedienteRiesgo'
	    },
	    {
	    	name: 'solicitaFinanciacion'
	    },
	    {
	    	name: 'tiposFinanciacionCodigo'
	    },
	    {
	    	name: 'estadosFinanciacion'
	    },
	    {
	    	name: 'capitalConcedido'
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
	    	name: 'entidadFinanciacion'
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
	    	name: 'entidadFinancieraCodigo'
	    },
	    {
	    	name: 'fechaPosicionamientoPrevista',
	    	type:'date',
			dateFormat: 'c'
	    },
	    {
	    	name: 'otraEntidadFinanciera'
	    },
		{
			name: 'financiacionTPCodigo'
		}
    ],

    proxy: {
		type: 'uxproxy',
		api: {
            read: 'expedientecomercial/getFormalizacionFinanciacion',
            update: 'expedientecomercial/saveFormalizacionFinanciacion'
        }
    }    
});
