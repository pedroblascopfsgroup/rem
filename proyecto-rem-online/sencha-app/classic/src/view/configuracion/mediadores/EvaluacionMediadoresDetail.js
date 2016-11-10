Ext.define('HreRem.view.configuracion.administracion.mediadores.ConfiguracionMediadoresDetail', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'configuracionmediadoresdetail',
    reference	: 'configuracionMediadoresDetail',
    scrollable: 'y',
    requires: ['HreRem.view.configuracion.administracion.mediadores.detalle.CarteraMediadorStats',
               'HreRem.view.configuracion.administracion.mediadores.detalle.OfertasVivasList'],
    
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.configuracion.mediadores.detail"));  
        
        me.items= [
	        			{	
	        				xtype: 'carteramediadorstats'
	        			},
	        			{	
	        				xtype: 'ofertasvivaslist'
	        			}
        ];
        
        me.callParent(); 

        
    }


});

