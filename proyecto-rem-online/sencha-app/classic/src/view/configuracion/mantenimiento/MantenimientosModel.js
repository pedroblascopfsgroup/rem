Ext.define('HreRem.view.configuracion.mantenimiento.MantenimientosModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.mantenimientosmodel',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 
    			'HreRem.view.configuracion.mantenimiento.tiposmantenimiento.MantenimientoPrincipal',
               'HreRem.view.configuracion.mantenimiento.tiposmantenimiento.MantenimientoPrincipalList',
               'HreRem.view.configuracion.mantenimiento.tiposmantenimiento.MantenimientoPrincipalFiltros',
               'HreRem.model.MantenimientoGridModel'], 
    
    data: {
    	proveedor: null
    },
    
    stores: {
    	listaMantenimiento: {    
   		 	pageSize: $AC.getDefaultPageSize(),
   		 	model: 'HreRem.model.MantenimientoGridModel',
       		proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'configuracion/getListMantenimiento',
		        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
	    	},
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	    	listeners : {
	            beforeload : 'paramLoading'
	        }
   		},
		comboCartera: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'entidadesPropietarias'}
			}
		},
    		
		comboSubcartera: {
			model: 'HreRem.model.ComboBase',
			proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'subentidadesPropietarias'}
			}
		},
		comboPropietario: {
			model: 'HreRem.model.ComboBase',
			proxy: {				
					type: 'uxproxy',
					remoteUrl: 'configuracion/getPropietariosByCartera'
			}
		},
		comboSubcarteraFilter: {
			model: 'HreRem.model.ComboBase',
			proxy: {				
					type: 'uxproxy',
					remoteUrl: 'configuracion/getSubcarteraFilterByCartera'
			}
		}
    }
    
});