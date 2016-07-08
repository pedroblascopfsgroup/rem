Ext.define('HreRem.view.agenda.AgendaMain', {
    extend: 'Ext.container.Container',
    xtype: 'agendamain',
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
			}/*,
			{
				xtype : 'agendanotificacion',
				reference : 'agendanotificacion'
			}*//*,{
				xtype : 'agendacardwidget',
				reference : 'agendacardwidget',
				flex: 1
			}*/
			,{
				xtype : 'agendalist',
				reference : 'agendalist',
				flex: 1
			}
	],
	
	initComponent: function() {
		
		var me = this;
		
		me.on({activate: me.refresh});
		me.callParent();
	},
	
	refresh: function() {
		
		var me = this;
		
		if(me.refreshOnActivate)  {
			me.down('agendalist').getStore().load();
			me.refreshOnActivate = false;
		}
	
	}
				

});

