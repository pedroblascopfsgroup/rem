Ext.define('HreRem.view.activos.common.adjuntos.formularioTipoDocumento.formularioTipoDocumento1', {	
    extend		: 'Ext.form.Panel',
    xtype		: 'xtypeFormularioTipoDocumento1',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'xtypeFormularioTipoDocumento1',
    layout: 'fit',
    isEditForm: true,
    autoScroll: true,
    items: [
    		{
			xtype: 'fieldsettable',
			layout: {
				type: 'vbox',
				align:'center'
			},
			margin: '20',
			reference: 'fieldsetDocumentoIdentidad',
			collapsible: false,
			defaults: {
				addUxReadOnlyEditFieldPlugin: false
			},
			items: [  
	            {
			    	xtype: 'combosino',
			    	title: 'Aplica',
			    	reference : 'aplica',
			    	value : '{wizardAdjuntarDocumentoModel.aplica}'
	            },
	            {
			    	xtype: 'datefield',
			    	title: 'Fecha emisión',
			    	reference: 'fechaEmision',
			    	value : '{wizardAdjuntarDocumentoModel.fechaEmision}'
	            }
    	   ]
    	}
    	]
	});