Ext.define('HreRem.view.administracion.AdministracionModel', {
    extend: 'HreRem.view.common.DDViewModel',
    alias: 'viewmodel.administracion',
    requires: ['HreRem.ux.data.Proxy','HreRem.model.Gasto', 'HreRem.model.Provision'],
    
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
    	},
    	
    	provisiones: {
    		pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Provision',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/provision.json',
		        remoteUrl: 'provisiongastos/findAll'
	    	},
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	        listeners : {
	            beforeload : 'paramLoadingProvisiones'
	        }
    		
    	},
    	
    	provisionGastos: {
    		pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Gasto',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/provision.json',
		        remoteUrl: 'gasto/getListGastos',
		        extraParams: {idProvision: '{provisionSeleccionada.id}'}
	    	}
    		
    	},
    	
    	comboEstadosProvision: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosProvision'}
			}   
    	}
    	
    		
    }
});