/**
 * This view is used to present the details of a single Expediente Comercial.
 */
Ext.define('HreRem.model.JuntasDocumentos', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    alias: 'viewmodel.juntasdocumentos',

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
            read: 'activojuntapropietarios/getTabJunta'
        },
        extraParams: {tab: 'junta'}
    }
});