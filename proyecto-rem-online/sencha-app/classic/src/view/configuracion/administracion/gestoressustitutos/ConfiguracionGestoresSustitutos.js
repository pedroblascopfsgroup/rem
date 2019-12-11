Ext.define('HreRem.view.configuracion.administracion.gestoressustitutos.ConfiguracionGestoresSustitutos', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'configuraciongestoressustitutos',
    reference	: 'configuracionGestoresSustitutos',
    requires: ['HreRem.view.configuracion.administracion.gestoressustitutos.ConfiguracionGestoresSustitutosFiltros',
    	'HreRem.view.configuracion.administracion.gestoressustitutos.ConfiguracionGestoresSustitutosList'],
    layout : {
		type : 'vbox',
		align : 'stretch'
    },
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.configuracion.gestoressustitutos"));  
        
        me.items= [
	        			{	
	        				xtype: 'configuraciongestoressustitutosfiltros'
	        			}
						,
	        			{	
	        				xtype: 'configuraciongestoressustitutoslist',
	        				flex: 1
	        			}
        ];
        
        me.callParent(); 

        
    }


});
