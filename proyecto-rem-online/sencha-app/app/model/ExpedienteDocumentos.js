/**
 * This view is used to present the details of a single Expediente Comercial.
 */
Ext.define('HreRem.model.ExpedienteDocumentos', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    alias: 'viewmodel.expedientedocumentos',

    fields: [ 
		    {
		    	name: 'docOk'
		    },
		    {
		    	name: 'fechaValidacion',
    			type:'date',
    			dateFormat: 'c'
		    }
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'expedientecomercial/getTabExpediente'
        },
        extraParams: {tab: 'documentos'}
    }
});