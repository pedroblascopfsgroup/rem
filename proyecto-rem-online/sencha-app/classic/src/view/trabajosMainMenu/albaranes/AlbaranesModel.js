Ext.define('HreRem.view.trabajosMainMenu.albaranes.AlbaranesModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.albaranes',
    
    requires: ['HreRem.ux.data.Proxy', 'HreRem.model.AlbaranGridModel','HreRem.model.DetalleAlbaranGridModel','HreRem.model.DetalleAlbaranGridModel'],
    
 	stores: {
        
        albaranes: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.AlbaranGridModel',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/albaran.json',
				remoteUrl: 'albaran/findAll',
				actionMethods: {read: 'POST'}
	    	},	    		
	    	remoteSort: true,
	    	remoteFilter: true,	    	
	    	autoLoad: false,
	        listeners : {
	            beforeload : 'paramLoading'	        
	        }
    	},
    	detalleAlbaranes: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.DetalleAlbaranGridModel',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/albaran.json',
				remoteUrl: 'albaran/findAllDetalles',
				actionMethods: {read: 'POST'}
	    	},	    		
	    	remoteSort: true,
	    	remoteFilter: true,	    	
	    	autoLoad: false
//	        listeners : {
//	            beforeload : 'paramLoading'	        
//	        }
    	},
    	detallePrefactrura: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.DetallePrefacturaGridModel',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/albaran.json',
				remoteUrl: 'albaran/findPrefectura',
				actionMethods: {read: 'POST'}
	    	},	    		
	    	remoteSort: true,
	    	remoteFilter: true,	    	
	    	autoLoad: false
//	        listeners : {
//	            beforeload : 'paramLoading'	        
//	        }
    	},
    	comboEstadoAlbaran: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'albaran/getComboEstadoAlbaran'
			}
    	},
    	comboEstadoPrefactura: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'albaran/getComboEstadoPrefactura'
			}
		},
		
		filtroComboEstadoTrabajo: {    		
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'albaran/getComboEstadoTrabajo'
			}
    	},
		
		comboTipologiaTrabajo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
    			extraParams: {diccionario: 'tiposTrabajo'}
			}
		},
		
		comboApiPrimario: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getComboApiPrimario'
			},
		    displayField: 'nombre',
			valueField: 'id'				
		}
  	
 	}
    
});