Ext.define('HreRem.view.agenda.AgendaCardWidget', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'agendacardwidget',
	layout		: 'card', 
	activeItem	: 0,
	//width		: '335px !important',
	//controller 	: 'agenda',
	
	requires: ['HreRem.view.agenda.AgendaList','HreRem.view.agenda.AgendaNotificacionList', 'HreRem.view.agenda.AgendaAlertasList','HreRem.view.agenda.AgendaAvisosList'],
	
	initComponent: function () {
	
		var me = this;

		me.items = [
			
			
			/*{
				xtype: 'calendariomainwidget',
				columnWidth: 0.5,
				height: 500
			},*/
			{
				xtype : 'agendalist'
			}
		];

		me.callParent();
		
	}	
});