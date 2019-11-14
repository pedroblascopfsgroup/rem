Ext.define('HreRem.view.common.adjuntos.AdjuntarDocumentoProveedorModel', {
	extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.adjuntardocumentoproveedor',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.SubtipoDocumento'],
        
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
    	},
    	
    	comboSubTipoDocumento: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'proveedores/getSubtipoDocProveedor',
				extraParams: {codigoTipoDoc: '{tipo.value}'}
			},
	    	autoLoad: false,
	    	sorters: 'descripcion'
    	},
    	
    	comboCarteraPorProveedor: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'proveedores/getCarteraPorProveedor',
				extraParams: {idProveedor: '{proveedor.id}'}
			},
	    	autoLoad: true
    	},
    	
    	comboSubcarteraPorProveedor: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'proveedores/getSubcarterasProveedor',
				extraParams: {idProveedor: '{proveedor.id}', codigoCartera: '{cartera.value}'}
			},
	    	autoLoad: false
    	}
    }
});