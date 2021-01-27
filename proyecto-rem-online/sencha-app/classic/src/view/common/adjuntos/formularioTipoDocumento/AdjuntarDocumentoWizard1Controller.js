Ext.define('HreRem.view.common.adjuntos.formularioTipoDocumento.AdjuntarDocumentoWizard1Controller', {
	extend: 'Ext.app.ViewController',
	alias: 'controller.AdjuntarDocumentoWizard1Controller',
	
	
	initModel: function(form){
		var me = this;
		var model = Ext.create(form.recordClass);
		wizard = form.up('wizardBase');
		var activoId = wizard.activo;
		model.setId(activoId);
		me.getViewModel().set(form.recordName,model);
		//form.next().formExtType = 'xtypeFormularioTipoDocumento1';
	},

	onActivate: function() {
		
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
		var inside = false;
		var comboTipoDocumento = me.lookupReference('tipoDocumentoNuevoComprador').value;
		var tipoFormulario1 = ['14','89'];//AFO,CFO
		var tipoFormulario2 = ['15','16','17','86','87','88','12','91'];//BOLETIN AGUA,LUZ,GAS,LPO,CDH
		var tipoFormulario3 = ['11','24','25','84','85','118','160','158'];//CEE
		var comboTipoFormulario = form.down('[reference = tipoDocumentoNuevoComprador]').value;
		
		
	if(form.isValid()){
		if(tipoFormulario1.includes(comboTipoFormulario)){
			form.next().formExtType = 'xtypeFormularioTipoDocumento1';
			inside = true;
		}else if(tipoFormulario2.includes(comboTipoFormulario)){
			form.next().formExtType = 'xtypeFormularioTipoDocumento2';
			inside = true;
		}else if(tipoFormulario3.includes(comboTipoFormulario)){
			form.next().formExtType = 'xtypeFormularioTipoDocumento3';
			inside = true;
		}else{
			me.upload();
		}
		if(inside){
			form.next().wizardAnterior = form;
			me.getView().unmask();
			wizard.nextSlide();
		}

	} else {
	  me.fireEvent('errorToast', HreRem.i18n('msg.numero.documento.comprador.incorrecto'));
	}
},
	
	upload : function (){
		var me = this,
		form = me.getView(),
		wizard = form.up('wizardBase');
		debugger;
		var fileupload = form.down('[reference = fileUpload]').value;
		var comboTipoDocumento = me.lookupReference('tipoDocumentoNuevoComprador').value;
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