Ext.define('HreRem.view.activos.actuaciones.ActuacionesModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.actuacionesold',
       
    stores: {
    	
    		actuaciones: {
    			
		    	model: 'HreRem.model.Actuacion',
		    	proxy: {
			        type: 'ajax',
			        url: $AC.getJsonDataPath() + 'actuaciones.json',
			        reader: {
			             type: 'json',
			             rootProperty: 'actuaciones'
			        }
		    	},
		    	autoLoad: true,
		    	filters: [{
	                property: 'idActivo',
	                value: '{idActivo}'
	            },
	            {
	                property: 'gestor',
	                value: '{currentUser}'
	   	    	}]
    		}
	    	
     }
 
    
});