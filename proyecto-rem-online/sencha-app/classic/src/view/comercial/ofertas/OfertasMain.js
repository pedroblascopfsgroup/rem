Ext.define('HreRem.view.comercial.ofertas.OfertasMain', {
	extend		: 'Ext.panel.Panel',
    xtype		: 'ofertasmain',
    requires	: [],
    layout: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n('title.comercial.ofertas'));
        
        me.items = [
        
        			   
        
        ];
        
        me.callParent(); 

        
    }


});

