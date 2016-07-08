Ext.define('HreRem.view.common.ComboOfertanteVendedor', { 
    extend		: 'Ext.form.field.ComboBox',
    xtype		: 'comboofertantevendedor',
	//queryMode:'local',
	fieldLabel: 'Por cuenta de',
	displayField: 'descripcion',
	valueField: 'id',
			    
	initComponent: function() {    	
    	
		var tipos = Ext.create('Ext.data.Store', {
		    
		    data : [
		        {"id":"1", "descripcion":"Ofertante"},
		        {"id":"2", "descripcion":"Vendedor"}
		    ]
		});
		
    	var me = this;
   		me.setStore(tipos);
    	me.callParent();
    }
	
});