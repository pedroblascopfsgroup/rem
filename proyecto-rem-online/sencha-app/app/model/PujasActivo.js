/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.PujasActivo', {
    extend: 'HreRem.model.Base',

    fields: [
    	{
    		name : 'id'
    	},
    	{
    		name : 'numOferta'
    	},
    	{
    		name : 'descripcionTipoOferta'
    	},
    	{
    		name : 'ofertante'
    	},
    	{
    		name : 'estadoOferta'
    	},  
    	{
    		name : 'estadoDeposito'
    	}, 
    	{
    		name : 'fechaCreacion',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
    		name : 'diasConcurrencia'
    	}

    ]

});