Ext.define('HreRem.model.CalificacionNegativaAdicionalModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'idMotivo',

    fields: [
    		{
    			name:'idActivo'
    		},
    		{
    			name:'idMotivo'
    		},
    		{
    			name:'motivoCalificacionNegativa'
    		},
    		{
    			name:'estadoMotivoCalificacionNegativa'
    		},
    		{
    			name:'codigoEstadoMotivoCalificacionNegativa'
    		},
    		{
    			name:'responsableSubsanar'
    		},
    		{
    			name:'codigoResponsableSubsanar'
    		},
    		{
    			name:'fechaSubsanacion',
               	type: 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'descripcionCalificacionNegativa'
    		},
    		{
    			name:'fechaCalificacionNegativa',
    			type: 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'fechaPresentacionRegistroCN',
    			type: 'date',
        		dateFormat: 'c'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            // read: 'activo/getActivoCalificacionNegativa',
            create: 'activo/createCalificacionNegativaAdicional', 
            update: 'activo/updateCalificacionNegativaAdicional',  
            destroy: 'activo/destroyCalificacionNegativaAdicional'
        }
    }
});