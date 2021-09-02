Ext.define('HreRem.view.agrupaciones.detalle.AgrupacionDetalleModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.agrupaciondetalle',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.ActivoAgrupacion', 
    'HreRem.model.ActivoSubdivision', 'HreRem.model.Subdivisiones', 'HreRem.model.VisitasAgrupacion','HreRem.model.OfertasAgrupacion','HreRem.model.OfertaComercial'
    ,'HreRem.model.ComercialAgrupacion','HreRem.model.ActivoAgrupacionActivo','HreRem.model.VigenciaAgrupacion','HreRem.model.AdjuntoActivoAgrupacion'],
    data: {
    	agrupacionficha: null,
    	ofertaRecord: null,
    	editing: null
    },
    
    formulas: {
    	
    	muestraUvem: function(get) {
    		return get('esAgrupacionProyecto') || get('esAgrupacionPromocionAlquiler');
    	},
    	
    	existeActivoEnAgrupacion: function(get) {
    		return get('agrupacionficha.numeroActivos') > 0;
    	},
    		
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
	     isEmptySrcCartera: function(get) {
	     	var cartera = get('agrupacionficha.cartera');
	     	var src=null;
	     	if(!Ext.isEmpty(cartera)) {
	     		src = CONST.IMAGENES_CARTERA[cartera.toUpperCase()];
	     	}
        	if(Ext.isEmpty(src)) {
        		return 	true;
        	}else {
        		return false;	     
        	}     	
	     	
	     },
	     
	     usuarioEditarVentaPlano: function(get){
				var me = this;
				var user = $AU.userIsRol("HAYASUPER") || $AU.userIsRol("HAYAGESTCOM");
				
				if(user){
					return false;
				}
				return true;
		},
	     
	     esAgrupacionPromocionAlquiler: function(get) {
	    	var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo') ;
	    	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['PROMOCION_ALQUILER'])) {
	    		return true;
	    	} else {
	    		return false;
	    	}
	     },

	     esAgrupacionRestringida: function(get) {
	    	 
		     	var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
		     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA'])
		     			|| (tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_ALQUILER'])
		     			|| (tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_OBREM'])) {
		     		return true;
		     	} else {
		     		return false;
		     	}
		 },
		 habilitarPestanyaDatosPublicacionAgrupacion: function(get) {
	    	 
		     	var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
		     	var numActivos = get('agrupacionficha.numeroActivos');
		     	if(((tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA'])
		     			|| (tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_ALQUILER'])
		     			|| (tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_OBREM'])) && numActivos > 0) {
		     		return true;
		     	} else {
		     		return false;
		     	}
		 },
		 esAgrupacionLoteComercialOrRestringida: function(get) {
			 return !(get('esAgrupacionRestringida') || get('esAgrupacionLoteComercial'));
		 },
		 
		 esAgrupacionGencat: function(get) {
		     	var agrupacionGencat = get('agrupacionficha.isAgrupacionGencat');
		     	if (!agrupacionGencat) {
	    			return true;
	    		} else {
	    			return false;
	    		}
		 },
		 
		 esAgrupacionLoteComercialOrRestringidaOrNotGencat: function(get) {
			 return !(get('esAgrupacionRestringida') || get('esAgrupacionLoteComercial')) || !get('esAgrupacionGencat');
		 },

		 esAgrupacionRestringidaIncluyeDestinoComercialVenta: function(get) {

			 var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
			 var incluyeDestinoComercialVenta = get('agrupacionficha.incluyeDestinoComercialVenta');
		     	if(((tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA'])
		     			|| (tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_ALQUILER'])
		     			|| (tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_OBREM'])) && incluyeDestinoComercialVenta) {
		     		return true;
		     	} else {
		     		return false;
		     	}
		 },

		 esAgrupacionRestringidaIncluyeDestinoComercialAlquiler: function(get) {

			 var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
			 var incluyeDestinoComercialAlquiler = get('agrupacionficha.incluyeDestinoComercialAlquiler');
		     	if(((tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA'])
		     			|| (tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_ALQUILER'])
		     			|| (tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_OBREM'])) && incluyeDestinoComercialAlquiler) {
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
	     	if(tipoComercial == CONST.TIPOS_AGRUPACION['LOTE_COMERCIAL']) {

	     		return true;
	     	} else {
	     		return false;
	     	}
		 },
		 
		 campoAllowBlank: function(get) {
			 var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
			 if(tipoAgrupacion == CONST.TIPOS_AGRUPACION['PROMOCION_ALQUILER']) {
				 return true;
			 } else {
				 return get('esAgrupacionLoteComercial');
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
		
		 esAgrupacionProyecto: function(get) {

		     	var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
		     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['PROYECTO'])) {
		     		return true;
		     	} else {
		     		return false;
		     	}
		 },
 		 visibilidadPestanyaDocumentos: function(get) {
		     	var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo'),
		     	cartera = get('agrupacionficha.codigoCartera'),
		     	subCartera =  get('agrupacionficha.codSubcartera');
		     	if ((tipoAgrupacion == CONST.TIPOS_AGRUPACION['PROYECTO'])) {
		     		return true;
		     	} else if ((tipoAgrupacion == CONST.TIPOS_AGRUPACION["OBRA_NUEVA"] && cartera == CONST.CARTERA["THIRDPARTIES"]  && subCartera == CONST.SUBCARTERA["YUBAI"] )) {
		     		return true;
		     	}else{
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
		 agrupacionPromocionAlquilerTieneActivos: function(get) {
			 var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
		     var numeroActivos = get('agrupacionficha.numeroActivos');
		     if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['PROMOCION_ALQUILER']) && numeroActivos > 0) {
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
		 
		 isCampoReadOnly: function(get) {
			 var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
			 if (tipoAgrupacion == CONST.TIPOS_AGRUPACION['PROMOCION_ALQUILER']) {
				 return true;
			 } else {
				 return get('agrupacionTieneActivosOrExisteFechaBaja');
			 }
		 },
		 
		 agrupacionTieneFechaBajaOrEsPromocionAlquiler: function(get) {
			return get('esAgrupacionPromocionAlquiler') || get('existeFechaBaja');
		 },
		 
		 existeFechaBajaOrEsPromocionAlquiler: function(get) {
			 var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
			 var existeFechaBaja = get('agrupacionficha.existeFechaBaja');
			 if(existeFechaBaja || (tipoAgrupacion == CONST.TIPOS_AGRUPACION['PROMOCION_ALQUILER'])) {
				 return true;
			 } else {
				 return false;
			 }
		 },

	     esAgrupacionObraNuevaOrAsistida: function(get) {
	    	 
	     	return get('esAgrupacionObraNueva') || get('esAgrupacionAsistida');
	     },
	     
	     esAgrupacionObraNuevaOrAsistidaOrProyecto: function(get) {

		   	return get('esAgrupacionObraNueva') || get('esAgrupacionAsistida') || get('esAgrupacionProyecto');
		 },
		 
		 habilitarComercial: function(get) {
			 return get('esAgrupacionObraNueva') || get('esAgrupacionAsistida') || get('esAgrupacionProyecto') || get('esAgrupacionPromocionAlquiler');
		 },

	     esAgrupacionLoteComercialOrProyecto: function(get) {

		  	return get('esAgrupacionLoteComercial') || get('esAgrupacionProyecto');
		 },
		 
		 esActivoDadoDeBaja: function(get) {
			 var existeFechaBaja = get('agrupacionficha.existeFechaBaja');
			 return existeFechaBaja != null;
		 },
		 
		 esAgrupacionObraNuevaOrAsistidaOrPromocionAlquiler: function(get) {
			return get('esAgrupacionObraNueva') || get('esAgrupacionAsistida') || get('esAgrupacionPromocionAlquiler'); 
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
	         if(codigoCartera == CONST.CARTERA['LIBERBANK'] && (tipoAgrup == CONST.TIPOS_AGRUPACION['LOTE_COMERCIAL'] || tipoAgrup == CONST.TIPOS_AGRUPACION['RESTRINGIDA'])){
	             return true;
	         }else{
	             return false;
	         }
	     },
	     
	     mostrarComboBO: function(get) {
	    	 var codigoCartera=get('agrupacionficha.codigoCartera');
	    	 var codigoSubCartera=get('agrupacionficha.codSubcartera');
	         var tipoAgrup= get('agrupacionficha.tipoAgrupacionCodigo');
	         if((codigoCartera == CONST.CARTERA['LIBERBANK'] || 
	        	codigoCartera == CONST.CARTERA['BANKIA'] ||
	        	codigoCartera == CONST.CARTERA['BBVA'] ||
	        	(codigoCartera == CONST.CARTERA['CERBERUS'] && 
	        		(codigoSubCartera == CONST.SUBCARTERA['APPLEINMOBILIARIO'] || 
	        		codigoSubCartera == CONST.SUBCARTERA['JAIPURFINANCIERO'] ||
	        		codigoSubCartera == CONST.SUBCARTERA['DIVARIANARROW'] ||
	        		codigoSubCartera == CONST.SUBCARTERA['DIVARIANREMAINING'])
	         	) ||
	        	(codigoCartera == CONST.CARTERA['EGEO'] 
	        		 && codigoSubCartera == CONST.SUBCARTERA['ZEUS']) ||
	        	codigoCartera == CONST.CARTERA['GALEON'] || 
	        	codigoCartera == CONST.CARTERA['GIANTS'] ||
		        codigoCartera == CONST.CARTERA['HYT'] || 
	        	codigoCartera == CONST.CARTERA['SAREB'] || 
	        	codigoCartera == CONST.CARTERA['TANGO'] ||
	        	(codigoCartera == CONST.CARTERA['THIRD'] && 
	        		(codigoSubCartera == CONST.SUBCARTERA['QUITASBANKIA'] ||
	        		codigoSubCartera == CONST.SUBCARTERA['COMERCIALING']) 
	        	)
	         ) 
	         && tipoAgrup == CONST.TIPOS_AGRUPACION['LOTE_COMERCIAL']){
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
        onInitChangePrecioWebAlquiler: function (get){
			var noMostrarPrecioAlquiler = get('datospublicacionagrupacion.noMostrarPrecioAlquiler');
			var precioWebAlquiler = get('datospublicacionagrupacion.precioWebAlquiler');
			
				if (noMostrarPrecioAlquiler)
					return 0; 
				else {
					if (precioWebAlquiler != undefined) 
						return precioWebAlquiler
					}
        },
        onInitChangePrecioWebVenta: function (get){
			var noMostrarPrecioVenta = get('datospublicacionagrupacion.noMostrarPrecioVenta');
			var precioWebVenta  = get('datospublicacionagrupacion.precioWebVenta');
			
				if (noMostrarPrecioVenta)
					return 0; 
				else {
					if (precioWebVenta != undefined) 
						return precioWebVenta
					}
		},
	     agrupacionRestringidaYPublicada: function(get) {
	    	 var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
		     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA'])
		     			|| (tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_ALQUILER'])
		     			|| (tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_OBREM'])) {
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
	     },
	     agrupacionRestringidaYPublicadaVenta: function(get) { 
	    	 var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
		     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA'])
		     			|| (tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_ALQUILER'])
		     			|| (tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_OBREM'])) {
					 var estadoVentaCodigo = get('agrupacionficha.estadoVentaCodigo');
					 var incluyeDestinoComercialVenta = get('agrupacionficha.incluyeDestinoComercialVenta');
					 
					 if(incluyeDestinoComercialVenta) {
						 return estadoVentaCodigo === CONST.ESTADO_PUBLICACION_VENTA['PUBLICADO'];
					 } else {
						 return false;
					 }
		     	}else return false;
	     },
	     agrupacionRestringidaYPublicadaAlquiler: function(get) { 
	    	 var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
		     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA'])
		     			|| (tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_ALQUILER'])
		     			|| (tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_OBREM'])) {
		     		 var estadoAlquilerCodigo = get('agrupacionficha.estadoAlquilerCodigo');
					 var incluyeDestinoComercialAlquiler = get('agrupacionficha.incluyeDestinoComercialAlquiler');
					 
					 if (incluyeDestinoComercialAlquiler){
						 return estadoAlquilerCodigo === CONST.ESTADO_PUBLICACION_ALQUILER['PUBLICADO'];
					 } else {
						 return false;
					 }
		     	}else return false;
	     },
	     getValuePublicacionVentaAgrupacion: function(get){		 	
		 	if(get('agrupacionRestringidaYPublicadaVenta')){
		 		
		 	var tipoActivoCodigo = get('agrupacionficha.tipoActivoPrincipalCodigo');
		 	var tipoActivo = "vivienda";
		 	if (CONST.TIPOS_ACTIVO['SUELO'] == tipoActivoCodigo){
		 		tipoActivo = "terreno";
		 	}else if(CONST.TIPOS_ACTIVO['COMERCIAL_Y_TERCIARIO'] == tipoActivoCodigo){
		 		tipoActivo = "local-comercial";
		 	}else if(CONST.TIPOS_ACTIVO['INDUSTRIAL'] == tipoActivoCodigo){
		 		tipoActivo = "nave-industrial";
		 	}else if(CONST.TIPOS_ACTIVO['EDIFICIO_COMPLETO'] == tipoActivoCodigo){
		 		tipoActivo = "edificio";
		 	}else if(CONST.TIPOS_ACTIVO['EN_CONSTRUCCION'] == tipoActivoCodigo){
		 		tipoActivo = "en-construccion";
		 	}else if(CONST.TIPOS_ACTIVO['OTROS'] == tipoActivoCodigo){
		 		tipoActivo = "garaje-trastero";
		 	}
		 		
		 		return '<a href="' + HreRem.i18n('fieldlabel.link.web.haya').replace("vivienda",tipoActivo) + get('agrupacionficha.idNumActivoPrincipal')+'?utm_source=rem&utm_medium=aplicacion&utm_campaign=activo " target="_blank">' + get('agrupacionficha.estadoVentaDescripcion') + '</a>'
		 	}else {
		 		return get('agrupacionficha.estadoVentaDescripcion')
		 	}
		 },
		 
		 getValuePublicacionAlquilerAgrupacion: function(get){	 	
		 	if(get('agrupacionRestringidaYPublicadaAlquiler')){
		 		
		 	var tipoActivoCodigo = get('agrupacionficha.tipoActivoPrincipalCodigo');
		 	var tipoActivo = "vivienda";
		 	if (CONST.TIPOS_ACTIVO['SUELO'] == tipoActivoCodigo){
		 		tipoActivo = "terreno";
		 	}else if(CONST.TIPOS_ACTIVO['COMERCIAL_Y_TERCIARIO'] == tipoActivoCodigo){
		 		tipoActivo = "local-comercial";
		 	}else if(CONST.TIPOS_ACTIVO['INDUSTRIAL'] == tipoActivoCodigo){
		 		tipoActivo = "nave-industrial";
		 	}else if(CONST.TIPOS_ACTIVO['EDIFICIO_COMPLETO'] == tipoActivoCodigo){
		 		tipoActivo = "edificio";
		 	}else if(CONST.TIPOS_ACTIVO['EN_CONSTRUCCION'] == tipoActivoCodigo){
		 		tipoActivo = "en-construccion";
		 	}else if(CONST.TIPOS_ACTIVO['OTROS'] == tipoActivoCodigo){
		 		tipoActivo = "garaje-trastero";
		 	}
		 		
		 		return '<a href="' + HreRem.i18n('fieldlabel.link.web.haya').replace("vivienda",tipoActivo) + get('agrupacionficha.idNumActivoPrincipal')+'?utm_source=rem&utm_medium=aplicacion&utm_campaign=activo " target="_blank">' + get('agrupacionficha.estadoAlquilerDescripcion') + '</a>'
		 	}else {
		 		return get('agrupacionficha.estadoAlquilerDescripcion');
		 	}
		 },
		 getValueNumAgrupacion: function(get){
			 if(get('esAgrupacionObraNueva') && get('agrupacionficha.numeroPublicados')>0){			 		
			 		return '<a href="' + HreRem.i18n('fieldlabel.link.web.haya.on') + get('agrupacionficha.numAgrupRem')+
			 		'?utm_source=rem&utm_medium=aplicacion&utm_campaign=agrupacion " target="_blank">' + get('agrupacionficha.numAgrupRem') + '</a>'
			 	}else {
			 		return get('agrupacionficha.numAgrupRem');
			 	}
		 },
		 comercializableConstruccionPlano: function(get){
			 return "true"===get('agrupacionficha.comercializableConsPlano');
		 },
		 
		 comprobarExistePiloto: function(get){
			 return "true"===get('agrupacionficha.existePiloto');
		 },
		 
		 comprobarEsVisitable: function(get){
			 return "true"===get('agrupacionficha.esVisitable');
		 },
		 
		 existePisoPilotoAndcomercializableConstruccionPlano: function(get){
			 return "true"===get('agrupacionficha.comercializableConsPlano') && "true"===get('agrupacionficha.existePiloto');
		 },
		 
		 esAgrupacionThirdpartiesYubaiObraNueva: function(get) {
			 	if(get('agrupacionficha.codigoCartera') == CONST.CARTERA['THIRDPARTIES']
			     		&& get('agrupacionficha.codSubcartera') == CONST.SUBCARTERA['YUBAI']
			     		&& get('agrupacionficha.tipoAgrupacionCodigo') == CONST.TIPOS_AGRUPACION['OBRA_NUEVA']) {
		     		return true;
		     	} else {
		     		return false;
		     	}
		},
		
		/*habilitaPestanyaDocumentos : function (get) {
				if (get('agrupacionficha'))
		}*/
		    
		esOtrosotivoAutorizacionTramitacion: function(get){
			var me = this;
			
			var comboOtros = get('comercialagrupacion.motivoAutorizacionTramitacionCodigo');
			
			if(CONST.DD_MOTIVO_AUTORIZACION_TRAMITE['COD_OTROS'] == comboOtros){
				return true;
			}
			me.set('comercialagrupacion.observacionesAutoTram', null);
		return false;
		},
		
		esSelecionadoAutorizacionTramitacion: function(get){
			var me = this;
			var editing = get('editing');
			var todoSelec = get('comercialagrupacion.motivoAutorizacionTramitacionCodigo');
			var obsv = get('comercialagrupacion.observacionesAutoTram');
			if(editing){
				if(todoSelec != undefined && todoSelec != null){
					if(CONST.DD_MOTIVO_AUTORIZACION_TRAMITE['COD_OTROS'] == todoSelec){
						if(obsv){
							return true;
						}
						return false;
					} else {
						return true;
					}
				}
			}
			return false;
		},
		
		usuarioEditarAgrupaciones: function(get){
			return $AU.userHasFunction("EDITAR_LIST_AGRUPACIONES");
		},
		esEditableExcluirValidaciones: function(get){
			var perfiles = $AU.userHasFunction('EDITAR_EXCLUIR_VALIDACIONES');
			return !perfiles;
		},
	     
	     esAgrupacionCaixa: function(get) {
	    	var me = this;
	    	var tipoCartera = get('agrupacionficha.codigoCartera');
	    	var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
	    	
    		if(tipoCartera == CONST.CARTERA['BANKIA']
    			&& (tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA'] 
    			|| tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_ALQUILER'] 
    			|| tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_OBREM'])) {
		    		return true;
	    	}
	    	return false;
	     },
	     
	     esAgrupacionCaixaOrPromocionAlquiler: function(get) {
				return get('esAgrupacionCaixa') || get('esAgrupacionPromocionAlquiler'); 
	     },
	     esAgrupacionCaixaComercial: function(get){
	     	var me = this;
	    	var tipoCartera = me.getData().agrupacionficha.getData().codigoCartera;
	    	var tipoAgrupacion = me.getData().agrupacionficha.getData().tipoAgrupacionCodigo;	    	
    		if(tipoCartera == CONST.CARTERA['BANKIA']
    			&& (tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA'] 
    			|| tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_ALQUILER'] 
    			|| tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_OBREM'])) {
		    		return true;
	    	}
	    	return false;
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
    	
    	storeDescripcionFoto: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'descripcionesFoto'}
			},
			autoLoad: true,
			remoteFilter: false,
			filters: {
    			property: 'codigoSubtipoActivo',
    			value: '{fotoSelected.codigoSubtipoActivo}'  
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
		        extraParams: {id: '{subdivisionFoto.id}', agrId: '{subdivisionFoto.agrupacionId}', codigoSubtipoActivo: '{subdivisionFoto.codigoSubtipoActivo}'}
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
			}
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
	    comboTipoAlquiler: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposAlquilerActivo'}
			}
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
		
		comboTrueFalse: {
			data : [
		        {"codigo":"true", "descripcion":eval(String.fromCharCode(34,83,237,34))},
		        {"codigo":"false", "descripcion":"No"}
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
		}, 
		
		comboMotivoAutorizacionTramitacion: {
			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'motivoAutorizacionTramitacion'}
				}
    },
		tiposAdjuntoAgrupacion : {
			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario', 
					extraParams: {diccionario: 'tipoDocumentoAgrupacion'}
				},
				autoLoad: true
		},
		storeDocumentosAgrupacion: {
			 pageSize: $AC.getDefaultPageSize(),
			 model: 'HreRem.model.AdjuntoActivoAgrupacion',
     	     proxy: {
     	        type: 'uxproxy',
     	        remoteUrl: 'agrupacion/getListAdjuntosAgrupacion',
     	        extraParams: {idAgrupacion: '{agrupacionficha.numAgrupRem}'}
         	 },
         	 groupField: 'descripcionTipo',
		     remoteSort: true,
         	 autoLoad: true
		},
		comboMotivoDeExcluido: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivoGestionComercial'}
			},
			autoLoad: true
		},
		comboRiesgoOperacion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoRiesgoOperacion'}
			},
			autoLoad: false
		}
    }
});