Ext.define('HreRem.model.CalidadDatoFasesGridModel', {
	extend: 'HreRem.model.Base',

	fields: [
		
		{
			name: 'nombreCampoWeb'
		},
		{
			name: 'valorRem'
		},
		{
			name: 'valorDq'
		},
		{
			name: 'indicadorCorrecto'
		},
		{
			name: 'codigoGrid'
		}
	],

	proxy: {
		type: 'uxproxy',
		api: {
			
		}
	}
});
