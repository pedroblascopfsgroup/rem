Ext.define('HreRem.view.activos.comercial.visitas.VisitasModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.visitasold',
       
    data: {
    	idActivo: null    
    },
    
    stores: {
    		
    		visitas: {
    			
			    	model: 'HreRem.model.Visita',
			    	proxy: {
				        type: 'ajax',
				        url: $AC.getJsonDataPath() + 'visitas.json',
				        reader: {
				             type: 'json',
				             rootProperty: 'visitas'
				        }
			    	},
			    	
			    	filters:[{idActivo:'{idActivo}'}],
			    	autoLoad: true
    		}
	    	
     }
 
    
});