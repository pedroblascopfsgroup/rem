/**
 * This view is used to present the details of a single AdmisionDocumento.
 */
Ext.define('HreRem.model.AdjuntoTrabajo', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [   
    		
		    {
		    	name: 'idTrabajo'
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
		remoteUrl: 'trabajo/getAdjuntoById',
		api: {
            read: 'trabajo/getAdjunto',
            create: 'trabajo/saveAdjunto',
            update: 'trabajo/updateAdjunto',
            destroy: 'trabajo/deleteAdjunto'
        }
    }   

});