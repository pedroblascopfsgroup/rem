Ext.define('HreRem.view.configuracion.ConfiguracionModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.configuracion',
    requires: ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.Proveedor', 'HreRem.model.Perfil', 'HreRem.model.ComboMunicipio','HreRem.model.GestorSustituto',
					'HreRem.model.Testigo', 'HreRem.model.ConfigRecomendacion'],

    stores: { 
//    	comboFiltroMunicipios: {
//	   		source: 'municipios',
//	   		loadSource: true
//		},   
    	comboUsuariosGestorSustituto: {
	   		source: 'usuariosgestorsustituto',
	   		loadSource: true
		},
		
		configuracionproveedores: {    
   		 	pageSize: $AC.getDefaultPageSize(),
   		 	model: 'HreRem.model.Proveedor',
       		proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'proveedores/getProveedores',
		        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
	    	},
			autoLoad: false,
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	    	listeners : {
	            beforeload : 'paramLoadingProveedores'
	        }
   		},
   		configuraciongestoressustitutos: {
   			pageSize: $AC.getDefaultPageSize(),
   		 	model: 'HreRem.model.GestorSustituto',
       		proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'gestorsustituto/getGestoresSustitutos',
		        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
	    	},
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	    	listeners : {
	            beforeload : 'paramLoadingGestoresSustitutos'
	        }
   		},
   		configuracionperfiles: {    
   		 	pageSize: $AC.getDefaultPageSize(),
   		 	model: 'HreRem.model.Perfil',
       		proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'perfil/getPerfiles',
	        	actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
	    	},
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	    	listeners : {
	            beforeload : 'paramLoadingPerfiles'
	        }
   		},
   		configuraciontestigosobligatorios: {    
   		 	pageSize: $AC.getDefaultPageSize(),
   		 	model: 'HreRem.model.Testigo',
       		proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'testigos/getTestigosObligatorios',
		        actionMethods: {create: 'POST', read: 'GET', update: 'POST', destroy: 'POST'}
	    	},
			autoLoad: true,
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true
		},
		configuracionrecomendacion: {    
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.ConfigRecomendacion',
		   	proxy: {
				type: 'uxproxy',
				remoteUrl: 'recomendacion/getConfiguracionRecomendacion'
			},
			autoLoad: true,
			session: true,
			remoteSort: true,
			remoteFilter: true
	   	},
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
				},
				autoload: true
		},
		comboNewSubtipoProveedor: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionarioSubtipoProveedor'
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
		comboCartera: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'entidadesPropietarias'}
			},
			autoLoad: true
		},
// No es un diccionario, la clase es: ActivoPropietario
//		comboPropietario: {
//			model: 'HreRem.model.ComboBase',
//				proxy: {
//					type: 'uxproxy',
//					remoteUrl: 'generic/getDiccionario',
//					extraParams: {diccionario: 'propietario'}
//				}
//		},
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
			},
			autoLoad: true
		},
		comboProvincia: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'provincias'}
			}   	
    	},
		comboMunicipio: {
			model: 'HreRem.model.ComboMunicipio',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'municipio'}
			}
		},
		comboCalificacionProveedor: {
			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'calificacionProveedor'}
    			}
		},
		
// No es un diccionario, son todos los nombres de los contactos del provedor seleccionado
//		comboContacto: {
//			model: 'HreRem.model.ComboBase',
//			proxy: {
//				type: 'uxproxy',
//				remoteUrl: 'generic/getDiccionario',
//				extraParams: {diccionario: 'contacto'}
//			}
//		}
		
		comboTiposComercializacion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposComercializacionActivo'}
			},
			autoLoad: true
		},
		comboEquipoGestion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposEquipoGestion'}
			},
			autoLoad: true
		},
		comboSinSino: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'DDSiNo'}
			},
			autoLoad: true
		},
		comboRecomendacionRCDC: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'recomendacionRCDC'}
			},
			autoLoad: true
		},
		comboLineaDeNegocio: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposComercializacionActivo'}
			}
		},						
		comboEspecialidad: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'especialidad'}
			}
		}	
    }
});