Ext.define('HreRem.view.configuracion.administracion.proveedores.detalle.ProveedorDetalleModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.proveedordetalle',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.DireccionesDelegacionesModel',
                'HreRem.model.PersonasContactoModel', 'HreRem.model.ActivosIntegradosModel', 'HreRem.model.AdjuntoProveedor',
                'HreRem.model.ComboLocalidadBase', 'HreRem.view.common.adjuntos.AdjuntarDocumentoProveedor'],
    
    data: {
    	proveedor: null
    },
    
    stores: {
    	comboEstadoProveedor: {
			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadoProveedor'}
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
					remoteUrl: 'generic/getDiccionarioSubtipoProveedor',
					extraParams: {codigoTipoProveedor: '{proveedor.tipoProveedorCodigo}'}
				}
		},
		comboTipoPersona: {
			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tipoPersona'}
				}
		},
		comboTipoActivosCartera: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoActivosCartera'}
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
		},
		comboCalificacionProveedor: {
			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'calificacionProveedor'}
    			}
		},
		comboResultadoProcesoBlanqueo: {
			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'resultadoProcesoBlanqueo'}
    			}
		},
		comboMotivoRetencionPago: {
			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'motivoRetencionPago'}
    			}
		},
		comboTerritorial: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'provincias'}
			},
			autoLoad: true
		},
		direccionesDelegaciones: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.DireccionesDelegacionesModel',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'proveedores/getDireccionesDelegacionesByProveedor',
				extraParams: {id: '{proveedor.id}'}
			},
			autoLoad: true
		},
		personasContacto: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.PersonasContactoModel',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'proveedores/getPersonasContactoByProveedor',
				extraParams: {id: '{proveedor.id}'}
			},
			autoLoad: true
		},
		activosIntegrados: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.ActivosIntegradosModel',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'proveedores/getActivosIntegradosByProveedor',
				extraParams: {id: '{proveedor.id}'}
			},
			autoLoad: true
		},
		comboTipoDireccionProveedor: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoDireccionProveedor'}
			},
			autoLoad: true
		},
		comboColCargo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'cargoProveedor'}
			},
			autoLoad: true
		},
		storeDocumentosProveedor: {
			 pageSize: $AC.getDefaultPageSize(),
			 model: 'HreRem.model.AdjuntoProveedor',
     	     proxy: {
     	        type: 'uxproxy',
     	        remoteUrl: 'proveedores/getListAdjuntos',
     	        extraParams: {id: '{proveedor.id}'}
         	 },
         	 groupField: 'descripcionTipo'
		},
		comboOperativa: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'operativa'}
			}
		},
		comboTipoDocumento: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposDocumentos'}
			}
		}
    }
    
});