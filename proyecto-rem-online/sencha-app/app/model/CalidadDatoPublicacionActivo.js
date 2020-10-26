Ext.define('HreRem.model.CalidadDatoPublicacionActivo', {
	extend: 'HreRem.model.Base',
	idProperty: 'idActivo',

	fields: [
	//FASE0
		{
			name: 'idActivo'
		}
	//FASE3
		//FASE4
	],

	proxy: {
		type: 'uxproxy',
		api: {
			//create: 'activo/saveFasePublicacionActivo',
			read: 'activo/getCalidadDatoPublicacionActivo'//,
			//update: 'activo/saveFasePublicacionActivo'
		}/*,
		extraParams: {tab: 'calidaddatopublicacion'}*/
	}
});
