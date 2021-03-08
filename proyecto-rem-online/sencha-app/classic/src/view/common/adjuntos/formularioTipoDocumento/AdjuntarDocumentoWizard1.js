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
		var entidad = me.up('panel').entidad;
		var subtipoTrabajo = null;
		if(entidad == 'trabajo'){
		subtipoTrabajo =  me.up().padre.view.refs.subtipoTrabajoComboFicha.value;
		}
		var comboTipoDocumento = new Ext.data.Store({
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionarioTiposDocumento',
				extraParams: {diccionario: 'tiposDocumento', entidad: entidad, subtipoTrabajo: subtipoTrabajo}
			}
			
    	});
		
		
		

		
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
				reference: 'adjuntarDocumentoFormRef1',
				collapsed: false,
			 	layout: 'fit',
				cls:'formbase_no_shadow',
				items: [
				{
					xtype: 'fieldsettable',
					layout: {
						type: 'vbox',
						align:'center'
	
					},
					reference: 'fieldsetDocumentoIdentidad',
					collapsible: false,
					defaults: {
			 			columnWidth: '50%',
			 			width: '50%',
			 			labelWidth: 100,
			 			msgTarget: 'side',
			 			addUxReadOnlyEditFieldPlugin: false,
			 			labelWidth: 100
			 		},
					items: [
						{
							xtype: 'combobox',
							fieldLabel: HreRem.i18n('fieldlabel.tipoDocumento'),
							name: 'codigoComboTipoDocumento',
							reference: 'tipoDocumentoNuevoComprador',
							allowBlank: false,
							filtradoEspecial: true,
							padding: '60px 0 0 0',
							store: comboTipoDocumento,
							displayField	: 'descripcion',
						    valueField		: 'codigo'
						},
						{
	
							xtype: 'filefield',
					        fieldLabel:   HreRem.i18n('fieldlabel.archivo'),
					        reference: 'fileUpload',
					        name: 'fileUpload',
					        allowBlank: false,
					        msgTarget: 'side',
					        buttonConfig: {
					        	iconCls: 'ico-search-white',
					        	text: ''
					        }
			    		},
			    		{
							xtype: 'textareafield',
							fieldLabel: HreRem.i18n('fieldlabel.calificacion.descripcion'),
							reference: 'descripcion',
							bind: {
								value : '{wizardAdjuntarDocumentoModel.descripcionAdjuntarDocumento}'
							}
							
						}
					]
				}]
			}
		];

		me.callParent();
	}

});