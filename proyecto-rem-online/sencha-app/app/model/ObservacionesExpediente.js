/**
 *  Modelo para el tab Informacion Administrativa de Expediente
 */
Ext.define('HreRem.model.ObservacionesExpediente', {
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
    		}
    		
    ],
    
    proxy: {
		type: 'uxproxy',
		api: {
			create: 'expedientecomercial/createObservacion',
            update: 'expedientecomercial/saveObservacion',
            destroy: 'expedientecomercial/deleteObservacion'
        }
    }

});