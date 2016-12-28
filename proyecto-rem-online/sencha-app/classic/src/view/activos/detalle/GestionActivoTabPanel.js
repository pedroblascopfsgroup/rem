Ext.define('HreRem.view.activos.detalle.GestionActivoTabPanel', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'gestionactivotabpanel',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    reference	: 'tabpanelgestionactivo',
    layout		: 'fit',
    requires	: ['HreRem.view.trabajos.HistoricoPeticionesActivo', 'HreRem.view.trabajos.PresupuestoAsignadoActivo'],

    initComponent: function () {
        var me = this;

        me.items = [];
        $AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'historicopeticionesactivo'})}, ['TAB_HIST_PETICIONES']);
    	$AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'presupuestoasignadosactivo', title: HreRem.i18n('title.presupuesto.asignado.activo')})}, ['TAB_PRESUPUESTO_ASIGNADO_ACTIVO']);

		me.callParent();
    }
});