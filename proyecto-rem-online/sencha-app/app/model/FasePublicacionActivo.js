Ext.define('HreRem.model.FasePublicacionActivo', {
	extend: 'HreRem.model.Base',
	idProperty: 'idActivo',

	fields: [
		{
			name: 'fasePublicacionCodigo'
		},
		{
			name: 'subfasePublicacionCodigo'
		},
		{
			name: 'comentario'
		}
	],

	proxy: {
		type: 'uxproxy',
		api: {
			create: 'activo/saveFasePublicacionActivo',
			read: 'activo/getFasePublicacionActivo',
			update: 'activo/saveFasePublicacionActivo'
		},
		extraParams: {tab: 'fasepublicacionactivo'}
	}
});
