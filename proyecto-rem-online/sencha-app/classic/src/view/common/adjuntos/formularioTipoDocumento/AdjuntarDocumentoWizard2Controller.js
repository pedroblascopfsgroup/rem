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
		var url =  $AC.getRemoteUrl('gestordocumental/upload');
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
	    			if(!Ext.isEmpty(o.response.responseText)) {
	    				var error = Ext.decode(o.response.responseText).errorMessage;
	    				wizard.fireEvent("errorToast", error);
	    			} else {
	    				wizard.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	    			}
	    			wizard.previousSlide();
				} else {
					var padre = form.up('wizardBase').padre;
					me.getView().unmask();
					wizard.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					form.up('wizardBase').close();
					padre.refrescarActivo(true);
					
				}
			}
	   })
	},
	
	devolverParametros: function(xtype, form,nuevosParametros){
		var siguienteReferencia = null;
		var formulario = form.down('[reference='+xtype+']');
		siguienteReferencia = form.down('[reference=primero'+xtype+']');
		while (!Ext.isEmpty(siguienteReferencia.nextSibling())){
			siguienteReferencia = siguienteReferencia.nextSibling();
			if(siguienteReferencia.xtype.match('datefield')){
				var fecha = siguienteReferencia.value.toLocaleDateString();
				nuevosParametros [siguienteReferencia.reference] = fecha;
			}else{
				nuevosParametros [siguienteReferencia.reference] = siguienteReferencia.value;
			}
			
		}
		
		return nuevosParametros;
	}
		
	
});