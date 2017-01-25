Ext.define('HreRem.view.precios.PreciosModel', {
    extend	: 'HreRem.view.common.DDViewModel',
    alias	: 'viewmodel.precios',
    requires: ['HreRem.model.ConfiguracionGeneracionPropuestasModel'],
    stores	: {
    	
    	
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
			    sorters: [{ property: 'fechaEmision', direction: 'DESC' }],
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

    		configuracionGeneracionPropuestas: {
    			pageSize: $AC.getDefaultPageSize(),
    			model: 'HreRem.model.ConfiguracionGeneracionPropuestasModel',
    	    	proxy: {
    		        type: 'uxproxy',
    		        remoteUrl: 'precios/getConfiguracionGeneracionPropuestas',
    			    actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
    	    	}
    		},

    		comboCartera: {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'entidadesPropietarias'}
				},
				autoLoad: true
    		},

    		comboTipoPropuestaPrecio: {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tipoPropuestaPrecio'}
				},
				autoLoad: true
    		},

    		comboIndicadorCondicionPrecioFiltered: {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getIndicadorCondicionPrecioFiltered'
				}
    		},

    		comboIndicadorCondicionPrecio: {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'indicadorCondicionPrecio'}
				},
				autoLoad: true
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