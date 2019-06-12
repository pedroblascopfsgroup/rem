Ext.define('HreRem.view.configuracion.ConfiguracionModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.configuracion',
    requires: ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.Proveedor', 'HreRem.model.Perfil', 'HreRem.model.ComboMunicipio'],

    stores: { 
//    	comboFiltroMunicipios: {
//	   		source: 'municipios',
//	   		loadSource: true
//		},      	
		configuracionproveedores: {    
   		 	pageSize: $AC.getDefaultPageSize(),
   		 	model: 'HreRem.model.Proveedor',
       		proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'proveedores/getProveedores',
		        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
	    	},
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	    	listeners : {
	            beforeload : 'paramLoadingProveedores'
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
// No localizo las subcarteras
//		comboSubcartera: {
//			model: 'HreRem.model.ComboBase',
//				proxy: {
//					type: 'uxproxy',
//					remoteUrl: 'generic/getDiccionario',
//					extraParams: {diccionario: 'subcartera'}
//				}
//		},
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
		}
		
// No es un diccionario, son todos los nombres de los contactos del provedor seleccionado
//		comboContacto: {
//			model: 'HreRem.model.ComboBase',
//			proxy: {
//				type: 'uxproxy',
//				remoteUrl: 'generic/getDiccionario',
//				extraParams: {diccionario: 'contacto'}
//			}
//		}
    }
});