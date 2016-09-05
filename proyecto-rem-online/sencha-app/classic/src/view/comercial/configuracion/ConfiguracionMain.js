Ext.define('HreRem.view.comercial.configuracion.ConfiguracionComercialMain', {
	extend		: 'Ext.panel.Panel',
    xtype		: 'configuracioncomercialmain',
    requires	: [],
    layout: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n('title.comercial.configuracion'));
        
        me.items = [
        
        			   
        
        ];
        
        me.callParent(); 

        
    }


});

