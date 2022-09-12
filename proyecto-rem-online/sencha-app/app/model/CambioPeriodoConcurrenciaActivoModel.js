/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.CambioPeriodoConcurrenciaActivoModel', {
    extend: 'HreRem.model.Base',

    fields: [
    	{
    		name : 'id'
    	},
    	{
    		name : 'accionConcurrencia'
    	},
    	{
    		name : 'fechaInicio',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
    		name : 'fechaFin',
    		type : 'date',
    		dateFormat: 'c'
    	}

    ]

});