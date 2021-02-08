Ext.define('HreRem.view.activos.common.adjuntos.formularioTipoDocumento.formularioTipoDocumento1', {	
    extend		: 'Ext.form.Panel',
    xtype		: 'xtypeFormularioTipoDocumento1',
    collapsed: false,
    reference: 'xtypeFormularioTipoDocumento1',
    layout: 'fit',
    isEditForm: true,
    autoScroll: false,
    items: [
    		{
			xtype: 'fieldsettable',
			layout: {
				type: 'vbox',
				align:'center'
			},
			reference: 'fieldsetDocumentoIdentidad',
			collapsible: false,
			collapsed: false,
			border: false,
			cls:'formbase_no_shadow',
			padding: '60px 0 0 0',
			defaults: {
				addUxReadOnlyEditFieldPlugin: false
			},
			items: [
				{
			    	reference : 'primeroxtypeFormularioTipoDocumento1',
			    	hidden : true
	            }, 
	            {
			    	xtype: 'combosino',
			    	fieldLabel: 'Aplica',
			    	reference : 'aplica'
	            },
	            {
			    	xtype: 'datefield',
			    	fieldLabel: 'Fecha emisión',
			    	reference: 'fechaEmision'
	            }
    	   ]
    	}
    	]
	});