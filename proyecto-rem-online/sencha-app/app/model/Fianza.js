/**
 * This view is used to present the details of a single Expediente Comercial.
 */
Ext.define('HreRem.model.Fianza', {
    extend: 'HreRem.model.Base',
    alias: 'viewmodel.fianza',
 	idProperty: 'id',
    fields: [
		    {
    			name:'agendacionIngreso',
    			type:'date',
        		dateFormat: 'c'
    		},
		    {
    			name:'importeFianza'
    		},
    		{
    			name:'fechaIngreso',
    			type:'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'cuentaVirtual'
    		},
    		{
    			name:'ibanDevolucion'
    		},
    		{
    			name:'idFianza'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		localUrl: 'expedienteComercial.json',

		api: {
            read: 'expedientecomercial/getTabExpediente',
            update: 'expedientecomercial/saveTabFianza'
        },

        extraParams: {tab: 'fianza'}
    }

});
