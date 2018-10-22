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
    			name:'idUsuario'
    		},
    		{
    			name:'nombreDocumento'
    		},
    		{
    			name:'tipoDocumento'
    		},
    		{
    			name:'descripcion'
    		},
    		{
    			name:'tamanoDocumento'
    		},
    		{
    			name:'fechaSubida',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'nombreCompleto'
    		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: '',
		remoteUrl: '',
		api: {
            create: '',
            update: '',
            destroy: ''
        }
    }

});