Ext.define('HreRem.model.OcupantesLegales', {
    extend: 'HreRem.model.Base',
    idProperty: 'idActivoOcupanteLegal',

    fields: [    
     		{
    			name:'numActivo'
    		},
    		{
    			name:'numActivoRem'
    		},
    		{
    			name:'nombreOcupante'
    		},
    		{
    			name:'nifOcupante'
    		},
    		{
    			name:'telefonoOcupante'
    		},
    		{
    			name:'emailOcupante'
    		},
    		{
    			name:'observacionesOcupante'
    		}
    ],
    
    proxy: {
		type: 'uxproxy',

		api: {
            create: 'activo/createOcupanteLegal',
            update: 'activo/saveOcupanteLegal',
            destroy: 'activo/deleteOcupanteLegal'
        }

    }  

});