Ext.define('HreRem.view.comercial.ofertas.OfertasComercialMain', {
	extend		: 'Ext.panel.Panel',
    xtype		: 'ofertascomercialmain',
    requires	: ['HreRem.view.comercial.ofertas.OfertasComercialSearch','HreRem.view.comercial.ofertas.OfertasComercialList','HreRem.view.comercial.ComercialOfertasController'],
    layout		: {
        type: 'vbox',
        align: 'stretch'
    },
    controller	: 'comercialofertas',
    viewModel	: {
        type: 'comercial'
    },
    refreshOnActivate : false,
    listeners	: {
		 activate: function(){this.refresh()}
	},

    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.comercial.ofertas'));

        me.items = [
        		{	
        			xtype: 'ofertascomercialsearch',
        			reference: 'ofertasComercialSearch'
        		},
        		{	
        			xtype: 'ofertascomerciallist',
        			reference: 'ofertasComercialList'
        		}
        ];

        me.callParent(); 
    },

    refresh: function() {						
		var me = this;
		if(me.refreshOnActivate)  {
			me.down('ofertascomerciallist').getStore().loadPage(1);
			me.refreshOnActivate = false;
		}
    }
});

