Ext.define('HreRem.view.configuracion.mantenimiento.tiposmantenimiento.MantenimientoPrincipal', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'mantenimientoprincipal',
    reference	: 'mantenimientoprincipalref',    
    cls	: 'panel-base shadow-panel',
    scrollable: 'y',

    requires: ['HreRem.view.configuracion.mantenimiento.tiposmantenimiento.MantenimientoPrincipalList',
               'HreRem.view.configuracion.mantenimiento.tiposmantenimiento.MantenimientoPrincipalFiltros'],
               
    controller: 'mantenimientoscontroller',
    viewModel: {        
        type: 'mantenimientosmodel'
    },

    
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.mantenimiento.seguridad.ream"));
		
		me.items= [
			{
    			xtype: 'mantenimientoprincipalfiltros'			    
			},
			{	
				xtype: 'mantenimientoprincipallist'						
			}
			
			
		];
        
        
        me.callParent(); 
        
    }
});

