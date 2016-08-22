Ext.define('HreRem.view.dashboard.visitas.DashboardVisitasModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.dashboardvisitasmodel',
       
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
			    	autoLoad: true
    		}
	    	
     }
 
    
});