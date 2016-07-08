Ext.define('HreRem.view.dashboard.actuaciones.DashboardActuacionesModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.dashboardactuacionesmodel',
       
    stores: {
    	
    		dashboardactuaciones: {
    			
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
	                property: 'gestor',
	                value: '{currentUser}'
	   	    	}]
    		}
	    	
     }
 
    
});