Ext.define('HreRem.store.dd.EstadosPropuestaActivo', {
     extend: 'Ext.data.Store',
     storeId: 'estadosPropuestaActivo',
     alias: 'store.dd.estadospropuestaactivo',
     model: 'HreRem.model.ComboBase',
     proxy: {
		type: 'uxproxy',
		remoteUrl: 'generic/getDiccionario',
		extraParams: {diccionario: 'estadosPropuestaActivo'}
	 }
 });