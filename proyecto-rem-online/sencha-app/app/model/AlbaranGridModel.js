Ext.define('HreRem.model.AlbaranGridModel', {
    extend: 'HreRem.model.Base',
//    idProperty: 'numAlbaran',

    fields: [
    		{
    			name:'numAlbaran'
    		},
    		{
    			name:'fechaAlbaran',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'estadoAlbaran'
    		},
    		{
    			name:'numPrefacturas'
    		},
    		{
    			name:'numTrabajos'
    		},
    		{
    			name:'importeTotal'
    		},
    		{
    			name:'importeTotalCliente'
    		},
    		{
    			name:'validarAlbaran'
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