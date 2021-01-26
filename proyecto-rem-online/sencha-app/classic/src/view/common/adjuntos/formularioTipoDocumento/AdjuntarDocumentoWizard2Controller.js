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
				Ext.Ajax.request({
					url: $AC.getRemoteUrl('ofertas/checkPedirDoc'),
					method: 'POST',
					params: {
						idExpediente: idExpediente,
						idActivo: idActivo,
						idAgrupacion: idAgrupacion,					
						dniComprador: wizard.numDocumento,
						codtipoDoc: wizard.codTipoDocumento
					},
					success: function(response, opts) {
		    			me.getView().unmask();
		    			wizard.nextSlide();
					},
					failure: function(record, operation) {
						me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				   }
				});
	
		me.getView().unmask();
		wizard.nextSlide();
			} else {
				me.fireEvent('errorToast', HreRem.i18n('msg.numero.documento.comprador.incorrecto'));
			}
	}
});