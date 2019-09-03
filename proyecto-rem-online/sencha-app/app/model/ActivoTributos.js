/**
 * This view is used to present the details of a single AdmisionDocumento.
 */
Ext.define('HreRem.model.ActivoTributos', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [   
    		
		    {
		    	name: 'numActivo'	
		    },
		    {
		    	name: 'idTributo'	
		    },
		    {
		    	name: 'fechaPresentacion',
		    	type:'date',
    			dateFormat: 'c'
		    }, 
		    {
		    	name: 'fechaRecPropietario',
		    	type:'date',
    			dateFormat: 'c'
		    }, 
      		{
		    	name: 'fechaRecGestoria',
		    	type:'date',
    			dateFormat: 'c'
		    }, 
    		{
    			name:'tipoSolicitud'
    		},
    		{
    			name:'observaciones'
    		},
    		{
    			name:'fechaRecRecursoPropietario',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaRecRecursoGestoria',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaRespRecurso',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'resultadoSolicitud'
    		},
    		{
    			name:'numGastoHaya'	
    		}
    ],
    
    proxy: {
		type: 'uxproxy',		
		writeAll: true,
		api: {
            create: 'activo/saveOrUpdateActivoTributo',
            update: 'activo/saveOrUpdateActivoTributo',
            destroy: 'activo/deleteActivoTributo'
        }

    } 

});