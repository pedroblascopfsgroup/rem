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
		    	me.getViewModel().set(form.recordName, record);			    	
		    	form.unmask();
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