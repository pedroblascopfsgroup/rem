/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.Ofertas', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [ 
    	{
    		name: 'numOferta'
    	},
    	{
    		name: 'numActivo'
    	},
    	{
    		name: 'numAgrupacionRem'
    	},
    	{
    		name: 'estadoOferta'
    		
    	},
		{
			name : 'descripcionTipoOferta'
		},
		{
			name : 'fechaCreacion',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name : 'numExpediente'
		},
		{
			name : 'descripcionEstadoExpediente'
		},
		{
			name : 'subtipoActivo'
		},
		{
			name : 'importeOferta'
		},
		{
			name : 'ofertante'
		},
		{
			name : 'comite'
		},
		{
			name : 'derechoTanteo'
		}
 	
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById'
    }

});