/**
 * This view is used to present the details of a single Oferta.
 */

Ext.define('HreRem.model.Reserva', {
    extend: 'HreRem.model.Base',

    fields: [
    	'idReserva',
    	'numReserva',
    	'tipoArrasCodigo',
    	'fechaEvio',
    	'importe',
    	'estadoReservaDescripcion',
    	'fechaFirma',
    	'conImpuesto',
    	'fechaVencimiento'    	
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
          