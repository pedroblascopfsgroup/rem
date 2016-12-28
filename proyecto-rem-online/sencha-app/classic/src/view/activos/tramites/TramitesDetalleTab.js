Ext.define('HreRem.view.activos.tramites.TramitesDetalleTab', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'tramitesdetalletab',
	cls			: 'panel-base shadow-panel, tabPanel-segundo-nivel',
	iconAlign	: 'left',
	flex		: 1,
	layout		: 'fit',
    requires 	: ['HreRem.view.activos.tramites.TramitesActivo','HreRem.view.activos.tramites.DatosGeneralesTramite','HreRem.view.activos.tramites.TareasModel',
				'HreRem.view.activos.tramites.TareasList','HreRem.view.activos.tramites.HistoricoTareasList','HreRem.model.ActivoTramite', 'HreRem.view.tramites.ActivosTramite'],

	initComponent: function () {
       var me = this;

       var items = [];
       $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'datosgeneralestramite'})}, ['TAB_DATOS_GENERALES_TRAMITE']);
       $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'tareaslist'})}, ['TAB_TAREAS_TRAMITE']);
       $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'historicotareaslist'})}, ['TAB_HISTORICO_TAREAS_TRAMITE']);
       $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'activostramite'})}, ['TAB_ACTIVOS_TRAMITE']);

       me.addPlugin({ptype: 'lazyitems', items: items});
       me.callParent();
	}
});