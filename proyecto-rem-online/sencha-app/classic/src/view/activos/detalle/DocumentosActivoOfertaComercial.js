Ext.define('HreRem.view.activos.detalle.DocumentosActivoOfertaComercial', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'documentosactivoofertacomercial',    
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    reference	: 'documentosactivoofertacomercialref',
    scrollable	: 'y',
    requires	: ['HreRem.model.AdjuntoActivo','HreRem.model.AdjuntoActivoPromocion','Ext.data.Store'],

    initComponent: function () {
    	var me = this;
        me.setTitle(HreRem.i18n('title.documentos'));

    	var items= [
    	         {
    	        	 xtype: 'textfieldbase',
    	        	 name: 'docOfertaComercial',
    	        	 readOnly: true,
    	        	 padding: 10,
    	        	 value: 'documentoFalso.doc'
    	         }
    	];
    	
    	me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();    	
    },

    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		/*Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load(grid.loadCallbackFunction);
  		});*/
    }
    
    
});