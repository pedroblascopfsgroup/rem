Ext.define('HreRem.view.common.ComboSiNo', { 
    extend		: 'Ext.form.field.ComboBox',
    xtype		: 'combosino',
	//queryMode:'local',
	displayField: 'descripcion',
	valueField: 'id',
			    
	initComponent: function() {    	
    	
		var siNo = Ext.create('Ext.data.Store', {
		    
		    data : [
		        {"id":"Si", "descripcion":"Si"},
		        {"id":"No", "descripcion":"No"}
		    ]
		});
		
    	var me = this;
   		me.setStore(siNo);
    	me.callParent();
    }
	
});