/**
 * This view is used to present the details of a single AdmisionDocumento.
 */
Ext.define('HreRem.model.AdjuntoActivo', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [   
    		
		    
     
    		{
		    	name: 'idEntidad'
		    },
		    {
		    	name: 'idActivo',
    			calculate: function(data) { 
    				return Ext.isEmpty(data.idActivo) ? data.idEntidad : data.idActivo; 
    			},
    			depends: 'idEntidad' 
		    },
			{
		    	name: 'idTrabajo',
    			calculate: function(data) { 
    				return Ext.isEmpty(data.idTrabajo) ? data.idEntidad : data.idTrabajo; 
    			},
    			depends: 'idEntidad' 
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
		remoteUrl: 'activo/getAdjuntoById',
		api: {
            read: 'activo/getAdjunto',
            create: 'activo/saveAdjunto',
            update: 'activo/updateAdjunto',
            destroy: 'activo/deleteAdjunto'
        }
    }   

});