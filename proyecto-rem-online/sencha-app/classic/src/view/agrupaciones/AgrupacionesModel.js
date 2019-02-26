Ext.define('HreRem.view.agrupaciones.AgrupacionesModel', {
    extend: 'HreRem.view.common.DDViewModel',
    alias: 'viewmodel.agrupaciones',
    
    requires: ['HreRem.ux.data.Proxy', 'HreRem.model.Agrupaciones','HreRem.model.ComboBase'],
    
 	stores: {
        
        agrupaciones: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Agrupaciones',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/tareas.json',
		        remoteUrl: 'agrupacion/getListAgrupaciones'
	    	},
	    	autoLoad: true,
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	        listeners : {
	            beforeload : 'paramLoading'
	        }
    	},

    	comboTipoAgrupacion: {
			pageSize: 10,
	    	model: 'HreRem.model.Agrupaciones',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'agrupacion/getComboTipoAgrupacion'
	    	},
	    	autoLoad: true
    	},

    	comboTodosTipoAgrupacion: {
			pageSize: 10,
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getTodosComboTipoAgrupacion'
	    	},
	    	autoLoad: true
    	},
    	
    	comboTipoAlquilerAgrupaciones: {
			model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposAlquilerActivo'}
	    	}
    	},
    	
    	comboSubcarteraFiltered: {
			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubcartera'
				}
		}
        
    }
    
});