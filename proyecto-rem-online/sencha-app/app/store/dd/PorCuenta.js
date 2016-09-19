Ext.define('HreRem.store.dd.PorCuenta', {
     extend: 'Ext.data.Store',
     storeId: 'porCuenta',
     alias: 'store.dd.porcuenta',
     model: 'HreRem.model.ComboBase',
     proxy: {
		type: 'uxproxy',
		remoteUrl: 'generic/getDiccionario',
		extraParams: {diccionario: 'tiposPorCuenta'}
	 }
 });