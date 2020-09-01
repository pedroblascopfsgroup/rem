Ext.define('HreRem.view.trabajosMainMenu.albaranes.AlbaranesModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.albaranes',
    
    requires: ['HreRem.ux.data.Proxy', 'HreRem.model.AlbaranGridModel','HreRem.model.DetalleAlbaranGridModel','HreRem.model.DetallePrefacturaGridModel'],
    
    data: {
    	albaran: null,
    	prefactura: null
    },
 	stores: {
        
        albaranes: {
			pageSize: 10,
	    	model: 'HreRem.model.AlbaranGridModel',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/albaran.json',
				remoteUrl: 'albaran/findAll',
				timeout: 300000,
				actionMethods: {read: 'POST'}
	    	},
	    	remoteSort: true,
	    	remoteFilter: true,	    	
	    	//autoLoad: false,
	        listeners : {
	            beforeload : 'paramLoading'	        
	        }
    	},
    	detalleAlbaranes: {
			pageSize: 10,
	    	model: 'HreRem.model.DetalleAlbaranGridModel',
	    	proxy: {
		        type: 'uxproxy',
		        timeout: 300000,
				remoteUrl: 'albaran/findAllDetalles',
//				extraParams: {numAlbaran: '{albaran.numAlbaran}'}
				actionMethods: {read: 'POST'}
	    	},
	    	remoteSort: true,
	    	remoteFilter: true,
	    	session: true
//	    	autoLoad: false
//	        listeners : {
//	            beforeload : 'paramLoading'	        
//	        }
    	},
    	detallePrefactrura: {
			pageSize: 10,
	    	model: 'HreRem.model.DetallePrefacturaGridModel',
	    	proxy: {
		        type: 'uxproxy',
		        timeout: 300000,
				remoteUrl: 'albaran/findPrefectura',
//				extraParams: {numPrefactura: '{prefactura.numPrefactura}'}
				actionMethods: {read: 'POST'}
	    	},	
	    	remoteSort: true,
	    	remoteFilter: true,
	    	session: true,
//	    	autoLoad: false
	        listeners : {
	            load : 'changeCheckbox'	        
	        }
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
				remoteUrl: 'albaran/getProveedores'
			},
		    displayField: 'descripcion',
			valueField: 'id'				
		}
  	
 	}
    
});