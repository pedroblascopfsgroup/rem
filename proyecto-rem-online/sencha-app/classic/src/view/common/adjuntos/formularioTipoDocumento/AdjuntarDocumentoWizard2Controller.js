Ext.define('HreRem.view.common.adjuntos.formularioTipoDocumento.AdjuntarDocumentoWizard2Controller', {
	extend: 'Ext.app.ViewController',
	alias: 'controller.AdjuntarDocumentoWizard2Controller',
	
	
	initModel: function(form){
		var me = this;
	},
	
	onActivateSlide2: function(){
		var me = this;
		me.getView().down('[reference = xtypeFormularioTipoDocumento1]').hide();
		me.getView().down('[reference = xtypeFormularioTipoDocumento2]').hide();
		me.getView().down('[reference = xtypeFormularioTipoDocumento3]').hide();
		me.getView().down('[reference = '+me.getView().formExtType+']').show();
		
	},

	onClickCancelar: function() {
		var me = this,
			wizard = me.getView().up('wizardBase');

		wizard.closeWindow();
	},

	onClickContinuar: function() {
		var me = this,
			form = me.getView(),
			wizard = form.up('wizardBase');
	if(form.isValid()){
		me.upload();
			} else {
				me.fireEvent('errorToast', HreRem.i18n('msg.numero.documento.comprador.incorrecto'));
			}
	},
	
	upload : function (){
		var me = this,
		form = me.getView(),
		wizard = form.up('wizardBase');
		debugger;
		var fileupload = me.getView().wizardAnterior.down('[reference = fileUpload]').value;
		var comboTipoDocumento = me.getView().wizardAnterior.down('[reference = tipoDocumentoNuevoComprador]').value;
		var url =  $AC.getRemoteUrl('activo/upload');
		var activoId = wizard.activo;
		form.submit({
			url: url,
			waitMsg: HreRem.i18n('msg.mask.loading'),
			params: {fileupload : fileupload,idEntidad : activoId,tipo : comboTipoDocumento},
			success: function(fp, o) {
				if(o.result.success == "false") {
					me.fireEvent("errorToast", o.result.errores);

				} else {
					debugger;
					me.getView().unmask();
					form.up('wizardBase').close();
					form.up('wizardBase').padre.refrescarActivo(true);
					
				}
			}
	   })
	}
	
});