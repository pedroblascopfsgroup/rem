Ext.define('HreRem.view.comercial.ComercialModel', {
    extend: 'HreRem.view.common.DDViewModel',
    alias: 'viewmodel.comercial',
    requires: ['HreRem.ux.data.Proxy', 'HreRem.model.Visitas','HreRem.model.Ofertas'],
    
    stores: {
    	
    	visitasComercial: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Visitas',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/visitasdetalle.json',
		        remoteUrl: 'visitas/getListVisitasDetalle'
	    	},
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	        listeners : {
	            beforeload : 'paramLoading'
	        }
    	},
    	
    	ofertasComercial: {
    		pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Ofertas',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/ofertas.json',
		        remoteUrl: 'ofertas/getListOfertas'
	    	},
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	        listeners : {
	            beforeload : 'paramLoading'
	        }
    	},
    	
    	comboTipoOferta: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'tiposOfertas'}
					}
    	},
    	comboEstadoOferta: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'estadosOfertas'}
					}
    	}
    		
    }
});