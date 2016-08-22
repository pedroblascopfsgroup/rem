Ext.define('HreRem.view.precios.historico.HistoricoPropuestasMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'historicopropuestasmain',
    requires	: ['HreRem.view.precios.historico.HistoricoPropuestasSearch', 'HreRem.view.precios.historico.HistoricoPropuestasList',
    				'HreRem.view.precios.historico.HistoricoPropuestaActivosList'],
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    initComponent: function () {        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.historico.propuestas.precios"));
        
        var items = [
        			{
        				xtype: 'container',
        				flex:1,
        				scrollable: 'y',
        				layout: {
        					type: 'vbox',
        					align: 'stretch'
        				},
        				items: [
		        			{	
		        				xtype: 'historicopropuestassearch',
		        				collapsible: true,
		        				reference: 'historicoPropuestasSearch'
		        			},
		        			{	
		        				xtype: 'historicopropuestaslist',
								reference: 'historicoPropuestasList',
								flex: 1
		        			}
		        		]
        			},
        			{
				        xtype: 'splitter',
				        cls: 'x-splitter-base',
				        collapsible: true
				       
				    },
        			{	
						xtype: 'historicopropuestaactivoslist',
						reference: 'historicoPropuestaActivosList',
						collapsed: true,
						scrollable: 'y',
						flex: 1
        			}
        
        
        
        
        
        
        ];
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent(); 
        
    }


});

