Ext.define('HreRem.view.activos.comercial.ofertas.condiciones.economicas.CondicionesJuridicasModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.condicionesjuridicas',
       
    stores: {
    	
    		licencias: {
    			
		    	model: 'HreRem.model.Licencias',
		    	proxy: {
			        type: 'ajax',
			        url: $AC.getJsonDataPath() + 'licencias.json',
			        reader: {
			             type: 'json',
			             rootProperty: 'licencias'
			        }
		    	},
		    	autoLoad: true,
		    	filters: [{
	                property: 'idOferta',
	                value: '{idOferta}'
	            }]
    		},
    		
    		saneamientos: {
    			
		    	model: 'HreRem.model.Saneamientos',
		    	proxy: {
			        type: 'ajax',
			        url: $AC.getJsonDataPath() + 'saneamientos.json',
			        reader: {
			             type: 'json',
			             rootProperty: 'saneamientos'
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