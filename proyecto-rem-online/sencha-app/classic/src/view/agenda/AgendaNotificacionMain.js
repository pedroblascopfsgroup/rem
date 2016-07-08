Ext.define('HreRem.view.agenda.AgendaNotificacionMain', {
    extend: 'Ext.container.Container',
    xtype: 'agendanotificacionmain',
    layout : {
					type : 'vbox',
					align : 'stretch'
	},
    
        
    requires: [
        'HreRem.view.agenda.AgendaController',
        'HreRem.view.agenda.AgendaModel',
        'HreRem.view.agenda.AgendaSearch',
        'HreRem.view.agenda.AgendaCardWidget'

    ],
    

    controller: 'agenda',
    viewModel: {
        type: 'agenda'
    },  



	items : [{
				xtype : 'agendasearch',
				reference : 'agendasearch'
			}
			,{
				xtype : 'agendanotificacionlist',
				reference : 'agendanotificacionlist',
				flex: 1
			}
	]	

});

