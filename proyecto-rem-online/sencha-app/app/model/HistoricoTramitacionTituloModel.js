Ext.define('HreRem.model.HistoricoTramtitacionTituloModel', {
    extend: 'HreRem.model.Base',
    requires: ['HreRem.model.Activo'],
    idProperty: 'id',

    fields: [
    		{
    			name:'idHistorico'
    		},
    		{
    			name:'idActivo'
    		},
    		{
    			name:'titulo'
    		},
    		{
    			name:'fechaPresentacionRegistro',
               	type: 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'fechaCalificacion',
               	type: 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'fechaInscripcion',
               	type: 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'estadoPresentacion'
    		},
    		{
    			name:'observaciones'
    		},
    		{
    			name:'tieneCalificacionNoSubsanada'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            // read: 'activo/getActivoCalificacionNegativa',
            create: 'activo/createHistoricoTramtitacionTitulo',
            update: 'activo/updateHistoricoTramtitacionTitulo',
            destroy: 'activo/destroyHistoricoTramtitacionTitulo'
        }
    }
});