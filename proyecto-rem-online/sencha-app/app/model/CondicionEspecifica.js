/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.CondicionEspecifica', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
    		{
    			name:'idActivo'
    		},
    		{
    			name:'texto'
    		},
    		{
    			name:'fechaDesde'
    		},
    		{
    			name:'fechaHasta'
    		},
    		{
    			name:'usuarioAlta'
    		},
    		{
    			name:'usuarioBaja'
    		}
	
    ],
    
	proxy: {
		type: 'uxproxy',
		//localUrl: 'activos.json',
		remoteUrl: 'activo/getCondicionEspecificaByActivo',

		api: {
            read: 'activo/getCondicionEspecificaByActivo',
            create: 'activo/createCondicionEspecifica',
            update: 'activo/saveCondicionEspecifica',
            destroy: 'activo/getCondicionEspecificaByActivo'
        }

    }

});