Ext.define('HreRem.view.activos.comercial.ofertas.condiciones.economicas.ComisionesModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.comisiones',
       
    stores: {
    	
    	comisiones: {
    			
		    	model: 'HreRem.model.Comision',
		    	proxy: {
			        type: 'ajax',
			        url: $AC.getJsonDataPath() + 'comisiones.json',
			        reader: {
			             type: 'json',
			             rootProperty: 'comisiones'
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