/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.Proceso', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [            
    		{
    			name:'estadoProceso'
    		},
    		{
    			name:'fechaCrear'
    		},
    		{
    			name:'idEstado'
    		},
    		{
    			name:'idTipoOperacion'
    		},
    		{
    			name:'nombre'
    		},
    		{
    			name:'tipoOperacion'
    		},
    		{
    			name:'usuario'
    		}  ,
    		{
    			name:'descripcion'
    		}  
    		
    ] 

});