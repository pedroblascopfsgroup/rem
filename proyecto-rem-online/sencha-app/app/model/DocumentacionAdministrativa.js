/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.DocumentacionAdministrativa', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
     		{
    			name:'numActivo'
    		},
    		{
    			name:'numActivoRem'
    		},
    		{
    			name:'calificacion'
    		},
    		{
    			name:'codigoTipoDocumentoActivo'
    		},
    		{
    			name:'numDocumento'
    		},
    		{
    			name:'fechaSolicitud',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaEmision',
    			type:'date',
    			dateFormat: 'c'
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
    		}
    		
    ]

});