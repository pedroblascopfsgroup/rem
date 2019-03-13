Ext.define('HreRem.model.CalificacionNegativaModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'idMotivo',

    fields: [
    		{
    			name:'idActivo'
    		},
    		{
    			name:'motivoCalificacionNegativa'
    		},
    		{
    			name:'estadoMotivoCalificacionNegativa'
    		},
    		{
    			name:'responsableSubsanar'
    		},
    		{
    			name:'fechaSubsanacion',
               	type: 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'descripcionCalificacionNegativa'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            // read: 'activo/getActivoCalificacionNegativa',
            create: 'activo/createCalificacionNegativa',
            update: 'activo/updateCalificacionNegativa'
        }
    }
});