Ext.define('HreRem.view.activos.comercial.ofertas.propuestas.PropuestasModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.propuestas',
    
    requires:['HreRem.model.Propuestas'],
      
    stores: {
    	
    	propuestas: {
    			
		    	model: 'HreRem.model.Propuestas',
		    	proxy: {
			        type: 'ajax',
			        url: $AC.getJsonDataPath() + 'propuestas.json',
			        reader: {
			             type: 'json',
			             rootProperty: 'propuestas'
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