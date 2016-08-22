Ext.define('HreRem.view.common.ComboEstadoPropuesta', { 
    extend		: 'Ext.form.field.ComboBox',
    xtype		: 'comboestadopropuesta',
	//queryMode:'local',
	fieldLabel: 'Estado',
	displayField: 'descripcion',
	valueField: 'id',
			    
	initComponent: function() {    	
    	
		var estados = Ext.create('Ext.data.Store', {
		    
		    data : [
		        {"id":"1", "descripcion":"Aceptada"},
		        {"id":"2", "descripcion":"Rechazada"},
		        {"id":"3", "descripcion":"Pendiente"}
		        
		    ]
		});
		
    	var me = this;
   		me.setStore(estados);
    	me.callParent();
    }
	
});