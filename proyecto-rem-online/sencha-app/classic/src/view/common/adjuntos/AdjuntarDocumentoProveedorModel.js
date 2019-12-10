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
				extraParams: {diccionario: 'tipoContenedorProveedor'}
			},
			autoLoad: true,
    		sorters: 'descripcion'
    	},
    	
    	//El tipo y subtipo se corresponden con contenedor y tipo ya que se cambió la forma de organizarlo internamente,
    	// pero visualmente quiere que se siga manteniendo como tipo y subtipo. (HREOS-8415).
    	comboSubTipoDocumento: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoDocumentoProveedor'}
			},
	    	autoLoad: true,
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