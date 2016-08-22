Ext.define('HreRem.view.activos.comercial.ofertas.OfertantesModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ofertantes',
    
    requires:['HreRem.model.Ofertantes'],
      
    stores: {
    	
    	ofertantes: {
    			
		    	model: 'HreRem.model.Ofertantes',
		    	proxy: {
			        type: 'ajax',
			        url: $AC.getJsonDataPath() + 'ofertantes.json',
			        reader: {
			             type: 'json',
			             rootProperty: 'ofertantes'
			        }
		    	},
		    	autoLoad: true,
		    	filters: [{
	                property: 'idOferta',
	                value: '{idOferta}'
	            }]
    		}
	    	
     }
 
    
});