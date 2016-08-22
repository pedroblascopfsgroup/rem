/**
 * This view is used to present the details of a single AdmisionDocumento.
 */
Ext.define('HreRem.model.AdmisionDocumento', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [   
    		
		    {
		    	name: 'idActivo'	
		    },   
		    {
		    	name: 'idAdmisionDoc'	
		    }, 
		    {
		    	name: 'idConfiguracionDoc'
		    },
      
    		{
    			name:'descripcionTipoDoc'
    		},

    		{
    			name:'aplica'
    		},
    		{
    			name:'estadoDocumento'
    		},
    		{
    			name:'fechaSolicitud',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaObtencion',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaVerificado',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'gestorCodigo',
    			hidden:true
    		}
    ],
    
    proxy: {
		type: 'uxproxy',		
		writeAll: true,
		api: {
            read: 'activo/getAdmisionDocumentoById',
            create: 'activo/saveAdmisionDocumento',
            update: 'activo/saveAdmisionDocumento',
            destroy: 'activo/getAdmisionDocumentoById'
        }

    } 

});