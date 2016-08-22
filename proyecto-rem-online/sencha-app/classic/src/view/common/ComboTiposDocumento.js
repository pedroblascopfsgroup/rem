Ext.define('HreRem.view.common.ComboTiposDocumento', { 
    extend		: 'Ext.form.field.ComboBox',
    xtype		: 'comboTiposDocumento',
	//queryMode:'local',
	fieldLabel: 'Tipo Doc.',
	displayField: 'descripcion',
	valueField: 'id',
			    
	initComponent: function() {    	
    	
		var tiposDocumento = Ext.create('Ext.data.Store', {
		    
		    data : [
		        {"id":"1", "descripcion":"DNI"},
		        {"id":"2", "descripcion":"Pasaporte"},
		        {"id":"3", "descripcion":"NIE"},
		        {"id":"4", "descripcion":"Otros"}
		        
		    ]
		});
		
    	var me = this;
   		me.setStore(tiposDocumento);
    	me.callParent();
    }
	
});