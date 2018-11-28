Ext.define('HreRem.view.activos.detalle.ActivoDetalleModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.activodetalle',
    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.Gestor', 'HreRem.model.GestorActivo', 
    'HreRem.model.AdmisionDocumento', 'HreRem.model.AdjuntoActivo', 'HreRem.model.BusquedaTrabajo',
    'HreRem.model.IncrementoPresupuesto', 'HreRem.model.Distribuciones', 'HreRem.model.Observaciones',
    'HreRem.model.Carga', 'HreRem.model.Llaves', 'HreRem.model.PreciosVigentes','HreRem.model.VisitasActivo',
    'HreRem.model.OfertaActivo', 'HreRem.model.PropuestaActivosVinculados', 'HreRem.model.HistoricoMediadorModel','HreRem.model.AdjuntoActivoPromocion',
    'HreRem.model.MediadorModel', 'HreRem.model.MovimientosLlave', 'HreRem.model.ActivoPatrimonio', 'HreRem.model.HistoricoAdecuacionesPatrimonioModel',
    'HreRem.model.ImpuestosActivo','HreRem.model.OcupacionIlegal','HreRem.model.HistoricoDestinoComercialModel'],

    data: {
    	activo: null,
    	ofertaRecord: null,
    	activoCondicionantesDisponibilidad: null
    },

    formulas: {
	     
    	/**
    	 * Formula para generar el objeto center que servirá para cargar el componente gmap
    	 * @param {} get
    	 * @return {}
    	 */
	     geoCodeAddr: function (get) {
	     	 var tipoVia = Ext.isEmpty(get('activo.tipoViaDescripcion')) ? "" : get('activo.tipoViaDescripcion'),
	     	 nombreVia = Ext.isEmpty(get('activo.nombreVia')) ? "" : get('activo.nombreVia'),
	     	 numero = Ext.isEmpty(get('activo.numeroDomicilio')) ? "" : get('activo.numeroDomicilio'),
	     	 municipio = Ext.isEmpty(get('activo.municipioDescripcion')) ? "" : get('activo.municipioDescripcion'),
	     	 provincia = Ext.isEmpty(get('activo.provinciaDescripcion')) ? "" : get('activo.provinciaDescripcion'),
			 geoCodeAddr = "";
	     	 geoCodeAddr = tipoVia + " " + nombreVia + " " + numero + " " + municipio + " " + provincia;

	     	 return geoCodeAddr;
	     },

	     tieneDivisionHorizontal: function(get) {
	     	var tieneDivision = Ext.isEmpty(get('activo.divHorizontal')) ? false : get('activo.divHorizontal') === "1";	 
	     	
	     	if(!Ext.isEmpty(get('datosRegistrales.divHorizontal'))) {	     		
	     		tieneDivision =  get('datosRegistrales.divHorizontal') == "1";	
	     	}
	     	
	     	if(!Ext.isEmpty(get('activoAdmision.divHorizontal'))) {	     		
	     		tieneDivision =  get('activoAdmision.divHorizontal') == "1";	
	     	}

	     	return tieneDivision;
	     },

	     esOcupacionLegal: function(get) {
	     	var ocupado = get('situacionPosesoria.ocupado') == "1";
	     	var conTitulo = get('situacionPosesoria.conTitulo') == "1";
	     	
	     	return ocupado && conTitulo;
	     },

	     esSituacionJudicial: function(get){
	     	return Ext.isEmpty(get('activo.tipoTituloCodigo')) ? false : get('activo.tipoTituloCodigo') === CONST.TIPO_TITULO_ACTIVO['JUDICIAL'];
	     },

	     esOcupacionIlegal: function(get) {
	     	var ocupado = get('situacionPosesoria.ocupado') == "1";
	     	var conTitulo = get('situacionPosesoria.conTitulo') == "1";
	     	var gridHistoricoOcupacionesIlegales = this.getView().lookupReference('historicoocupacionesilegalesgridref');
			var fieldHistoricoOcupacionesIlegales = this.getView().lookupReference('fieldHistoricoOcupacionesIlegales');

			var hayDatosEnStore = gridHistoricoOcupacionesIlegales.store.data.length>0
			if(hayDatosEnStore  || ocupado){
				fieldHistoricoOcupacionesIlegales.show();
			}else {
				fieldHistoricoOcupacionesIlegales.hide();
			}

	     	return ocupado && !conTitulo;
	     },

	     getIconClsEstadoAdmision: function(get) {
	     	var estadoAdmision = get('activo.admision');
	     	
	     	if(estadoAdmision) {
	     		return 'app-tbfiedset-ico icono-ok';
	     	} else {
	     		return 'app-tbfiedset-ico icono-ko';
	     	}
	     },

	     getIconClsEstadoSituacionComercial: function(get){
			var estadoSituacionComercial= get('estadoSituacionComercial');

			if(estadoSituacionComercial) {
				return 'app-tbfiedset-ico icono-ok';
	        } else {
	            return 'app-tbfiedset-ico icono-ko';
	        }
	     },

	     getIconClsEstadoVenta: function(get) {
			var estadoVenta = get('activo.estadoVenta');

	        if(estadoVenta == 0) {
	            return 'app-tbfiedset-ico icono-ko';
	        } else if (estadoVenta == 1){
	            return 'app-tbfiedset-ico icono-ok';
	        }else if (estadoVenta == 2){
	            return 'app-tbfiedset-ico icono-okn';
	        }
		 },

		 getIconClsestadoAlquiler : function(get) {
			var estadoAlquiler = get('activo.estadoAlquiler');

			if (estadoAlquiler == 0) {
				return 'app-tbfiedset-ico icono-ko';
			} else if (estadoAlquiler == 1) {
				return 'app-tbfiedset-ico icono-ok';
			} else if (estadoAlquiler == 2) {
				return 'app-tbfiedset-ico icono-okn';
			}
		 },

	     getIconClsEstadoGestion: function(get) {
	     	var estadoAdmision = get('activo.tieneOkTecnico');

	     	if(estadoAdmision) {
	     		return 'app-tbfiedset-ico icono-ok';
	     	} else {
	     		return 'app-tbfiedset-ico icono-ko';
	     	}
	     },

	     getIconClsPrecioAprobadoVentaRenta: function(get) {
	     	var me = this;
	     	var aprobadoVentaWeb= get('activo.aprobadoVentaWeb');
	     	var aprobadoRentaWeb= get('activo.aprobadoRentaWeb');

	     	if(!Ext.isEmpty(aprobadoVentaWeb) && aprobadoVentaWeb>0 || !Ext.isEmpty(aprobadoRentaWeb) && aprobadoRentaWeb>0) {
	     		return 'app-tbfiedset-ico icono-ok';
	     	} else {
	     		return 'app-tbfiedset-ico icono-ko';
	     	}
	     },

	     //Condicionantes
	     getIconClsCondicionantesRuina: function(get) {
	    	var condicion = get('activoCondicionantesDisponibilidad.ruina');

	        if(!eval(condicion)) {
	            return 'app-tbfiedset-ico icono-ok';
	        } else {
	            return 'app-tbfiedset-ico icono-ko';
	        }
		 },

		 getIconClsCondicionantesPendiente: function(get) {
		 	var claseActivo= get('activo.claseActivoCodigo');

			if(CONST.CLASE_ACTIVO['FINANCIERO'] != claseActivo){
				var condicion = get('activoCondicionantesDisponibilidad.pendienteInscripcion');
			   	if(!eval(condicion)) {
			   		return 'app-tbfiedset-ico icono-ok';
			   	} else {
			   		return 'app-tbfiedset-ico icono-ko';
			   	}
			}

			return 'app-tbfiedset-ico';
		},

		getIconClsCondicionantesObraTerminada: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.obraNuevaSinDeclarar');

		    if(!eval(condicion)) {
		        return 'app-tbfiedset-ico icono-ok';
		    } else {
		        return 'app-tbfiedset-ico icono-ko';
		    }
		},

		getIconClsCondicionantesSinPosesion: function(get) {
			var claseActivo= get('activo.claseActivoCodigo');

			if(CONST.CLASE_ACTIVO['FINANCIERO'] != claseActivo){
				var condicion = get('activoCondicionantesDisponibilidad.sinTomaPosesionInicial');
				if(!eval(condicion)) {
					return 'app-tbfiedset-ico icono-ok';
				} else {
					return 'app-tbfiedset-ico icono-ko';
				}
			}

			return 'app-tbfiedset-ico'
		},

		getIconClsCondicionantesProindiviso: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.proindiviso');

		    if(!eval(condicion)) {
		        return 'app-tbfiedset-ico icono-ok';
		    } else {
		        return 'app-tbfiedset-ico icono-ko';
		    }
		 },

		getIconClsCondicionantesObraNueva: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.obraNuevaEnConstruccion');

		    if(!eval(condicion)) {
		        return 'app-tbfiedset-ico icono-ok';
		    } else {
		        return 'app-tbfiedset-ico icono-ko';
		    }
		},

		getIconClsCondicionantesOcupadoConTitulo: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.ocupadoConTitulo');

		    if(!eval(condicion)) {
		        return 'app-tbfiedset-ico icono-ok';
		    } else {
		        return 'app-tbfiedset-ico icono-ko';
		    }
		},

		getIconClsCondicionantesTapiado: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.tapiado');

		    if(!eval(condicion)) {
		        return 'app-tbfiedset-ico icono-ok';
		    } else {
		        return 'app-tbfiedset-ico icono-ko';
		    }
		 },
		getIconClsCondicionantesOcupadoSinTitulo: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.ocupadoSinTitulo');

		    if(!eval(condicion)) {
		        return 'app-tbfiedset-ico icono-ok';
		    } else {
		        return 'app-tbfiedset-ico icono-ko';
		    }
		 },

		getIconClsCondicionantesDivHorizontal: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.divHorizontalNoInscrita');

		    if(!eval(condicion)) {
		        return 'app-tbfiedset-ico icono-ok';
		    } else {
		        return 'app-tbfiedset-ico icono-ko';
		    }
		 },
		 getIconClsCondicionantesConCargas: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.conCargas');

		    if(!eval(condicion)) {
		        return 'app-tbfiedset-ico icono-ok';
		    } else {
		        return 'app-tbfiedset-ico icono-ko';
		    }
		 },
		 getIconClsCondicionantesSinInformeAprobado: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.sinInformeAprobado');

		    if(!eval(condicion)) {
		        return 'app-tbfiedset-ico icono-ok';
		    } else {
		        return 'app-tbfiedset-ico icono-ko';
		    }
		 },
		 getIconClsCondicionantesVandalizado: function(get) {
			 var condicion = get('activoCondicionantesDisponibilidad.vandalizado');

            if(!eval(condicion)) {
                return 'app-tbfiedset-ico icono-ok';
            } else {
                return 'app-tbfiedset-ico icono-ko';
            }
		},
		getIconClsCondicionantesSinAcceso: function(get) {
	        var condicion = get('activoCondicionantesDisponibilidad.sinAcceso');

            if(!eval(condicion)) {
                return 'app-tbfiedset-ico icono-ok';
            } else {
                return 'app-tbfiedset-ico icono-ko';
            }
         },
		getSiNoFromOtro: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.otro');

		    if(Ext.isEmpty(condicion)) {
		        return '0';
		    } else {
		        return '1';
		    }
		 },
		 //FinCondicionantes
	     
	     getSrcSelloCalidad: function(get) {
	     	
	     	var esCalidad = get('activo.selloCalidad');
	     	
	     	if(esCalidad) {
	     		return 'resources/images/sello_calidad.png';
	     	} else {
	     		return '';
	     	}
	     },
	     
	     getSrcCartera: function(get) {
	     	
	     	var cartera = get('activo.entidadPropietariaDescripcion');
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
	     
	     getEstadoPublicacionCodigo: function(get) {
			var codigo = Ext.isEmpty(get('activo.estadoPublicacionCodigo')) ? "" : get('activo.estadoPublicacionCodigo');
			return codigo;
		 },

		 estaPublicadoVentaOAlquiler: function(get) {
			 var estadoAlquilerCodigo = get('activo.estadoAlquilerCodigo');
			 var estadoVentaCodigo = get('activo.estadoVentaCodigo');
			 var incluyeDestinoComercialAlquiler = get('activo.incluyeDestinoComercialAlquiler');
			 var incluyeDestinoComercialVenta = get('activo.incluyeDestinoComercialVenta');

			 if(incluyeDestinoComercialVenta && incluyeDestinoComercialAlquiler) {
				 return estadoAlquilerCodigo === CONST.ESTADO_PUBLICACION_ALQUILER['PUBLICADO'] || estadoVentaCodigo === CONST.ESTADO_PUBLICACION_VENTA['PUBLICADO'];
			 } else if(incluyeDestinoComercialVenta) {
				 return estadoVentaCodigo === CONST.ESTADO_PUBLICACION_VENTA['PUBLICADO'];
			 } else if (incluyeDestinoComercialAlquiler){
				 return estadoAlquilerCodigo === CONST.ESTADO_PUBLICACION_ALQUILER['PUBLICADO'];
			 } else {
				 return false;
			 }
		 },

		 activoPertenceAgrupacionComercialOrRestringida: function(get) {
			 var restringida = get('activo.pertenceAgrupacionRestringida');
			 var comercial = get('activo.pertenceAgrupacionComercial');

			 if(restringida || comercial) {
				 return true;
			 } else {
				 return false;
			 }
		 },
		 
		 activoPerteneceAgrupacionComercial: function(get){
		 	 return get('activo.pertenceAgrupacionComercial');
		 },

		 activoPerteneceAgrupacionRestringida: function(get){
		 	 return get('activo.pertenceAgrupacionRestringida');
		 },
		 
		 enableChkPerimetroAlquiler: function(get){
			 var esGestorAlquiler = get('activo.esGestorAlquiler');
			 var estadoAlquiler = get('patrimonio.estadoAlquiler');

			 if(esGestorAlquiler == true || esGestorAlquiler == "true" ){
				if(estadoAlquiler == CONST.COMBO_ESTADO_ALQUILER["ALQUILADO"] || estadoAlquiler == CONST.COMBO_ESTADO_ALQUILER["CON_DEMANDAS"]){
					return true;
				} else {
					return false;
				}
			 }else{
				 return true;
			 }
		 },

		 getLinkHayaActivo: function(get) {
			 if(get('activo.perteneceAgrupacionRestringidaVigente')) {
				 return get('activo.activoPrincipalRestringida');
			 } else {
				 return get('activo.numActivo');
			 }
		 },

		 enableComboTipoAlquiler: function(get){
			var chkPerimetroAlquiler = get('patrimonio.chkPerimetroAlquiler');
			var tipoComercializacion = get('activo.tipoComercializacionCodigo');
			if((chkPerimetroAlquiler == true || chkPerimetroAlquiler == "true" ) && CONST.TIPOS_COMERCIALIZACION['VENTA'] != tipoComercializacion){
				return false;
			}else{
				return true;
			}
		 },

		 enableComboAdecuacion: function(get){
			var chkPerimetroAlquiler = get('patrimonio.chkPerimetroAlquiler');
			if((chkPerimetroAlquiler == true || chkPerimetroAlquiler == "true" )){
				return false;
			}else{
				return true;
			}
		 },

		 enableComboRentaAntigua: function(get){
			var chkPerimetroAlquiler = get('patrimonio.chkPerimetroAlquiler');
			var situacionActivo = get('activo.situacionComercialCodigo');
			if((chkPerimetroAlquiler == true || chkPerimetroAlquiler == "true" ) && CONST.SITUACION_COMERCIAL['ALQUILADO'] == situacionActivo){
				return false;
			}else{
				return true;
			}
		 },

		 enableCheckPerimetroAlquiler: function(get){
		 	var comboEstadoAlquiler = get('patrimonio.estadoAlquiler');

		 	if(comboEstadoAlquiler != null){
		 		if(comboEstadoAlquiler.value == CONST.COMBO_ESTADO_ALQUILER["ALQUILADO"] || comboEstadoAlquiler.value == CONST.COMBO_ESTADO_ALQUILER["CON_DEMANDAS"]){
			 		return true;
		 		}
		 	}
		 	return false;
		 },

		 esEditableCodigoPromocion: function(get){
			 var isGestorActivos = $AU.userIsRol('HAYAGESACT') || $AU.userIsRol('HAYAGESTADM');
			 var isLiberbank = get('activo.isCarteraLiberbank');
			 if(isGestorActivos && isLiberbank) return true;
			 else return false;
		 },

		 enableComboTipoAlquiler: function(get){
			var chkPerimetroAlquiler = get('patrimonio.chkPerimetroAlquiler');
			var tipoComercializacion = get('activo.tipoComercializacionCodigo');
			if((chkPerimetroAlquiler == true || chkPerimetroAlquiler == "true" ) && CONST.TIPOS_COMERCIALIZACION['VENTA'] != tipoComercializacion){
				return false;
			}else{
				return true;
			}
		},

		enableComboAdecuacion: function(get){
			var chkPerimetroAlquiler = get('patrimonio.chkPerimetroAlquiler');
			if((chkPerimetroAlquiler == true || chkPerimetroAlquiler == "true" )){
				return false;
			}else{
				return true;
			}
		},

		filtrarComboMotivosOcultacionVenta: function(get) {
			var bloqueoCheckOcultar = get('datospublicacionactivo.deshabilitarCheckOcultarVenta');

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
            var bloqueoCheckOcultar = get('datospublicacionactivo.deshabilitarCheckOcultarAlquiler');

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

        debePreguntarPorTipoPublicacionAlquiler: function(get) {
            var publicarSinPrecioAlquiler = get('datospublicacionactivo.publicarSinPrecioAlquiler');
            var informeComercialAprobado = get('activo.informeComercialAceptado');
            var precioRentaWeb = !Ext.isEmpty(get('datospublicacionactivo.precioWebAlquiler'));
            return (informeComercialAprobado || !informeComercialAprobado) && (publicarSinPrecioAlquiler || precioRentaWeb);
        },

        esReadonlyChkbxPublicar: function(get){
			var activoVendido = get('activo.isVendido');

			var ponerPublicarAReadonly = false;
			if(activoVendido) {
				ponerPublicarAReadonly = true;
			}

			return ponerPublicarAReadonly;
		},

		esEditableChkbxComercializar: function(get){
			var activoVendido = get('activo.isVendido');

			return activoVendido;
		},

		esVisibleTipoPublicacionVenta: function(get){
			var estadoVenta = get('datospublicacionactivo.estadoPublicacionVenta');
			var tipoPublicacionVenta = get('datospublicacionactivo.tipoPublicacionVentaDescripcion');

			if(!Ext.isEmpty(estadoVenta) && estadoVenta != CONST.DESCRIPCION_PUBLICACION['OCULTO_VENTA']){
				return tipoPublicacionVenta;
			}else{
				return null;
			}

		},

		esVisibleTipoPublicacionAlquiler: function(get){
			var estadoAlquiler = get('datospublicacionactivo.estadoPublicacionAlquiler');
			var tipoPublicacionAlquiler = get('datospublicacionactivo.tipoPublicacionAlquilerDescripcion');

			if(!Ext.isEmpty(estadoAlquiler) && estadoAlquiler != CONST.DESCRIPCION_PUBLICACION['OCULTO_ALQUILER']){
				return tipoPublicacionAlquiler;
			} else {
				return null;
			}

		},

		isReadOnlyFechaRealizacionPosesion: function(get){
			var me = this;

			var isSareb = get('activo.isCarteraSareb');
	    	var isCerberus = get('activo.isCarteraCerberus');

			if(isSareb || isCerberus){
				return true;
			}

			return false;
		 },

		 esEditableComboEstadoAlquiler: function(get){
			var comboOcupacion = get('activo.ocupado');

			return comboOcupacion == CONST.COMBO_OCUPACION["SI"];
		},

		enableComboTipoInquilino: function(get){
			var comboEstadoAlquiler = get('patrimonio.estadoAlquiler');

			return (Ext.isEmpty(comboEstadoAlquiler) && comboEstadoAlquiler == CONST.COMBO_ESTADO_ALQUILER["LIBRE"]);
		},

		esTipoEstadoAlquilerAlquilado: function(get){
			var estadoAlquilerCodigo = get('situacionPosesoria.tipoEstadoAlquiler');

			return (CONST.COMBO_ESTADO_ALQUILER["ALQUILADO"] == estadoAlquilerCodigo);
		}

	 },



    stores: {
    		
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
					extraParams: {codigoProvincia: '{activo.provinciaCodigo}'}
				}
    		},
    		
    		    		
    		comboInferiorMunicipio: {
					model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'activo/getComboInferiorMunicipio',
						extraParams: {codigoMunicipio: '{activo.municipioCodigo}'}
   					}
    		},
    		
    		comboInferiorMunicipioMediadorIC: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'activo/getComboInferiorMunicipio',
					extraParams: {codigoMunicipio: '{infoComercial.municipioCodigo}'}
					}
    		},
    		
    		comboInferiorMunicipioAdmisionIC: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'activo/getComboInferiorMunicipio',
					extraParams: {codigoMunicipio: '{activoInforme.municipioCodigo}'}
					}
    		},
    		
    		comboMunicipioRegistro: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboMunicipio',
					extraParams: {codigoProvincia: '{datosRegistrales.provinciaRegistro}'}
				}
    		},
    		
    		comboMunicipioAdmisionIC: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboMunicipio',
					extraParams: {codigoProvincia: '{activoInforme.provinciaCodigo}'}
				}
    		},

    		comboMunicipioMediadorIC: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboMunicipio',
					extraParams: {codigoProvincia: '{infoComercial.provinciaCodigo}'}
				}
    		},    		
    		
    		comboUsuarios: {
				model: 'HreRem.model.ComboBase',
				proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getComboUsuarios',
				extraParams: {idTipoGestor: '{tipoGestor.selection.id}'}
				}
    		},
    		
    		comboTiposCarga: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposCarga'}
				}
    		},
    		
    		comboTiposPersona: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tipoPersona'}
				}
    		},
    		
    		comboProvincias: {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'provincias'}
				}
    		},
    		
    		comboPoblacion: {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboMunicipio',
					extraParams: {codigoProvincia: '{propietario.provinciaCodigo}'}
				}
    		},
    		comboProvinciasContacto: {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'provincias'}
				}
    		},
    		
    		comboPoblacionContacto: {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboMunicipio',
					extraParams: {codigoProvincia: '{propietario.provinciaContactoCodigo}'}
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
    		
    		comboGradoPropiedad: {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposGradoPropiedad'}
				}
    		},
    		
    		comboSubtiposCarga: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoCarga',
					extraParams: {codigoTipoCarga: '{carga.tipoCargaCodigo}'}
				}
    		},

    		storeCargas: {    	
    		 pageSize: $AC.getDefaultPageSize(),
			 model : 'HreRem.model.ActivoCargas',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'activo/getListCargasById',
		        extraParams: {id: '{activo.id}'}
	    	 }
    		},
    		
    		storeObservaciones: {    
    		 pageSize: $AC.getDefaultPageSize(),
    		 model: 'HreRem.model.Observaciones',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'activo/getListObservacionesById',
		        extraParams: {id: '{activo.id}'}
	    	 }
    		},
    		
    		storeAgrupacionesActivo: {    	
    		 pageSize: $AC.getDefaultPageSize(),
    		 model: 'HreRem.model.AgrupacionesActivo',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'activo/getListAgrupacionesActivoById',
		        extraParams: {id: '{activo.id}'}
	    	 }
    		},
    		
    		storeVisitasActivo: {    	
       		 pageSize: $AC.getDefaultPageSize(),
       		 model: 'HreRem.model.VisitasActivo',
   		     proxy: {
   		        type: 'uxproxy',
   		        remoteUrl: 'activo/getListVisitasActivoById',
   		        extraParams: {id: '{activo.id}'}
   	    	 }
       		},
       		storeOfertasActivo: {  
	       		 pageSize: $AC.getDefaultPageSize(),
	       		 model: 'HreRem.model.OfertaActivo',
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
	   		        remoteUrl: 'activo/getListOfertasActivos',
	   		        extraParams: {
	   		        	id: '{activo.id}',
	   		        	incluirOfertasAnuladas: false
	   		        }
	   	    	 }
       		},
    		
    		storeFotos: {    			
    		 model: 'HreRem.model.Fotos',
		     proxy: {
		        type: 'uxproxy',
		        //remoteUrl: 'activo/getFotosById',
		        api: {
		            read: 'activo/getFotosById',
		            create: 'activo/getFotosById',
		            update: 'activo/updateFotosById',
		            destroy: 'activo/destroy'
		        },
		        extraParams: {id: '{activo.id}', tipoFoto: '01'}
		     }, autoLoad: false
		     /*   remoteUrl: 'activo/getFotosById',
		        extraParams: {id: '{activo.id}'}
	    	 }*/
    		},
    		
    		storeFotosTecnicas: {    			
    		 model: 'HreRem.model.Fotos',
		     proxy: {
		        type: 'uxproxy',
		        api: {
		            read: 'activo/getFotosById',
		            create: 'activo/getFotosById',
		            update: 'activo/updateFotosById',
		            destroy: 'activo/destroy'
		        },
		        extraParams: {id: '{activo.id}', tipoFoto: '02'}
		     }, autoLoad: false
    		},

    		storeOcupantesLegales: {    			
       		 model: 'HreRem.model.OcupantesLegales',
   		     proxy: {
   		        type: 'uxproxy',
   		        remoteUrl: 'activo/getListOcupantesLegalesById',
   		        extraParams: {id: '{activo.id}'}
   	    	 }
       		},
       		
       		storeHistoricoOcupacionesIlegales: {
         		pageSize: 10,
         		model: 'HreRem.model.OcupacionIlegal',
         		sorters: [{ property: 'numAsunto', direction: 'DESC' }],
         		proxy: {
         			type: 'uxproxy',
         			remoteUrl: 'activo/getListHistoricoOcupacionesIlegales',
			        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'},
			        extraParams: {idActivo: '{activo.id}'}
		    	},
	         	remoteSort: true,
		    	remoteFilter: true
        	},

    		storeLlaves: {
	    		pageSize: 10,
	     		model: 'HreRem.model.Llaves',
	 		    proxy: {
	 		        type: 'uxproxy',
	 		        remoteUrl: 'activo/getListLlavesById',
			        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
	 	    	},
	       		remoteSort: true,
		    	remoteFilter: true,
		    	listeners : {
		            beforeload : 'beforeLoadLlaves'
		    	}
         	},
         	
         	storeMovimientosLlave: {
         		pageSize: 10,
         		model: 'HreRem.model.MovimientosLlave',
         		sorters: [{ property: 'fechaDevolucion', direction: 'DESC' }],
         		proxy: {
         			type: 'uxproxy',
         			remoteUrl: 'activo/getListMovimientosLlaveByLlave',
			        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
		    	},
	         	remoteSort: true,
		    	remoteFilter: true,
		    	listeners : {
		            beforeload : 'beforeLoadMovimientosLlave'
		        }
        	},
    		
    		storeCatastro: {    			
    		 model: 'HreRem.model.Catastro',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'activo/getListCatastroById',
		        extraParams: {id: '{activo.id}'}
	    	 }
    		},
    		
    		storePreciosVigentes: {
       		 model: 'HreRem.model.PreciosVigentes',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'activo/getPreciosVigentesById',
		        extraParams: {id: '{activo.id}'}
	    	 }
    		},
    		
    		storeDocumentacionAdministrativa: {    			
    		 model: 'HreRem.model.Catastro',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'activo/getListDocumentacionAdministrativaById',
		        extraParams: {id: '{activo.id}'}
	    	 }
    		},

    		storeGestoresActivos: {
    			pageSize: $AC.getDefaultPageSize(),
				model: 'HreRem.model.GestorActivo',
			   	proxy: {
			   		type: 'uxproxy',
			   	    remoteUrl: 'activo/getGestoresActivos',
			   	    extraParams: {
			   	    	idActivo: '{activo.id}',
			   	    	incluirGestoresInactivos: false
			   	    }
			    }
    		},

    		storeGestores: {
    			pageSize: $AC.getDefaultPageSize(),
				model: 'HreRem.model.GestorActivo',
			   	proxy: {
			   		type: 'uxproxy',
			   	    remoteUrl: 'activo/getGestores',
			   	    extraParams: {idActivo: '{activo.id}'}
			    }
    		},

    		storePropietario: {
				 model: 'HreRem.model.ActivoPropietario',
				 proxy: {
				    type: 'uxproxy',
					remoteUrl: 'activo/getListPropietarioById',
					extraParams: {id: '{activo.id}'}
				 }
    		},
    		
    		storeValoraciones: {
				 model: 'HreRem.model.ActivoValoraciones',
				 proxy: {
				    type: 'uxproxy',
					remoteUrl: 'activo/getListValoracionesById',
					extraParams: {id: '{activo.id}'}
				 }
    		},
    		
    		storeGestoresActivos: {
    			pageSize: $AC.getDefaultPageSize(),
				model: 'HreRem.model.GestorActivo',
			   	proxy: {
			   		type: 'uxproxy',
			   	    remoteUrl: 'activo/getGestoresActivos',
			   	    extraParams: {
			   	    	idActivo: '{activo.id}',
			   	    	incluirGestoresInactivos: false
			   	    }
			    }
    		},

    		storeDistribuciones: {
				 model: 'HreRem.model.Distribuciones',
				 proxy: {
				    type: 'uxproxy',
					remoteUrl: 'activo/getListDistribucionesById',
					extraParams: {id: '{activo.id}'}
				 },
				 groupField: 'numPlanta'
    		},

    		storeTasaciones: {
				 model: 'HreRem.model.ActivoTasacion',
				 sorters: [{ property: 'fechaValorTasacion', direction: 'DESC' }],
				 proxy: {
				    type: 'uxproxy',
					remoteUrl: 'activo/getListTasacionById',
					extraParams: {id: '{activo.id}'}
				 }
    		},
    		
    		storeTasacionesGrid: {
				 model: 'HreRem.model.ActivoTasacion',
				 sorters: [{ property: 'fechaValorTasacion', direction: 'DESC' }],
				 proxy: {
				    type: 'uxproxy',
					remoteUrl: 'activo/getListTasacionByIdGrid',
					extraParams: {id: '{activo.id}'}
				 }
    		},
    		
    		tipoTasacionStore: {    		
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tipoTasacion'}
				},  		
				autoLoad: true
			},

    		storeTramites: {
    			 model: 'HreRem.model.Tramite',
	      	     proxy: {
	      	        type: 'uxproxy',
	      	        remoteUrl: 'activo/getTramites',
	      	        extraParams: {idActivo: '{activo.id}'}
	          	 }
    		},

    		storeAdmisionCheckDocumentos: {
    			 pageSize: $AC.getDefaultPageSize(),
    			 model: 'HreRem.model.AdmisionDocumento',
	      	     proxy: {
	      	        type: 'uxproxy',
	      	        remoteUrl: 'activo/getListAdmisionCheckDocumentos',
	      	        extraParams: {id: '{activo.id}'}
	          	 }
    		},    		
    		    		
    		storeDocumentosActivo: {
    			 pageSize: $AC.getDefaultPageSize(),
    			 model: 'HreRem.model.AdjuntoActivo',
	      	     proxy: {
	      	        type: 'uxproxy',
	      	        remoteUrl: 'activo/getListAdjuntos',
	      	        extraParams: {id: '{activo.id}'}
	          	 },
	          	 groupField: 'descripcionTipo'
    		},

    		storeDocumentosActivoPromocion: {
   			 pageSize: $AC.getDefaultPageSize(),
   			 model: 'HreRem.model.AdjuntoActivoPromocion',
	      	     proxy: {
	      	        type: 'uxproxy',
	      	        remoteUrl: 'promocion/getListAdjuntosPromocion',
	      	        extraParams: {id:'{activo.id}'}
	          	 },
	          	 groupField: 'descripcionTipo',
	          	 autoLoad: false
    		},

    		historicoTrabajos: {
				pageSize: $AC.getDefaultPageSize(),
		    	model: 'HreRem.model.BusquedaTrabajo',
		    	proxy: {
			        type: 'uxproxy',
			        localUrl: '/trabajos.json',
			        remoteUrl: 'trabajo/findAll',
		        	extraParams: {idActivo: '{activo.id}'},
		        	actionMethods: {read: 'POST'} // Necesario para que el filtro no se mande en la URL lo que provoca un problema de encoding
		        	
		    	},	    		
		    	remoteSort: true,
		    	remoteFilter: true,	    	
		    	autoLoad: false
	    	},
	    	
	    	filtroComboSubtipoTrabajo: {    		
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'subtiposTrabajo'}
				}  		
			},
			
			storeHistoricoPresupuestos: {
				pageSize: 3,
		    	model: 'HreRem.model.Presupuesto',
		    	proxy: {
			        type: 'uxproxy',
			        timeout: 50000,
			        localUrl: '/activos.json',
			        remoteUrl: 'activo/findAllHistoricoPresupuestos',
		        	extraParams: {idActivo: '{activo.id}'}
		    	},	    		
		    	remoteSort: true,
		    	remoteFilter: true,	    	
		    	autoLoad: false
	    	},
	    	
	    	storeIncrementosPresupuesto: {
				pageSize: 3,
		    	model: 'HreRem.model.IncrementoPresupuesto',
		    	proxy: {
			        type: 'uxproxy',
			        localUrl: '/activos.json',
			        remoteUrl: 'activo/findAllIncrementosPresupuestoById',
		        	extraParams: {idActivo: '{activo.id}'}
		    	},	    		
		    	remoteSort: false,
		    	remoteFilter: false,	    	
		    	autoLoad: false
	    	},
	    	
    		comboSubtipoActivo: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoActivo',
					extraParams: {codigoTipoActivo: '{activo.tipoActivoCodigo}'}
				}
    		},
	    	    		
    		comboSubtipoActivoAdmision: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoActivo',
					extraParams: {codigoTipoActivo: '{activoAdmision.tipoActivoCodigo}'}
				}
    		},

    		comboSubtipoActivoAdmisionIC: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoActivo',
					extraParams: {codigoTipoActivo: '{activoInforme.tipoActivoCodigo}'}
				}
    		},

    		comboSubtipoActivoMediadorIC: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoActivo',
					extraParams: {codigoTipoActivo: '{infoComercial.tipoActivoCodigo}'}
				}
    		},    		
    		    		
    		comboMunicipioAdmision: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboMunicipio',
					extraParams: {codigoProvincia: '{activoAdmision.provinciaCodigo}'}
				}
    		},
    		
    		    		
    		comboInferiorMunicipioAdmision: {
					model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'activo/getComboInferiorMunicipio',
						extraParams: {codigoMunicipio: '{activoAdmision.municipioCodigo}'}
   					}
    		},
    		
    		comboMunicipioRegistroAdmision: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboMunicipio',
					extraParams: {codigoProvincia: '{datosRegistralesAdmision.provinciaRegistro}'}
				}
    		},
    		
    		comboSubtipoTituloAdmision: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'subtiposTitulo'}
				},
				filters: {
                    property: 'codigoTipoTitulo',
                    value: '{datosRegistralesAdmision.tipoTituloCodigo}'
				}
    		},
    		
    		comboSubtipoTitulo: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'subtiposTitulo'}
				},
				filters: {
                    property: 'codigoTipoTitulo',
                    value: '{datosRegistrales.tipoTituloCodigo}'
				}
    		},
    		
    		comboAcabadoCarpinteria: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'acabadosCarpinteria'}
				}
    		},
    		/*
    		comboTipoComercializacionActivo: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposComercializacionActivo'}
				}
    		},*/
    		
    		comboMotivoAplicaComercializarActivo: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'motivoAplicaComercializarActivo'}
				}
    		},
    		
    		comboMotivoNoAplicaComercializarActivo: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'motivoNoAplicaComercializarActivo'}
				}
    		},

    		comboClaseActivoBancario: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'claseActivoBancario'}
				}
    		},
    		
    		comboSubtipoClaseActivoBancario: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoClaseActivo',
					extraParams: {tipoClaseActivoCodigo: '{activo.claseActivoCodigo}'}
				}
    		},
    		
    		comboTipoProductoBancario: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tipoProductoBancario'}
				}
    		},
    		
    		comboEstadoExpRiesgoBancario: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadoExpRiesgoBancario'}
				}
    		},
    		
    		comboEstadoExpIncorrienteBancario: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadoExpIncorrienteBancario'}
				}
    		},

    		comboEntradaActivoBankia: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'entradaActivoBankia'}
				}
    		},

    		historicocondiciones: {    
    			pageSize: $AC.getDefaultPageSize(),
    			model: 'HreRem.model.CondicionEspecifica',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'activo/getCondicionEspecificaByActivo',
    				extraParams: {id: '{activo.id}'}
    			}
    		},
    		
    		historicoEstadosPublicacionVenta: {
    			pageSize: $AC.getDefaultPageSize(),
    			model: 'HreRem.model.HistoricoEstadosPublicacion',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'activo/getHistoricoEstadosPublicacionVentaByIdActivo',
    				extraParams: {idActivo: '{activo.id}'}
    			}
    		},

    		historicoEstadosPublicacionAlquiler: {
    			pageSize: $AC.getDefaultPageSize(),
    			model: 'HreRem.model.HistoricoEstadosPublicacion',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'activo/getHistoricoEstadosPublicacionAlquilerByIdActivo',
    				extraParams: {idActivo: '{activo.id}'}
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

    		comboMotivosOcultacionAlquiler: {
                model: 'HreRem.model.ComboBase',
                proxy: {
                    type: 'uxproxy',
                    remoteUrl: 'generic/getDiccionario',
                    extraParams: {diccionario: 'motivosOcultacion'}
                }
            },

    		historicoInformeComercial:{
    			pageSize: $AC.getDefaultPageSize(),
    			model: 'HreRem.model.InformeComercial',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'activo/getEstadoInformeComercialByActivo',
    				extraParams: {id: '{activo.id}'}
    			}
    		},
    		
    		storeHistoricoMediador:{
    			pageSize: $AC.getDefaultPageSize(),
    			model: 'HreRem.model.HistoricoMediadorModel',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'activo/getHistoricoMediadorByActivo',
    				extraParams: {id: '{activo.id}'}
    			}
    		},
    		
    		storeMediadorListFiltered: {
    			model: 'HreRem.model.MediadorModel',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'proveedores/getMediadorListFiltered',
					extraParams: {idActivo : '{activo.id}'}
				}
    		},
    		
    		storeHistoricoValoresPrecios : {    			
    			pageSize: $AC.getDefaultPageSize(),
		    	proxy: {
			        type: 'uxproxy',
			        remoteUrl: 'activo/getHistoricoValoresPrecios',
			        extraParams: {idActivo: '{activo.id}'}
		    	},
		    	sorters: [{ property: 'fechaFin', direction: 'DESC' }],
		        groupField: 'descripcionTipoPrecio'
    		},
    		
    		storePropuestasActivo: {
			    pageSize: $AC.getDefaultPageSize(),
		    	proxy: {
			        type: 'uxproxy',
			        remoteUrl: 'activo/getPropuestas',
					extraParams: {id: '{activo.id}'}
		    	},
		    	remoteSort: true,
		    	remoteFilter: true,
		    	listeners : {
		            beforeload : 'beforeLoadPropuestas'
		        }
		        
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
			
		comboSituacionComercial: {
			model: 'HreRem.model.DDBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'situacionComercial'}
			},
			autoLoad: true
		},
			
			
		comboEstadoOferta: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosOfertas'}
			},
			autoLoad: true

	    },

	    comboTipoOferta: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposOfertas'}
			}   	
	    },

	    comboTipoRechazoOferta: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoRechazoOferta'}
			},
			autoLoad: true
	    },
	    
	    comboMotivoRechazoOferta: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboMotivoRechazoOferta',
				extraParams: {tipoRechazoOfertaCodigo: '{ofertaRecord.tipoRechazoCodigo}'}
			}
	    },
	    
	    comboTipoDocumento: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposDocumentos'}
			},
			autoLoad: true   	
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
	    
	    comboUnidadPoblacional: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'unidadPoblacional'}
			} 	
    	},
    	
    	storePropuestaActivosVinculados:{
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.PropuestaActivosVinculados',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getPropuestaActivosVinculadosByActivo',
				extraParams: {idActivo: '{activo.id}'}
			}
		},
		
		storeProveedores: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.Proveedor',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getProveedorByActivo',
				extraParams: {idActivo: '{activo.id}'}
			}
		},
		
		storeImpuestosActivo: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.ImpuestosActivo',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getImpuestosByActivo',
				extraParams: {idActivo: '{activo.id}'}
			}
		},
		
		storeEntidades: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.Proveedor',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getProveedoresByActivoIntegrado',
				extraParams: {idActivo: '{activo.id}'}
			}
		},
		
		comboSiNoRemActivo: {
				data : [
			        {"codigo":"1", "descripcion":eval(String.fromCharCode(34,83,237,34))},
			        {"codigo":"0", "descripcion":"No"}
			    ]
			},
		
    	comboNumCartas: {
			data : [
		        {"codigo":1, "descripcion": "1"},
		        {"codigo":2, "descripcion": "2"},
		        {"codigo":3, "descripcion": "3"}			       
			 ]
    	},
		
		storeGastosProveedor: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.Gasto',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getGastoByActivo',
				extraParams: {idActivo: '{activo.id}'}
			},
			remoteSort: false,
		    remoteFilter: false,	    	
		    autoLoad: false
		},
		
		comboTipoComercializarActivo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposComercializarActivo'}
			}
		},
		
		//Se filtra, ya que en principio hay un registro de este diccionario que no corresponde, pero no lo eliminamos de BD
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

    	comboTipoInquilino: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposInquilino'}
			}
    	},


    	comboEstadoAlquiler: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposEstadoAlquiler'}
			}
    	},

		comboTipoTenedor: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoTenedor'}
			},
			autoLoad: true
		},

		comboRetencionPago: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivoRetencionPago'}
			}
		},

		comboSubtipoActivoOtros : {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboSubtipoActivo',
				extraParams: {codigoTipoActivo: '{activo.tipoActivoCodigo}'}
			}
		},

		comboManiobra: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'valoracionTrabajo'}
			}
		},

		storeOfertantesOfertaDetalle:{
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.OfertantesOfertaDetalleModel',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'ofertas/getOfertantesByOfertaId'
			}
		},

		storeHonorariosOfertaDetalle:{
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.HonorariosOfertaDetalleModel',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'ofertas/getHonorariosByActivoOferta'
			}
		},
		comboTipoProveedor: {
			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionarioSubtipoProveedor',
					extraParams: {codigoTipoProveedor: '03'}
				}
		},
		
		filtroComboPrescriptor: {
			model: 'HreRem.model.Proveedor',
			proxy: {
			type: 'uxproxy',
			remoteUrl: 'proveedores/getProveedores',
			extraParams: {tipoProveedorCodigo: '03', subtipoProveedorCodigo: '{tipoProveedor.selection.codigo}'}
			}
		},

		storeTipoObservacionActivo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoObservacionActivo'}
			},
			autoLoad: true
		},
		
		storeNumeroPlantas: {
			 model: 'HreRem.model.Distribuciones',
			 proxy: {
					type: 'uxproxy',
					remoteUrl: 'activo/getNumeroPlantasActivo',
					extraParams: {
						idActivo: '{activo.id}'
							}

				}
		},
		storeTipoHabitaculo: {
			 model: 'HreRem.model.Distribuciones',
			 proxy: {
					type: 'uxproxy',
					remoteUrl: 'activo/getTipoHabitaculoByNumPlanta',
					extraParams: {
						idActivo: '{activo.id}',
						numPlanta: '{comboNumeroPlantas.selection.numPlanta}'
							}

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

		storeHistoricoAdecuacionesAlquiler:{
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.HistoricoAdecuacionesPatrimonioModel',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getHistoricoAdecuacionesAlquilerByActivo',
				extraParams: {id: '{activo.id}'}
			}
		},

		storeHistoricoDestinoComercial: {
			 pageSize: 10,
	   		 model: 'HreRem.model.HistoricoDestinoComercialModel',
	   		 proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'activo/getHistoricoDestinoComercialByActivo',
		        extraParams: {id: '{activo.id}'}
	    	 }
   		}
     }    
});