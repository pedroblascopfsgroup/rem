Ext.define('HreRem.view.common.ComboTiposImpuesto', { 
    extend		: 'Ext.form.field.ComboBox',
    xtype		: 'combotiposimpuesto',
	//queryMode:'local',
	fieldLabel: 'Tipo Impuesto',
	displayField: 'descripcion',
	valueField: 'id',
			    
	initComponent: function() {    	
    	
		var tiposImpuesto = Ext.create('Ext.data.Store', {
		    
		    data : [
		        {"id":"1", "descripcion":"IVA"},
		        {"id":"2", "descripcion":"ITP"}
		    ]
		});
		
    	var me = this;
   		me.setStore(tiposImpuesto);
    	me.callParent();
    }
	
});