Ext.define('HreRem.view.publicacion.PublicacionModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.publicaciones',
    
    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase',
    	'HreRem.model.BusquedaActivosPublicacion', 'HreRem.model.ConfiguracionPublicacionModel'],
    
    stores: {
    	
    	comboTipoActivo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposActivo'}
			}
		},
		
		comboSubtipoActivo: {
			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'subtiposActivo'}
				}
		},
		
		activospublicacion: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.BusquedaActivosPublicacion',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'activo/getActivosPublicacion',
			    actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
	    	},
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	    	listeners : {
	            beforeload : 'paramLoading'
	        }
		},
		
		configuracionpublicacion: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.ConfiguracionPublicacionModel',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'activo/getReglasPublicacionAutomatica',
			    actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
	    	}
		},
		
		comboEstadoPublicacion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosPublicacion'}
			}
			
		},
		
		comboEstadoPublicacionAlquiler: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosPublicacionAlquiler'}
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
		}
    }
});