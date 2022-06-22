/**
 * This view is used to present the details of a single Reserva.
 */

Ext.define('HreRem.model.Deposito', {
    extend: 'HreRem.model.Base',

    fields: [
    	{
    		name:'idDeposito'
    	},
    	{
			name:'importeDeposito'
		},
		{
			name:'fechaIngresoDeposito',
			type:'date',
    		dateFormat: 'c'
		},
		{
			name: 'estadoCodigo'
		},
		{
			name:'fechaDevolucionDeposito',
			type:'date',
    		dateFormat: 'c'
		},
		{
			name: 'ibanDevolucionDeposito'
		},
        {
			name: 'ofertaConDeposito',
   			type: 'boolean'
		},
        {
			name: 'usuCrearOfertaDepositoExterno',
   			type: 'boolean'
		}
		
    ],

    proxy: {
		type: 'uxproxy',
		localUrl: 'depositoExpediente.json',
		api: {
            read: 'expedientecomercial/getTabExpediente',
            update: 'expedientecomercial/saveDeposito'
        },
        extraParams: {tab: 'deposito'}
    }
});
          