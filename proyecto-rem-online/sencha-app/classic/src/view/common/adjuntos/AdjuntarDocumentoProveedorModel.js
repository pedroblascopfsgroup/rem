Ext.define('HreRem.view.common.adjuntos.AdjuntarDocumentoProveedorModel', {
	extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.adjuntardocumentoproveedor',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase'],
        
    stores: {
    	comboTipoDocumento: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoDocumentoProveedor'}
			},
	    	autoLoad: true,
	    	sorters: 'descripcion'
    	}
    }
});