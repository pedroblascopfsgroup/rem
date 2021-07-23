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
    		name : 'importeOferta',
			type: 'number'
    	},
    	{
    		name : 'importeContraOferta',
			type: 'number'
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
    	},
    	{
    		name: 'gencat'
    	}

    ],
    
    proxy: {
		type: 'uxproxy',
		writeAll: true,
		timeout: 60000,
		api: {
            update: 'tramitacionofertas/saveOferta'
        },
        extraParams: {entidad: 'activo'}
    }    

});