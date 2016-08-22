/**
 *  Modelo para el tab Informacion Administrativa de Trabajos 
 */
Ext.define('HreRem.model.ObservacionesTrabajo', {
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
    			name:'nombreCompleto'
    		},
    		{
    			name:'observacion'
    		},
    		{
    			name:'fecha',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaModificacion',
    			type:'date',
    			dateFormat: 'c'
    		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            create: 'trabajo/createObservacion',
            update: 'trabajo/saveObservacion',
            destroy: 'trabajo/deleteObservacion'
        }
    }

});