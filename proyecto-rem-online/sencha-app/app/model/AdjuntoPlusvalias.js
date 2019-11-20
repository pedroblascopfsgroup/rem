/**
 * This view is used to present the details of a single AdmisionDocumento.
 */
Ext.define('HreRem.model.AdjuntosPlusvalias', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
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
//		type: 'uxproxy',
//		localUrl: 'adjuntos.json',
//		remoteUrl: 'activo/getAdjuntoById',
//		api: {
//            read: 'activo/getAdjunto',
//            create: 'activo/saveAdjunto',
//            update: 'activo/updateAdjunto',
//            destroy: 'activo/deleteAdjunto'
//        }
    }   

});