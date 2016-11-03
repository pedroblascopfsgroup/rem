Ext.define('HreRem.view.configuracion.administracion.mediadores.ConfiguracionMediadores', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'configuracionmediadores',
    reference	: 'configuracionMediadores',
    scrollable: 'y',
    requires: ['HreRem.view.configuracion.administracion.mediadores.ConfiguracionMediadoresFiltros',
               'HreRem.view.configuracion.administracion.mediadores.ConfiguracionMediadoresList'],
    
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.configuracion.mediadores"));  
        
        me.items= [
	        			{	
	        				xtype: 'configuracionmediadoresfiltros'
	        			},
	        			{	
	        				xtype: 'configuracionmediadoreslist'
	        			},
	        			{	
	        				xtype: 'configuracionmediadoresdetail'
	        			}
        ];
        
        me.callParent(); 

        
    }


});

