Ext.define('HreRem.model.ReferenciaCatastralGridModel', {
	extend: 'HreRem.model.Base',
	idProperty: 'id',
	fields: [
		
		{
			name: 'refCatastral'
		},
		{
			name: 'correcto'
		}
	],

	proxy: {
		type: 'uxproxy',
		api: {
			
		}
	}
});
