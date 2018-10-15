Ext.define('HreRem.view.agrupaciones.detalle.SeguimientoAgrupacion', {
    extend: 'Ext.form.Panel',
    xtype: 'seguimientoagrupacion',
	layout: 'fit',
	requires: ['HreRem.view.common.FieldSetTable', 'HreRem.model.SeguimientoAgrupacion'],

    initComponent: function () {

        var me = this;
        
        me.setTitle('Seguimiento');
        		         
        var items= [];
        
		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
    }

});