/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.OfertaActivo', {
    extend: 'HreRem.model.Base',

    fields: [
    	
    	{
    		name : 'idVisita'
    	},
    	{
    		name : 'idActivo'
    	},
    	{
    		name : 'idOferta'
    	},
    	{
    		name : 'idAgrupacion'
    	},
    	{
    		name : 'fechaCreacion',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
    		name : 'descripcionTipoOferta'
    	},
    	{
    		name : 'numAgrupacionRem'
    	},
    	{
    		name : 'ofertante'
    	},
    	{
    		name : 'precioPublicado'
    	},
    	{
    		name : 'importeOferta'
    	},
    	{
    		name : 'estadoOferta'
    	},
    	{
    		name : 'numExpediente'
    	},
    	{
    		name : 'descripcionEstadoExpediente'
    	}  	

    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById'
        
    }    

});