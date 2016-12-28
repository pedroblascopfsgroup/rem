Ext.define('HreRem.view.precios.generacion.GeneracionPropuestasMain', {
	extend		: 'Ext.panel.Panel',
    xtype		: 'generacionpropuestasmain',
    requires	: ['HreRem.view.precios.generacion.GeneracionPropuestasTabPanel', 'HreRem.view.precios.generacion.GeneracionPropuestasActivosList'],
    layout		: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.generacion.propuestas.precios'));

        me.items = [
    			{	
    				xtype: 'generacionpropuestastabpanel',
    				flex: 1
    			},
    			{
			        xtype: 'splitter',
			        cls: 'x-splitter-base',
			        collapsible: true,
			        performCollapse: true
			    },
    			{	
					xtype: 'generacionpropuestasactivoslist',
					reference: 'generacionPropuestasActivosList',
					collapsed: true,
					flex: 1
    			}
        ];

        me.callParent(); 
    }
});