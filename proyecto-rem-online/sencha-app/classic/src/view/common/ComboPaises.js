Ext.define('HreRem.view.common.ComboPaises', { 
    extend		: 'Ext.form.field.ComboBox',
    xtype		: 'comboPaises',
    store		: 'ComboPaisesStoreId',
    require:['HreRemstore.ComboPaisesStore'],
	queryMode:'local',
	fieldLabel: 'País',
	displayField: 'descripcion',
	valueField: 'id',

	initComponent: function() {    	
    	var me = this;
    	

   		me.callParent();
    }
	
});