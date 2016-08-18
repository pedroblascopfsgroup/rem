Ext.define('HreRem.view.comercial.visitas.VisitasComercialMain', {
	extend		: 'Ext.panel.Panel',
    xtype		: 'visitascomercialmain',
    requires	: [],
    layout: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n('title.comercial.visitas'));
        
        me.items = [
		        		
        
        ];
        
        me.callParent(); 

        
    }


});

