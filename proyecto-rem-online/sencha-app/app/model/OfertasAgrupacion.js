/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.OfertasAgrupacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

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