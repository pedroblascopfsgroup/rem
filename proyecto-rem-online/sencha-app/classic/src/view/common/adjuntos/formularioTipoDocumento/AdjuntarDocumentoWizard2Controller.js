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
		var fileupload = me.getView().wizardAnterior.down('[reference = fileUpload]').value;
		var comboTipoDocumento = me.getView().wizardAnterior.down('[reference = tipoDocumentoNuevoComprador]').value;
		var descripcion =me.getView().wizardAnterior.down('[reference = descripcion]').value;
		var url =  $AC.getRemoteUrl('activo/upload');
		var idEntidad = wizard.idEntidad; 
		var entidad = wizard.entidad; 
		form2 = me.getView().wizardAnterior.down('form');
		var params = {fileupload : fileupload, idEntidad : idEntidad, entidad: entidad, tipo : comboTipoDocumento,descripcion:descripcion};
		params = me.devolverParametros(me.getView().formExtType, form,params);
		form2.submit({
			url: url,
			waitMsg: HreRem.i18n('msg.mask.loading'),
			params: params,
			success: function(fp, o) {
				if(o.result.success == "false") {
					me.fireEvent("errorToast", o.result.errores);

				} else {
					var padre = form.up('wizardBase').padre;
					me.getView().unmask();
					form.up('wizardBase').close();
					padre.refrescarActivo(true);
					
				}
			}
	   })
	},
	
	devolverParametros: function(xtype, form,nuevosParametros){
		var siguienteReferencia = null;
		var formulario = form.down('[reference='+xtype+']');
		siguienteReferencia = form.down('[reference=primero]');
		while (!Ext.isEmpty(siguienteReferencia.nextSibling())){
			siguienteReferencia = siguienteReferencia.nextSibling();
			nuevosParametros [siguienteReferencia.reference] = siguienteReferencia.value;
		}
		
		return nuevosParametros;
	}
		
	
});