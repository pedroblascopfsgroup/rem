Ext.define('HreRem.view.activos.detalle.PropuestasPreciosActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'propuestaspreciosactivo',    
    cls	: 'panel-base shadow-panel',
    scrollable	: 'y',
    
    requires: ['HreRem.view.common.FieldSetTable'/*, 'HreRem.model.ActivoValoraciones', 'HreRem.model.ActivoTasacion'*/],

    initComponent: function () {

        var me = this;
        me.setTitle(HreRem.i18n('title.propuestas.precios'));
        var items= [
        ];
        
		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
   }, 
   
   funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
   }
    
});