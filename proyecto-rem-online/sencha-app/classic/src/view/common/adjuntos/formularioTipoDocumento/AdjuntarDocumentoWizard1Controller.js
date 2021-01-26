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
		me.getView().unmask();

			Ext.Ajax.request({
				url: $AC.getRemoteUrl('activo/upload'),
				method: 'POST',
				params: {
					idActivo: wizard.activo,
					idEntidad: 'activo',
					formulario : form
				},
				success: function(response, opts) {
	    			me.getView().unmask();
	    			wizard.close();
				},
				failure: function(record, operation) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			   }
		})
	}

});