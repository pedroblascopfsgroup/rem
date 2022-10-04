Ext.define('HreRem.model.HistoricoAntiguoDeudorModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name: 'idHistorico'
    		},
    		{
    			name: 'codigoLocalizable'
    		},
    		{
    			name: 'fechaIlocalizable',
               	type: 'date',
        		dateFormat: 'c'
    		},
    		{
    			name: 'fechaLocalizado',
               	type: 'date',
        		dateFormat: 'c'
    		},
    		{
    			name: 'motivo'
    		},
    		{
    			name: 'fechaCreacion',
               	type: 'date',
        		dateFormat: 'c'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            create: 'expedientecomercial/createHistoricoAntiguoDeudor',
            update: 'expedientecomercial/updateHistoricoAntiguoDeudor',
            destroy: 'expedientecomercial/deleteHistoricoAntiguoDeudor'
        }
    }
});