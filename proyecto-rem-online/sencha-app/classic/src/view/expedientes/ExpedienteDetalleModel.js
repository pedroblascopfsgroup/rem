Ext.define('HreRem.view.expedientes.ExpedienteDetalleModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.expedientedetalle',
    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.TextosOferta', 'HreRem.model.ActivosExpediente', 
                'HreRem.model.EntregaReserva', 'HreRem.model.ObservacionesExpediente', 'HreRem.model.AdjuntoExpedienteComercial',
                'HreRem.model.Posicionamiento', 'HreRem.model.ComparecienteVendedor', 'HreRem.model.Subsanacion', 'HreRem.model.Notario',
                'HreRem.model.ComparecienteBusqueda', 'HreRem.model.Honorario',
				'HreRem.model.CompradorExpediente', 'HreRem.model.FichaComprador'],
    
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
	     },
	     
	     esDestinoActivoOtros: function(get){
	     	var destinoActivo= get('destinoActivo');
	     	if(destinoActivo=='05'){
	     		return true;
	     	}
	     	return false;
	     },

		esOfertaVenta: function(get){
			var me= this;
	     	var expediente= me.getData().expediente;
	     	var tipoOferta= expediente.get('tipoExpedienteDescripcion');
	     	var sujeto= get('condiciones.sujetoTramiteTanteo');
	     	if(tipoOferta=='Venta'){
	     		return true;
	     	}
	     	return false;
	     },   

	     esOfertaVentaFicha: function(get){
	     	var me = this;
	     	var expediente= me.getData().expediente;
	     	var tipoOferta= expediente.get('tipoExpedienteDescripcion');
	     	if(tipoOferta=='Venta'){
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
    	
    	storeTiposArras: {
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
	    	},
	    	remoteSort: true,
	    	remoteFilter: true
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
	    	}/*,
	    	remoteSort: true,
	    	remoteFilter: true
			*/
		},
		
		storeCompradoresExpediente: {
			pageSize: 10,
	    	model: 'HreRem.model.CompradorExpediente',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getCompradoresExpediente',
		        extraParams: {idExpediente: '{expediente.id}'}
	    	}
		},
		
		comboTipoPersona : {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposPersona'}
			}
    	},
    	
	    comboTipoDocumento: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposDocumentos'}
			}   	
	    },
    	
	    comboEstadoCivil: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosCiviles'}
			}   	
	    },
	    
	    comboDestinoActivo: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'usosActivo'}
			} 
	    },
	    
	    comboRegimenesMatrimoniales: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'regimenesMatrimoniales'}
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
		},
		
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
		
		storeHoronarios: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Honorario',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getHonorarios',
		        extraParams: {idExpediente: '{expediente.id}'}
	    	}
		}
	
    }
  
});