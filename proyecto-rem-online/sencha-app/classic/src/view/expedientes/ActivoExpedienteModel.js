Ext.define('HreRem.view.expedientes.ActivoExpedienteModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [ 
    		
		    {
		    	name: 'idExpediente'
		    }
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activoExpediente.json',
		api: {
            read: 'expedientecomercial/getActivoExpedienteInfo'
        }
    }
});