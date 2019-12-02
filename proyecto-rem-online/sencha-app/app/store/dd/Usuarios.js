Ext.define('HreRem.store.dd.Usuarios', {
     extend: 'Ext.data.Store',
     storeId: 'usuarios',
     alias: 'store.dd.usuarios',
     model: 'HreRem.model.ComboBase',
     proxy: {
		type: 'uxproxy',
		timeout: 200000,
		remoteUrl: 'generic/getTodosComboUsuarios'
	 }
 });