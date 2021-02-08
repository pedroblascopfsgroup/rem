Ext.define('HreRem.view.common.adjuntos.formularioTipoDocumento.WizardAdjuntarDocumentoDetalleModel', {
	extend: 'Ext.app.ViewModel',
	alias: 'viewmodel.WizardAdjuntarDocumentoDetalleModel',
	requires: ['HreRem.ux.data.Proxy', 'HreRem.view.common.adjuntos.formularioTipoDocumento.WizardAdjuntarDocumentoModel'],
    data: {
    	wizardAdjuntarDocumentoModel: null
    },
    
	stores: {
		comboSiNoWizard: {
				data : [
			        {"codigo":"true", "descripcion":"Si"},
			        {"codigo":"false", "descripcion":"No"}
			    ]
			},
			
			storeEnergia: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'calificacionEnergetica'}
					}
				}
			}	
});