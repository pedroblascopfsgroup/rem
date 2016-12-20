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
		        remoteUrl: 'gastosproveedor/getListGastos'
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
		        remoteUrl: 'gastosproveedor/getListGastos',
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
    	},
    	
    	comboEstadoAutorizacionHaya: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosAutorizacionHaya'}
			}
    	},
    	
    	comboEstadoAutorizacionPropietario: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosAutorizacionPropietario'}
			}
    	},
    	
    	comboTipoGasto: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposGasto'}
			}		
    		
    	},
    	
    	comboSubtipoGasto: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'subtiposGasto'}
			}		
    		
    	},
    	
    	comboPeriodicidad: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoPeriocidad'}
			}   
    	},
    	
    	comboDestinatarios: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'destinatariosGasto'}
			}   
    	},
    	
    	estadosGasto: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadoGasto'}
			}   
			
    	},
    	
    	comboTipoProveedor: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoProveedor'}
			}
		},
		
		comboSubtipoProveedor: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'subtipoProveedor'}
			}
		},
		
		comboEntidadPropietaria: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'entidadesPropietarias'}
			}
		},
		
		comboSubentidadPropietaria: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'subentidadesPropietarias'}
			}
		},
		
		comboGestorias: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getGestoriasGasto'
			}		
		}
    }
	    
});