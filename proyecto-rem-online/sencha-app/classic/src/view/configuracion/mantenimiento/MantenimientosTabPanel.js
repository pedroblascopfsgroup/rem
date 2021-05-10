Ext.define('HreRem.view.configuracion.mantenimiento.MantenimientosTabPanel', {
	extend		: 'Ext.tab.Panel',
    xtype		: 'mantenimientostabpanel',
	cls			: 'panel-base shadow-panel, tabPanel-segundo-nivel',
    requires: ['HreRem.view.configuracion.mantenimiento.tiposmantenimiento.MantenimientoPrincipalList',
               'HreRem.view.configuracion.mantenimiento.tiposmantenimiento.MantenimientoPrincipalFiltros',
               'HreRem.view.configuracion.mantenimiento.MantenimientosController',
			   'HreRem.view.configuracion.mantenimiento.MantenimientosModel'],
	listeners	: {
		boxready: function (tabPanel) {
			if(tabPanel.items.length > 0 && tabPanel.items.items.length > 0) {
				var tab = tabPanel.items.items[0];
				tabPanel.setActiveTab(tab);
			}
		}
	},         
    controller: 'mantenimientoscontroller',
    viewModel: {
        type: 'mantenimientosmodel'
    },
    
    
    initComponent: function () {
        
        var me = this;
        
		var items= [];
		
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'mantenimientoprincipal', reference: 'mantenimientoprincipal'})}, ['TAB_MEDIADORES']);
		
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent(); 
        
    }
});

