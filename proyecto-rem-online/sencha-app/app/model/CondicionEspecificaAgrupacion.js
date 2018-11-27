/**
 * This view is used to present the details of a condicion especifica.
 */
Ext.define('HreRem.model.CondicionEspecificaAgrupacion', {
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
		api: {
            read: 'agrupacion/getCondicionEspecificaByAgrupacion',
            create: 'agrupacion/createCondicionEspecifica',
            update: 'agrupacion/saveCondicionEspecifica',
            destroy: 'agrupacion/darDeBajaCondicionEspecifica'
        }

    }

});