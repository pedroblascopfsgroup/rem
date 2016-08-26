/**
 * This view is used to present the details of a single Oferta.
 */

Ext.define('HreRem.model.CondicionesExpediente', {
    extend: 'HreRem.model.Base',

    fields: [
    
	    {
	    	name: 'idCondiciones'
	    },
	    {
	    	name: 'solicitaFinanciacion'
	    }

    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'condicionesExpediente.json',
		
		api: {
            read: 'expedientecomercial/getTabExpediente',
            update: 'expedientecomercial/saveCondicionesExpediente'
        },
		
        extraParams: {tab: 'condiciones'}
    }    

});
          