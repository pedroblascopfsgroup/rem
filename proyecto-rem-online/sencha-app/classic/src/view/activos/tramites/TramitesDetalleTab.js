Ext.define('HreRem.view.activos.tramites.TramitesDetalleTab', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'tramitesdetalletab',
	cls			: 'panel-base shadow-panel, tabPanel-segundo-nivel',
	//iconCls		: 'ico-pestana-activos',
	iconAlign	: 'left',
	flex: 1,
	layout		: 'fit',
    requires : ['HreRem.view.activos.tramites.TramitesActivo','HreRem.view.activos.tramites.DatosGeneralesTramite','HreRem.view.activos.tramites.TareasModel',
				'HreRem.view.activos.tramites.TareasList','HreRem.view.activos.tramites.HistoricoTareasList','HreRem.model.ActivoTramite', 'HreRem.view.tramites.ActivosTramite'],

    items: [				
		    				
		    		{xtype: 'datosgeneralestramite'},
		    		{xtype: 'tareaslist'},
		    		{xtype: 'historicotareaslist'},
		    		{xtype: 'activostramite'}
    ]
        
});