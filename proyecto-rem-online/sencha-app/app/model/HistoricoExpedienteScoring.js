/**
 * This view is used to present the details of a single Expediente Comercial.
 */
Ext.define('HreRem.model.HistoricoExpedienteScoring', {
    extend: 'HreRem.model.Base',
    idProperty: 'scoring.id',
    alias: 'viewmodel.historicoexpedientescoring',

    fields: [ 
    		
	    {
			name:'fechaSancion',
			type:'date',
			dateFormat: 'c'
		},
	    {
			name:'resultadoScoring'
		},
	    {
			name:'nSolicitud'
		},
	    {
			name:'docScoring'
		},
	    {
			name:'nMesesFianza'
		},
	    {
			name:'importeFianza'
		}
    		 
    ]
});