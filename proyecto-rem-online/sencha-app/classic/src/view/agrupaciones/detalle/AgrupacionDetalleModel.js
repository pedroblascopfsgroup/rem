Ext.define('HreRem.view.agrupaciones.detalle.AgrupacionDetalleModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.agrupaciondetalle',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.ActivoAgrupacion', 
    'HreRem.model.ActivoSubdivision', 'HreRem.model.Subdivisiones', 'HreRem.model.VisitasAgrupacion','HreRem.model.OfertasAgrupacion','HreRem.model.OfertaComercial',
    'HreRem.model.ActivoAgrupacionActivo','HreRem.model.VigenciaAgrupacion'],
    
    data: {
    	agrupacionficha: null,
    	ofertaRecord: null
    	
    },
    
    formulas: {
    		
    	getSrcCartera: function(get) {
	     	
	     	var cartera = get('agrupacionficha.cartera');
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

	     esAgrupacionRestringida: function(get) {
	    	 
		     	var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
		     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA'])) {
		     		return true;
		     	} else {
		     		return false;
		     	}
		 },
		 
		 esAgrupacionLoteComercialOrRestringida: function(get) {
			 return !(get('esAgrupacionRestringida') || get('esAgrupacionLoteComercial'));
		 },

		 esAgrupacionRestringidaIncluyeDestinoComercialVenta: function(get) {

			 var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
			 var incluyeDestinoComercialVenta = get('agrupacionficha.incluyeDestinoComercialVenta');
		     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA']) && incluyeDestinoComercialVenta) {
		     		return true;
		     	} else {
		     		return false;
		     	}
		 },

		 esAgrupacionRestringidaIncluyeDestinoComercialAlquiler: function(get) {

			 var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
			 var incluyeDestinoComercialAlquiler = get('agrupacionficha.incluyeDestinoComercialAlquiler');
		     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA']) && incluyeDestinoComercialAlquiler) {
		     		return true;
		     	} else {
		     		return false;
		     	}
		 },

	     esAgrupacionAsistida: function(get) {
	    	 
	     	var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
	     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['ASISTIDA'])) {
	     		return true;
	     	} else {
	     		return false;
	     	}
	     },
	     
	     esComercialAlquiler: function(get) {
	    	 
	     	var tipoComercialAlquiler = get('agrupacionficha.tipoAgrupacionCodigo');
	     	if((tipoComercialAlquiler == CONST.TIPOS_AGRUPACION['COMERCIAL_ALQUILER'])) {
	     		return true;
	     	} else {
	     		return false;
	     	}
		 },
		 
		 esComercialVenta: function(get) {
			var tipoComercialVenta = get('agrupacionficha.tipoAgrupacionCodigo');
			
			if (tipoComercialVenta == CONST.TIPOS_AGRUPACION['COMERCIAL_VENTA']) {
				return true;
			} else {
				return false;
			} 
				
		 },
		 
		 esComercialVentaOAlquiler: function(get) {
		     	var tipoComercialAlquiler = get('agrupacionficha.tipoAgrupacionCodigo');
		     	if((tipoComercialAlquiler == CONST.TIPOS_AGRUPACION['COMERCIAL_ALQUILER']) || (tipoComercialAlquiler == CONST.TIPOS_AGRUPACION['LOTE_COMERCIAL'])) {
		     		return true;
		     	} else {
		     		return false;
		     	}
		 },

		 esAgrupacionLoteComercial: function(get) {

	     	var tipoComercial = get('agrupacionficha.tipoAgrupacionCodigo');
	     	if((tipoComercial == CONST.TIPOS_AGRUPACION['COMERCIAL_ALQUILER']) || (tipoComercial == CONST.TIPOS_AGRUPACION['LOTE_COMERCIAL'])) {
	     		return true;
	     	} else {
	     		return false;
	     	}
		 },

	     esAgrupacionAsistidaAndFechaVigenciaNotNull: function(get) {
	    	 
	     	var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
	     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['ASISTIDA'])
	     	&& (get('agrupacionficha.fechaInicioVigencia') == null 
	     	|| get('agrupacionficha.fechaFinVigencia') == null)) {
	     		return true;
	     	} else {
	     		return false;
	     	}
	     },
	     
	     esAgrupacionObraNueva: function(get) {
	    	 
	     	var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
	     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['OBRA_NUEVA'])) {
	     		return true;
	     	} else {
	     		return false;
	     	}
	     },

	     esAgrupacionLoteComercial: function(get) {

		     	var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
		     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['LOTE_COMERCIAL'])) {
		     		return true;
		     	} else {
		     		return false;
		     	}
		 },

		 esAgrupacionProyecto: function(get) {

		     	var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
		     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['PROYECTO'])) {
		     		return true;
		     	} else {
		     		return false;
		     	}
		 },
		 agrupacionProyectoTieneActivos: function(get) {

		     	var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
		     	var numeroActivos = get('agrupacionficha.numeroActivos');
		     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['PROYECTO']) && numeroActivos > 0) {
		     		return true;
		     	} else {
		     		return false;
		     	}
		 },
		 agrupacionTieneActivosOrExisteFechaBaja: function(get) {
		     	var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
		     	var numeroActivos = get('agrupacionficha.numeroActivos');
		     	var existeFechaBaja = get('agrupacionficha.existeFechaBaja');
		     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['PROYECTO'])) {
		     		if(numeroActivos > 0 || existeFechaBaja){
		     			return true;
		     		}else{
		     			return false;
		     		}

		     	} else {
		     		return existeFechaBaja;
		     	}
		 },

	     esAgrupacionObraNuevaOrAsistida: function(get) {
	    	 
	     	return get('esAgrupacionObraNueva') || get('esAgrupacionAsistida');
	     },
	     
	     esAgrupacionObraNuevaOrAsistidaOrProyecto: function(get) {

		   	return get('esAgrupacionObraNueva') || get('esAgrupacionAsistida') || get('esAgrupacionProyecto');
		 },

	     esAgrupacionLoteComercialOrProyecto: function(get) {

		  	return get('esAgrupacionLoteComercial') || get('esAgrupacionProyecto');
		 },

	     existeFechaBaja : function(get) {
	    	var existeFechaBaja = get('agrupacionficha.existeFechaBaja');
	    	return existeFechaBaja;
	     },
	     
	     hideBotoneraFotosWebAgrupacion: function(get) {
	    	 var existeFechaBaja = get('agrupacionficha.existeFechaBaja');
	    	 var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
	    	 var esAgrupacionObraNueva = tipoAgrupacion == CONST.TIPOS_AGRUPACION['OBRA_NUEVA'];
	    	 var esAgrupacionAsistida = tipoAgrupacion == CONST.TIPOS_AGRUPACION['ASISTIDA'];
	    	 //Si NO es agrupación obra nueva OR sí hay fecha baja se debe ocultar
	    	 return (existeFechaBaja || !(esAgrupacionObraNueva || esAgrupacionAsistida));
	    	 
	     },

	     agrupacionTieneActivos: function(get) {
	     		return (get('agrupacionficha.numeroActivos')>0);
	     },

	     esAgrupacionLiberbank: function(get) {
			var codigoCartera=get('agrupacionficha.codigoCartera');
	         var tipoAgrup= get('agrupacionficha.tipoAgrupacionCodigo');
	         if(codigoCartera == CONST.CARTERA['LIBERBANK'] && tipoAgrup == CONST.TIPOS_AGRUPACION['LOTE_COMERCIAL']){
	             return true;
	         }else{
	             return false;
	         }
	     },

	     getIconClsEstadoVenta: function(get) {
	        var estadoVenta = get('agrupacionficha.estadoVenta');

	        if(estadoVenta == 0) {
	            return 'app-tbfiedset-ico icono-ko'
	        } else if (estadoVenta == 1){
	            return 'app-tbfiedset-ico icono-ok'
	        }else if (estadoVenta == 2){
	            return 'app-tbfiedset-ico icono-okn'
	        }
		 },

		 getIconClsestadoAlquiler : function(get) {
			var estadoAlquiler = get('agrupacionficha.estadoAlquiler');

			if (estadoAlquiler == 0) {
				return 'app-tbfiedset-ico icono-ko'
			} else if (estadoAlquiler == 1) {
				return 'app-tbfiedset-ico icono-ok'
			} else if (estadoAlquiler == 2) {
				return 'app-tbfiedset-ico icono-okn'
			}
		 },

	     getIconClsCondicionantesRuina: function(get) {
	        var condicion = get('datospublicacionagrupacion.ruina');

	     	if(!eval(condicion)) {
	     		return 'app-tbfiedset-ico icono-ok'
	     	} else {
	     		return 'app-tbfiedset-ico icono-ko'
	     	}
	     },

		 getIconClsCondicionantesPendiente: function(get) {
		 	var claseActivo= get('datospublicacionagrupacion.claseActivoCodigo');

			if(CONST.CLASE_ACTIVO['FINANCIERO'] != claseActivo){
				var condicion = get('datospublicacionagrupacion.pendienteInscripcion');
			   	if(!eval(condicion)) {
			   		return 'app-tbfiedset-ico icono-ok'
			   	} else {
			   		return 'app-tbfiedset-ico icono-ko'
			   	}
			}

			return 'app-tbfiedset-ico'
		},

		getIconClsCondicionantesObraTerminada: function(get) {
			var condicion = get('datospublicacionagrupacion.obraNuevaSinDeclarar');

		   	if(!eval(condicion)) {
		   		return 'app-tbfiedset-ico icono-ok'
		   	} else {
		   		return 'app-tbfiedset-ico icono-ko'
		   	}
		 },

		getIconClsCondicionantesSinPosesion: function(get) {
			var claseActivo= get('datospublicacionagrupacion.claseActivoCodigo');

			if(CONST.CLASE_ACTIVO['FINANCIERO'] != claseActivo){
				var condicion = get('datospublicacionagrupacion.sinTomaPosesionInicial');
				if(!eval(condicion)) {
					return 'app-tbfiedset-ico icono-ok'
				} else {
					return 'app-tbfiedset-ico icono-ko'
				}
			}

			return 'app-tbfiedset-ico'
		},

		getIconClsCondicionantesProindiviso: function(get) {
			var condicion = get('datospublicacionagrupacion.proindiviso');

		   	if(!eval(condicion)) {
		   		return 'app-tbfiedset-ico icono-ok'
		   	} else {
		   		return 'app-tbfiedset-ico icono-ko'
		   	}
		},

		getIconClsCondicionantesObraNueva: function(get) {
			var condicion = get('datospublicacionagrupacion.obraNuevaEnConstruccion');

		   	if(!eval(condicion)) {
		   		return 'app-tbfiedset-ico icono-ok'
		   	} else {
		   		return 'app-tbfiedset-ico icono-ko'
		   	}
		},

		getIconClsCondicionantesOcupadoConTitulo: function(get) {
			var condicion = get('datospublicacionagrupacion.ocupadoConTitulo');

		   	if(!eval(condicion)) {
		   		return 'app-tbfiedset-ico icono-ok'
		   	} else {
		   		return 'app-tbfiedset-ico icono-ko'
		   	}
		},

		getIconClsCondicionantesTapiado: function(get) {
			var condicion = get('datospublicacionagrupacion.tapiado');

		   	if(!eval(condicion)) {
		   		return 'app-tbfiedset-ico icono-ok'
		   	} else {
		   		return 'app-tbfiedset-ico icono-ko'
		   	}
		},

		getIconClsCondicionantesOcupadoSinTitulo: function(get) {
			var condicion = get('datospublicacionagrupacion.ocupadoSinTitulo');

		   	if(!eval(condicion)) {
		   		return 'app-tbfiedset-ico icono-ok'
		   	} else {
		   		return 'app-tbfiedset-ico icono-ko'
		   	}
		},

		getIconClsCondicionantesDivHorizontal: function(get) {
			var condicion = get('datospublicacionagrupacion.divHorizontalNoInscrita');

		    if(!eval(condicion)) {
		        return 'app-tbfiedset-ico icono-ok'
		    } else {
		        return 'app-tbfiedset-ico icono-ko'
		    }
		},

		getIconClsCondicionantesConCargas: function(get) {
			var condicion = get('datospublicacionagrupacion.conCargas');

		    if(!eval(condicion)) {
		        return 'app-tbfiedset-ico icono-ok'
		    } else {
		        return 'app-tbfiedset-ico icono-ko'
		    }
		},

		getIconClsCondicionantesSinInformeAprobado: function(get) {
			var condicion = get('datospublicacionagrupacion.sinInformeAprobado');

		    if(!eval(condicion)) {
		        return 'app-tbfiedset-ico icono-ok'
		    } else {
		        return 'app-tbfiedset-ico icono-ko'
		    }
		},

		getIconClsCondicionantesVandalizado: function(get) {
			var condicion = get('datospublicacionagrupacion.vandalizado');

		    if(!eval(condicion)) {
		        return 'app-tbfiedset-ico icono-ok'
		    } else {
		        return 'app-tbfiedset-ico icono-ko'
		    }
		},

		getSiNoFromOtro: function(get) {
			var condicion = get('datospublicacionagrupacion.otro');

		   	if(Ext.isEmpty(condicion)) {
		   		return '0';
		   	} else {
		   		return '1';
		   	}
		},

		filtrarComboMotivosOcultacionVenta: function(get) {
			var bloqueoCheckOcultar = get('datospublicacionagrupacion.deshabilitarCheckOcultarVenta');

			if(!Ext.isEmpty(bloqueoCheckOcultar) && !bloqueoCheckOcultar) {
				 this.getData().comboMotivosOcultacionVenta.filter([{
                     filterFn: function(rec){
                         return rec.getData().esMotivoManual === 'true';
                     }
                 }]);
			} else {
				this.getData().comboMotivosOcultacionVenta.clearFilter();
			}
		},

		filtrarComboMotivosOcultacionAlquiler: function(get) {
            var bloqueoCheckOcultar = get('datospublicacionagrupacion.deshabilitarCheckOcultarAlquiler');

            if(!Ext.isEmpty(bloqueoCheckOcultar) && !bloqueoCheckOcultar) {
                 this.getData().comboMotivosOcultacionAlquiler.filter([{
                     filterFn: function(rec){
                         return rec.getData().esMotivoManual === 'true';
                     }
                 }]);
            } else {
                this.getData().comboMotivosOcultacionAlquiler.clearFilter();
            }
        },
	     agrupacionRestringidaYPublicada: function(get) {
	    	 var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
		     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA'])) {
		     		 var estadoAlquilerCodigo = get('agrupacionficha.estadoAlquilerCodigo');
					 var estadoVentaCodigo = get('agrupacionficha.estadoVentaCodigo');
					 var incluyeDestinoComercialAlquiler = get('agrupacionficha.incluyeDestinoComercialAlquiler');
					 var incluyeDestinoComercialVenta = get('agrupacionficha.incluyeDestinoComercialVenta');

					 if(incluyeDestinoComercialVenta && incluyeDestinoComercialAlquiler) {
						 return estadoAlquilerCodigo === CONST.ESTADO_PUBLICACION_ALQUILER['PUBLICADO'] || estadoVentaCodigo === CONST.ESTADO_PUBLICACION_VENTA['PUBLICADO'];
					 } else if(incluyeDestinoComercialVenta) {
						 return estadoVentaCodigo === CONST.ESTADO_PUBLICACION_VENTA['PUBLICADO'];
					 } else if (incluyeDestinoComercialAlquiler){
						 return estadoAlquilerCodigo === CONST.ESTADO_PUBLICACION_ALQUILER['PUBLICADO'];
					 } else {
						 return false;
					 }
		     	}else return false;
	     }
    },

    stores: {
    	comboCartera: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'entidadesPropietarias'}
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
				extraParams: {codigoProvincia: '{agrupacionficha.provinciaCodigo}'}
			},autoLoad: true
		},
    	
		storeFotos: {    			
    		 model: 'HreRem.model.Fotos',
		     proxy: {
		        type: 'uxproxy',
		        api: {
		            read: 'agrupacion/getFotosAgrupacionById',
		            create: 'agrupacion/getFotosAgrupacionById',
		            update: 'agrupacion/updateFotosById',
		            destroy: 'agrupacion/destroy'
		        },
		        extraParams: {id: '{agrupacionficha.id}', tipoFoto: '01'}
		     }
    	},    	

		storeActivos: {
			 pageSize: $AC.getDefaultPageSize(),
			 model: 'HreRem.model.ActivoAgrupacionActivo',
			 proxy: {
			    type: 'uxproxy',
			    timeout: 60000,
				remoteUrl: 'agrupacion/getListActivosAgrupacionById',
				extraParams: {id: '{agrupacionficha.id}'}
			 },
		     remoteSort: true
		},
	
    	storeObservaciones: {  
    	     pageSize: $AC.getDefaultPageSize(),
    		 model: 'HreRem.model.ObservacionesAgrupacion',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'agrupacion/getListObservacionesAgrupacionById',
		        extraParams: {id: '{agrupacionficha.id}'}
	    	 }
    	},
    	
    	storeVisitasAgrupacion: {  
	   	     pageSize: $AC.getDefaultPageSize(),
			 model: 'HreRem.model.VisitasAgrupacion',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'agrupacion/getListVisitasAgrupacionById',
		        extraParams: {id: '{agrupacionficha.id}'}
	    	 }
    	},
    	storeOfertasAgrupacion: {  
	   	     pageSize: $AC.getDefaultPageSize(),
			 model: 'HreRem.model.OfertasAgrupacion',
			 sorters: [
			 			{
			        		property: 'estadoOferta',
			        		direction: 'ASC'	
			 			},
			 			{
			        		property: 'fechaCreacion',
			        		direction: 'DESC'	
			 			}
			 ],
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'agrupacion/getListOfertasAgrupacion',
		        extraParams: {id: '{agrupacionficha.id}'}
	    	 }
    	},
    	
    	storeSubdivisiones: {    			
    		 model: 'HreRem.model.Subdivisiones',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'agrupacion/getListSubdivisionesAgrupacionById',
		        extraParams: {agrId: '{agrupacionficha.id}'}
	    	 },
	    	 remoteSort: true,
		     remoteFilter: true,
		     sorters: [{
		        property: 'dormitorios',
		        direction: 'ASC'
		     }]
    	},
    	
    	storeHistoricoVigencias: {    			
    		 model: 'HreRem.model.VigenciaAgrupacion',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'agrupacion/getHistoricoVigencias',
		        extraParams: {agrId: '{agrupacionficha.id}'}
	    	 },
	    	 remoteSort: true,
		     remoteFilter: true
    	},
    	
    	storeActivosSubdivision: {    			
    		 model: 'HreRem.model.ActivoSubdivision',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'agrupacion/getListActivosSubdivisionById',
		        extraParams: {id: '{subdivision.id}', agrId: '{subdivision.agrupacionId}'}
	    	 }
    	},
    	
    	storeFotosSubdivision: {    			
    		 model: 'HreRem.model.Fotos',    		
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'agrupacion/getFotosSubdivisionById',
		        extraParams: {id: '{subdivisionFoto.id}', agrId: '{subdivisionFoto.agrupacionId}'}
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
	    
	    comboTipoOferta: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposOfertas'}
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

	    comboGestoriaFormalizacion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'agrupacion/getUsuariosPorTipoGestorYCarteraDelLoteComercial',
				extraParams: {agrId: '{agrupacionficha.id}', codigoGestor: 'GIAFORM'}
			}   	
	    },

	    comboGestorComercial: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'agrupacion/getGestoresLoteComercial',
				extraParams: {agrId: '{agrupacionficha.id}', codigoGestor: 'GCOM'}
			}   	
	    },

	    comboGestorComercialTipo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'agrupacion/getGestoresLoteComercialPorTipo',
				extraParams: {agrId: '{agrupacionficha.id}'}
			}
	    },

	    comboGestorComercialBackoffice: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'agrupacion/getGestoresLoteComercial',
				extraParams: {agrId: '{agrupacionficha.id}', codigoGestor: 'HAYAGBOINM'}
			}
	    },

	    comboDobleGestorActivo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'agrupacion/getDobleGestorActivo',
				extraParams: {agrId: '{agrupacionficha.id}', codigoGestorEdi: 'GEDI', codigoGestorSu: 'GSUE'}
			}
	    },

	    comboGestorActivos: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'agrupacion/getGestoresLoteComercial',
				extraParams: {agrId: '{agrupacionficha.id}', codigoGestor: 'GACT'}
			}
	    },

	    comboGestorFormalizacion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'agrupacion/getGestoresLoteComercial',
				extraParams: {agrId: '{agrupacionficha.id}', codigoGestor: 'GFORM'}
			}   	
	    },

	    comboTipoPersona: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoPersona'}
			},
			autoLoad: true
	    },
	    comboEstadoCivil: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosCiviles'}
			},
			autoLoad: true   	
	    },
	    comboRegimenMatrimonial: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'regimenesMatrimoniales'}
			},
			autoLoad: true   	
	    },

	    comboMotivosOcultacionVenta: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivosOcultacion'}
			}
		},

		comboAdecuacionAlquiler: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'comboAdecuacionAlquiler'}
			}
		},

		comboMotivosOcultacionAlquiler: {
            model: 'HreRem.model.ComboBase',
            proxy: {
                type: 'uxproxy',
                remoteUrl: 'generic/getDiccionario',
                extraParams: {diccionario: 'motivosOcultacion'}
            }
        },

        comboSiNoRemActivo: {
			data : [
		        {"codigo":"1", "descripcion":eval(String.fromCharCode(34,83,237,34))},
		        {"codigo":"0", "descripcion":"No"}
		    ]
		},

		storeEstadoDisponibilidadComercial: {
			model: 'HreRem.model.DDBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadoDisponibilidadComercial'}
			},
			autoLoad: true
		},

		historicoEstadosPublicacionVenta: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.HistoricoEstadosPublicacion',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getHistoricoEstadosPublicacionVentaByIdActivo',
				extraParams: {idActivo: '{datospublicacionagrupacion.idActivoPrincipal}'}
			}
		},

		historicoEstadosPublicacionAlquiler: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.HistoricoEstadosPublicacion',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getHistoricoEstadosPublicacionAlquilerByIdActivo',
				extraParams: {idActivo: '{datospublicacionagrupacion.idActivoPrincipal}'}
			}
		},

		historicocondicionesagrupacion: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.CondicionEspecificaAgrupacion',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getCondicionEspecificaByActivo',
				extraParams: {id: '{datospublicacionagrupacion.idActivoPrincipal}'}
			}
		},
		comboTipoDestinoComercialCreaFiltered: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboTipoDestinoComercialCreaFiltered'
			}
		},

        comboTipoAlquiler: {
            model: 'HreRem.model.ComboBase',
            proxy: {
                type: 'uxproxy',
                remoteUrl: 'generic/getDiccionario',
                extraParams: {diccionario: 'tiposAlquilerActivo'}
            }
        }
     }
});