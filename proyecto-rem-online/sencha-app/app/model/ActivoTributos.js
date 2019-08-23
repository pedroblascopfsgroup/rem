/**
 * This view is used to present the details of a single AdmisionDocumento.
 */
Ext.define('HreRem.model.ActivoTributos', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    reference	: 'referenciaTributos',

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
    		},
    		{
    			name:'existeDocumentoTributo',
    			type: 'boolean',
    			convert: function(value, record) {
    				
    				if (value == false || value == "false") {
    					return "No";
    				} else {
    					return "Si";
    				}
    			}
    		},
    		{
    			name:'documentoTributoNombre'
    		},
    		{
    			name: 'documentoTributoId'
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