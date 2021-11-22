Ext.define('HreRem.view.configuracion.administracion.configuracionrecomendacion.ConfiguracionRecomendacion', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'configuracionrecomendacion',
    reference	: 'configuracionRecomendacion',
    scrollable: 'y',
    
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.configuracion.recomendacion"));  
        
        me.items= [
			{	
				xtype: 'configuracionrecomendacionlist'
			}
        ];
        
        me.callParent(); 

        
    }


});

