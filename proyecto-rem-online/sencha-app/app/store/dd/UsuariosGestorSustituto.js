Ext.define('HreRem.store.dd.UsuariosGestorSustituto', {
     extend: 'Ext.data.Store',
     storeId: 'usuariosgestorsustituto',
     alias: 'store.dd.usuariosgestorsustituto',
     model: 'HreRem.model.ComboBase',
     proxy: {
		type: 'uxproxy',
		timeout: 200000,
		remoteUrl: 'generic/getTodosComboUsuarios'
	 }
 });