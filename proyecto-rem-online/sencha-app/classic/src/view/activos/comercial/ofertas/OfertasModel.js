Ext.define('HreRem.view.activos.comercial.ofertas.OfertasModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ofertasold',
    
    requires:['HreRem.model.Oferta'],
      
    stores: {
    	
    	ofertas: {
    			
		    	model: 'HreRem.model.Oferta',
		    	proxy: {
			        type: 'ajax',
			        url: $AC.getJsonDataPath() + 'ofertas.json',
			        reader: {
			             type: 'json',
			             rootProperty: 'ofertas'
			        }
		    	},
		    	autoLoad: true,
		    	filters: [{
	                property: 'idActivo',
	                value: '{idActivo}'
	            }]
    		}
	    	
     }
 
    
});