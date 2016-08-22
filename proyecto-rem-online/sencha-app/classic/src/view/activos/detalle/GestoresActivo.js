Ext.define('HreRem.view.activos.detalle.GestoresActivo', {
    extend: 'Ext.panel.Panel',
    xtype: 'gestoresactivo',
    requires: ['HreRem.view.activos.gestores.ComboGestores','HreRem.view.activos.gestores.GestoresList','Ext.plugin.LazyItems'],
    layout: 'fit',
    
    initComponent: function () {
    	var me = this;   	
    	me.setTitle(HreRem.i18n('title.gestores'));
    	var items= [
    	          {
    	          	xtype:'container',
					flex : 1,
					defaultType: 'displayfield',
					layout: {
						type: 'hbox',
						align: 'stretch'
					},
					items: [
						        {xtype : 'gestoreslist',
						        	flex: 0.7
								},
						        {xtype : 'combogestores',
									secFunPermToShow: 'MOSTRAR_COMBO_GESTORES',
						        	flex: 0.3,
						        	maxHeight: 150}
						        ]
    	          }
    	];

    	me.addPlugin({ptype: 'lazyitems', items: items });
    	
    	me.callParent();
    	
   },
   
   
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    }
    
});