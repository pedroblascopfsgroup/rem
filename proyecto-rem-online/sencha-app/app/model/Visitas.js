/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.Visitas', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [ 
    	{
    		name: 'tipoEntidad'
    	},
    	{
    		name: 'numActivo'
    	},
    	{
    		name: 'idActivo'
    		
    	},
		{
			name : 'idVisita'
		},
		{
			name : 'fechaSolicitud',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name : 'nombre'
		},
		{
			name : 'numDocumento'
		},
		{
			name : 'fechaVisita',
			type : 'date',
			dateFormat: 'c'
		} 
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById'
    }

});