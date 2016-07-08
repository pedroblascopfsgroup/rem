Ext.define('HreRem.view.activos.detalle.GestionActivo', {
    extend: 'Ext.form.Panel',
    xtype: 'gestionactivo',
    layout		: 'fit',
    requires: ['HreRem.view.trabajos.HistoricoPeticionesActivo', 'HreRem.view.trabajos.PresupuestoAsignadoActivo'],
    
    initComponent: function () {
    	
    	var me = this;
    	
    	var items = [
			
			{				
			    xtype		: 'tabpanel',
				cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
			    reference	: 'tabpanelgestionactivo',
			    layout: 'fit',
			    items: [
			    		
			    		{
			    			xtype: 'historicopeticionesactivo'
			    		},
			    		{
			    			xtype: 'presupuestoasignadosactivo',
			    			title: 'Presupuesto asignado al activo'
			    		}		    		
			     ]				
			}   	
			
    	];

    	me.setTitle(HreRem.i18n('title.gestion.activo'));
		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
    },
    
    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.down('tabpanel').getActiveTab().funcionRecargar();
    } 
    
});