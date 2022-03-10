Ext.define('HreRem.view.administracion.AdministracionModel', {
    extend: 'HreRem.view.common.DDViewModel',
    alias: 'viewmodel.administracion',
    requires: ['HreRem.ux.data.Proxy','HreRem.model.Gasto', 'HreRem.model.Provision', 'HreRem.model.ActivoJuntaPropietarios', 'HreRem.model.ComboBase', 'HreRem.model.JuntasPropietarios', 
    	'HreRem.model.TipoDocumentoExpediente', 'HreRem.model.AdjuntoJuntas', 'HreRem.model.Activo', 'HreRem.model.Plusvalia'],

    data: {
    	junta: null
    },
    stores: {

    	gastosAdministracion: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Gasto',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/gasto.json',
		        remoteUrl: 'gastosproveedor/getListGastos'
	    	},
	    	//autoLoad: true,
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	        listeners : {
	            beforeload : 'paramLoading'
	        }
    	},    	

    	plusvaliaAdministracion: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Plusvalia',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/plusvalia.json',
		        remoteUrl: 'activo/getListPlusvalia'
	    	},
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	        listeners : {
	            beforeload : 'paramLoading'
	        }
    	},

    	juntas: {
    		pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.JuntasPropietarios',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/activojuntapropietarios.json',
		        remoteUrl: 'activojuntapropietarios/getListJuntas'
	    	},
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,	    		       
	    	listeners : {
	            beforeload : 'paramLoadingJuntas'
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
		        remoteUrl: 'gastosproveedor/getListGastosProvision',
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
				remoteUrl: 'generic/getComboGestoriasGasto'
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
    comboMotivosAviso: {
      model: 'HreRem.model.ComboBase',
    proxy: {
        type: 'uxproxy',
        remoteUrl: 'generic/getDiccionario',
        extraParams: {diccionario: 'motivosAvisoGasto'}
      }
    },
	comboSiNoJuntas: {
		data : [
	        {"codigo":"1", "descripcion":"Si"},
	        {"codigo":"2", "descripcion":"No"}
	    ]
	},
	
	// STORE PESTA�A DOCUMENTOS TIPO DE JUNTA
    	comboTipoDocumento: {
			model: 'HreRem.model.ComboBase',
	    	proxy: {
	    		type: 'uxproxy', 
	    		remoteUrl: 'generic/getDiccionario',
	    		extraParams: {diccionario: 'tipoDocJunta'}
	    		
	    	},
	    	autoLoad: false,
    		sorters: 'descripcion'
    	},
    	
	storeActivos: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.JuntasPropietarios',
	    	proxy: {
	    		type: 'uxproxy', 
	    		remoteUrl: 'activojuntapropietarios/getActivosJuntas',
	    		extraParams: {idJunta: '{junta.id}'}
	    	},
	    	autoLoad: false
    	},

	
	storeDocumentosJuntas: {
		 pageSize: $AC.getDefaultPageSize(),
		 model: 'HreRem.model.JuntasPropietarios',
 	     proxy: {
 	        type: 'uxproxy',
 	        remoteUrl: 'activojuntapropietarios/getListAdjuntos',
 	        extraParams: {idJunta: '{junta.id}'}
     	 },
     	 groupField: 'descripcionTipo'
	},
	
	comboSubtipoGastoFiltered: {
		model: 'HreRem.model.ComboBase',
		proxy: {
			type: 'uxproxy',
			remoteUrl: 'generic/getComboSubtipoGastoFiltered'
		}
	}

  }

});
