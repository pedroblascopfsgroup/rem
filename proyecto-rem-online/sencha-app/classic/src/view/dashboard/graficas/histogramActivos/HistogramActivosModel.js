Ext.define('HreRem.view.dashboard.graficas.histogramActivos.HistogramActivosModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.histogramactivosmodel',
    reference: 'histogramactivosmodel',
    
    stores: {
    		
    	activosvendidos: {
			
	    	model: 'HreRem.model.ActivosVendidos',
	    	proxy: {
		        type: 'ajax',
		        url: $AC.getJsonDataPath() + 'activosVendidos.json',
		        reader: {
		             type: 'json',
		             rootProperty: 'activosvendidos'
		        }
	    	},
	    	autoLoad: true
	    	
	 	}
	      
    }
    		
});