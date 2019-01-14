/**
 *  Modelo para el combo de tipo de documentos del Expediente
 */
Ext.define('HreRem.model.TipoDocumentoExpediente', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'id'
    		},
    		{
    			name:'codigo'
    		},
    		{
    			name:'descripcion'
    		},
    		{
    			name:'descripcionLarga'
    		}
    ]
});