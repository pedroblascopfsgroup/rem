Ext.define('HreRem.view.expedientes.wizards.comprador.SlideAdjuntarDocumento', {
	extend: 'Ext.form.Panel',
	xtype: 'slideadjuntardocumento',
	layout: 'fit',
	bodyPadding: '0',
	margin: '0',
	cls: 'panel-base',
	requires: [
		'HreRem.view.expedientes.wizards.comprador.SlideAdjuntarDocumentoModel',
		'HreRem.view.expedientes.wizards.comprador.SlideAdjuntarDocumentoController'
	],

	controller: 'slideadjuntardocumento',
	viewModel: {
		type: 'slideadjuntardocumento'
	},

	defaults: {
		addUxReadOnlyEditFieldPlugin: false,
		margin: '10px 20px'
	},

	listeners: {
		activate: 'onActivate'
	},

	initComponent: function() {
		var me = this;

		me.buttons = [{
				text: HreRem.i18n('btn.volverBtnText'),
				handler: 'onClickAtras'
			},
			{
				text: HreRem.i18n('label.generar.documento'),
				handler: 'onClickBotonGenerarDoc',
				reference: 'btnGenerarDocumento',
				disabled: true
			},
			{
				text: HreRem.i18n('label.subir.documento'),
				handler: 'abrirFormularioAdjuntarDocumentoOferta',
				reference: 'btnSubirDocumento',
				disabled: true
			},
			{
				text: HreRem.i18n('btn.finalizarBtnText'),
				handler: 'onClickContinuar',
				reference: 'btnFinalizar',
				disabled: true
			}
		];

		me.items = [{
			xtype: 'fieldsettable',
			layout: 'vbox',
			defaults: {
				addUxReadOnlyEditFieldPlugin: false
			},
			collapsible: false,
			title: HreRem.i18n('fieldset.title.doc'),
			items: [{
					xtype: 'checkboxfieldbase',
					name: 'carteraInternacional',
					hidden: true
				},
				{
					xtype: 'checkboxfieldbase',
					fieldLabel: HreRem.i18n('wizard.oferta.documento.cesionDatos'),
					bind: '{oferta.cesionDatos}',
					name: 'cesionDatos',
					margin: '50px 0 0 200px',
					reference: 'chkbxCesionDatosHaya',
					readOnly: false,
					listeners: {
						change: 'onChangeCheckboxCesionDatos'
					}
				},
				{
					xtype: 'checkboxfieldbase',
					fieldLabel: HreRem.i18n('wizard.oferta.documento.comunicacionTerceros'),
					bind: '{oferta.comunicacionTerceros}',
					name: 'comunicacionTerceros',
					margin: '10px 0 0 200px',
					reference: 'chkbxcComunicacionTerceros',
					readOnly: false,
					listeners: {
						change: 'onChangeCheckboxComunicacionTerceros'
					}
				},
				{
					xtype: 'checkboxfieldbase',
					fieldLabel: HreRem.i18n('wizard.oferta.documento.transferenciasInternacionales'),
					bind: '{oferta.transferenciasInternacionales}',
					name: 'transferenciasInternacionales',
					margin: '10px 0 0 200px',
					reference: 'chkbxTransferenciasInternacionales',
					readOnly: false,
					listeners: {
						change: 'onChangeCheckboxTransferenciasInternacionales'
					}
				},
				{
					xtype: 'panel',
					layout: 'hbox',
					name: 'panelDocumentoOferta',
					defaults: {
						addUxReadOnlyEditFieldPlugin: false
					},
					margin: '10px 0 0 200px',
					style: 'background-color: transparent; border: none;',
					title: HreRem.i18n('title.documentos'),
					cls: 'panel-base',
					items: [{
							xtype: 'textfieldbase',
							name: 'docOfertaComercial',
							readOnly: true,
							padding: 10,
							style: 'overflow: hidden',
							listeners: {
								render: 'onRenderTextfieldDocumentoOfertaComercial'
							}
						},
						{
							xtype: 'button',
							iconCls: 'fa fa-trash',
							margin: '10px 0 0 0',
							reference: 'btnBorrarDocumentoAdjunto',
							style: 'bodyBackground: transparent',
							hidden: true,
							handler: 'borrarDocumentoAdjuntoOferta'
						}
					]
				}
			]
		}];

		me.callParent();
	}
});