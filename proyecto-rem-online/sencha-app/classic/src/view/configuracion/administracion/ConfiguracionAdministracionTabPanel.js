Ext.define('HreRem.view.configuracion.administracion.ConfiguracionAdministracionTabPanel', {
	extend		: 'Ext.tab.Panel',
    xtype		: 'configuracionadministraciontabpanel',
	cls			: 'panel-base shadow-panel, tabPanel-segundo-nivel',
    
    requires	: ['HreRem.view.configuracion.administracion.proveedores.ConfiguracionProveedores'],

    initComponent: function () {
        
        var me = this;
        
        me.items = [
	        			{	
	        				xtype: 'configuracionproveedores'
	        			}
        ];

        me.callParent();
        



        
    }


});

