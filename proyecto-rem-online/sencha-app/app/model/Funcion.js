Ext.define('HreRem.model.Funcion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
	    	{
	        	name:'id'
	        },
            {
            	name:'descripcion'
            }
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'funciones/getFunciones'
		}
    }
});