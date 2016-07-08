var me = this;
//debugger;
me.agendaItems= {
	    	
	model: 'HreRem.model.Tarea',
	proxy: {
        type: 'ajax',
        url: $AC.getJsonDataPath() + 'tareas.json',
        reader: {
             type: 'json',
             rootProperty: 'evts'
        }
	},
	autoLoad: true
	/*sorters: [{
        property: 'diasVencidaNumber',
        direction: 'ASC'
    }],
	filters: [
        function(rec) {
  			return (!Ext.isEmpty(rec.get("fechaInicio")) && Ext.isEmpty(rec.get("fechaFin")));
  			
		},
		{
            property: 'gestor',
            value: '{currentUser}'
        }]*/
};
// This is an example calendar store that enables event color-coding
me.calendarStore = Ext.create('Ext.calendar.data.MemoryCalendarStore', {
    data: Ext.calendar.data.Calendars.getData()
   // data: me.agendaItems
});

// A sample event store that loads static JSON from a local file. Obviously a real
// implementation would likely be loading remote data via an HttpProxy, but the
// underlying store functionality is the same.
me.eventStore = Ext.create('Ext.calendar.data.MemoryEventStore', {
	//data: me.agendaItems.getData()
    data: Ext.calendar.data.Events.getData()
});
        
Ext.define('HreRem.view.dashboard.calendario.CalendarMainWidget', {
    extend		: 'HreRem.view.common.PanelBase',
    xtype		: 'calendariomainwidget',
    title		: 'Calendario',
	cls			: 'panel-base shadow-panel calendar-widget',
	layout		: 'card', 
	activeItem	: 0,
	
	controller : 'calendariocontroller',
				
		
	items : [{
				xtype : 'calendarmain',
				columnWidth : 1,
				eventStore : this.eventStore,
				calendarStore : this.calendarStore,
				border : false,
				//id : 'app-calendar',
				region : 'center',
				activeItem : 3, // month view

				monthViewCfg : {
					showHeader : true,
					showWeekLinks : true,
					showWeekNumbers : true
				}
			}]
});