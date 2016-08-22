//@define Ext.calendar.data.EventMappings
/**
 * @class Ext.calendar.data.EventMappings
 * A simple object that provides the field definitions for Event records so that they can
 * be easily overridden.
 *
 * To ensure the proper definition of Ext.calendar.data.EventModel the override should be
 * written like this:
 *
 *      Ext.define('MyApp.data.EventMappings', {
 *          override: 'Ext.calendar.data.EventMappings'
 *      },
 *      function () {
 *          // Update "this" (this === Ext.calendar.data.EventMappings)
 *      });
 */
Ext.ns('Ext.calendar.data');

 var today = Ext.Date.clearTime(new Date()), 
                makeDate = function(d, h, m, s) {
                    d = d * 86400;
                    h = (h || 0) * 3600;
                    m = (m || 0) * 60;
                    s = (s || 0);
                    return Ext.Date.add(today, Ext.Date.SECOND, d + h + m + s);
                };
                

Ext.calendar.data.EventMappings = {
    EventId: {
        name: 'EventId',
        mapping: 'idTarea',
        type: 'int'
    },
    Gestor: {
        name: 'gestor',
        mapping: 'gestor',
        type: 'string'
    },
    
    CalendarId: {
        name: 'CalendarId',
        mapping: 'idTarea',
        type: 'int',
        calculate : function(data) {				
				return 1;
			}
    },
    Title: {
        name: 'Title',
        mapping: 'nombreTarea',
        type: 'string'
    },
    FechaInicio: {
        name: 'FechaInicio',
        mapping: 'fechaInicio',
        type: 'string'
    },
    FechaFin: {
        name: 'FechaFin',
        mapping: 'fechaFin',
        type: 'string'
    },
    StartDate: {
        name: 'StartDate',
        mapping: 'start',
        type: 'date',
        dateFormat: 'c',
        calculate : function(data) {	


					// Si no viene informada la fecha, ponemos una por defecto
					if (data.FechaInicio == null || data.FechaInicio == "") {
						data.FechaInicio = '31/12/2099 00:00:00';
					}
					var fechaPartes = data.FechaInicio.split("/");
					var parteTres = fechaPartes[2].split(" ");
					var ano = parteTres[0];
					
					// Hora de inicio por defecto si no viene informada 
					if (parteTres[1] == null) {
						parteTres[1] = '09:00:00';
					}
					
					var horaPartes = parteTres[1].split(":");
					
					var fecha = new Date(ano, fechaPartes[1] - 1, fechaPartes[0], horaPartes[0], horaPartes[1], horaPartes[2]);

					return fecha;
                }
    },
    EndDate: {
        name: 'EndDate',
        mapping: 'end',
        type: 'date',
        dateFormat: 'c',
        calculate : function(data) {
        		
					// Si no viene informada la fecha, ponemos una por defecto
					if (data.FechaFin == null || data.FechaFin == "") {
						data.FechaFin = '31/12/1099 00:00:00';
					}
					var fechaPartes = data.FechaFin.split("/");
					var parteTres = fechaPartes[2].split(" ");
					var ano = parteTres[0];
					
					// Hora de fin por defecto si no viene informada 
					if (parteTres[1] == null) {
						parteTres[1] = '19:00:00';
					}
					
					var horaPartes = parteTres[1].split(":");
					
					var fecha = new Date(ano, fechaPartes[1] - 1, fechaPartes[0], horaPartes[0], horaPartes[1], horaPartes[2]);

                	/*var	makeDate = function(d, h, m, s) 
                		{
		                    d = d * 86400;
		                    h = (h || 0) * 3600;
		                    m = (m || 0) * 60;
		                    s = (s || 0);
	                    	return Ext.Date.add(fecha, Ext.Date.SECOND, d + h + m + s);
	                   		
                		};
					
					return makeDate(-7,-12);*/
					return fecha;
                }
        
    },
    Location: {
        name: 'Location',
        mapping: 'loc',
        type: 'string'
    },
    Notes: {
        name: 'Notes',
        mapping: 'tipoActuacion',
        type: 'string'
    },
    Url: {
        name: 'Url',
        mapping: 'url',
        type: 'string'
    },
    IsAllDay: {
        name: 'IsAllDay',
        mapping: 'ad',
        type: 'boolean'
    },
    Reminder: {
        name: 'Reminder',
        mapping: 'rem',
        type: 'string'
    },
    IsNew: {
        name: 'IsNew',
        mapping: 'n',
        type: 'boolean'
    }
   /*EventId: {
        name: 'idTarea',
        mapping: 'id',
        type: 'int'
    },
    CalendarId: {
        name: 1,
        mapping: 'cid',
        type: 'int'
    },
    Title: {
        name: 'nombreTarea',
        mapping: 'title',
        type: 'string'
    },
    StartDate: {
        name: this.makeDate(-7,-12),
        mapping: 'start',
        type: 'date',
        dateFormat: 'c'
    },
    EndDate: {
        name: makeDate(-7,-12), 
        mapping: 'end',
        type: 'date',
        dateFormat: 'c'
    },
    Location: {
        name: 'Location',
        mapping: 'loc',
        type: 'string'
    },
    Notes: {
        name: 'idTipoActuacion',
        mapping: 'notes',
        type: 'string'
    },
    Url: {
        name: 'Url',
        mapping: 'url',
        type: 'string'
    },
    IsAllDay: {
        name: true,
        mapping: 'ad',
        type: 'boolean'
    },
    Reminder: {
        name: 'Reminder',
        mapping: 'rem',
        type: 'string'
    },
    IsNew: {
        name: 'IsNew',
        mapping: 'n',
        type: 'boolean'
    }*/ 
};
