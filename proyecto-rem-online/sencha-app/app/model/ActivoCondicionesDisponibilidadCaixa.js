Ext.define('HreRem.model.ActivoCondicionesDisponibilidadCaixa', {
    extend: 'HreRem.model.Base',
    idProperty: 'idActivo',

    fields: [        		
    		{
    			name: 'publicacionPortalPublicoVenta',
    			type: 'boolean'
    		},
    		{
    			name: 'publicacionPortalPublicoAlquiler',
    			type: 'boolean'
    		},
    		{
    			name: 'publicacionPortalInversorVenta',
    			type: 'boolean'
    		},
    		{
    			name: 'publicacionPortalInversorAlquiler',
    			type: 'boolean'
    		},
    		{
    			name: 'publicacionPortalApiVenta',
    			type: 'boolean'
    		},
    		{
    			name: 'publicacionPortalApiAlquiler',
    			type: 'boolean'
    		}

    ],
    
	proxy: {
		type: 'uxproxy',
		extraParams:{
			tab: 'activocondicionantesdisponibilidad' //TODO
			//tab: 'activocondicionesdisponibilidadcaixa' //TODO
		},
		api: {
			read: 'activo/getTabActivo'//, //TODO
//            update: 'activo/saveCondicionesDisponibilidadCaixa', //TODO
//            create: 'activo/CondicionesDisponibilidadCaixa', //TODO
//            destroy: 'activo/getCondicionesDisponibilidadCaixa' //TODO
        }
    }
});