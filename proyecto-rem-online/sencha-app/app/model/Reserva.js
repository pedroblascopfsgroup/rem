/**
 * This view is used to present the details of a single Oferta.
 */

Ext.define('HreRem.model.Reserva', {
    extend: 'HreRem.model.Base',

    fields: [
    	'idReserva',
    	'numReserva',
    	'tipoArrasCodigo',
    	{
    		name: 'fechaEnvio',
    		type : 'date',
			dateFormat: 'c'
    	},
    	'importe',
    	'estadoReservaDescripcion',
    	{
    		name: 'fechaFirma',
    		type : 'date',
			dateFormat: 'c'
    	},
    	'conImpuesto',
    	{
			name: 'fechaVencimiento',
    		type : 'date',
			dateFormat: 'c'
    	}    	
    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'reserva.json',
		
		api: {
            read: 'expedientecomercial/getTabExpediente',
            update: 'expedientecomercial/saveReserva'
        },
		
        extraParams: {tab: 'reserva'}
    }    

});
          