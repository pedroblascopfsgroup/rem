Ext.define('HreRem.model.ActivoHistoricoEstadoPublicacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'idActivo',

    fields: [    
    		{
    			name:'publicacionOrdinaria',
    			type: 'boolean'
    		},
    		{
    			name:'publicacionForzada',
    			type: 'boolean'
    		},
    		{
    			name:'ocultacionForzada',
    			type: 'boolean'
    		},
    		{
    			name:'ocultacionPrecio',
    			type: 'boolean'
    		},
    		{
    			name:'despublicacionForzada',
    			type: 'boolean'
    		},
    		{
    			name:'motivo'
    		},
    		{
    			name:'observaciones'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            create: 'activo/setHistoricoEstadoPublicacion',
            update: 'activo/setHistoricoEstadoPublicacion'
        }
    }
});