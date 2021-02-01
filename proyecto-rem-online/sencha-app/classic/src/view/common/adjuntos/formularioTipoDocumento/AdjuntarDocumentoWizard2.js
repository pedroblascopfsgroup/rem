Ext.define('HreRem.view.common.adjuntos.formularioTipoDocumento.AdjuntarDocumentoWizard2', {
    extend: 'Ext.form.Panel',
    xtype: 'adjuntardocumentowizard2',
    layout: 'fit',
	bodyPadding: '0',
	margin: '0',
	cls: 'panel-base',
	formExtType : null,
	wizardAnterior : null,
	
	requires: [
		'HreRem.view.common.adjuntos.formularioTipoDocumento.AdjuntarDocumentoWizard2Controller',
		'HreRem.view.common.adjuntos.formularioTipoDocumento.WizardAdjuntarDocumentoDetalleModel',
		'HreRem.view.activos.common.adjuntos.formularioTipoDocumento.formularioTipoDocumento1',
		'HreRem.view.activos.common.adjuntos.formularioTipoDocumento.formularioTipoDocumento2',
		'HreRem.view.activos.common.adjuntos.formularioTipoDocumento.formularioTipoDocumento3'
    ],

	controller: 'AdjuntarDocumentoWizard2Controller',
	viewModel: {
        type: 'WizardAdjuntarDocumentoDetalleModel'
    },

	listeners: {
		activate: 'onActivateSlide2'
	},

    
initComponent: function() {
    	
    	var me = this;

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
				reference: 'adjuntarDocumentoFormRef2',
				collapsed: false,
				collapsible: false,
		 		layout: {
					type: 'fit',
					align:'center'
				},
				
				cls:'formbase_no_shadow',
				items: [
					{
			    		xtype : 'xtypeFormularioTipoDocumento1',
			    		refence : 'xtypeFormularioTipoDocumento1'
			    	},
			    	{
			    		xtype : 'xtypeFormularioTipoDocumento2',
			    		refence : 'xtypeFormularioTipoDocumento2'
			    	},
			    	{
			    		xtype : 'xtypeFormularioTipoDocumento3',
			    		refence : 'xtypeFormularioTipoDocumento3'
			    	}
			    ]
		 	}
    	]
    	me.callParent();
    }

});