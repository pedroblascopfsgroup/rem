Ext.define('HreRem.view.common.adjuntos.formularioTipoDocumento.WizardAdjuntarDocumentoModel', {
	extend: 'HreRem.model.Base',
	idProperty : 'id',
	fields : [
		{
		name : 'codigoComboTipoDocumento'	
		},
		
		{
			name : 'fileUpload'	
		},
		{
		name : 'descripcionAdjuntarDocumento'
		},
		{
			name : 'fechaEmision'
		},
		{
			name : 'combosinoAplica'
		}
	]
	});
	