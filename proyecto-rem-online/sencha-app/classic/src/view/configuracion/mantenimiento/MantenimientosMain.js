Ext.define('HreRem.view.configuracion.mantenimiento.MantenimientosMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'mantenimientosmain',
    reference	: 'mantenimientosmainref',
    requires: ['HreRem.view.configuracion.mantenimiento.tiposmantenimiento.MantenimientoPrincipalList',
               'HreRem.view.configuracion.mantenimiento.tiposmantenimiento.MantenimientoPrincipalFiltros',
               'HreRem.view.configuracion.mantenimiento.MantenimientosController',
			   'HreRem.view.configuracion.mantenimiento.MantenimientosModel',
			   'HreRem.view.configuracion.mantenimiento.MantenimientosTabPanel'],
			   
    controller: 'mantenimientoscontroller',
    viewModel: {
        type: 'mantenimientosmodel'
    },
    
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.mantenimiento"));
		
		me.items= [
			
			{	
				xtype: 'mantenimientostabpanel',
				flex: 1
			}
		];
		
        me.callParent(); 
        
    }


});

