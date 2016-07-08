Ext.define('HreRem.view.dashboard.graficas.histogramTareasSupervisor.HistogramTareasSupervisorModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.histogramtareassupervisormodel',
    reference: 'histogramtareassupervisormodel',
    
    stores: {

    	tareasAbiertasCerradas: {
			
	    	model: 'HreRem.model.TareasAbiertasCerradas',
	    	proxy: {
		        type: 'ajax',
		        url: $AC.getJsonDataPath() + 'tareasAbiertasCerradasPorGestor.json',
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