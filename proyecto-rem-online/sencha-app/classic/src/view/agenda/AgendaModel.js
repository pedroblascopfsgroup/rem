Ext.define('HreRem.view.agenda.AgendaModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.agenda',
    
    requires: ['HreRem.ux.data.Proxy', 'HreRem.model.Tarea'],
    
 	stores: {
        
        tareas: {
    				pageSize: $AC.getDefaultPageSize(),
			    	model: 'HreRem.model.Tarea',
			    	proxy: {
				        type: 'uxproxy',
				        localUrl: '/tareas.json',
				        remoteUrl: 'agenda/getListTareas',
					    actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
			    	},
			    	//autoLoad: true,
			    	session: true,
			    	remoteSort: true,
			    	remoteFilter: true,
			    	sorters: [{
			            property: 'fechaVenc',
			            direction: 'ASC'
			        }],
			        listeners : {
			            beforeload : 'paramLoading'
			        }
    	},
    	tareasalertas: {
					pageSize: 10,
					model: 'HreRem.model.Tarea',
					proxy: {
				        type: 'uxproxy',
				        localUrl: '/tareas.json',
				        remoteUrl: 'agenda/getListTareas',
					    actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
					},
					//autoLoad: true,
					session: true,
					remoteSort: true,
					remoteFilter: true,
					//extraParams: {nombreTarea:'Anotacion'},
					sorters: [{
			            property: 'fechaVenc',
			            direction: 'ASC'
				    }],
				    listeners : {
				        beforeload : 'paramLoadingAlertas'
				    }
		},
		tareasavisos: {
			pageSize: 10,
			model: 'HreRem.model.Tarea',
			proxy: {
		        type: 'uxproxy',
		        localUrl: '/tareas.json',
		        remoteUrl: 'agenda/getListTareas',
			    actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
			},
			//autoLoad: true,
			session: true,
			remoteSort: true,
			remoteFilter: true,
			//extraParams: {nombreTarea:'Anotacion'},
			sorters: [{
		        property: 'fechaInicio',
		        direction: 'DESC'
		    }],
		    listeners : {
		        beforeload : 'paramLoadingAvisos'
		    }
		},
		comboTipoTramite: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'agenda/getTiposProcedimientoAgenda'
			}
		},
		comboNombreTarea: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'agenda/getComboNombreTarea',
				extraParams: {idTipoTramite: '{descripcionTarea.selection.id}'}
			}
		}
        
    }
    
});