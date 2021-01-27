Ext.define('HreRem.view.common.adjuntos.formularioTipoDocumento.AdjuntarDocumentoWizard1', {
    extend: 'Ext.form.Panel',
    xtype: 'adjuntardocumentowizard1',
    layout: 'fit',
	bodyPadding: '0',
	margin: '0',
	cls: 'panel-base',
	requires: [
		'HreRem.view.common.adjuntos.formularioTipoDocumento.AdjuntarDocumentoWizard1Controller',
		'HreRem.view.common.adjuntos.formularioTipoDocumento.WizardAdjuntarDocumentoDetalleModel',
		'HreRem.view.common.adjuntos.formularioTipoDocumento.WizardAdjuntarDocumentoModel'
    ],
	controller: 'AdjuntarDocumentoWizard1Controller',
	viewModel: {
        type: 'WizardAdjuntarDocumentoDetalleModel'
    },
    recordName : 'wizardAdjuntarDocumentoModel',
    recordClass : 'HreRem.view.common.adjuntos.formularioTipoDocumento.WizardAdjuntarDocumentoModel',
	listeners: {
		activate: 'onActivate',
		boxready: function(){
			this.lookupController().initModel(this);
		}
	},
    
	initComponent: function() {
		var me = this;
		// TODO: llevar esta linea hacia el metodo que abra el 'wizard de ofertas' en base al método que abre el 'wizard de compradores'.
		// IF WIZARD-ALTA-OFERTA THEN wizardTitle = HreRem.i18n('title.nueva.oferta');
		
		me.buttons = [
			{
				text: HreRem.i18n('btn.cancelBtnText'),
				handler: 'onClickCancelar'
			},
			{
				text: HreRem.i18n('btn.continueBtnText'),
				handler: 'onClickContinuar'
			}
		];

		me.items = [
			{
				xtype: 'formBase',
				reference: 'adjuntarDocumentoFormRef',
				collapsed: false,
			 		scrollable	: 'y',
			 		layout: 'fit',
				cls:'formbase_no_shadow',
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
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.tipoDocumento'),
						name: 'codigoComboTipoDocumento',
						reference: 'tipoDocumentoNuevoComprador',
						//allowBlank: false,
						padding: '120px 0 0 0',
						bind: {
							store: '{comboTipoDocumento}',
							value : '{wizardAdjuntarDocumentoModel.codigoComboTipoDocumento}'
						}
						
						
					},
					{

						xtype: 'filefield',
				        fieldLabel:   HreRem.i18n('fieldlabel.archivo'),
				        reference: 'fileUpload',
				        name: 'fileUpload',
				        //allowBlank: false,
				        msgTarget: 'side',
				        buttonConfig: {
				        	iconCls: 'ico-search-white',
				        	text: ''
				        }
		    		},
		    		{
						xtype: 'textareafield',
						fieldLabel: HreRem.i18n('fieldlabel.calificacion.descripcion'),
						name: 'descripcionAdjuntarDocumento',
						reference: 'descripcion',
						bind: {
							value : '{wizardAdjuntarDocumentoModel.descripcionAdjuntarDocumento}'
						}
						
					}
				]
			}
			]
			}
		];

		me.callParent();
	}

});