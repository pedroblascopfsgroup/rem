Ext.define('HreRem.view.precios.PreciosModel', {
    extend: 'HreRem.view.common.DDViewModel',
    alias: 'viewmodel.precios',
    
    stores: {
    	
    	
    		activos: {
			    pageSize: $AC.getDefaultPageSize(),
		    	proxy: {
			        type: 'uxproxy',
			        remoteUrl: 'precios/getActivos',
			        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
		    	},
		    	remoteSort: true,
		    	remoteFilter: true,
		    	listeners : {
		            beforeload : 'beforeLoadActivos'
		        }
    		},
    		
    		    	
    		propuestas: {
			    pageSize: $AC.getDefaultPageSize(),
		    	proxy: {
			        type: 'uxproxy',
			        remoteUrl: 'precios/getPropuestas',
			        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
		    	},
		    	remoteSort: true,
		    	remoteFilter: true,
		    	listeners : {
		            beforeload : 'beforeLoadPropuestas'
		        }
		        
    		},
			
			comboTipoTitulo: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposTitulo'}
				}
    		}, 
    		
    		comboSubtipoTitulo: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'subtiposTitulo'}
				}
    		},
    		
    		activosPropuesta: {    
       		 	pageSize: $AC.getDefaultPageSize(),
	       		proxy: {
			        type: 'uxproxy',
			        remoteUrl: 'precios/getActivosByPropuesta',
			        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
		    	},
		    	remoteSort: true,
		    	remoteFilter: true,
		    	listeners : {
		            beforeload : 'beforeLoadActivosByPropuesta'
		        }
       		},
    		
    		numActivosByTipoPrecio: {
    			
    			pageSize: $AC.getDefaultPageSize(),
    	    	proxy: {
    		        type: 'uxproxy',
    		        remoteUrl: 'precios/getNumActivosByTipoPrecio',
    			    actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
    	    	},
    	    	session: true,
    	    	remoteSort: true,
    	    	remoteFilter: true
    		},
    		
    		numActivosByTipoPrecioAmpliada: {
    			
    			pageSize: $AC.getDefaultPageSize(),
    	    	proxy: {
    		        type: 'uxproxy',
    		        remoteUrl: 'precios/getNumActivosByTipoPrecioAmpliada',
    			    actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
    	    	},
    	    	session: true,
    	    	remoteSort: true,
    	    	remoteFilter: true
    		},

    		comboActivoPropietario: {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboEspecial',
					extraParams: {diccionario: 'DDPropietario'}
				}
    		}
    }
});