/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.TextosOferta', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'id'
    		},
    		{
    			name:'campo'
    		},
    		{
    			name:'texto'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'textosOferta.json',
		api: {
            create: 'expedienteComercial/createTextoOferta',
            update: 'expedienteComercial/saveTextoOferta',
            destroy: 'expedienteComercial/deleteTextoOferta'
        }
    }

});