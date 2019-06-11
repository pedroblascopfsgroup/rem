Ext.define('HreRem.view.expedientes.wizards.comprador.SlideDocumentoIdentidadCliente', {
	extend: 'Ext.form.Panel',
	xtype: 'slidedocumentoidentidadcliente',
	layout: 'fit',
	bodyPadding: '0',
	margin: '0',
	cls: 'panel-base',
	requires: [
		'HreRem.view.expedientes.wizards.comprador.SlideDocumentoIdentidadClienteController',
		'HreRem.view.expedientes.wizards.comprador.SlideDocumentoIdentidadClienteModel'
    ],

	controller: 'slidedocumentoidentidadcliente',
	viewModel: {
        type: 'slidedocumentoidentidadcliente'
    },

	listeners: {
		activate: 'onActivate'
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
						name: 'comboTipoDocumento',
						reference: 'tipoDocumentoNuevoComprador',
						allowBlank: false,
						padding: '120px 0 0 0',
						bind: {
							store: '{storeTipoDocumentoIdentidad}'
						}
					},
					{
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.documento.cliente'),
						reference: 'nuevoCompradorNumDoc',
						name: 'numDocumentoCliente',
						allowBlank: false
					}	
				]
			}
		];

		me.callParent();
	}

});