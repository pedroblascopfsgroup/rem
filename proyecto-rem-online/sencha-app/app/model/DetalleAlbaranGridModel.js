Ext.define('HreRem.model.DetalleAlbaranGridModel', {
    extend: 'HreRem.model.Base',

    fields: [
    		{
    			name:'numPrefactura'
    		},
    		{
    			name:'propietario'
    		},
    		{
    			name:'anyo'
    		},
    		{
    			name:'estadoAlbaran'
    		},
    		{
    			name:'numGasto'
    		},
    		{
    			name:'estadoGasto'
    		},
    		{
    			name:'importeTotalDetalle'
    		},
    		{
    			name:'importeTotalClienteDetalle'
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