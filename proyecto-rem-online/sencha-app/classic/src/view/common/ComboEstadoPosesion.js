Ext.define('HreRem.view.common.ComboEstadoPosesion', { 
    extend		: 'Ext.form.field.ComboBox',
    xtype		: 'comboestadoposesion',
	//queryMode:'local',
	fieldLabel: 'Estado',
	displayField: 'descripcion',
	valueField: 'id',
			    
	initComponent: function() {    	
    	
		var estados = Ext.create('Ext.data.Store', {
		    
		    data : [
		        {"id":"1", "descripcion":"Libre"},
		        {"id":"2", "descripcion":"Ocupado"},
		        {"id":"3", "descripcion":"Arrendado"}
		        
		    ]
		});
		
    	var me = this;
   		me.setStore(estados);
    	me.callParent();
    }
	
});