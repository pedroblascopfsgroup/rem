Ext.define('HreRem.view.dashboard.graficas.pieTareasSupervisor.PieTareasSupervisorModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.pietareassupervisormodel',
    reference: 'pietareassupervisormodel',
    
    stores: {

    	tareasAbiertasCerradas: {
			
	    	model: 'HreRem.model.TareasAbiertasCerradas',
	    	proxy: {
		        type: 'ajax',
		        url: $AC.getJsonDataPath() + 'tareasAbiertasCerradasPorGestorPie.json',
		        reader: {
		             type: 'json',
		             rootProperty: 'tareas'
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