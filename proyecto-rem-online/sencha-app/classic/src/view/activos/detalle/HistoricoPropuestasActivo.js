Ext.define('HreRem.view.activo.detalle.HistoricoPropuestasActivo', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'historicopropuestasactivo',
    requires	: ['HreRem.view.precios.historico.HistoricoPropuestasSearch', 'HreRem.view.precios.historico.HistoricoPropuestasList'],
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    initComponent: function () {        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.historico.propuestas.precios"));
        
        var items = [
        			
        			{	
        				xtype: 'historicopropuestassearch',
        				collapsible: true,
        				reference: 'historicoPropuestasActivoSearch'
        			},
        			{	
        				xtype: 'historicopropuestaslist'        			
        			}
        
        ];
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent(); 
        
    }


});

