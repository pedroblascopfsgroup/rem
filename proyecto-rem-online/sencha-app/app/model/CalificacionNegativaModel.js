Ext.define('HreRem.model.CalificacionNegativaModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'MotivoCalificacionNegativa'
    		},
    		{
    			name:'EstadoCalificacionNegativa'
    		},
    		{
    			name:'ResponsableSubsanar'
    		},
    		{
    			name:'FechaSubsanar'
    		},
    		{
    			name:'DescripcionCalificacionNegativa'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getHistoricoMediadorByActivo',
            create: 'activo/createHistoricoMediador'
        }
    }
});