Ext.define('HreRem.view.dashboard.activosCalientes.ActivosCalientesModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.activoscalientesmodel',
    
    requires:['HreRem.model.ActivoCaliente'],
      
    stores: {
    	
    	activoscalientes: {
    			
		    	model: 'HreRem.model.ActivoCaliente',
		    	proxy: {
			        type: 'ajax',
			        url: $AC.getJsonDataPath() + 'activosCalientes.json',
			        reader: {
			             type: 'json',
			             rootProperty: 'activoscalientes'
			        }
		    	},
		    	autoLoad: true,
		    	filters: [{
	                property: 'perfilActual',
	                value: '{currentUser}'
	            }]
    		},
     
    	activoscalientesimagenes: {
			
	    	model: 'HreRem.model.ActivoCaliente',
	    	proxy: {
		        type: 'ajax',
		        url: $AC.getJsonDataPath() + 'activosCalientes.json',
		        reader: {
		             type: 'json',
		             rootProperty: 'activoscalientes'
		        }
	    	},
	    	autoLoad: true,
	    	filters: [{
             property: 'perfilActual',
             value: '{currentUser}'
	    	}]
	 	}
	    	
    } 
    
});