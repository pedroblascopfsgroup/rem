Ext.define('HreRem.view.configuracion.administracion.proveedores.ConfiguracionProveedores', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'configuracionproveedores',
    reference	: 'configuracionProveedores',
    scrollable: 'y',
    requires: ['HreRem.view.configuracion.administracion.proveedores.ConfiguracionProveedoresFiltros',
               'HreRem.view.configuracion.administracion.proveedores.ConfiguracionProveedoresList'],
    
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.configuracion.proveedores"));  
        
        me.items= [
	        			{	
	        				xtype: 'configuracionproveedoresfiltros'
	        			}
						,
	        			{	
	        				xtype: 'configuracionproveedoreslist'
	        			}
        ];
        
        me.callParent(); 

        
    }


});

