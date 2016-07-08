Ext.define('HreRem.view.agenda.AgendaAvisosMain', {
    extend: 'Ext.container.Container',
    xtype: 'agendaavisosmain',
    layout : {
					type : 'vbox',
					align : 'stretch'
	},
    
        
    requires: [
        'HreRem.view.agenda.AgendaController',
        'HreRem.view.agenda.AgendaModel',
        'HreRem.view.agenda.AgendaAvisosSearch',
        'HreRem.view.agenda.AgendaCardWidget'

    ],
    

    controller: 'agenda',
    viewModel: {
        type: 'agenda'
    },  



	items : [{
				xtype : 'agendaavisossearch',
				reference : 'agendaavisossearch'
			}
			,{
				xtype : 'agendaavisoslist',
				reference : 'agendaavisoslist',
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
			me.down('agendaavisoslist').getStore().load();
			me.refreshOnActivate = false;
		}
	
	}	

});

