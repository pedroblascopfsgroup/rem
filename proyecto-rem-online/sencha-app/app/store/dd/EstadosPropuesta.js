Ext.define('HreRem.store.dd.EstadosPropuesta', {
     extend: 'Ext.data.Store',
     storeId: 'estadosPropuesta',
     alias: 'store.dd.estadospropuesta',
     model: 'HreRem.model.ComboBase',
     proxy: {
		type: 'uxproxy',
		remoteUrl: 'generic/getDiccionario',
		extraParams: {diccionario: 'estadosPropuesta'}
	 }
 });