/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.PujasActivo', {
    extend: 'HreRem.model.Base',

    fields: [
    	
    	{
    		name : 'idOferta'
    	},
    	{
    		name : 'numOferta'
    	},
    	{
    		name : 'ofertante'
    	},
    	{
    		name : 'estadoOferta'
    	},  
    	{
    		name : 'codigoEstadoOferta'
    	}, 
    	{
    		name : 'estadoDeposito'
    	},
    	{
    		name : 'codigoEstadoDeposito'
    	}, 
    	{
    		name : 'fechaCreacion',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
    		name : 'periodoConcurrencia'
    	}

    ]/*,
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById'
        
    }*/

});