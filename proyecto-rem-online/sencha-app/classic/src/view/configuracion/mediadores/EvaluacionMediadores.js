Ext.define('HreRem.view.configuracion.mediadores.EvaluacionMediadores', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'evaluacionmediadores',
    reference	: 'evaluacionMediadores',
    scrollable: 'y',
    requires: ['HreRem.view.configuracion.mediadores.EvaluacionMediadoresFiltros',
               'HreRem.view.configuracion.mediadores.EvaluacionMediadoresList',
               'HreRem.view.configuracion.mediadores.EvaluacionMediadoresDetail',
               'HreRem.view.configuracion.mediadores.EvaluacionMediadoresController',
			   'HreRem.view.configuracion.mediadores.EvaluacionMediadoresModel'],
               
    controller: 'evaluacionmediadores',
    viewModel: {
        type: 'evaluacionmediadoresmodel'
    },
    
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.evaluacion.mediadores"));
		
		var items= [
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
						xtype: 'evaluacionmediadoresfiltros',
						flex: 0.3
					},
					{	
						xtype: 'evaluacionmediadoreslist',
						addUxReadOnlyEditFieldPlugin: false
					}
				]
			},
			{
			    xtype: 'splitter',
			    cls: 'x-splitter-base',
			    collapsible: true
			},
			{	
				xtype: 'evaluacionmediadoresdetail',
				addUxReadOnlyEditFieldPlugin: false,
				collapsed: true,
				scrollable: 'y'
			}
		];
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent(); 
        
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().loadPage(1);
  		});
    } 


});

