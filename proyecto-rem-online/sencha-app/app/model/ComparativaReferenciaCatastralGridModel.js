Ext.define('HreRem.model.ComparativaReferenciaCatastralGridModel', {
	extend: 'HreRem.model.Base',

	fields: [
		{
			name: 'nombre'
		},
		{
			name: 'datoRem'
		},
		{
			name: 'datoCatastro'
		},
		{
			name: 'coincidencia'
		},
		{
			name: 'probabilidad'
		}
	],

	proxy: {
		type: 'uxproxy',
		api: {
			
		}
	}
});
