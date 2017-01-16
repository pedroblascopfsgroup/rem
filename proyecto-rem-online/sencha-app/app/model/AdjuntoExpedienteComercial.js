/**
 * This view is used to present the details of a single ExpedienteComercial.
 */
Ext.define('HreRem.model.AdjuntoExpedienteComercial', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [   
    		
    		{
		    	name: 'idEntidad'
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
		    	name: 'codigoSubtipo'
		    },      
    		{
    			name:'descripcionSubtipo'
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
		remoteUrl: 'expedientecomercial/getAdjuntoById',
		api: {
            read: 'expedientecomercial/getAdjunto',
            create: 'expedientecomercial/saveAdjunto',
            update: 'expedientecomercial/updateAdjunto',
            destroy: 'expedientecomercial/deleteAdjunto'
        }
    }   

});