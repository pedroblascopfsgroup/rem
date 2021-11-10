Ext.define('HreRem.view.expedientes.wizards.comprador.SlideDocumentoIdentidadClienteModel', {
	extend: 'Ext.app.ViewModel',
	alias: 'viewmodel.slidedocumentoidentidadcliente',

	data: {},

	stores: {
		storeTipoDocumentoIdentidad: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {
					diccionario: 'tipoDeDocumento'
				}
			}
		}
	}
});