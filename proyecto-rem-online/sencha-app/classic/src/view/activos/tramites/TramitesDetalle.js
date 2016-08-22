Ext.define('HreRem.view.activos.tramites.TramitesDetalle', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'tramitesdetalle',
	iconCls		: 'ico-pestana-activos',
	iconAlign	: 'left',
	    width: '100%',
    height: '100%',
	layout: {
        type: 'vbox',
        align: 'stretch'
    },
    requires : ['HreRem.view.activos.tramites.TramiteDetalleController', 'HreRem.view.activos.tramites.TramiteDetalleModel','HreRem.view.activos.tramites.TramitesActivo', 
			'HreRem.view.activos.tramites.DatosGeneralesTramite','HreRem.view.activos.tramites.CabeceraTramite','HreRem.view.activos.tramites.TramitesDetalleTab',
			'HreRem.view.activos.tramites.TareasList','HreRem.view.activos.tramites.HistoricoTareasList'],

    controller: 'tramitedetalle',
    viewModel: {
        type: 'tramitedetalle'
    },
    items: [	
    		{ 
    			xtype: 'cabeceratramite'
    		},
    		{
		    	xtype: 'tramitesdetalletab',
		    	flex: 3
		    }
    ]
    
});