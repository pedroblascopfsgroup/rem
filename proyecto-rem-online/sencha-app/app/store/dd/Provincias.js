Ext.define('HreRem.store.dd.Provincias', {
     extend: 'Ext.data.Store',
     storeId: 'provincias',
     alias: 'store.dd.provincias',
     model: 'HreRem.model.ComboBase',
     proxy: {
		type: 'uxproxy',
		remoteUrl: 'generic/getDiccionario',
		extraParams: {diccionario: 'provincias'}
	 }
 });