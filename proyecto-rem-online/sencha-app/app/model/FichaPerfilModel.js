/**
 * This view is used to present the details of a single Perfil item.
 */
Ext.define('HreRem.model.FichaPerfilModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
	    	{
	        	name:'pefId'
	        },
		    {
		    	name: 'id'
		    },		    
		    {
		    	name: 'perfilDescripcion'
		    },
		    {
		    	name: 'perfilDescripcionLarga'
		    },
		    {
            	name:'perfilCodigo'
            },
		    {
		    	name: 'funcionDescripcion'
		    },
		    {
		    	name: 'funcionDescripcionLarga'
		    }
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'perfil/getPerfilById'
        }
    }    
});