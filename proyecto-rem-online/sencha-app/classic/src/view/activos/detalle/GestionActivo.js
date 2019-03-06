Ext.define('HreRem.view.activos.detalle.GestionActivo', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'gestionactivo',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    reference	: 'gestionactivo',
    layout		: 'fit',
    requires	: ['HreRem.view.trabajos.HistoricoPeticionesActivo', 'HreRem.view.trabajos.PresupuestoAsignadoActivo'],

    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.gestion.activo'));
        var items = [];
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'historicopeticionesactivo'})}, ['TAB_HIST_PETICIONES']);
    	$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'presupuestoasignadosactivo', title: HreRem.i18n('title.presupuesto.asignado.activo')})}, ['TAB_PRESUPUESTO_ASIGNADO_ACTIVO']);
    	me.addPlugin({ptype: 'lazyitems', items: items });
		me.callParent();
    },

    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.getActiveTab().funcionRecargar();
    }
});