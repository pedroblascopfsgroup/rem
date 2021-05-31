Ext.define('HreRem.model.RechazosPropietarioGridModel', {
	extend: 'HreRem.model.Base',

	fields: [
		
		{
			name: 'id'
		},
		{
			name: 'numeroGasto'
		},
		{
			name: 'listadoErroresDesc'
		},
		{			
			name: 'listadoErroresCod'
		},
		{
			name: 'mensajeError'
		},
		{
			name:'fechaProcesado',
			type:'date',
			dateFormat: 'c'
		}
	],

	proxy: {
		type: 'uxproxy',
		api: {
			
		}
	}
});
