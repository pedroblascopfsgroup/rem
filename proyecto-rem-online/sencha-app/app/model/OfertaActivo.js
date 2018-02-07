/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.OfertaActivo', {
    extend: 'HreRem.model.Base',
	idProperty: 'id',
	
    fields: [
    	
    	{
    		name : 'idVisita'
    	},
    	{
    		name: 'numActivoAgrupacion'
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
    		name : 'codigoEstadoOferta'
    	},
    	{
    		name : 'tipoRechazoCodigo'
    	},
    	{
    		name : 'motivoRechazoCodigo'
    	},
    	{
    		name : 'numExpediente'
    	},
    	{
    		name : 'descripcionEstadoExpediente'
    	} ,
    	{
    		name : 'idExpediente'
    	},
    	{
    		name: 'ofertaExpress'
    	}

    ],
    
    proxy: {
		type: 'uxproxy',
		writeAll: true,
		api: {
            update: 'activo/saveOfertaActivo'
        }
    }    

});