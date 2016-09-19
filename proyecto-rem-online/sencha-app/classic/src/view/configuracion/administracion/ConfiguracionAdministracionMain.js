Ext.define('HreRem.view.configuracion.administracion.ConfiguracionAdministracionMain', {
	extend		: 'Ext.panel.Panel',
    xtype		: 'configuracionadministracionmain',
    requires	: ['HreRem.view.configuracion.administracion.ConfiguracionAdministracionTabPanel'],
    layout: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n('title.configuracion.administracion'));
        
        me.items = [
        			{	
        				xtype: 'configuracionadministraciontabpanel',
        				flex: 1
        				
        			}
        ];
        
        me.callParent(); 

        
    }


});

