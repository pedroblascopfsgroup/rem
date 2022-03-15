/**
 * This view is used to present the details of a single Expediente Comercial Gestión Economica.
 */
Ext.define('HreRem.model.ExpedienteComercialGestionEconomica', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    alias: 'viewmodel.expedientecomercialgestioneconomica',

    fields: [ 
		    {
		    	name: 'revisadoPorControllers'
		    },
		    {
		    	name: 'fechaRevision',
    			type:'date',
    			dateFormat: 'c'
		    }
    ],
	proxy: {
		type: 'uxproxy',
		//localUrl: 'expedienteComercial.json',
		api: {
            read: 'expedientecomercial/getTabExpediente',
            update: 'expedientecomercial/updateExpedienteComercialGestionEconomica'
        },
        extraParams: {tab: 'gestioneconomica'}
    }
});