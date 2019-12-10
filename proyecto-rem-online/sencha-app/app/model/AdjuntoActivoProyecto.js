/**
 * This view is used to present the details of a single AdmisionDocumento.
 */
Ext.define('HreRem.model.AdjuntoActivoProyecto', {
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
		    	name: 'idActivo'
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
		remoteUrl: 'proyecto/getAdjuntoById',
		api: {
            read: 'proyecto/getAdjunto',
            create: 'proyecto/saveAdjunto',
            update: 'proyecto/updateAdjunto',
            destroy: 'proyecto/deleteAdjunto'
        }
    }   

});