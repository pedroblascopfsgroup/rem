/**
 * This view is used to present the details of a single Agrupacion Item.
 */
Ext.define('HreRem.model.VigenciaAgrupacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
     			{
		    		name : 'idAgrupacion'
		    	},
		    	{
		    		name : 'fechaInicioVigencia',
		    		type : 'date',
		    		dateFormat: 'c'
		    	},
		    	{
		    		name : 'fechaFinVigencia',
		    		type : 'date',
		    		dateFormat: 'c'
		    	},
			 	{
		    		name: 'usuarioModificacion'
		    	},
		    	{
		    		name : 'fechaCrear',
		    		type : 'date',
		    		dateFormat: 'c'
		    	}
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            create: 'agrupacion/reactivar',
            update: 'agrupacion/reactivar'            
        }
    }    

});