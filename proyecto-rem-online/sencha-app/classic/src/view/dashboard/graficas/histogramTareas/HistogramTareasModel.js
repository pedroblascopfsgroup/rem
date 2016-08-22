Ext.define('HreRem.view.dashboard.graficas.histogramTareas.HistogramTareasModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.histogramtareasmodel',
    reference: 'histogramtareasmodel',
    
    stores: {

    	tareasAbiertasCerradas: {
			
	    	model: 'HreRem.model.TareasAbiertasCerradas',
	    	proxy: {
		        type: 'ajax',
		        url: $AC.getJsonDataPath() + 'tareasAbiertasCerradas.json',
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