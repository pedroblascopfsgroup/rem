Ext.define('HreRem.view.common.ComboEstadoInscripcion', { 
    extend		: 'Ext.form.field.ComboBox',
    xtype		: 'comboestadoinscripcion',
	//queryMode:'local',
	fieldLabel: 'Estado',
	displayField: 'descripcion',
	valueField: 'id',
			    
	initComponent: function() {    	
    	
		var estados = Ext.create('Ext.data.Store', {
		    
		    data : [
		        {"id":"1", "descripcion":"Inscrito"},
		        {"id":"2", "descripcion":"Pendiente"}
		        
		    ]
		});
		
    	var me = this;
   		me.setStore(estados);
    	me.callParent();
    }
	
});