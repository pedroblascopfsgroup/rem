Ext.define('HreRem.view.configuracion.administracion.proveedores.ConfiguracionProveedores', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'configuracionproveedores',
    reference	: 'configuracionProveedores',
    scrollable: 'y',
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.configuracion.proveedores"));  
        
        me.columns= [
	        			{	
	        				xtype: 'configuracionproveedoresfiltros'
	        			},
	        			{	
	        				xtype: 'configuracionproveedoreslist'
	        			}
        ];
        
        me.callParent(); 

        
    }


});

