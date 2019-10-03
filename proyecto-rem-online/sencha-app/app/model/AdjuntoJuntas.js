/**
 * This view is used to present the details of a single AdmisionDocumento.
 */
Ext.define('HreRem.model.AdjuntoJuntas', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    // MODELO ADJUNTOS --> PESTAÑA DOCUMENTOS (JUNTAS)
    
    fields: [   
		    {
		    	name: 'idEntidad'
		    },
		    {
		    	name: 'codigoTipo'
		    },      
    		{
    			name:'descripcionTipo'
    		},
    		{
    			name:'nombre'
    		},
    		{
    			name:'contentType'
    		},
    		{
    			name:'descripcion'
    		},
    		{
    			name:'tamanyo'
    		},
    		{
    			name:'fechaDocumento',
    			type:'date',
    			dateFormat: 'c'
    		}   

    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'adjuntos.json',
		api: {
            read: 'activojuntapropietarios/getListAdjuntos',
            create: 'activojuntapropietarios/createAdjuntos',
            update: 'activojuntapropietarios/updateAdjuntos',
            destroy: 'activojuntapropietarios/deleteAdjuntos'
        }
    }   

});