Ext.define('HreRem.view.activos.common.adjuntos.formularioTipoDocumento.formularioTipoDocumento2', {	
	 extend		: 'Ext.form.Panel',
    xtype		: 'xtypeFormularioTipoDocumento2',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'xtypeFormularioTipoDocumento2',
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
			    	reference : 'primero',
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