Ext.define('HreRem.view.activos.common.adjuntos.formularioTipoDocumento.formularioTipoDocumento2', {	
	 extend		: 'Ext.form.Panel',
    xtype		: 'xtypeFormularioTipoDocumento2',
    collapsed: false,
    reference: 'xtypeFormularioTipoDocumento2',
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
			border: true,
			cls:'formbase_no_shadow',
			padding: '60px 0 0 0',
			defaults: {
				addUxReadOnlyEditFieldPlugin: false
			},
			items: [
				{
			    	reference : 'primeroxtypeFormularioTipoDocumento2',
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
	            },
	            {
	            	xtype: 'datefield',
			    	fieldLabel: 'Fecha Caducidad',
			    	reference: 'fechaCaducidad'
	
	            }
	            ]
    		}       
    	]
	});