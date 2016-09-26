Ext.define('HreRem.view.administracion.AdministracionModel', {
    extend: 'HreRem.view.common.DDViewModel',
    alias: 'viewmodel.administracion',
    requires: ['HreRem.ux.data.Proxy','HreRem.model.Gasto'],
    
    stores: {
    	
    	gastosAdministracion: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Gasto',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/gasto.json',
		        remoteUrl: 'gasto/getListGastos'
	    	},
	    	autoLoad: true,
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	        listeners : {
	            beforeload : 'paramLoading'
	        }
    	}
    	
//    	visitasComercial: {
//			pageSize: $AC.getDefaultPageSize(),
//	    	model: 'HreRem.model.Visitas',
//	    	proxy: {
//		        type: 'uxproxy',
//		        localUrl: '/visitas.json',
//		        remoteUrl: 'visitas/getListVisitas'
//	    	},
//	    	autoLoad: true,
//	    	session: true,
//	    	remoteSort: true,
//	    	remoteFilter: true,
//	        listeners : {
//	            beforeload : 'paramLoading'
//	        }
//    	},
//    	
//    	ofertasComercial: {
//    		pageSize: $AC.getDefaultPageSize(),
//	    	model: 'HreRem.model.Ofertas',
//	    	proxy: {
//		        type: 'uxproxy',
//		        localUrl: '/ofertas.json',
//		        remoteUrl: 'ofertas/getListOfertas'
//	    	},
//	    	autoLoad: true,
//	    	session: true,
//	    	remoteSort: true,
//	    	remoteFilter: true,
//	        listeners : {
//	            beforeload : 'paramLoading'
//	        }
//    	},
//    	
//    	comboTipoOferta: {
//				model: 'HreRem.model.ComboBase',
//					proxy: {
//						type: 'uxproxy',
//						remoteUrl: 'generic/getDiccionario',
//						extraParams: {diccionario: 'tiposOfertas'}
//					}
//    	},
//    	comboEstadoOferta: {
//				model: 'HreRem.model.ComboBase',
//					proxy: {
//						type: 'uxproxy',
//						remoteUrl: 'generic/getDiccionario',
//						extraParams: {diccionario: 'estadosOfertas'}
//					}
//    	}
    		
    }
});