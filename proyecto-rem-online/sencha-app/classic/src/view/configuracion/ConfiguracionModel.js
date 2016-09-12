Ext.define('HreRem.view.configuracion.ConfiguracionModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.configuracion',
    requires: ['HreRem.model.Proveedor'],

    stores: { 
    	
		configuracionproveedores: {    
   		 	pageSize: $AC.getDefaultPageSize(),
   		 	model: 'HreRem.model.Proveedor',
       		proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'proveedores/getProveedores',
		        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
	    	},
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
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'subtipoProveedor'}
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
				}
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
// Hay que definirlo
//		comboAmbito: {
//			model: 'HreRem.model.ComboBase',
//				proxy: {
//					type: 'uxproxy',
//					remoteUrl: 'generic/getDiccionario',
//					extraParams: {diccionario: 'ambito'}
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
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'municipio'}
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
    }
});