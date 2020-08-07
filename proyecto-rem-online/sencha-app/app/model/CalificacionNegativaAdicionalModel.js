Ext.define('HreRem.model.CalificacionNegativaAdicionalModel', {
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
            create: 'activo/createCalificacionNegativa', //activo/createCalificacionNegativaAdicional
            update: 'activo/updateCalificacionNegativa', //activo/updateCalificacionNegativaAdicional
            destroy: 'activo/destroyCalificacionNegativa' //activo/destroyCalificacionNegativa
        }
    }
});