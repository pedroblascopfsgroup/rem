Ext.define('HreRem.view.common.ComboTipoActuacion', { 
    extend		: 'Ext.form.field.ComboBox',
    xtype		: 'comboTipoActuacion',
	displayField: 'descripcion',
	valueField: 'id',
			    
	initComponent: function() {    	
    	
		var store = Ext.create('Ext.data.Store', {
		    
		    data : [
		        {"id":"1", "descripcion":"Solicitud Cliente Web"},
		        {"id":"2", "descripcion":"Visita"},
		        {"id":"3", "descripcion":"Oferta"}
		        
		    ]
		});
		
    	var me = this;
    	me.setFieldLabel(HreRem.i18n('fieldlabel.tipo.actuacion'));
   		me.setStore(store);
    	me.callParent();
    }
	
});