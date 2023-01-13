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
    			name:'importeParticipacion',
    			type: 'float'
    		},
    		{
    			name:'porcentajeParticipacion',
    			type: 'float'
    		},
    		{
    			name:'precioMinimo'
    		},
    		{
    			name:'precioAprobadoVenta'
    		},
    		{
    			name: 'idActivo',
    			critical: true
    		},
    		{
    			name:'municipio'
    		},
    		{
    			name:'direccion'
    		},
    		{
    			name:'condiciones'
    		},
    		{
    			name:'bloqueos'
    		},
    		{
    			name:'tanteos'
    		},
    		{
    			name:'idCondicion'
    		},
    		{
    			name:'activoEPA'
    		},
    		{
    			name:'esPisoPiloto',
    			type: 'boolean'
    		}
    ],
    
    proxy: {
		type: 'uxproxy',
		api: {
			create: '',
            update: 'expedientecomercial/updateActivoExpediente',
            destroy: ''
        }
    }

});