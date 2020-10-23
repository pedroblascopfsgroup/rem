Ext.define('HreRem.model.CalidadDatoPublicacionActivo', {
	extend: 'HreRem.model.Base',
	idProperty: 'idActivo',

	fields: [
		{
			name: 'comentario'
		}
	]/*,

	proxy: {
		type: 'uxproxy',
		api: {
			create: 'activo/saveFasePublicacionActivo',
			read: 'activo/getFasePublicacionActivo',
			update: 'activo/saveFasePublicacionActivo'
		},
		extraParams: {tab: 'fasepublicacionactivo'}
	}*/
});
