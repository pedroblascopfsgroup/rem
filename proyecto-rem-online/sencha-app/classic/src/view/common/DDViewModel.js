Ext.define('HreRem.view.common.DDViewModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ddviewmodel',

    stores: {
    	
    		comboFiltroProvincias: {
    	   		source: 'provincias',
    	   		loadSource: true
    		},
    		
    	   	comboEntidadPropietaria: {
    	   		source: 'entidadPropietaria',
    	   		loadSource: true
    		},
    		
    		comboEstadosPropuesta: {
    			source: 'estadosPropuesta',
    	   		loadSource: true    			
    		}
    	
			
     }    
});