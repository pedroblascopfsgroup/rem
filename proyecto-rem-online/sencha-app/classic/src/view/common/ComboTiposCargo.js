Ext.define('HreRem.view.common.ComboTiposCargo', { 
    extend		: 'Ext.form.field.ComboBox',
    xtype		: 'combotiposcargo',
	//queryMode:'local',
	fieldLabel: 'Cargo',
	displayField: 'descripcion',
	valueField: 'id',
			    
	initComponent: function() {    	
    	
		var tiposCargo = Ext.create('Ext.data.Store', {
		    
		    data : [
		        {"id":"1", "descripcion":"Ley"},
		        {"id":"2", "descripcion":"Cliente"},
		        {"id":"3", "descripcion":"Vendedor"}
		    ]
		});
		
    	var me = this;
   		me.setStore(tiposCargo);
    	me.callParent();
    }
	
});