Ext.define('HreRem.model.HistoricoAntiguoDeudorModel', {
    extend: 'HreRem.model.Base',
    //requires: ['HreRem.model.Activo'],
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
            // read: 'activo/getActivoCalificacionNegativa',
            /*create: 'activo/createHistoricoTramitacionTituloAdicional',
            update: 'activo/updateHistoricoTramitacionTituloAdicional',
            destroy: 'activo/destroyHistoricoTramitacionTituloAdicional'*/
        }
    }
});