Ext.define('HreRem.model.ReferenciaCatastralComboModel', {
	extend: 'HreRem.model.Base',
	idProperty: 'id',
	fields: [
		
		{
			name: 'id'
		},
		{
			name: 'codigo'
		},
		{
			name: 'descripcion'
		}
	],

	proxy: {
		type: 'uxproxy',
		api: {
			
		}
	}
});
