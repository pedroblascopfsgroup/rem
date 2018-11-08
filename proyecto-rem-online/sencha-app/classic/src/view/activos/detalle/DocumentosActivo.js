Ext.define('HreRem.view.activos.detalle.DocumentosActivo', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'documentosactivo',    
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    reference	: 'documentosactivoref',
    scrollable	: 'y',
    requires	: ['HreRem.model.AdjuntoActivo','HreRem.model.AdjuntoActivoPromocion','Ext.data.Store'],

    initComponent: function () {
    	 var me = this;
        me.setTitle(HreRem.i18n('title.documentos'));

    	var items= [
    	         {
     				xtype:'documentosactivosimple',
					reference: 'listadoDocumentosSimple',
					collapsible: true,
					colspan: 3
    	        	 
    	        	 
    	         }/*,
    	         
    			 {
    				xtype:'documentosactivopromocion',
					reference: 'listadoDocumentosPromo',
                    bind: {
                       // hidden: '{!activo.isVisibleCodPrinex}'
                    	hidden: true
                    },
					collapsible: true,
					colspan: 3

    			 }*/
    	];

    	me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    },

    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load(grid.loadCallbackFunction);
  		});
    }
    
    
});