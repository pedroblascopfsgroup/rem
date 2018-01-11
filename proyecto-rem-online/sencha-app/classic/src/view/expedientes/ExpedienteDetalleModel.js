Ext.define('HreRem.view.expedientes.ExpedienteDetalleModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.expedientedetalle',
    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.TextosOferta', 'HreRem.model.ActivosExpediente', 
                'HreRem.model.EntregaReserva', 'HreRem.model.ObservacionesExpediente', 'HreRem.model.AdjuntoExpedienteComercial',
                'HreRem.model.Posicionamiento', 'HreRem.model.ComparecienteVendedor', 'HreRem.model.Subsanacion', 'HreRem.model.Notario',
                'HreRem.model.ComparecienteBusqueda', 'HreRem.model.Honorario',
				'HreRem.model.CompradorExpediente', 'HreRem.model.FichaComprador','HreRem.model.BloqueoActivo','HreRem.model.TanteoActivo'],
    
    data: {
    },
    
    formulas: {   

    	puedeModificarCompradores: function(get) {
			/*if(get('esCarteraBankia')){
				if(get('esExpedienteSinReserva')){
					if(get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['APROBADO'] || get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['FIRMADO'] || get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['ANULADO'] || get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['VENDIDO']){
						return false;
					}
				}
				else{
					if(get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['RESERVADO'] || get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['FIRMADO'] || get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['ANULADO'] || get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['VENDIDO']){
						return false;
					}
				}
			}	*/
			return $AU.userHasFunction(['EDITAR_TAB_COMPRADORES_EXPEDIENTES']);
		 },
    		
	     getSrcCartera: function(get) {
	     	
	     	var cartera = get('expediente.entidadPropietariaDescripcion');
	     	var src=null;
	     	if(!Ext.isEmpty(cartera)) {
	     		src = CONST.IMAGENES_CARTERA[cartera.toUpperCase()];
	     	}
        	if(Ext.isEmpty(src)) {
        		return 	null;
        	}else {
        		return 'resources/images/'+src;	     
        	} 
	     },
	     
	     esCarteraBankia: function(get) {
	     	
	     	var carteraCodigo = get('expediente.entidadPropietariaCodigo');
	     	return CONST.CARTERA['BANKIA'] == carteraCodigo;
	     },
	     
	     fechaIngresoChequeReadOnly: function(get) {
	    	 var carteraCodigo = get('expediente.entidadPropietariaCodigo');
	    	 var subCartera = get('expediente.propietario');
	    	 return CONST.CARTERA['BANKIA'] == carteraCodigo && CONST.NOMBRE_SUBCARTERA['BANKIA_HABITAT'] != subCartera;
	     },
	     
	     comiteSancionadorNoEditable: function(get) {
	     	var carteraCodigo = get('expediente.entidadPropietariaCodigo');
	     	return CONST.CARTERA['BANKIA'] == carteraCodigo || CONST.CARTERA['CAJAMAR'] == carteraCodigo;	
	     },
	     
	     esCarteraSareb: function(get) {
	     	
	     	var carteraCodigo = get('expediente.entidadPropietariaCodigo');
	     	return CONST.CARTERA['SAREB'] == carteraCodigo;
	     },
	     
	     esCarteraCajamar: function(get) {
		     	
	     	var carteraCodigo = get('expediente.entidadPropietariaCodigo');
	     	return CONST.CARTERA['CAJAMAR'] == carteraCodigo;
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
	     esEditableCompradores : function(get){
	     	var me = this;
	     	if(get('esCarteraBankia')){
			return (get('expediente.codigoEstado') != CONST.ESTADOS_EXPEDIENTE['FIRMADO']
					    && get('expediente.codigoEstado') != CONST.ESTADOS_EXPEDIENTE['VENDIDO'] )
					    && $AU.userHasFunction(['EDITAR_TAB_COMPRADORES_EXPEDIENTES']);
	     	}else{
	     		return false;
	     	}
					    
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

			var tipoOferta= get('expediente.tipoExpedienteDescripcion');

	     	if(tipoOferta=='Venta'){
	     		return true;
	     	}
	     	return false;
	     },
	     
	     esExpedienteSinReserva: function(get) {
	     	
	     	
	     	if(!Ext.isEmpty(get('expediente.solicitaReserva'))) {
	    	 	return get('expediente.solicitaReserva') == "0";
	     	} else {
	    	 	return !get('expediente.tieneReserva');
	    	}

	     	
	     },
		
		esOfertaVentaFicha: function(get){
	     	var me = this;
	     	var expediente= me.getData().expediente;
	     	if(!Ext.isEmpty(expediente)){
		     	var tipoOferta= expediente.get('tipoExpedienteDescripcion');
		     	if(tipoOferta=='Venta'){
		     		return true;
		     	}
	     	}
	     	return false;
	     },
	     
	     esAlquilerConOpcionCompra: function(get){
	     	var me = this;
			if(!Ext.isEmpty(me.getData().expediente)){
				if(me.getData().expediente.get('alquilerOpcionCompra')==1){
					return true;
				}
			}
	     	return false;
	     },
	     
	     esExpedienteNoSujetoTramiteTanteo: function(get) {
		     	
	     	var ocultarPestTanteo = get('expediente.ocultarPestTanteoRetracto');
	     	return ocultarPestTanteo === "true";
	     	
	     },
	     
	     esExpedienteSinReservaOdeTipoAlquiler: function(get) {
	    	 var me = this;
	    	 return get('esExpedienteSinReserva') ||  get('expediente.tipoExpedienteCodigo') === "02";	    	 
	     },
	     
	     esExpedienteBloqueado: function(get) {
		     	
		     	var bloqueado = get('expediente.bloqueado');
		     	return bloqueado;
		     	
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
    	comboMotivoDesbloqueo: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivosDesbloqueo'}
			}   
    	},
    	
    	comboTiposFinanciacion: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposFinanciacion'}
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
				remoteUrl: 'generic/getDiccionarioPorCuenta',
				extraParams: {
					tipoCodigo: '{expediente.tipoExpedienteCodigo}'
				}
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
				extraParams: {diccionario: 'tipoPersona'}
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
	    
	    comboClienteUrsus: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'expedientecomercial/buscarClientesUrsus',
				extraParams: {numeroDocumento: null, tipoDocumento: null}
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
		        remoteUrl: 'expedientecomercial/getContactosNotario',
		        extraParams: {idProveedor: '{posicionamSelected.idProveedorNotario}'}
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
		},
		storeBloqueosActivo: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.BloqueoActivo',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getBloqueosActivo',
		        extraParams: {idExpediente: '{expediente.id}',idActivo: '{activoExpedienteSeleccionado.idActivo}'}
	    	}
		},
		storeTanteosActivo: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.TanteoActivo',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getTanteosActivo',
		        extraParams: {idExpediente: '{expediente.id}',idActivo: '{activoExpedienteSeleccionado.idActivo}'}
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
	    
	    comboColaboradorPrescriptor: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposColaborador'}
			}
	    },
	    
	    comboCanalPrescripcion: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'canalesPrescripcion'}
			}
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
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboMunicipio',
				extraParams: {codigoProvincia: '{comprador.provinciaCodigo}'}
			}
    	},
    	
    	comboMunicipioRte: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboMunicipio',
				extraParams: {codigoProvincia: '{comprador.provinciaRteCodigo}'}
			}
    	},

		comboComites: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getComitesByCartera',
		        extraParams: {carteraCodigo: '{expediente.entidadPropietariaCodigo}'}
	    	}	    	
	    },
	    
	    comboComitesPropuestos: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getComitesByCartera',
		        extraParams: {carteraCodigo: '{expediente.entidadPropietariaCodigo}'}
	    	}	    	
	    },

	    storeMotivoAnulacion: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
		        extraParams: {diccionario: 'motivoAnulacionExpediente'}
	    	}	    	
	    },
	    
	    storeEstadosDevolucion: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
		        extraParams: {diccionario: 'estadosDevolucion'}
	    	}	    	
	    },
	    
		comboResultadoTanteo: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
		        extraParams: {diccionario: 'resultadoTanteo'}
	    	}	    	
	    },

	    comboAreaBloqueo: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
		        extraParams: {diccionario: 'areaBloqueo'}
	    	},
	    	autoLoad: true
	    },

	    comboTipoBloqueo: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionarioTipoBloqueo'
	    	}
	    },

	    comboTipoBloqueoGrid: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionarioTipoBloqueo',
		        extraParams: {areaCodigo: 'mostrarTodos'}
	    	},
	    	autoLoad: true
	    },
	    
	    storeBloqueosFormalizacion: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.BloqueosFormalizacionModel',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getBloqueosFormalizacion',
		        extraParams: {idExpediente: '{expediente.id}',
		        				id: '{activoExpedienteSeleccionado.idActivo}'}
	    	}
		},
		
		comboUsuarios: {
			model: 'HreRem.model.ComboBase',
			proxy: {
			type: 'uxproxy',
			remoteUrl: 'expedientecomercial/getComboUsuarios',
			extraParams: {idTipoGestor: '{tipoGestor.selection.id}'}
			}
		},
		
		storeGestores: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.GestorActivo',
		   	proxy: {
		   		type: 'uxproxy',
		   	    remoteUrl: 'expedientecomercial/getGestores',
		   	    extraParams: {idExpediente: '{expediente.id}'}
		    }
		},
		
		comboTipoGestorFilteredExpediente: {
			model: 'HreRem.model.ComboBase',
			proxy: {
			type: 'uxproxy',
			remoteUrl: 'expedientecomercial/getComboTipoGestorFiltered'
			}/*,autoLoad: true*/
		},
		
		storeProcedeDevolucion: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
		        extraParams: {diccionario: 'devolucionReserva'}
	    	}	    	
	    },
		activoExpediente: {
    		pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Gasto',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/provision.json',
		        remoteUrl: 'gastosproveedor/getListGastos',
		        extraParams: {idProvision: '{activoExpedienteSeleccionado.data.idActivo}'}
	    	}
    		
    	},
    	
    	comboTipoGradoPropiedad : {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposGradoPropiedad'}
			}
    	},
    	
    	comboPaises : {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'paises'}
			}
    	}
    	
		
    }
});