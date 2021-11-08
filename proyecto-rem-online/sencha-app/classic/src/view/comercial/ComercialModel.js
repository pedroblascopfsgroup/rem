Ext.define('HreRem.view.comercial.ComercialModel', {
    extend: 'HreRem.view.common.DDViewModel',
    alias: 'viewmodel.comercial',
    requires: ['HreRem.ux.data.Proxy', 'HreRem.model.Visitas', 'HreRem.model.BusquedaOfertaGrid'],
    
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
    	comboTipoGestorOfertas: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboTipoGestorOfertas'
			}
		},
		comboUsuarios: {
			model: 'HreRem.model.ComboBase',
			proxy: {
			type: 'uxproxy',
			remoteUrl: 'activo/getComboUsuarios',
			extraParams: {idTipoGestor: '{tipoGestor.selection.id}'}
			},
			autoLoad: false,
			remoteFilter: false,
			remoteSort: false
		}, 
		comboUsuariosGestoria: {
			model: 'HreRem.model.ComboBase',
			proxy: {
			type: 'uxproxy',
			autoLoad: false,
			remoteFilter: false,
			remoteSort: false,
			remoteUrl: 'activo/getComboUsuariosGestoria'
			}
		}, 
    	ofertasComercial: {
    		pageSize: $AC.getDefaultPageSize(),
    		model: 'HreRem.model.BusquedaOfertaGrid',
	    	proxy: {
	    		type: 'uxproxy',		 
	    		remoteUrl: 'ofertas/getBusquedaOfertasGrid' 
	    	},
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	        listeners : {
	            beforeload : 'paramLoading',
	            load: 'controlErrorOfertas'
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
    	},
    	comboEstadoExpediente: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosExpediente'}
			}
    	},
    	comboEstadoExpedienteVentas: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'expedientecomercial/getEstadoExpedienteComercial',
				extraParams: {esVenta: CONST.ES_VENTA["SI"]}
			}
    	},
    	comboEstadoExpedienteAlquileres: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'expedientecomercial/getEstadoExpedienteComercial',
				extraParams: {esVenta: CONST.ES_VENTA["NO"]}
			}
    	},
    	comboTiposComercializarActivo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposComercializarActivo'}
			}
    	},
    	comboClaseActivo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'claseActivoBancario'}
			}
    	},    	
    	comboTiposFechaOfertas: {
	    	data : [
				        {"codigo":"01", "descripcion": "Fecha de alta"},
				        {"codigo":"02", "descripcion": "Fecha de firma reserva"},
						/*{"codigo":"03", "descripcion": "Fecha de posicionamiento"},*/
						{"codigo":"04", "descripcion": "Fecha entrada CRM/SF"},
				        {"codigo":"05", "descripcion": "Fecha de oferta pendiente"}
			]		
	    		
    	},
    	
		comboCanalOferta: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'ofertas/getDiccionarioSubtipoProveedorCanal'
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
		
		comboSubcarteraFiltered: {
			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubcartera'
				}
		}
    		
    }
});