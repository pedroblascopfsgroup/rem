/**
 * This view is used to present the details of a document.
 */
Ext.define('HreRem.model.AdjuntoProveedor', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
		    {
		    	name: 'idProveedor'
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
		api: {
            destroy: 'proveedores/deleteAdjunto'
        }
    }   

});