Ext.define('HreRem.model.DetallePrefacturaGridModel', {
    extend: 'HreRem.model.Base',

    fields: [
    		{
    			name:'numTrabajo'
    		},
    		{
    			name:'descripcion'
    		},
    		{
    			name:'fechaAlta',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'estadoTrabajo'
    		},
    		{
    			name:'importeTotalPrefactura'
    		},
    		{
    			name:'importeTotalClientePrefactura'
    		},
    		{
    			name:'checkIncluirTrabajo'
    		},
    		{
    			name:'totalPrefactura'
    		},
    		{
    			name:'totalAlbaran'
    		}
    		
    ]

	/*proxy: {
		type: 'uxproxy',
		api: {
            // read: 'activo/getActivoCalificacionNegativa',
            create: 'activo/createCalificacionNegativa',
            update: 'activo/updateCalificacionNegativa',
            destroy: 'activo/destroyCalificacionNegativa'
        }
    }*/
});