Ext.define('HreRem.view.publicacion.PublicacionModel', {
    extend: 'HreRem.view.common.DDViewModel',
    alias: 'viewmodel.publicaciones',
    
    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase'],
    
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
		
		comboEstadoPublicacion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosPublicacion'}
			}
			
		}
		
		
		
    }
});