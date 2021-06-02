Ext.define('HreRem.model.RechazosPropietarioGridModel', {
	extend: 'HreRem.model.Base',

	fields: [
		
		{
			name: 'id'
		},
		{
			name: 'gastoId'
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
			name: 'listadoErroresRetorno'
		},
		{
			name: 'numeroLinea'
		},
		{
			name: 'activoId'
		},
		{
			name: 'numeroActivo'
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
