Ext.define('HreRem.view.configuracion.administracion.ConfiguracionAdministracionTabPanel', {
	extend		: 'Ext.tab.Panel',
    xtype		: 'configuracionadministraciontabpanel',
	cls			: 'panel-base shadow-panel, tabPanel-segundo-nivel',
    
    requires	: ['HreRem.view.configuracion.administracion.proveedores.ConfiguracionProveedores',
    				'HreRem.view.configuracion.administracion.mediadores.ConfiguracionMediadores'],

    initComponent: function () {
        
        var me = this;
        
        me.items = [
	        			{	
	        				xtype: 'configuracionproveedores'
	        			},
	        			{	
	        				xtype: 'configuracionmediadores'
	        			} 
        ];

        me.callParent();
        



        
    }


});

