Ext.define('HreRem.view.activos.ActivosModel', {
    extend: 'HreRem.view.common.DDViewModel',
    alias: 'viewmodel.activos',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.BusquedaActivo', 'HreRem.model.ComboBase', 'HreRem.model.Gestor', 'HreRem.model.Tramite' ],

    data: {	
    },
    
    stores: {
    		
    		activos: {
    				
    				pageSize: $AC.getDefaultPageSize(),
			    	model: 'HreRem.model.BusquedaActivo',
			    	proxy: {
				        type: 'uxproxy',
				        localUrl: '/activos.json',
				        remoteUrl: 'activo/getActivos',
					    actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
			    	},
			    	session: true,
			    	remoteSort: true,
			    	remoteFilter: true,
			    	listeners : {
			            beforeload : 'paramLoading'
			        }

    		},

    		comboTipoTitulo: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'tiposTitulo'}
					}
    		},
    		    		
    		comboTipoUsoDestino: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'tiposUsoDestino'}
					}
    		},
    		
    		comboPais: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'paises'}
				}
    		},
    		
    		comboTipoVia: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposVia'}
				}
    		},

    		comboFiltroSubtipoActivo: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'subtiposActivo'}
					}
    		},
    		
    		comboEstadoActivo: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'estadosActivo'}
					}
    		},
    		
    		comboSiNoRem: {
			data : [
		        {"codigo":"1", "descripcion":eval(String.fromCharCode(34,83,237,34))},
		        {"codigo":"0", "descripcion":"No"}
		    ]
		}
	
     }

});