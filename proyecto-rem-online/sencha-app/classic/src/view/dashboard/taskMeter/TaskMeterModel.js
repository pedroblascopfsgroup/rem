Ext.define('HreRem.view.dashboard.taskMeter.TaskMeterModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.taskmetermodel',
    reference: 'taskmetermodel',
    
    stores: {

		agrupacionTareas: {
			
			model: 'HreRem.model.AgrupacionTareas',
			proxy: {
		        type: 'ajax',
		        url: $AC.getJsonDataPath() + 'agrupacionTareas.json',
		        reader: {
		             type: 'json',
		             rootProperty: 'agrupaciontareas'
		        }
			},
			autoLoad: true,
			filters: [{
		        property: 'gestor',
		        value: '{currentUser}'
		   	}]
		}	      
    }

    
});