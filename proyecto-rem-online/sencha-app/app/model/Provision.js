/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.Provision', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [ 
    	{
    		name: 'numProvision'
    	},
    	{
    		name: 'estadoProvisionDescripcion'
    	},
		{
			name : 'fechaAlta',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name : 'gestoria'
		},
		{
			name : 'fechaEnvio',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name : 'fechaRespuesta',
			type : 'date',
			dateFormat: 'c'
		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: '/provision.json',
		remoteUrl: 'provisiongastos/findOne'
    }

});