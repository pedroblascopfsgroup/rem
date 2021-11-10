Ext.define('HreRem.view.configuracion.administracion.testigosobligatorios.ConfiguracionTestigosObligatorios', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'configuraciontestigosobligatorios',
    reference	: 'configuracionTestigosObligatorios',
    scrollable: 'y',
    requires: ['HreRem.view.configuracion.administracion.proveedores.ConfiguracionProveedoresList'],
    
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.configuracion.testigos.obligatorios"));  
        
        me.items= [
	        			{	
	        				xtype: 'configuraciontestigosobligatorioslist'
	        			}
        ];
        
        me.callParent(); 

        
    }


});

