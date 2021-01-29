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
			name : 'descripcion'
		},
		{
			name : 'fechaEmision'
		},
		{
			name : 'combosinoAplica'
		},
		{
			name : 'aplica'	
		},
		{
			name : 'fechaCaducidad'
		},
		{
			name : 'fechaObtencion'
		},
		{
			name : 'fechaEtiqueta'
		},
		{
			name : 'registro'
		}
	]
	});
	