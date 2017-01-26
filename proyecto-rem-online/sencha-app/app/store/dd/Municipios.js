Ext.define('HreRem.store.dd.Municipios', {
     extend: 'Ext.data.Store',
     storeId: 'municipios',
     alias: 'store.dd.municipios',
     model: 'HreRem.model.ComboLocalidadBase',
     proxy: {
		type: 'uxproxy',
		remoteUrl: 'generic/getComboMunicipioSinFiltro'
	 }
 });