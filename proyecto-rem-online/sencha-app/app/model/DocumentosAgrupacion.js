/**
 *  Modelo para el tab Documentos de Agrupaciones 
 */
Ext.define('HreRem.model.DocumentosAgrupacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'id'
    		},
    		{
    			name:'idAgrupacion'
    		},
    		{
    			name:'nombreDocumento'
    		},
    		{
    			name:'descripcionTipo'
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
    		},
    		{
    			name:'nombreCompleto'
    		}
    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		//remoteUrl: 'activo/getActivoById',
			api: {
	            //destroy: 'gencat/deleteAdjunto'
	        }
    } 

});