/**
 *  Modelo para el tab Lista de activos de Expediente
 */
Ext.define('HreRem.model.ActivosExpediente', {
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
    			name:'numActivo'
    		},
    		{
    			name:'subtipoActivo'
    		},
    		{
    			name:'importeParticipacion'
    		},
    		{
    			name:'porcentajeParticipacion'
    		},
    		{
    			name:'precioMinimo'
    		},
    		{
    			name:'precioAprobadoVenta'
    		}
    		
    ],
    
    proxy: {
		type: 'uxproxy',
		api: {
			create: '',
            update: '',
            destroy: ''
        }
    }

});