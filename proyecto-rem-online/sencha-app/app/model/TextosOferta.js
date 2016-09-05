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
		writeAll: true,
		localUrl: 'textosOferta.json',
		api: {
            update: 'expedientecomercial/saveTextoOferta'
        }
    }

});