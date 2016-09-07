Ext.define('HreRem.view.expedientes.ExpedienteDetalleModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.expedientedetalle',
    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.TextosOferta', 'HreRem.model.ActivosExpediente', 
                'HreRem.model.EntregaReserva', 'HreRem.model.ObservacionesExpediente', 'HreRem.model.AdjuntoExpedienteComercial',
                'HreRem.model.Posicionamiento', 'HreRem.model.ComparecienteVendedor', 'HreRem.model.Subsanacion', 'HreRem.model.Notario',
                'HreRem.model.ComparecienteBusqueda'],
    
    data: {
    	expediente: null
    },
    
    formulas: {   
	
	     
	     getSrcCartera: function(get) {
	     	
	     	var cartera = get('expediente.entidadPropietariaDescripcion');
	     	
	     	if(!Ext.isEmpty(cartera)) {
	     		return 'resources/images/logo_'+cartera.toLowerCase()+'.svg'	     		
	     	} else {
	     		return '';
	     	}

	     },
	     
	     getTipoExpedienteCabecera: function(get) {
	     
	     	var tipoExpedidenteDescripcion =  get('expediente.tipoExpedienteDescripcion');
	     	var idAgrupacion = get('expediente.idAgrupacion');
			var numEntidad = get('expediente.numEntidad');
			var descEntidad = Ext.isEmpty(idAgrupacion) ? ' Activo ' : ' Agrupación '
			
			return tipoExpedidenteDescripcion + descEntidad + numEntidad;
	     
	     },
	     
	     esImpuestoMayorQueCero: function(get){
	     	var impuesto= get('condiciones.impuestos');
	     	if(impuesto > 0){
	     		return true;
	     	}
	     	return false;
	     	
	     },
	     
	     esComunidadesMayorQueCero: function(get){
	     	var comunidades= get('condiciones.comunidades');
	     	if(comunidades > 0){
	     		return true;
	     	}
	     	return false;
	     	
	     },
	     
	     onEstaSujetoTanteo: function(get){
	     	var sujeto= get('condiciones.sujetoTramiteTanteo');
	     	if(sujeto==1){
	     		return true;
	     	}
	     	return false;
	     }
	 },

    stores: {
    	

    	storeTextosOferta: {    
    		 pageSize: $AC.getDefaultPageSize(),
    		 model: 'HreRem.model.TextosOferta',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getListTextosOfertaById',
		        extraParams: {id: '{expediente.id}'}
	    	 }
    	},
    	
    	storeEntregasACuenta: {    
    		 pageSize: $AC.getDefaultPageSize(),
    		 model: 'HreRem.model.EntregaReserva',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getListEntregasReserva',
		        extraParams: {id: '{expediente.id}'}
	    	 }
    	},
    	
    	comboEstadosVisitaOferta: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosVisitaOferta'}
			}   
    		
    	},
    	
    	comboTiposArras: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposArras'}
			}   
    		
    	},
    	
    	comboEstadosFinanciacion: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosFinanciacion'}
			}   
    	},
    	
    	comboEntidadesFinancieras: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'entidadesFinancieras'}
			}   
    	},
    	
    	comboTipoCalculo: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposCalculo'}
			}   
    	},
    	
    	comboTiposPorCuenta: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposPorCuenta'}
			}   
    	},
    	
    	comboTiposPorCuentaPrueba: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposPorCuenta'}
			}   
    	},
    	
    	comboTiposImpuesto: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposImpuestos'}
			}   
    	},
    	
    	comboSituacionTitulo: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosTitulo'}
			}   
    	},
    	
    	comboSituacionPosesoria: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'situacionesPosesoria'}
			}   
    	},
storeObservaciones: {
			
    		pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.ObservacionesExpediente',
	    	proxy: {
	    		type: 'uxproxy',
	    		remoteUrl: 'expedientecomercial/getObservaciones',
	    		extraParams: {idExpediente: '{expediente.id}'}
	    	}
    	},

    	storeActivosExpediente: {
    		pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.ActivosExpediente',
	    	proxy: {
	    		type: 'uxproxy',
	    		remoteUrl: 'expedientecomercial/getActivosExpediente',
	    		extraParams: {idExpediente: '{expediente.id}'}
	    	}
    	},

    	storeDocumentosExpediente: {
			 pageSize: $AC.getDefaultPageSize(),
			 model: 'HreRem.model.AdjuntoExpedienteComercial',
      	     proxy: {
      	        type: 'uxproxy',
      	        remoteUrl: 'expedientecomercial/getListAdjuntos',
      	        extraParams: {idExpediente: '{expediente.id}'}
          	 },
          	 groupField: 'descripcionTipo'
		},
		
		tareasTramiteExpediente: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.TareaList',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getTramitesTareas',
		        extraParams: {idExpediente: '{expediente.id}'},
		        rootProperty: 'tramite.tareas'
	    	}

		},
		
		storePosicionamientos: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Posicionamiento',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getPosicionamientosExpediente',
		        extraParams: {idExpediente: '{expediente.id}'}
	    	}
		},
		
		storeSubsanaciones: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Subsanacion',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getSubsanacionesExpediente',
		        extraParams: {idExpediente: '{expediente.id}'}
	    	}
		},
		
		storeNotarios: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Notario',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getNotariosExpediente',
		        extraParams: {idExpediente: '{expediente.id}'}
	    	}
		}
		
//		COMPARECIENTES EN NOMBRE DEL VENDEDOR
		
//		storeComparecientes: {
//			pageSize: $AC.getDefaultPageSize(),
//	    	model: 'HreRem.model.ComparecienteVendedor',
//	    	proxy: {
//		        type: 'uxproxy',
//		        remoteUrl: 'expedientecomercial/getComparecientesExpediente',
//		        extraParams: {idExpediente: '{expediente.id}'}
//	    	}
//		},
//		
//		comboTipoCompareciente: {
//			model: 'HreRem.model.ComboBase',
//			proxy: {
//				type: 'uxproxy',
//				remoteUrl: 'generic/getDiccionario',
//				extraParams: {diccionario: 'tiposComparecientes'}
//			} 
//		},
//		
//		storeBusquedaComparecientes: {
//    		pageSize: $AC.getDefaultPageSize(),
//	    	model: 'HreRem.model.ComparecienteBusqueda',
//	    	proxy: {
//		        type: 'uxproxy',
//		        localUrl: '/busquedacomparecientes.json',
//		        remoteUrl: 'expedientecomercial/getComparecientesBusqueda'
//	    	},
//	    	autoLoad: true,
//	    	session: true,
//	    	remoteSort: true,
//	    	remoteFilter: true,
//	        listeners : {
//	            beforeload : 'paramLoading'
//	        }
//    	}
    		
    		
    }    
});