Ext.define('HreRem.view.dashboard.DashboardVisitasPanel', {
    extend: 'Ext.container.Container',
    xtype: 'dashboardvisitaspanel',
    reference: 'dashboardvisitaspanel',
    layout : {
					type : 'vbox',
					align : 'stretch'
				},
        
    requires: [
        'HreRem.view.agenda.AgendaList'    
    ],

	items : [{
				xtype : 'dashboardvisitaslist',
				reference : 'dashboardvisitaslist'						
			}]				

});