Ext.define('HreRem.view.dashboard.activosCalientes.ActivosCalientesPanel', {
    extend		: 'HreRem.view.common.PanelBase',
    xtype		: 'activoscalientespanel',
    cls			: 'panel-base shadow-panel taskmeter-main',
	title: 'Activos en Curso',

	selModel: {
	    selType: 'rowmodel',
	    mode   : 'MULTI'
	}, 
	
	viewModel: {
        type: 'activoscalientesmodel'
    },
    controller: {
        type: 'activoscalientescontroller'
    },
	


    items: [
        
        
        {
			xtype: 'activoscalienteswidget'
		}
    ]
});