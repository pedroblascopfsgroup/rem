Ext.define('HreRem.model.ActivoHistoricoEstadoPublicacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'idActivo',

    fields: [    
    		{
    			name:'publicacionForzada',
    			type: 'boolean'
    		},
    		{
    			name: 'publicacionOrdinaria',
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
    			name:'motivoPublicacion'
    		},
    		{
    			name:'motivoOcultacionPrecio'
    		},
    		{
    			name:'motivoDespublicacionForzada'
    		},
    		{
    			name:'motivoOcultacionForzada'
    		},
    		{
    			name:'observaciones'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		writeAll: true,
		api: {
            create: 'activo/setHistoricoEstadoPublicacion',
            update: 'activo/setHistoricoEstadoPublicacion',
            read: 'activo/getHistoricoEstadoPublicacion'
        }
    }
});