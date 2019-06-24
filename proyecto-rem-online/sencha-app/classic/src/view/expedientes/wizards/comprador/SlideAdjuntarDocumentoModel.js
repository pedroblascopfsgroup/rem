Ext.define('HreRem.view.expedientes.wizards.comprador.SlideAdjuntarDocumentoModel', {
	extend: 'Ext.app.ViewModel',
	alias: 'viewmodel.slideadjuntardocumento',

	data: {},

	stores: {
		comboSiNoWizard: {
				data : [
			        {"codigo":"true", "descripcion":"Si"},
			        {"codigo":"false", "descripcion":"No"}
			    ]
			}
	}
});