Ext.define('HreRem.view.comercial.visitas.VisitasComercialMain', {
	extend		: 'Ext.panel.Panel',
    xtype		: 'visitascomercialmain',
    requires	: ['HreRem.view.comercial.visitas.VisitasComercialSearch','HreRem.view.comercial.visitas.VisitasComercialList','HreRem.view.comercial.ComercialVisitasController'],
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    
        controller: 'comercialvisitas',
    viewModel: {
        type: 'comercial'
    },

    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n('title.comercial.visitas'));
        
        me.items = [
		        	{	
        				xtype: 'visitascomercialsearch',
        				reference: 'visitasComercialSearch'
        			},
        			{	
		        		xtype: 'visitascomerciallist',
						reference: 'visitasComercialList',
						flex: 1
		        	}
        
        ];
        
        me.callParent(); 

        
    }


});

