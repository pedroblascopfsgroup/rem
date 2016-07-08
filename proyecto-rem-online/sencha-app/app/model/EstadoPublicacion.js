/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.EstadoPublicacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
            {
            	name: 'id' 
            },
    		{
    			name:'idActivo'
    		},
    		{
    			name:'fechaDesde'
    		},
    		{
    			name:'fechaHasta'
    		},
    		{
    			name:'portal'
    		},
    		{
    			name:'tipoPublicacion'
    		},
    		{
    			name:'estadoPublicacion'
    		},
    		{
    			name:'motivo'
    		},
    		{
    			name:'diasPeriodo'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		//localUrl: 'activos.json',
		remoteUrl: 'activo/getEstadosPublicacionByActivo',

		api: {
            read: 'activo/getEstadosPublicacionByActivo',
            create: 'activo/getEstadosPublicacionByActivo',
            update: 'activo/getEstadosPublicacionByActivo',
            destroy: 'activo/getEstadosPublicacionByActivo'
        }

    }

});