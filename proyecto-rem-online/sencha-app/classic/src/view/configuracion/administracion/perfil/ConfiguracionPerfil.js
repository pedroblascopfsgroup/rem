Ext.define('HreRem.view.configuracion.administracion.perfiles.ConfiguracionPerfiles', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'configuracionperfiles',
    reference	: 'configuracionPerfiles',
    scrollable: 'y',
    requires: ['HreRem.view.configuracion.administracion.perfiles.ConfiguracionPerfilesBusqueda',
    	'HreRem.view.configuracion.administracion.perfiles.ConfiguracionPerfilesList'],
    
    initComponent: function () {        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.configuracion.perfiles"));  
        
        me.items= [
	        			{	
	        				xtype: 'configuracionperfilesbusqueda'
	        			},
	        			{	
	        				xtype: 'configuracionperfileslist'
	        			}
        ];
        
        me.callParent(); 

        
    }


});

