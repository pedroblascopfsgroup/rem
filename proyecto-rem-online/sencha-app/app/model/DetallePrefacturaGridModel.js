Ext.define('HreRem.model.DetallePrefacturaGridModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'numTrabajo',

    fields: [
    		{
    			name:'tipologiaTrabajo'
    		},
    		{
    			name:'subtipologiaTrabajo'
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