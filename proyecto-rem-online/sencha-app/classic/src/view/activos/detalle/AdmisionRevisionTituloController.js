Ext.define('HreRem.view.activos.detalle.AdmisionRevisionTituloController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.admisionrevisiontitulo',
    requires: ['HreRem.view.activos.detalle.AdmisionRevisionTitulo', 'HreRem.model.AdmisionRevisionTitulo'],
    
	
	cargarTabData: function (form) {
		var me = this;
		var model = form.getModelInstance();
		var id = me.getViewModel().get("activo.id");
		model.setId(id);
		model.set("idActivo",id);
		
		form.mask(HreRem.i18n("msg.mask.loading"));
		model.load({
		    success: function(record,b,c,d) {
		    	form.setBindRecord(record);		
		    	me.getViewModel().set(form.recordName, record);			    	
		    	form.unmask();
		    	if(Ext.isFunction(form.afterLoad)) {
		    		form.afterLoad();
		    	}
		    },
		    failure: function(operation) {		    	
		    	form.up("tabpanel").unmask();
		    	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
		    }
		});
	},
	saveTabData : function(btn, form) {
		var me = this;
		var model = me.getViewModel().get("admisionRevisionTitulo");
		model.set("idActivo",me.getViewModel().get("activo.id"));
		form.mask(HreRem.i18n("msg.mask.espere"));
		model.save({
			success : function(record) {
				form.unmask();
				me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
			},
			failure : function(record, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				form.unmask();
			}
		});
		if(!Ext.isEmpty(btn)) {
			btn.hide();
			btn.up('tabbar').down('button[itemId=botoncancelar]').hide();
			btn.up('tabbar').down('button[itemId=botoneditar]').show();
			me.getView().up("tabpanel").lookupController().getViewModel().set("editing", false);
			me.getView().up("tabpanel").lookupController().getViewModel().notify();
			Ext.Array.each(btn.up('tabpanel').getActiveTab()
							.query('field[isReadOnlyEdit]'), function(
							field, index) {
						field.fireEvent('save');
						field.fireEvent('update');
					});
		}
	},
    comboRevisadoOnSelect: function (combo, record, eOpts) {
    	var me = this;
    	var fechaRevisionTitulo = me.lookupReference("fechaRevisionTitulo");
    	if ("01"===record.data.codigo){
    		fechaRevisionTitulo.setValue(new Date())		
    	}else {
    		fechaRevisionTitulo.setValue(null);
    	}
    }
});