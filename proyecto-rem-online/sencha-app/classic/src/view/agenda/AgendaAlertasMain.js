Ext.define('HreRem.view.agenda.AgendaAlertasMain', {
    extend: 'Ext.container.Container',
    xtype: 'agendaalertasmain',
    layout : {
					type : 'vbox',
					align : 'stretch'
	},
    
        
    requires: [
        'HreRem.view.agenda.AgendaController',
        'HreRem.view.agenda.AgendaModel',
        'HreRem.view.agenda.AgendaAlertasSearch',
        'HreRem.view.agenda.AgendaCardWidget'

    ],
    

    controller: 'agenda',
    viewModel: {
        type: 'agenda'
    },  



	items : [{
				xtype : 'agendaalertassearch',
				reference : 'agendaalertassearch'
			}
			,{
				xtype : 'agendaalertaslist',
				reference : 'agendaalertaslist',
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
			me.down('agendaalertaslist').getStore().load();
			me.refreshOnActivate = false;
		}
	
	}	

});

