Ext.define('HreRem.view.agrupaciones.AgrupacionesModel', {
    extend: 'HreRem.view.common.DDViewModel',
    alias: 'viewmodel.agrupaciones',

    requires: ['HreRem.model.BusquedaAgrupacionGrid'],

    
 	stores: {
        
        agrupaciones: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.BusquedaAgrupacionGrid',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'agrupacion/getBusquedaAgrupacionesGrid'
	    	},
	    	autoLoad: false,
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	        listeners : {
	            beforeload : 'paramLoading'
	        }
    	},
    	
    	comboTipoAgrupacionFiltro: {		
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'agrupacion/getComboTipoAgrupacionFiltro'
	    	}	    	
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
		},
		
		comboSubcartera: {
		model: 'HreRem.model.ComboBase',
		proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'subentidadesPropietarias'}
			}
		}
		
        
    }
    
});