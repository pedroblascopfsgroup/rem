Ext.define('HreRem.store.dd.EntidadPropietaria', {
     extend: 'Ext.data.Store',
     storeId: 'entidadPropietaria',
     alias: 'store.dd.entidadpropietaria',
     model: 'HreRem.model.ComboBase',
     proxy: {
		type: 'uxproxy',
		remoteUrl: 'generic/getDiccionarioCarteraPorCodigoFestor'
	 }
 });