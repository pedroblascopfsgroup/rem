/**
 * This view is used to present the details of a single Expediente Comercial.
 */
Ext.define('HreRem.model.ExpedienteScoring', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    alias: 'viewmodel.expedientescoring',

    fields: [ 
    		
		    {
		    	name: 'estadoEscoring'
		    },
		    {
    			name:'motivoRechazo'
    		},
		    {
    			name:'idSolicitud'
    		},
		    {
    			name:'revision'
    		},
		    {
    			name:'comentarios'
    		}
    		 
    ],
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'expedientecomercial/getTabExpediente',
            update: 'expedientecomercial/saveExpedienteScoring'
        },
        extraParams: {tab: 'scoring'}
    }
});