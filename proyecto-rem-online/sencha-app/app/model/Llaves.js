Ext.define('HreRem.model.Llaves', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
     		{
    			name:'id'
    		},
    		{
    			name:'numLlave'
    		},
    		{
    			name:'idActivo'
    		},
    		{
    			name:'juegoCompleto'
    		},
    		{
    			name:'motivoIncompleto'
    		},
    		{
    			name:'tipoTenedor'
    		},
    		{
    			name:'nombreTenedor'
    		},
    		{
    			name:'telefonoTenedor'
    		},
    		{
    			name:'fechaPrimerAnillado'
    		},
    		{
    			name:'fechaRecepcion'
    		},
    		{
    			name:'observaciones'
    		}
    ],
    
    proxy: {
		type: 'uxproxy',
		//writeAll: true,
		api: {
			read: 'activo/getListLlavesById',
            create: 'activo/createLlave',
            update: 'activo/saveLlave',
            destroy: 'activo/deleteLlave'
        }
    }  
});