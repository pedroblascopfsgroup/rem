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
    	},
    	{
    		name: 'gencat'
    	},
		{
			name:'fechaEntradaCRMSF',
			type:'date',
    		dateFormat: 'c'
		},
    	{
    		name: 'ventaCartera',
			type: 'boolean'
    	},
    	{
    		name: 'ofertaEspecial',
			type: 'boolean'
    	},
    	{
    		name: 'ventaSobrePlano',
			type: 'boolean'
    	},
    	{
    		name: 'codRiesgoOperacion'
    	}
    		
    ],
    
    proxy: {
		type: 'uxproxy',
		writeAll: true,
		timeout: 600000,
		api: {
            update: 'tramitacionofertas/saveOferta'
        },
        extraParams: {entidad: 'agrupacion'}
    } 

});