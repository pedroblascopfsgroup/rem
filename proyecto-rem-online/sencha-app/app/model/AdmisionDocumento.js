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
    		},
    		{
    				
    		},
    		{
    			name:'fechaCaducidad',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaEtiqueta',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'tipoCalificacionCodigo'    			
    		},
    		{
    			name: 'dataIdDocumento'
    		},
    		{
    			name: 'letraConsumo'
    		},
    		{
    			name: 'consumo'
    		},
    		{
    			name: 'letraEmisiones'
    		},
    		{
    			name: 'motivoExoneracionCee'
    		},
    		{
    			name: 'incidenciaCee'
    		},
    		{
    			name: 'emision'
    		},
    		{
    			name: 'registro'
    		},
            {
                name:'estadoDocumentoDescripcion'
            },
            {
                name:'tipoCalificacionDescripcion'
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