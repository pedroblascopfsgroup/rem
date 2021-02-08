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
			name : 'fechaEmision',
			type:'date', 
			dateFormat: 'c'
		},
		{
			name : 'combosinoAplica'
		},
		{
			name : 'aplica'	
		},
		{
			name : 'fechaCaducidad',
			type:'date',
			dateFormat: 'c'
		},
		{
			name : 'fechaObtencion',
			type:'date',
			dateFormat: 'c'
		},
		{
			name : 'fechaEtiqueta',
			type:'date',
			dateFormat: 'c'
		},
		{
			name : 'registro'
		},
		{
			name : 'calificacionEnergetica'
		}
	]
	});
	