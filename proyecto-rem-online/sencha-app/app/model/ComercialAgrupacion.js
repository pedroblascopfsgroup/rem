/**
 * This view is used to present the details of a single ComercialAgrupacion Item.
 */
Ext.define('HreRem.model.ComercialAgrupacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
                {
                	name: 'tramitable',
                	type: 'boolean'
                },
                {
        			name: 'motivoAutorizacionTramitacionCodigo'
        		},
        		{
        			name: 'observacionesAutoTram'
        		},
        		{
        			name: 'necesidadArras'
        		},
        		{
        			name: 'canalVentaBc'
        		},
        		{
        			name: 'canalAlquilerBc'
        		},
        		{
        			name: 'codCartera'
        		},
        		{
        			name: 'codAgrupacion'
        		}
    ],
    
	proxy: {
		type: 'uxproxy',
		timeout: 60000,
		api: {
            read: 'agrupacion/getComercialAgrupacionById',
            create: 'agrupacion/saveComericalAgrupacion',
            update: 'agrupacion/saveComercialAgrupacion',
            destroy: 'agrupacion/getComercialAgrupacionById'
        },
		extraParams: {pestana: '1'}
    }    
});