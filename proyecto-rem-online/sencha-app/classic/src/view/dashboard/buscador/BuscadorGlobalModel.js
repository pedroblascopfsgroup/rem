Ext.define('HreRem.view.dashboard.buscador.BuscadorGlobalModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.buscadorglobal',
    
    stores: {
    
    		entidadesBusqueda: {
    		
		    	data : [
		    			{"id": "00", "descripcion": "--"},
				        {"id": "01", "descripcion": "Activos"},
				        {"id": "02", "descripcion": "Ofertas"},
				        {"id": "03", "descripcion": "Solicitudes"},
				        {"id": "04", "descripcion": "Visitas"},
						{"id": "05", "descripcion": "Lotes"}
    			],
		    	autoLoad: true			
    		
    		},
    		camposBusqueda: {
    		
		    	data : [
		    			{"id": "00", "descripcion": "--"},
				        {"id": "01", "descripcion": "Id"},
				        {"id": "02", "descripcion": "Fecha Creación"},
				        {"id": "03", "descripcion": "Fecha  "}

    			],
		    	autoLoad: true			
    		
    		}
    }
    		
    		
    		
 
    
});