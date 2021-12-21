Ext.define('HreRem.view.activos.detalle.ActivoDetalleModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.activodetalle',
    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.Gestor', 'HreRem.model.GestorActivo', 
    'HreRem.model.AdmisionDocumento', 'HreRem.model.AdjuntoActivo', 'HreRem.model.BusquedaTrabajo',
    'HreRem.model.IncrementoPresupuesto', 'HreRem.model.Distribuciones', 'HreRem.model.Observaciones',
    'HreRem.model.Carga', 'HreRem.model.Llaves', 'HreRem.model.PreciosVigentes','HreRem.model.VisitasActivo',
    'HreRem.model.OfertaActivo', 'HreRem.model.PropuestaActivosVinculados', 'HreRem.model.HistoricoMediadorModel','HreRem.model.AdjuntoActivoPromocion',
    'HreRem.model.MediadorModel', 'HreRem.model.MovimientosLlave', 'HreRem.model.ActivoPatrimonio', 'HreRem.model.HistoricoAdecuacionesPatrimonioModel',
    'HreRem.model.ImpuestosActivo','HreRem.model.OcupacionIlegal','HreRem.model.HistoricoDestinoComercialModel','HreRem.model.ActivosAsociados','HreRem.model.CalificacionNegativaModel',
    'HreRem.model.HistoricoTramtitacionTituloModel', 'HreRem.model.HistoricoGestionGrid', 'HreRem.model.ListaActivoGrid', 'HreRem.model.HistoricoFasesDePublicacion',
    'HreRem.model.AdjuntoActivoAgrupacion','HreRem.model.AdjuntoActivoProyecto','HreRem.model.DocumentacionAdministrativa', 'HreRem.model.ActivoPatrimonio',
    'HreRem.model.DocumentosTributosModel','HreRem.model.HistoricoSolicitudesPreciosModel','HreRem.model.SuministrosActivoModel', 'HreRem.model.ActivoEvolucion', 'HreRem.model.ActivoSaneamiento',
	'HreRem.model.ReqFaseVentaModel', 'HreRem.model.AgendaRevisionTituloGridModel', 'HreRem.model.SaneamientoAgenda', 'HreRem.model.CalificacionNegativaAdicionalModel',
	'HreRem.model.HistoricoTramitacionTituloAdicionalModel', 'HreRem.model.CalidadDatoFasesGridModel','HreRem.model.SituacionOcupacionalGridModel',
	'HreRem.model.DetalleOfertaModel', 'HreRem.model.ActivoInformacionAdministrativa'],

    data: {
    	activo: null,
    	ofertaRecord: null,
    	activoCondicionantesDisponibilidad: null,
    	editingFirstLevel: null
    },

    formulas: {
    	
    	editableCES: function(get){	
    		var isEditable = $AU.userIsRol('DIRTERRITORIAL') || $AU.userIsRol('HAYASUPER');
    		return isEditable;
    	},
	     
    	esEditableAsistenciaJuntaObligatoria: function(get){
    		var isEditable = $AU.userIsRol('HAYAADM') || $AU.userIsRol('HAYASADM') || $AU.userIsRol('HAYAGESTADMT') || $AU.userIsRol('HAYASUPER');
    		return isEditable;
    	},
    	
    	
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
	     
	     esAgrupacionObraNueva: function(get) {
	     	var tipoAgrupacion = get('activo.pertenceAgrupacionObraNueva');
	     	var user = $AU.userIsRol("HAYASUPER") || $AU.userIsRol("HAYAGESTCOM");
	     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['OBRA_NUEVA']) && user) {
	     		return true;
	     	} else {
	     		return false;
	     	}
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
	     	var conTitulo = get('situacionPosesoria.conTitulo') == "01";

			return ocupado && conTitulo;
	     },

	     esSituacionJudicial: function(get){
	    	 var tipoTituloCodigo = get('activo.tipoTituloCodigo');
			 var subtipoClaseActivoCodigo = get('activo.subtipoClaseActivoCodigo') == "02";
			
	    	 if(get('activo.unidadAlquilable') 
	    			 || ($AU.userIsRol(CONST.PERFILES['ASSET_MANAGEMENT']) && (('03' === tipoTituloCodigo || '04' === tipoTituloCodigo) || subtipoClaseActivoCodigo === true))){
	    		 return true;
	    	 }
	    	 else{
	    		 return Ext.isEmpty(get('activo.tipoTituloCodigo')) ? false : get('activo.tipoTituloCodigo') === CONST.TIPO_TITULO_ACTIVO['JUDICIAL'];
	    	 }
	     },

	     esOcupacionIlegal: function(get) {
	     	var ocupado = get('situacionPosesoria.ocupado') == "1";
	     	var conTitulo = get('situacionPosesoria.conTitulo') == "01";
	     	var gridHistoricoOcupacionesIlegales = this.getView().lookupReference('historicoocupacionesilegalesgridref');
			var fieldHistoricoOcupacionesIlegales = this.getView().lookupReference('fieldHistoricoOcupacionesIlegales');
			if(gridHistoricoOcupacionesIlegales != null && fieldHistoricoOcupacionesIlegales != null){
				var hayDatosEnStore = gridHistoricoOcupacionesIlegales.store.data.length>0
				if(hayDatosEnStore  || ocupado){
					fieldHistoricoOcupacionesIlegales.show();
				}else {
					fieldHistoricoOcupacionesIlegales.hide();
				}

		     	return ocupado && !conTitulo;
			}else{
				return ocupado && !conTitulo;
			}
	     },

	     getIconClsEstadoAdmision: function(get) {
	     	var admisionAntiguo = get('activo.admision');
	     	var estadoAdmision = get('activo.estadoAdmisionCodCabecera');
	     	var subestadoAdmision = get('activo.subestadoAdmisionCodCabecera');
	     	var perimetroAdmision = get('activo.perimetroAdmision');
	     	
	     	if(perimetroAdmision){
	     		if(estadoAdmision == CONST.ESTADO_ADMISION['CODIGO_SANEADO_REGISTRALMENTE']){
	     			return 'app-tbfiedset-ico icono-ok-green';
	     		}else if(estadoAdmision == CONST.ESTADO_ADMISION['CODIGO_PENDIENTE_SANEAMIENTO']
	     			&& subestadoAdmision == CONST.SUBESTADO_ADMISION['CODIGO_PENDIENTE_CARGAS']){
	     			return 'app-tbfiedset-ico icono-okn';
	     		}else{
	     			return 'app-tbfiedset-ico icono-ko-red';
	     		}
	     	}else{
	     		if(admisionAntiguo) {
		     		return 'app-tbfiedset-ico icono-ok-green';
		     	} else {
		     		return 'app-tbfiedset-ico icono-ko';
	     		}
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
		 
		 esActivoAlquilado : function(get) {
			 var comboEstadoAlquiler = get('patrimonio.estadoAlquiler');

			return comboEstadoAlquiler == CONST.COMBO_ESTADO_ALQUILER["ALQUILADO"];
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

	     getIconClsPrecio: function(get) {
	     	var aprobadoVentaWeb= get('activo.aprobadoVentaWeb');
	     	var aprobadoRentaWeb= get('activo.aprobadoRentaWeb');
	     	var incluyeDestinoComercialVenta= get('activo.incluyeDestinoComercialVenta');
	     	var incluyeDestinoComercialAlquiler= get('activo.incluyeDestinoComercialAlquiler');

	     	if((!Ext.isEmpty(aprobadoVentaWeb) && aprobadoVentaWeb>0 && incluyeDestinoComercialVenta)
	     			|| (!Ext.isEmpty(aprobadoRentaWeb) && aprobadoRentaWeb>0 && incluyeDestinoComercialAlquiler)) {
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
			var condicion = get('activoCondicionantesDisponibilidad.sinInformeAprobadoREM');

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
	     
	       isEmptySrcCartera: function(get) {
	     	var cartera = get('activo.entidadPropietariaDescripcion');
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

		  estaPublicadoVenta: function(get) {
			 var estadoVentaCodigo = get('activo.estadoVentaCodigo');
			 var incluyeDestinoComercialVenta = get('activo.incluyeDestinoComercialVenta');

			 if(incluyeDestinoComercialVenta) {
				 return estadoVentaCodigo === CONST.ESTADO_PUBLICACION_VENTA['PUBLICADO'];
			 }else {
				 return false;
			 }
		 },

		  estaPublicadoAlquiler: function(get) {
			 var estadoAlquilerCodigo = get('activo.estadoAlquilerCodigo');
			 var incluyeDestinoComercialAlquiler = get('activo.incluyeDestinoComercialAlquiler');

			 if (incluyeDestinoComercialAlquiler){
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

		 getLinkHayaActivo: function(get) {
			 if(get('activo.perteneceAgrupacionRestringidaVigente')) {
				 return get('activo.activoPrincipalRestringida');
			 } else {
				 return get('activo.numActivo');
			 }
		 },

		 getValuePublicacionVenta: function(get){
		 	var linkHaya = get('activo.numActivo');

		 	var tipoActivoCodigo = get('activo.tipoActivoCodigo');
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

		 	if(get('activo.perteneceAgrupacionRestringidaVigente')) {
				 linkHaya = get('activo.activoPrincipalRestringida');
			 }
		 	if(get('estaPublicadoVenta')){
		 		return '<a href="' + HreRem.i18n('fieldlabel.link.web.haya').replace("vivienda",tipoActivo) + linkHaya +'?utm_source=rem&utm_medium=aplicacion&utm_campaign=activo " target="_blank">' + get('activo.estadoVentaDescripcion') + '</a>'
		 	}else {
		 		return get('activo.estadoVentaDescripcion')
		 	}
		 },

		 getValuePublicacionAlquiler: function(get){
		 	var linkHaya = get('activo.numActivo');

		 	var tipoActivoCodigo = get('activo.tipoActivoCodigo');
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

		 	if(get('activo.perteneceAgrupacionRestringidaVigente')) {
				 linkHaya = get('activo.activoPrincipalRestringida');
			 }
		 	if(get('estaPublicadoAlquiler')){
		 		return '<a href="' + HreRem.i18n('fieldlabel.link.web.haya').replace("vivienda",tipoActivo) + linkHaya +'?utm_source=rem&utm_medium=aplicacion&utm_campaign=activo " target="_blank">' + get('activo.estadoAlquilerDescripcion') + '</a>'
		 	}else {
		 		return get('activo.estadoAlquilerDescripcion')
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
		 
		 enableEdicionCheckHpm: function(get){
			 var esGestorAlquiler = get('activo.esGestorAlquiler');
			 var estadoAlquiler = get('patrimonio.estadoAlquiler');
			 var tieneOfertaAlquilerViva = get('activo.tieneOfertaAlquilerViva');
			 var incluidoEnPerimetro = get('activo.incluidoEnPerimetro');
			 var tipoTituloCodigo = get('activo.tipoTituloCodigo');
			 if($AU.userIsRol(CONST.PERFILES['HAYASUPER']) || (esGestorAlquiler == true || esGestorAlquiler == "true")){
				 var isAM = get('activo.activoMatriz'); /*Si el activo no es Activo Matriz devolverá undefined*/
				 var dadaDeBaja = get('activo.agrupacionDadaDeBaja');
				 
				 if(isAM == true) {
					 /*Comprobar si su PA está dada de baja*/
					 if(dadaDeBaja == "true") {
					   	return get('disableCheckHpm'); //El checkbox será editable.
					   } else {
					   	return get('disableCheckHpm'); //El checkbox no será editable.
					   }
				 }
				 
				 if((tipoTituloCodigo == CONST.TIPO_TITULO_ACTIVO['UNIDAD_ALQUILABLE'] && incluidoEnPerimetro) || (tieneOfertaAlquilerViva === true && (estadoAlquiler == CONST.COMBO_ESTADO_ALQUILER["ALQUILADO"] || estadoAlquiler == CONST.COMBO_ESTADO_ALQUILER["CON_DEMANDAS"]))){
					return get('disableCheckHpm');
				} else {
					return get('disableCheckHpm');
				}
			 }else{
				 return get('disableCheckHpm');
			 }
		 },
		 
		 disableCheckHpm: function(get){
			var estadoAlquiler = get('patrimonio.estadoAlquiler');
			var codComercializacion = get('activo.tipoComercializacionCodigo');
			
	        if((!Ext.isEmpty(estadoAlquiler) && estadoAlquiler == CONST.COMBO_ESTADO_ALQUILER["ALQUILADO"])){
	        	return true;
	          } else if (!Ext.isEmpty(codComercializacion) && 
	        		(CONST.TIPOS_COMERCIALIZACION['ALQUILER_VENTA'] == codComercializacion || CONST.TIPOS_COMERCIALIZACION['SOLO_ALQUILER'] == codComercializacion)) {
	            return false;
	        } else {
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
			var situacionActivo = get('patrimonio.estadoAlquiler');
			if((chkPerimetroAlquiler == true || chkPerimetroAlquiler == "true" ) && CONST.COMBO_ESTADO_ALQUILER['ALQUILADO'] == situacionActivo){
				return false;
			}else{
				return true;
			}
		 },

		 enableCheckPerimetroAlquiler: function(get){
		 	var comboEstadoAlquiler = get('patrimonio.estadoAlquiler');
		 	
		 	if(comboEstadoAlquiler != null){
		 		if((comboEstadoAlquiler.value == CONST.COMBO_ESTADO_ALQUILER["ALQUILADO"] || comboEstadoAlquiler.value == CONST.COMBO_ESTADO_ALQUILER["CON_DEMANDAS"])){
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
				if (this.getView('activosdetalle').lookupReference('chkbxocultarventa') != null)
					this.getView('activosdetalle').lookupReference('chkbxocultarventa').setDisabled(true);
				if (this.getView('activosdetalle').lookupReference('comboMotivoOcultacionVenta') != null) 
					this.getView('activosdetalle').lookupReference('comboMotivoOcultacionVenta').setDisabled(true)
		
				
				
				
			}
		},
		disabledData: function (){

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
            var admisionOk = get('activo.admision');
            var gestionOk = get('activo.tieneOkTecnico');
            var adecuacionOk = get('datospublicacionactivo.adecuacionAlquilerCodigo');
            var ceeOk = get('activo.tieneCEE');
            
            return !(admisionOk && gestionOk && informeComercialAprobado && ceeOk && (adecuacionOk=="01"||adecuacionOk=="03") && (publicarSinPrecioAlquiler || precioRentaWeb));
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
		onInitChangePrecioWebAlquiler: function (get){
			var noMostrarPrecioAlquiler = get('datospublicacionactivo.noMostrarPrecioAlquiler');
			var precioWebVentaAlquiler = get('datospublicacionactivo.precioWebAlquiler');
			
				if (noMostrarPrecioAlquiler)
					return 0; 
				else{
					if (precioWebVentaAlquiler != undefined) 
						return precioWebVentaAlquiler
					}
				
		},
		onInitChangePrecioWebVenta: function (get){
			var noMostrarPrecioVenta = get('datospublicacionactivo.noMostrarPrecioVenta');
			var precioWebVenta  = get('datospublicacionactivo.precioWebVenta');
			
				if (noMostrarPrecioVenta)
					return 0; 
				else{
					if (precioWebVenta != undefined) 
						return precioWebVenta
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
	    	var unidadAlquilable = get('activo.unidadAlquilable');

			if(isSareb || isCerberus || unidadAlquilable){
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

			return (!Ext.isEmpty(comboEstadoAlquiler) && comboEstadoAlquiler == CONST.COMBO_ESTADO_ALQUILER["LIBRE"]);
		},
		
		enableSubrogado: function(get){
			var chkPerimetroAlquiler = get('patrimonio.chkPerimetroAlquiler');
			var situacionActivo = get('patrimonio.estadoAlquiler');
			var isDivarian = get('patrimonio.isCarteraCerberusDivarian');

			if((chkPerimetroAlquiler == true || chkPerimetroAlquiler == "true" ) && CONST.COMBO_ESTADO_ALQUILER['ALQUILADO'] == situacionActivo && !isDivarian){
				return false;
			}else{
				return true;
			}
		},


		esTipoEstadoAlquilerAlquilado: function(get){
			var estadoAlquilerCodigo = get('situacionPosesoria.tipoEstadoAlquiler');
			var estadoReam = get('situacionPosesoria.perteneceActivoREAM');
			var tipoTituloCodigo = get('activo.tipoTituloCodigo');			
			
			if(estadoReam == true){
				if($AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['SEGURIDAD_REAM']) 
						|| ($AU.userIsRol(CONST.PERFILES['ASSET_MANAGEMENT']) && ('03' === tipoTituloCodigo || '04' === tipoTituloCodigo))){
					return false;
				}
				return true; 
			}else{
				return CONST.COMBO_ESTADO_ALQUILER["ALQUILADO"] == estadoAlquilerCodigo
					&& !($AU.userIsRol(CONST.PERFILES['GESTOR_ACTIVOS']) 
					|| ($AU.userIsRol(CONST.PERFILES['ASSET_MANAGEMENT']) && ('03' === tipoTituloCodigo || '04' === tipoTituloCodigo))
					|| $AU.userIsRol(CONST.PERFILES['HAYASUPER']));
			}
			
		},
		
		disabledComboConTituloTPA: function(get){
			
			
			var esTipoEstadoAlquilerAlquilado = get('esTipoEstadoAlquilerAlquilado');
			var ocupado = get('situacionPosesoria.ocupado');
			
		
			
			
			return (esTipoEstadoAlquilerAlquilado || ocupado == CONST.COMBO_OCUPACION["NO"]) 
			
			
				&&  !($AU.userIsRol(CONST.PERFILES['GESTOR_ACTIVOS']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']));
		},

		isCarteraLiberbank: function(get){
			 var isLiberbank = get('activo.isCarteraLiberbank');
			 if(isLiberbank){
				 return true;
			 }
			 return false;
		 },
		 
		 isCarteraSareb: function(get){
				 var isCarteraSareb = get('activo.isCarteraSareb');
				 if(isCarteraSareb){
					 return true;
				 }
				 return false;
		 },
		 
		 isCarteraDivarian: function(get){
			 var isDivarian = get('activo.isCarteraDivarian');
			 if(isDivarian){
				 return true;
			 }
			 return false;
		 },
		 
		 isCarteraBankia: function(get){
				 var isCarteraBankia = get('activo.isCarteraBankia');
				 if(isCarteraBankia){
					 return true;
				 }
				 return false;
		 },
		 getTiposOfertasUAs: function (get) {
			var unidadAlquilable = get('activo.unidadAlquilable');
		 	tiposDeOferta = new Ext.data.Store({
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposOfertas'}
				}
			});
            	tiposDeOferta.filter([{
		    	filterFn: function(rec){
			    	if (unidadAlquilable) {
			    		if (rec.getData().codigo == '02') return true; 
			    		else return false;
			    	}else {
			    		return true
			    	}
		    	}
		}]);
				
				return tiposDeOferta;
		},
		
		 enableDestinoComercial: function(get) {
			 var me = this;
			 if(me.get('activo.activoMatriz') == "true") { //Comprobar si es un AM. 
				 //Comprobar si la PA está dada de baja.
				 if(me.get('activo.agrupacionDadaDeBaja') == "true") {
					   	return false; //Se puede editar.
					   } else {
					   	return true; //No se puede editar.
					   }
			 }
			 
			if(get('esUA') == true) {
				return true;
			} else {
				return false;
			}
		 },
		 
		 esAM: function(get) {
			var me = this;
			var esAM = false;
			
			if(me.get('activo.activoMatriz')) {
				esAM = true;
			}
			
			return esAM;
		 },
				
		esUA: function(){
			var me = this; 
			var esUA = false;
			var vendido = false;
			if(me.get('activo.unidadAlquilable') != undefined)
				esUA = me.get('activo.unidadAlquilable');
			if(me.get('activo.isVendidoOEntramite') != undefined)
				vendido = me.get('activo.isVendidoOEntramite');
			return (vendido === true || esUA === true);
		},
		esUaSinImportarEstado: function(){
			var me = this; 
			var esUA = false;
			
			if(me.get('activo.unidadAlquilable') != undefined){
				esUA = me.get('activo.unidadAlquilable');
			}
			
			return esUA === true;
		},
		
		editableTipoActivo: function(get){
			//No se podrán editar las coordenadas de latitud y longitud si se trata de una UA
			var me = this;
			var unidadAlquilable = get('activo.unidadAlquilable');
			var editable = get('editing');
			
			if((unidadAlquilable != undefined || unidadAlquilable != null))
				return (!editable || unidadAlquilable);
			else
				return !editable;
		},
		
		visibilidadPestanyaDocumentacionAgrupacion : function (get)  {
			if ( CONST.CARTERA['THIRDPARTIES'] === get('activo.entidad')
			&& CONST.SUBCARTERA['YUBAI'] === get('activo.subCartera')){
				return false;
			}
			return true;
		},

		esGestorPublicacionVenta: function(get) {

	    	var me = this;
	    	var checkboxVenta = get('datospublicacionactivo.ocultarVenta');

	    	if($AU.userIsRol(CONST.PERFILES['HAYAGESTPUBL']) && checkboxVenta){
	    		return false;
	    	}else{
	    		return true;
	    	}
	    },
	    
	    esGestorPublicacionAlquiler: function(get) {

	    	var me = this;
	    	var checkboxAlquiler = get('datospublicacionactivo.ocultarAlquiler');
	    	
	    	if($AU.userIsRol(CONST.PERFILES['HAYAGESTPUBL']) && checkboxAlquiler){
	    		return false;
	    	}else{
	    		return true;
	    	}
	    },
	    
	    esSubcarteraDivarian: function(get){
			return get('activo.subcarteraCodigo') == CONST.SUBCARTERA['DIVARIANARROW'] 
				|| get('activo.subcarteraCodigo') == CONST.SUBCARTERA['DIVARIANREMAINING'];
		},

	    esSuperUsuario: function(get){
	    		return $AU.userIsRol(CONST.PERFILES["HAYASUPER"]);
	    },
	    
	    esUnRolPreinmueble: function(get){
	    	var isOneRol = false;
	    	isOneRol= $AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) ||
				$AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMISION']) || 
				$AU.userIsRol(CONST.PERFILES['SUPERUSUARO_ADMISION']) ||
				$AU.userIsRol(CONST.PERFILES['HAYASUPER']);
    		return isOneRol;
	    },
	    
		esSuperUsuarioAndNoUA: function(get){
	    	var UA = false;
	    	if (get('activo.unidadAlquilable') != undefined) {
	    		UA = get('activo.unidadAlquilable');
	    	}
    		return $AU.userIsRol(CONST.PERFILES["HAYASUPER"]) && !UA;
	    },

	    esSuperUsuarioCalidadDatoAndNoUA: function(get){
	    	var UA = false;
	    	if (get('activo.unidadAlquilable') != undefined) {
	    		UA = get('activo.unidadAlquilable');
	    	}
    		return ($AU.userIsRol(CONST.PERFILES["HAYASUPER"]) || $AU.userIsRol(CONST.PERFILES["HAYASUPCAL"])) && !UA;
	    },

    	esOtrosotivoAutorizacionTramitacion: function(get){
    		
    		var me = this;
    		
    		var comboOtros = get('comercial.motivoAutorizacionTramitacionCodigo');
    		if(CONST.DD_MOTIVO_AUTORIZACION_TRAMITE['COD_OTROS'] == comboOtros){
    			return true;
    		}
    		me.set('comercial.observacionesAutoTram', null);
    			
			return false;
    	},
    	
    	esSelecionadoAutorizacionTramitacion: function(get){
    		
    		var me = this;
    		var todoSelec = get('comercial.motivoAutorizacionTramitacionCodigo');
    		var obsv = get('comercial.observacionesAutoTram');
    		var editable = get('editingFirstLevel');
    		if(editable){
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
    	// a�adimos tipo comercial y tipo restringida no tramitar oferta
    	usuarioTieneFuncionTramitarOferta: function(get){
    		var me = this;
    		if ( CONST.CARTERA['BANKIA'] === me.get('activo.cartera')){
    			var esTramitable = me.get('activo.tramitable');
        		var comercial =	me.get('activo.pertenceAgrupacionComercial');
        		var restringida = me.get('activo.pertenceAgrupacionRestringida');
        		var funcion = $AU.userHasFunction('AUTORIZAR_TRAMITACION_OFERTA');
        		if (comercial || restringida || !funcion )	
        			return true;
    		}else{
    			if(!esTramitable){
    				return !funcion;
    			}
    			return true;
    		}
    	}, 
    	
    	checkEditEstadoGestionPlusvalia: function(get) {
    		var estadoGestion = get('plusvalia.estadoGestion');    	
    		var usuariosPermitidosAdmin = $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMINISTRACION']) || $AU.userIsRol(CONST.PERFILES['GESTOR_ADMINISTRACION']) || $AU.userIsRol(CONST.PERFILES['GESTIAFORM']);
    		if (usuariosPermitidosAdmin) {
    			return !usuariosPermitidosAdmin;
    		}
    		if(Ext.isEmpty(estadoGestion)){    			
    			return true;
    		} else {
    			if(estadoGestion == CONST.DD_ESTADO_GEST_PLUVS["EN_CURSO"]) {
         			return false;
         		} else {
         			return true;
         		}
    		}
    	},
    	isCesionUsoEditable: function () {
    		return $AU.userIsRol('GESTALQ') || $AU.userIsRol(CONST.PERFILES['HAYASUPER']);    		
    	},
		
		mostrarTitlePerimetroDatosBasicos: function(get){
			var me = this;
			var isSubcarteraApple = get('activo.isSubcarteraApple');
			var isSubcarteraDivarian = get('activo.isSubcarteraDivarian');
			var title = "";
			
			if(isSubcarteraApple){
				title = HreRem.i18n('title.perimetro.apple');
			}else if(isSubcarteraDivarian){
				title = HreRem.i18n('title.perimetro.divarian');
			}
			return title;
		},
		
		esEditablePerimetroMacc: function(get){
			var codComercializacion = get('activo.tipoComercializacionCodigo');
			var isSuper = $AU.userIsRol(CONST.PERFILES['HAYASUPER']);
			return CONST.TIPOS_COMERCIALIZACION['SOLO_ALQUILER'] === codComercializacion && isSuper;
		},
		
		esSubcarteraAppleDivarian: function(get){
			var me = this;
			var esApple = get('activo.isSubcarteraApple');
			var esDivarian = get('activo.isSubcarteraDivarian');			
			
			if (esApple || esDivarian)
				return true;
			else
				return false;
		},
		esSupervisionGestorias: function(get){
			
			return $AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']); 
		},
		
		auComprador: function(get){
			
			return $AU.userIsRol(CONST.PERFILES['GESTOR_FORM']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_FORM']) || $AU.userIsRol(CONST.PERFILES['GESTIAFORM']); 
		},
		
		editarCheckValidado: function(get){
			//Desactivamos la columna de validado en función del usuario:			
			return $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_ADMINISTRACION']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMINISTRACION']);
		},
		
	     getIconClsDQRefCatastral: function(get) {
	     	var correctoF3ReferenciaCatastral = get('calidaddatopublicacionactivo.correctoF3ReferenciaCatastral');
	     	
	     	if("0" == correctoF3ReferenciaCatastral){
	     		return 'app-tbfiedset-ico icono-tickok';	
	     	}else if("1" == correctoF3ReferenciaCatastral){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     	
	     },
	     
	     getIconClsDQSupConstruida: function(get) {
	     	var correctoF3ReferenciaCatastral = get('calidaddatopublicacionactivo.correctoF3SuperficieConstruida');
	     	
	     	if("0" == correctoF3ReferenciaCatastral){
	     		return 'app-tbfiedset-ico icono-tickok';	
	     	}else if("1" == correctoF3ReferenciaCatastral){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     	
	     },
	     
	     getIconClsDQSuperficieUtil: function(get) {
	     	var correctoF3SuperficieUtil = get('calidaddatopublicacionactivo.correctoF3SuperficieUtil');
	     	
	     	if("0" == correctoF3SuperficieUtil){
	     		return 'app-tbfiedset-ico icono-tickok';	
	     	}else if("1" == correctoF3SuperficieUtil){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     	
	     },
	     
	     getIconClsDQAnyoConstruccion: function(get) {
	     	var correctoF3AnyoConstruccion = get('calidaddatopublicacionactivo.correctoF3AnyoConstruccion');
	     	
	     	if("0" == correctoF3AnyoConstruccion){
	     		return 'app-tbfiedset-ico icono-tickok';	
	     	}else if("1" == correctoF3AnyoConstruccion){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     	
	     },
	     
	     getIconClsDQTipoVia: function(get) {
	     	var correctoF3TipoVia = get('calidaddatopublicacionactivo.correctoF3TipoVia');

	     	if("0" == correctoF3TipoVia){
	     		return 'app-tbfiedset-ico icono-tickok';	
	     	}else if("1" == correctoF3TipoVia){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     	
	     },
	     
	     getIconClsDQNomCalle: function(get) {
	     	var correctoF3NomCalle = get('calidaddatopublicacionactivo.correctoF3NomCalle');
	     	
	     	if("0" == correctoF3NomCalle){
	     		return 'app-tbfiedset-ico icono-tickok';	
	     	}else if("1" == correctoF3NomCalle){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     	
	     },
	     
	     getIconClsDQCP: function(get) {
	     	var correctoF3CP = get('calidaddatopublicacionactivo.correctoF3CP');
	     	
	     	if("0" == correctoF3CP){
	     		return 'app-tbfiedset-ico icono-tickok';	
	     	}else if("1" == correctoF3CP){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     	
	     },
	     
	     getIconClsDQMunicipio: function(get) {
	     	var correctoF3Municipio = get('calidaddatopublicacionactivo.correctoF3Municipio');
	     	
	     	if("0" == correctoF3Municipio){
	     		return 'app-tbfiedset-ico icono-tickok';	
	     	}else if("1" == correctoF3Municipio){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     	
	     },
	     
	     getIconClsDQProvincia: function(get) {
	     	var correctoF3Provincia = get('calidaddatopublicacionactivo.correctoF3Provincia');
	     	
	     	if("0" == correctoF3Provincia){
	     		return 'app-tbfiedset-ico icono-tickok';	
	     	}else if("1" == correctoF3Provincia){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     	
	     },
	     
	     getIconClsDQBloqueFase3: function(get) {
	     	var correctoF3BloqueFase3 = get('calidaddatopublicacionactivo.correctoF3BloqueFase3');
	     	
	     	if("0" == correctoF3BloqueFase3){
	     		return 'app-tbfiedset-ico icono-tickok';	
	     	}else if("1" == correctoF3BloqueFase3){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     	
	     },getIconClsIdufirCorrecto:function(get){
	     	
	     	var correctoIdufirFase1 = get('calidaddatopublicacionactivo.correctoIdufirFase1');
	     	
	     	if("0"==correctoIdufirFase1)  {
	     		return 'app-tbfiedset-ico icono-tickok';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}
	     },getIconClsFincaRegistralCorrecto:function(get){
	     	var correcto = get('calidaddatopublicacionactivo.correctoFincaRegistralFase1');
	     	
	     	if("0"==correcto)  {
	     		return 'app-tbfiedset-ico icono-tickok';
	     	}else if("1"==correcto){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     },getIconClsTomoCorrecto:function(get){
	     	var correcto = get('calidaddatopublicacionactivo.correctoTomoFase1');
	     	
	     	if("0"==correcto)  {
	     		return 'app-tbfiedset-ico icono-tickok';
	     	}else if("1"==correcto){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     },getIconClsLibroCorrecto:function(get){
	     	var correcto = get('calidaddatopublicacionactivo.correctoLibroFase1');
	     	
	     	if("0"==correcto)  {
	     		return 'app-tbfiedset-ico icono-tickok';
	     	}else if("1"==correcto){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     },getIconClsFolioCorrecto:function(get){
	     	var correcto = get('calidaddatopublicacionactivo.correctoFolioFase1');
	     	
	     	if("0"==correcto)  {
	     		return 'app-tbfiedset-ico icono-tickok';
	     	}else if("1"==correcto){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     },getIconClsUsoDominanteCorrecto:function(get){
	     	var correcto = get('calidaddatopublicacionactivo.correctoUsoDominanteFase1');
	     	
	     	if("0"==correcto)  {
	     		return 'app-tbfiedset-ico icono-tickok';
	     	}else if("1"==correcto){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     },getIconClsMunicipioDelRegistroCorrecto:function(get){
	     	var correcto = get('calidaddatopublicacionactivo.correctoMunicipioDelRegistroFase1');
	     	
	     	if("0"==correcto)  {
	     		return 'app-tbfiedset-ico icono-tickok';
	     	}else if("1"==correcto){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     },getIconClsProvinciaDelRegistroCorrecto:function(get){
	     	var correcto = get('calidaddatopublicacionactivo.correctoProvinciaDelRegistroFase1');
	     	
	     	if("0"==correcto)  {
	     		return 'app-tbfiedset-ico icono-tickok';
	     	}else if("1"==correcto){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     },getIconClsProvinciaNumeroDelRegistroCorrecto:function(get){
	     	var correcto = get('calidaddatopublicacionactivo.correctoNumeroDelRegistroFase1');
	     	
	     	if("0"==correcto)  {
	     		return 'app-tbfiedset-ico icono-tickok';
	     	}else if("1"==correcto){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     },getIconClsVPOCorrecto:function(get){
	     	var correcto = get('calidaddatopublicacionactivo.correctoVpoFase1');
	     	
	     	if("0"==correcto)  {
	     		return 'app-tbfiedset-ico icono-tickok';
	     	}else if("1"==correcto){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     },getIconClsAnyoConstruccionCorrecto:function(get){
	     	var correcto = get('calidaddatopublicacionactivo.correctoAnyoConstruccionFase1');
	     	
	     	if("0"==correcto)  {
	     		return 'app-tbfiedset-ico icono-tickok';
	     	}else if("1"==correcto){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     },getIconClsTipologiaCorrecto:function(get){
	     	var correcto = get('calidaddatopublicacionactivo.correctoTipologiaFase1');
	     	
	     	if("0"==correcto)  {
	     		return 'app-tbfiedset-ico icono-tickok';
	     	}else if("1"==correcto){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     },getIconClsSubtipologiaCorrecto:function(get){
	     	var correcto = get('calidaddatopublicacionactivo.correctoSubtipologiaFase1');
	     	
	     	if("0"==correcto)  {
	     		return 'app-tbfiedset-ico icono-tickok';
	     	}else if("1"==correcto){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     },getIconClsInformacionCargasCorrecto:function(get){
	     	var correcto = get('calidaddatopublicacionactivo.correctoInformacionCargasFase1');
	     	
	     	if("0"==correcto)  {
	     		return 'app-tbfiedset-ico icono-tickok';
	     	}else if("1"==correcto){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     },getIconClsInscripcionCorrecto:function(get){
	     	var correcto = get('calidaddatopublicacionactivo.correctoInscripcionCorrectaFase1');	     	
	     	if("0"==correcto)  {
	     		return 'app-tbfiedset-ico icono-tickok';
	     	}else if("1"==correcto){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     },getIconClsPorCienCorrecto:function(get){
	     	var correcto = get('calidaddatopublicacionactivo.correctoPor100PropiedadFase1');		
	     	if("0"==correcto)  {
	     		return 'app-tbfiedset-ico icono-tickok';
	     	}else if("1"==correcto){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     },getCorrectoDatosRegistralesFase0a2:function(get){
	     	var correcto = get('calidaddatopublicacionactivo.correctoDatosRegistralesFase1');
	     	
	     	if("0"==correcto)  {
	     		return 'app-tbfiedset-ico icono-tickok';
	     	}else if("1"==correcto){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     },
	     
	     getIconClsDQFotos: function(get) {
	     	var correctoF1Fotos = get('calidaddatopublicacionactivo.correctoFotos');
	     	
	     	if("0" == correctoF1Fotos){
	     		return 'app-tbfiedset-ico icono-tickok';	
	     	}else if("1" == correctoF1Fotos){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     },
	     
	       getIconClsDQescripcion: function(get) {
	     	var correctoF1Descripcion = get('calidaddatopublicacionactivo.correctoDescripcion');
	     	
	     	if("0" == correctoF1Descripcion){
	     		return 'app-tbfiedset-ico icono-tickok';	
	     	}else if("1" == correctoF1Descripcion){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     	
	     },
	     
	       getIconClsDQLocalizacion: function(get) {
	     	var correctoF1Descripcion = get('calidaddatopublicacionactivo.correctoLocalizacion');
	     	
	     	if("0" == correctoF1Descripcion){
	     		return 'app-tbfiedset-ico icono-tickok';	
	     	}else if("1" == correctoF1Descripcion){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     	
	     },
	     
	       getIconClsDQCEE: function(get) {
	     	var correctoF1CEE = get('calidaddatopublicacionactivo.correctoCEE');
	     	
	     	if("0" == correctoF1CEE){
	     		return 'app-tbfiedset-ico icono-tickok';	
	     	}else if("1" == correctoF1CEE){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     	
	     },
	     
	       getIconClsDQBloqueFase4: function(get) {
	     	var correctoF4BloqueFase4 = get('calidaddatopublicacionactivo.correctoF4BloqueFase4');
	     	
	     	if("0" == correctoF4BloqueFase4){
	     		return 'app-tbfiedset-ico icono-tickok';	
	     	}else if("1" == correctoF4BloqueFase4){
	     		return 'app-tbfiedset-ico icono-tickko';
	     	}else{
	     		return 'app-tbfiedset-ico icono-tickinterrogante';
	     	}
	     	
	     },
	     
	       disableBtnDescF1: function(get) {
	     
	       	if(get('calidaddatopublicacionactivo.disableDescripcion')=='false'){
	       		return false;
	       	}else{
	       		return true;
	       	}
	  	        	
	     },
	
		activarCamposGridPreciosVigentes: function(){
			var gestorPrecios = $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_PRECIOS']);
			if(gestorPrecios){
				return true;
			}
			return false;
		},

		estadoAdmisionVisible : function(get){

			var retorno = !($AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMISION'])
							|| $AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION'])
							|| $AU.userIsRol(CONST.PERFILES['HAYASUPER']));
			if (!retorno){
				retorno = !(get('activo.incluidoEnPerimetroAdmision') == "true");
			}
			return retorno;
		},
		
		tienePosesion: function(get){
			var posesion = get('situacionPosesoria.indicaPosesion') == "1";
			var subtipoClaseActivoCodigo = get('activo.subtipoClaseActivoCodigo') == "02";
			
			if ($AU.userIsRol(CONST.PERFILES['ASSET_MANAGEMENT']) && subtipoClaseActivoCodigo == true) {
				return true;
			} else {
				return posesion;
			} 
		},
		
		isGestorAdmisionAndSuper: function(){
			var gestores = $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) ||  $AU.userIsRol(CONST.PERFILES['SUPERUSUARO_ADMISION']);
			var me = this; 		
			if(gestores){			
				return true;
				}
				
			
			return false;
		},

		isGestorOSupervisorAdmisionAndSuper: function(){
			return $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) ||  $AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMISION']);
			
		},

		isGestorAdmisionAndSuperComboTipoAltaBlo: function(get){			
			if(get("activo.isCarteraBbva")){
				var gestores = $AU.userIsRol(CONST.PERFILES['HAYASUPER']) 
				|| $AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) 
				||  $AU.userIsRol(CONST.PERFILES['SUPERUSUARO_ADMISION']);
				var me = this;
				
				var tipoAltaCodigo = me.getView().getViewModel().get('activo.tipoAltaCodigo');
				var comboActivoRecovery = me.getView().getViewModel().get('activo.idRecovery');
				var comboTipoAltaRef = me.getView().down("[reference='tipoAltaRef']");
				
				
				if(gestores){
					if (comboActivoRecovery != null) {
						if(!Ext.isEmpty(comboTipoAltaRef)) comboTipoAltaRef.setValue(CONST.DD_TAL_TIPO_ALTA['ALTA_AUTOMATICA']);
						return false;
					}else if(comboActivoRecovery == null && tipoAltaCodigo == CONST.DD_TAL_TIPO_ALTA['ALTA_AUTOMATICA']){
						return true;
					}else{
						if(tipoAltaCodigo == CONST.DD_TAL_TIPO_ALTA['ALTA_AUTOMATICA']) {
							if(!Ext.isEmpty(comboTipoAltaRef)) comboTipoAltaRef.setValue(CONST.DD_TAL_TIPO_ALTA['ALTA_AUTOMATICA']);
	         				return false;
	         			} else if (tipoAltaCodigo != CONST.DD_TAL_TIPO_ALTA['ALTA_AUTOMATICA'] || tipoAltaCodigo == null) {
	         				return true;         				
	         			} 
	
					}
	
					}
									
				}
			return false;
		},
		
		
		activarCamposGridPreciosVigentesGestorAdmisionYPrecios: function(){
			var gestores = $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_PRECIOS']) || $AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) ||  $AU.userIsRol(CONST.PERFILES['SUPERUSUARO_ADMISION']);
			var me = this; 		
			if(gestores){			
				return true;
				}
				
			
			return false;
		},


		 isCarteraBbva: function(get){
			 var isBbva = get('activo.isCarteraBbva');
			 if(isBbva){
				 return true;
			 }
			 return false;
		 },
		 isCarteraBankia: function(get){
		 	var isBankia = get('activo.isCarteraBankia')
		 	if (isBankia) {
		 		return true;
		 	}
		 	return false;
		 },

		 mostrarCamposDivarianandBbva: function(get){
			var isSubcarteraDivarian = get('activo.isSubcarteraDivarian');			
		    var isBbva = get('activo.isCarteraBbva');
		    if(isBbva || isSubcarteraDivarian ){
			return true;
		    }
		    return false;
		 },
		 
		 editarSegmentoDivarianandBbva: function(get){
			var isSubcarteraDivarian = get('activo.isSubcarteraDivarian');			
		    var isBbva = get('activo.isCarteraBbva');
		    var isGrupoOficinaKAM = get('activo.isGrupoOficinaKAM');
		    if(isBbva && (isGrupoOficinaKAM || $AU.userIsRol(CONST.PERFILES['HAYASUPER'])) || isSubcarteraDivarian){
			return true;
		    }
		    return false;
		},

		mostrarCamposDivarianAndJaguar: function(get){
	 	 	var isSubcarteraDivarian = get('activo.isSubcarteraDivarian');
	 	 	var isSubcarteraJaguar = get('activo.isSubcarteraJaguar');
		    if(isSubcarteraDivarian || isSubcarteraJaguar){
			return true;
		    }
		    return false;
		 },
		
		isGestorAdmisionAndSuperUA: function(){
			var gestores = $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) ||  $AU.userIsRol(CONST.PERFILES['SUPERUSUARO_ADMISION']);
			var me = this; 
			var esUA = false;

			if(gestores){						
				return true;
			}	
			return false;
		
	 	},

		isCarteraBbva: function(get){
				var isBbva = get('activo.isCarteraBbva');
				if(isBbva){
					return true;
				}
				return false;
		},

		esSupervisionGestorias: function(get){
			
			return $AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']); 
		},
		
		auComprador: function(get){
			
			return $AU.userIsRol(CONST.PERFILES['GESTOR_FORM']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_FORM']) || $AU.userIsRol(CONST.PERFILES['GESTIAFORM']); 
		},
		
		editarCheckValidado: function(get){
			//Desactivamos la columna de validado en función del usuario:			
			return $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_ADMINISTRACION']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMINISTRACION']);
		},
		
		isGestorSeguridadOAssetManager:function(get){
			var tipoTituloCodigo = get('activo.tipoTituloCodigo');
			
			return $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['PERFIL_SEGURIDAD']) 
				|| ($AU.userIsRol(CONST.PERFILES['ASSET_MANAGEMENT']) && ('03' === tipoTituloCodigo || '04' === tipoTituloCodigo));
		},
		
		isAssetManager:function(get){
			var tipoTituloCodigo = get('activo.tipoTituloCodigo');
			var subtipoClaseActivoCodigo = get('activo.subtipoClaseActivoCodigo') == "02";
			
			return $AU.userIsRol(CONST.PERFILES['ASSET_MANAGEMENT']) && (('03' === tipoTituloCodigo || '04' === tipoTituloCodigo) || subtipoClaseActivoCodigo === true);
		},
		
	    esActivoMacc: function (get) {
	    	
	    	 var esMacc = get('activo.perimetroMacc');
	    	 
	    	 if (esMacc == 1)
	    		 return false;
	    	 else
	    		 return true;
	    },
	    
		estadoAdmisionVisible : function(get){
			
			var retorno = !($AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMISION']) 
							|| $AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) 
							|| $AU.userIsRol(CONST.PERFILES['HAYASUPER']));				
			if (!retorno){
				retorno = !(get('activo.incluidoEnPerimetroAdmision') == "true");
			}
			return retorno;
		},
		esPerfilSuperYSupercomercial :function(get){
			
		 	return $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['SUPERCOMERCIAL']);
		},	
		
		esUsuarioBBVA: function(get) {
			return $AU.userIsRol(CONST.PERFILES['CARTERA_BBVA']);
		},
		
		btnNuevaPeticionTrabajoOculto: function(get) {
			var isIncluidoEnPerimetro = get('activo.incluidoEnPerimetro');
			return (isIncluidoEnPerimetro == false || $AU.getUser().codigoCartera == CONST.CARTERA['BBVA']);
		},
		
		isSubcarteraCerberus: function(get) {
	    	var codigoSubcartera = get('activo.subcarteraCodigo');
	    	var isSareb = get('activo.isCarteraSareb');
	    	if (CONST.SUBCARTERA['APPLEINMOBILIARIO'] === codigoSubcartera
	    		|| CONST.SUBCARTERA['DIVARIANARROW'] === codigoSubcartera
	    		|| CONST.SUBCARTERA['DIVARIANREMAINING'] === codigoSubcartera 
	    		|| isSareb){
	    	return true;
	    	}
	    	return false;
	    },
	    
		isSubcarteraCerberusOrSareb: function(get) {
	    	var codigoSubcartera = get('activo.subcarteraCodigo')
	    	if (CONST.SUBCARTERA['APPLEINMOBILIARIO'] === codigoSubcartera
	    		|| CONST.SUBCARTERA['DIVARIANARROW'] === codigoSubcartera
	    		|| CONST.SUBCARTERA['DIVARIANREMAINING'] === codigoSubcartera){
	    	return true;
	    	}
	    	return false;
	    },
	    
	    isGestorActivosAndSuper: function(get){
			var usuarios = $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_ACTIVOS']);
			var incluidoEnPerimetro = get('activo.incluidoEnPerimetro');
			if(usuarios && incluidoEnPerimetro){			
				return false;
				}
			return true;
		},
		
		esEditableExcluirValidaciones: function(get){

			var tieneFuncion = $AU.userHasFunction('EDITAR_EXCLUIR_VALIDACIONES');
			var perteneceAgrupacionRestringida = get('activo.pertenceAgrupacionRestringida');
			var isBankia = ('isCarteraBankia');
			
			if (perteneceAgrupacionRestringida || !tieneFuncion || isBankia){
				return true;
			}			
			
			return false;
		}, 

		noEditableUASSoloSuper: function(get) {
			var me = this; 
			var esUA = false;
			if(me.get('activo.unidadAlquilable') != undefined){
				esUA = me.get('activo.unidadAlquilable');
			}
			
			return esUA === false && $AU.userIsRol(CONST.PERFILES['HAYASUPER']);
		},
		
		noEditableSareb: function(get) {
			var me = this;
			var isCarteraSareb = get('activo.isCarteraSareb');
			var tipoTituloCodigo = get('activo.tipoTituloCodigo');
			var subtipoClaseActivoCodigo = get('activo.subtipoClaseActivoCodigo') == "02";
			
			if(isCarteraSareb != true 
					&& !($AU.userIsRol(CONST.PERFILES['ASSET_MANAGEMENT']) && (('03' === tipoTituloCodigo || '04' === tipoTituloCodigo) || subtipoClaseActivoCodigo === true))){
				return false;
			}
			return true;
		},
		
		esEditablePorcentajeConstruccion: function(get){
			 var isGestorActivos = $AU.userIsRol('HAYAGESACT');
			 var isUnidadAlquilable = false;
			 if(get('activo.unidadAlquilable')){
	    		 isUnidadAlquilable = true;
			 }
			 if(isGestorActivos && isUnidadAlquilable) return true;
				 else return false;
	 	},
	 	
	 	editarPorcentajeConstruccion: function(get){
			var editable = get('activo.isEditablePorcentajeConstruccion');			
		    var funcion = $AU.userHasFunction('ACTUALIZAR_PORCENTAJE_CONSTRUCCION');
		    
		    if(editable && funcion){
		    	return true;
		    }
		    
		    return false;
		},
		
		esCarteraSarebBbvaBankiaCajamarLiberbank : function(get){
			var activo = null;
			if(get('activo') != null)
				activo = get('activo').data;
			
			if (activo != null || activo != undefined) {
				var esCarteraSareb = activo.isCarteraSareb;
				var esCarteraBbva = activo.isCarteraBbva;
				var esCarteraBankia = activo.isCarteraBankia;
				var esCarteraCajamar = activo.isCarteraCajamar;
				var esCarteraLiberbank = activo.isCarteraLiberbank;
				
				if (esCarteraSareb == true || esCarteraBbva == true || esCarteraBankia == true || esCarteraCajamar == true || esCarteraLiberbank == true) {
					return false;
				}else{
					return true;
				}
			}else{
				return true;
			}
		},
		
		getIconClsCondicionantesPortalPublicoVenta: function(get) {
	    	var condicion = get('activoCondicionesDisponibilidadCaixa.publicacionPortalPublicoVenta');

	        if(eval(condicion)) {
	            return 'app-tbfiedset-ico icono-ok';
	        } else {
	            return 'app-tbfiedset-ico icono-ko';
	        }
		 },
		 getIconClsCondicionantesPortalPublicoAlquiler: function(get) {
	    	var condicion = get('activoCondicionesDisponibilidadCaixa.publicacionPortalPublicoAlquiler');

	        if(eval(condicion)) {
	            return 'app-tbfiedset-ico icono-ok';
	        } else {
	            return 'app-tbfiedset-ico icono-ko';
	        }
		 },
		 getIconClsCondicionantesPublicacionPortalInversorVenta: function(get) {
	    	var condicion = get('activoCondicionesDisponibilidadCaixa.publicacionPortalInversorVenta');

	        if(eval(condicion)) {
	            return 'app-tbfiedset-ico icono-ok';
	        } else {
	            return 'app-tbfiedset-ico icono-ko';
	        }
		 },
		 getIconClsCondicionantesPublicacionPortalInversorAlquiler: function(get) {
	    	var condicion = get('activoCondicionesDisponibilidadCaixa.publicacionPortalInversorAlquiler');

	        if(eval(condicion)) {
	            return 'app-tbfiedset-ico icono-ok';
	        } else {
	            return 'app-tbfiedset-ico icono-ko';
	        }
		 },
		 getIconClsCondicionantesPublicacionPortalApiVenta: function(get) {
	    	var condicion = get('activoCondicionesDisponibilidadCaixa.publicacionPortalApiVenta');

	        if(eval(condicion)) {
	            return 'app-tbfiedset-ico icono-ok';
	        } else {
	            return 'app-tbfiedset-ico icono-ko';
	        }
		 },
 		 getIconClsCondicionantesPublicacionPortalApiAlquiler: function(get) {
	    	var condicion = get('activoCondicionesDisponibilidadCaixa.publicacionPortalApiAlquiler');

	        if(eval(condicion)) {
	            return 'app-tbfiedset-ico icono-ok';
	        } else {
	            return 'app-tbfiedset-ico icono-ko';
	        }
		 },
		 
		editableCheckComercializar: function(get){
			var principalRestringida = get('activo.activoPrincipalRestringida');
			var perteneceRestringida = get('activo.perteneceAgrupacionRestringidaVigente');
			var isSareb = get('activo.isCarteraSareb');
			var numActivo = get('activo.numActivo');
			var readOnly = false;
			if((perteneceRestringida && (principalRestringida != numActivo)) && isSareb){
				readOnly = true;
			}	
			return readOnly;
		},
		
		 esSuperUsuarioCaixa: function(get){
		 	var isBankia = get('activo.isCarteraBankia');
	    	if (isBankia) {
	    		if ($AU.userIsRol(CONST.PERFILES["HAYASUPER"])) {
	    			return false;
	    		}else{
	    			return true;	
	    		}
	    	}else{
	    		return false;
	    	}
    		return false;
	    },
	    esEditableUsuariosCaixa: function(get){
	    	var me = this;
	    	var isBankia = get('saneamiento.isCarteraBankia');
	    	if (!isBankia && ($AU.userIsRol(CONST.PERFILES["GESTOR_ADMISION"]) || $AU.userIsRol(CONST.PERFILES["GESTORIA_ADMISION"])
	    			|| $AU.userIsRol(CONST.PERFILES["SUPERVISOR_ADMISION"]) || $AU.userIsRol(CONST.PERFILES["HAYASUPER"]))) {
				return false;
			} else {
		    	return true;
			}
	    },

		esBankia: function(get) {
			var carteraCodigo = get('activo.entidadPropietariaCodigo');
	     	
	     	if(CONST.CARTERA['BANKIA'] == carteraCodigo){
	     		return true;
	     	}else{
	     		return false;
	     	}
		},
	    
	    isCarteraBankiayUnidadAlquilable: function(get){
			var me = this;

			var isBankia = get('activo.isCarteraBankia');
	    	var unidadAlquilable = get('activo.unidadAlquilable');

			if(isBankia || unidadAlquilable){
				return true;
			}

			return false;
		 },
		    
	    isCarteraBankiaYesSituacionJudicial: function(get){
			var me = this;

			var isBankia = get('activo.isCarteraBankia');

			if(get('esSituacionJudicial') || isBankia){
				return true;
	    	 } else {
	    		 return false;
	    	 }
		 },
		    
	    esUAyIsCarteraBankia: function(get){
			var me = this;
			
			if(get('esUA') == true || get('isCarteraBankia')) {
				return true;
			} else {
				return false;
			}
		},
		
		isCarteraHyTOrBFA: function(get) {
	    	var codigoCarteraHyT = get('activo.isCarteraHyT'), codigoCarteraBFA = get('activo.isCarteraBFA');	    	
	    	return codigoCarteraHyT || codigoCarteraBFA;
		},
		
		tieneGestionDnd: function(get){
			var tieneGestionDnd = get('activo.tieneGestionDndCodigo');
			//var tieneGestionDndCombo = this.getView().lookupReference('gestionDndCodigo');

			if (tieneGestionDnd === '01') {
				return true;
			} else {
				return false;
			}
		},
		mostrarCamposDivarianAndBbvaAndJaguar: function(get){
			var isSubcarteraDivarian = get('activo.isSubcarteraDivarian');
			var isSubcarteraJaguar = get('activo.isSubcarteraJaguar');
		    var isBbva = get('activo.isCarteraBbva');
		    if(isBbva || isSubcarteraDivarian || isSubcarteraJaguar){
			return true;
		    }
		    return false;		 
		 },
		    
		 esEditableDestinoComercialOresBankia: function(get){
			var me = this;
			
			var destinoComercial = get('!activo.esEditableDestinoComercial');
			if(destinoComercial == true || get('isCarteraBankia')) {
				return true;
			} else {
				return false;
			}
		 },
		
		 tieneGestionDnd: function(get){
			var tieneGestionDnd = get('activo.tieneGestionDndCodigo');
			//var tieneGestionDndCombo = this.getView().lookupReference('gestionDndCodigo');

			if (tieneGestionDnd === '01') {
				return true;
			} else {
				return false;
			}
		 },
		 
	    isCarteraBankiayTienePosesion:function(get){
	    	var me = this;
	    	var isBankia = get('isCarteraBankia');	    	
	    	var tienePosesion = get('tienePosesion');
	    	
	    	if (isBankia || tienePosesion){
	    		return true;
	    	}
	    	return false;
		},
		
	    isCarteraBankiaeIsReadOnlyFechaRealizacionPosesion:function(get){
	    	var me = this;
	    	var isBankia = get('isCarteraBankia');	    	
	    	var isReadOnlyFechaRealizacionPosesion = get('isReadOnlyFechaRealizacionPosesion');
	    	
	    	if (isBankia || isReadOnlyFechaRealizacionPosesion){
	    		return true;
	    	}
	    	return false;
		},
		
	    isCarteraBankiayEditarPorcentajeConstruccion:function(get){
	    	var me = this;
	    	var isBankia = get('isCarteraBankia');	    	
	    	var editarPorcentajeConstruccion = get('editarPorcentajeConstruccion');
	    	
	    	if (isBankia || !editarPorcentajeConstruccion){
	    		return true;
	    	}
	    	return false;
		},
		
		esUsuarioTasadorayVpo: function(get){
			var me = this;
			var vpo = get('infoAdministrativa.vpo');
			
			if ($AU.userIsRol(CONST.PERFILES["TASADORA"]) || !vpo) {
				return true;
			}
			return false;
		},
		
		esUsuarioTasadora: function(get){
			var me = this;
			
			return $AU.userIsRol(CONST.PERFILES["TASADORA"]);
		},
		
		isSubcarteraCerberusOrJaguar: function(get) {
			var codigoSubcartera = get('activo.subcarteraCodigo');
	    	var isSareb = get('activo.isCarteraSareb');
	    	var isJaguar = get('activo.isSubcarteraJaguar');
	    	if (CONST.SUBCARTERA['APPLEINMOBILIARIO'] === codigoSubcartera
	    		|| CONST.SUBCARTERA['DIVARIANARROW'] === codigoSubcartera
	    		|| CONST.SUBCARTERA['DIVARIANREMAINING'] === codigoSubcartera 
	    		|| isSareb
	    		|| isJaguar){
	    	return true;
	    	}
	    	return false;
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
	    	
    		comboMunicipioDatosBasicos: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboMunicipio',
					extraParams: {codigoProvincia: '{activo.provinciaCodigo}'}
				}
    		},
    		
    		comboProvinciaOE: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'provincias'}
				}   	
	    	},
	    	
    		comboMunicipioOE: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboMunicipio',
					extraParams: {codigoProvincia: '{activo.provinciaCodigoOE}'}
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
				},
				autoLoad: false,
				remoteFilter: false,
				remoteSort: false
				
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
       		 model: 'HreRem.model.DocumentacionAdministrativa',
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
    		storeTituloOrigenActivo: {								        		
    			model: 'HreRem.model.ComboBase',   
      		     proxy: {
        		        type: 'uxproxy',
        		        remoteUrl: 'activo/getOrigenActivo',
        		        extraParams: {id: '{activo.id}'}
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
    		
    		storeDeudores: {
				 model: 'HreRem.model.ActivoDeudorAcreditador',
				 proxy: {
				    type: 'uxproxy',
					remoteUrl: 'activo/getListDeudoresById',
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
    		
    		storeDocumentosActivoAgrupacion: {
   			 pageSize: $AC.getDefaultPageSize(),
   			 model: 'HreRem.model.AdjuntoActivoAgrupacion',
	      	     proxy: {
	      	        type: 'uxproxy',
	      	        remoteUrl: 'agrupacion/getListAdjuntosAgrupacionByIdActivo',
	      	        extraParams: {id:'{activo.id}'}
	          	 },
	          	 groupField: 'descripcionTipo',
	          	 autoLoad: false
    		},
    		
    		storeDocumentosActivoProyecto: {
   			 pageSize: $AC.getDefaultPageSize(),
   			 model: 'HreRem.model.AdjuntoActivoProyecto',
	      	     proxy: {
	      	        type: 'uxproxy',
	      	        remoteUrl: 'proyecto/getListAdjuntosProyecto',
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
		        	extraParams: {numActivo: '{activo.numActivo}' ,esHistoricoPeticionActivo: true},
		        	actionMethods: {read: 'POST'} // Necesario para que el filtro no se mande en la URL lo que provoca un problema de encoding
		        	
		    	},	    		
		    	remoteSort: true,
		    	remoteFilter: true,	    	
		    	autoLoad: false
	    	},
	    	
	    	storeActivosAsociados: {
	    		pageSize: 10,
	    		model: 'HreRem.model.ActivosAsociados',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'activo/getListAsociadosById',
    				extraParams: {activo: '{activo.id}'} 
    			},
    			remoteSort: true,
    		    remoteFilter: true
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
					extraParams: {codigoTipoActivo: '{activo.tipoActivoCodigo}',idActivo: '{activo.id}'}
				}
    		},
    		
    		//
    		comboFiltroSubtipoActivo: {
				model: 'HreRem.model.ComboBase',
	    		proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoActivoFiltered',
					extraParams: {codCartera: '{activo.entidadPropietariaCodigo}',codTipoActivo: '{activo.tipoActivoCodigo}'}
				}
    		},

    		
    		comboSubtipoActivoOE: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoActivo',
					extraParams: {codigoTipoActivo: '{activo.tipoActivoCodigoOE}'}
				}
    		},

    		comboSubtipoActivoAdmision: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoActivo',
					extraParams: {codigoTipoActivo: '{activoAdmision.tipoActivoCodigo}',idActivo: '{activoAdmision.id}'}
				}
    		},

    		comboSubtipoActivoAdmisionIC: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoActivo',
					extraParams: {codigoTipoActivo: '{activoInforme.tipoActivoCodigo}',idActivo: '{activoInforme.id}'}
				}
    		},

    		comboSubtipoActivoMediadorIC: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoActivo',
					extraParams: {codigoTipoActivo: '{infoComercial.tipoActivoCodigo}',idActivo: '{infoComercial.id}'}
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
    		
    		comboTipoSolicitud: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tipoSolicitudTributo'}
				},
				autoLoad: true
    		},
    		
    		comboResultadoSolicitud: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'resultadoSolicitud'}
				},
				autoLoad: true
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
    		comboCanalDePublicacion:{
	 			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'canalDePublicacionActivo'}
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
			
			storeHistoricoDiarioDeGestion:{
    			pageSize: $AC.getDefaultPageSize(),
    			model: 'HreRem.model.HistoricoGestionGrid',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'activo/getHistoricoDiarioGestion',
    				extraParams: {id: '{activo.id}'}
    			}
    		},
			
		comboSituacionComercial: {
			model: 'HreRem.model.DDBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'situacionComercial'}
			}
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
				extraParams: {tipoRechazoOfertaCodigo: '{ofertaRecord.tipoRechazoCodigo}', idOferta: '{ofertaRecord.idOferta}'}
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
			model: 'HreRem.model.ActivoIntegrado',
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
		
		storeActivoTributos: {
			model: 'HreRem.model.ActivoTributos', 
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getActivoTributosById',
				extraParams: {idActivo: '{activo.id}'}
			}
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
				extraParams: {codigoTipoActivo: '{activo.tipoActivoCodigo}',idActivo: '{activo.id}'}
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
		comboEstadoLocalizacion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoEstadoLoc'}
			}
		},
		comboSubestadoGestion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getSubestadoGestion',
				extraParams: {idActivo: '{activo.id}'}
			}
		},
		
		comboSubestadoGestionFiltered: {
			model: 'HreRem.model.DDBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboSubestadoGestionFiltered',
				extraParams: {codLocalizacion: '{datosComunidad.estadoLocalizacion}'}
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

		comboSituacionActivo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'situacionActivo'}
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
   		},
   		
		storeCalifiacionNegativa:{
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.CalificacionNegativaModel',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getCalificacionNegativa',
				extraParams: {id: '{activo.id}'}
			},
			autoLoad: true
		},
		
		
		
   		comboDDTipoTituloActivoTPA: {
			model: 'HreRem.model.DDBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoTituloActivoTPA'}
			}
		},
		
		storeHistoricoTramitacionTitulo:{
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.HistoricoTramtitacionTituloModel',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getHistoricoTramitacionTitulo',
				extraParams: {id: '{activo.id}'}
			},

			autoLoad: true
		},

		comboServicerActivo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'servicerActivo'}
			}
		},
		
		comboCesionSaneamiento: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getPerimetroAppleCesion',
				extraParams: {codigoServicer: '{comboPerimetroAppleServicer.value}'}
			}
		},
		
		comboEquipoGestion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposEquipoGestion'}
			}
		},
		
		comboEstadoGestionPlusvalia: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadoGestionPlusvalia'}
			}
		},
		
		comboSiNoDatosPerimetroApple: {
			data : [	        	
	        	{"codigo":"0", "descripcion":"No"},
	        	{"codigo":"1", "descripcion":"Si"}
	    	]
		},
		
		comboSiNoPlusvalia: {
			data : [
		        {"codigo":"01", "descripcion":"Si"},
		        {"codigo":"02", "descripcion":"No"}
		    ]
		},
		
		comboSiNoPosesionNegociada: {
			data : [
		        {"codigo":"0", "descripcion":"No"},
		        {"codigo":"1", "descripcion":"Si"}
		    ]
		},
		comboSiNoFuerzaPublica: {
			data : [
		        {"codigo":"0", "descripcion":"No"},
		        {"codigo":"1", "descripcion":"Si"}
		    ]
		},

		comboSiNoEntradaVoluntariaPosesion: {
			data : [
		        {"codigo":"0", "descripcion":"No"},
		        {"codigo":"1", "descripcion":"Si"}
		    ]
		},

		storeAdjuntosPlusvalias: {
			 pageSize: $AC.getDefaultPageSize(),
			 model: 'HreRem.model.AdjuntosPlusvalias',
      	     proxy: {
      	        type: 'uxproxy',
      	        remoteUrl: 'activo/getListAdjuntosPlusvalia',
      	        extraParams: {id: '{activo.id}'}
          	 }
		},
		
		storeDatosActivo: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.ListaActivoGrid',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getDatosActivo',
				extraParams: {idActivo: '{activo.id}'}
			},
			autoLoad: true
		},
		
		storeDocumentosTributos: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.DocumentosTributosModel',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'tributo/getDocumentosTributo'
			},
			autoLoad: false
		},
		
		storeFasesDePublicacion: {
			model: 'HreRem.model.DDBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'faseDePublicacion'}
			},
			autoLoad: true
		},
		
		storeSubfasesDePublicacion: {
			model: 'HreRem.model.DDBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboSubfase',
				extraParams: {idActivo: '{activo.id}'}
			}
		},
		
		storeSubfasesDePublicacionFiltered: {
			model: 'HreRem.model.DDBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboSubfaseFiltered'
			}
		},
		
		storeHistoricoFesesDePublicacion:{
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.HistoricoFasesDePublicacion',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getHistoricoFasesDePublicacionActivo',
				extraParams: {id: '{activo.id}'}
			}
		},

		comboCesionUso :{
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'cesionUso'}
			}
		},
				
		comboSinSino: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'DDSiNo'}
			}
		},

		comboDireccionComercial: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoDireccionComercial'}
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
    			value: '{activo.subtipoActivoCodigo}'  
    		}
    	},
 		
 		storeOrigenAnteriorActivo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'origenAnterior'}
			}
		},
		
		storeHistoricoSolicitudesPrecios:{
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.HistoricoSolicitudesPreciosModel',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getHistoricoSolicitudesPrecios',
				extraParams: {id: '{activo.id}'}
			}
		},

		comboTributacionAdquisicion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tributacionAdquisicion'}
			}
		},
		
		comboEstadoVenta: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadoVenta'}
			}
		},
		
		storeReqFaseVenta:{
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.ReqFaseVentaModel',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getReqFaseVenta',
				extraParams: {id: '{activo.id}'}
			}
		},
		
		comboTipoTributo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoTributo'}
			},
			autoLoad: true
		},

		storeSuministrosActivo: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.SuministrosActivoModel',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getSuministrosActivo',
				extraParams: {id: '{activo.id}'}
			}
		},
		
		comboDDTipoSuministro: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoSuministro'}
			},
			autoLoad: true
		},
		
		comboDDSubtipoSuministro: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'subtipoSuministro'}
			},
			autoLoad: true
		},
		
		comboDDCompaniaSuministradora: {
			model: 'HreRem.model.Proveedor',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboActivoProveedorSuministro'
			},
			autoLoad: true
		},
		
		comboDDDomiciliado: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'domiciliado'}
			},
			autoLoad: true
		},
		
		comboDDPeriodicidad: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'periodicidad'}
			},
			autoLoad: true
		},
		
		comboDDMotivoAltaSuministro: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivoAltaSuministro'}
			},
			autoLoad: true
		},
		
		comboDDMotivoBajaSuministro: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivoBajaSuministro'}
			},
			autoLoad: true
		},
		
		comboEstadoAdmision: {//
			model: 'HreRem.model.DDBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboEstadoAdmision'//,
				//extraParams: {diccionario: 'estadosAdmision'}
			}
		},
		comboSubestadoAdmision: {//
			model: 'HreRem.model.DDBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getSubEstadoAdmision',
				extraParams: {diccionario: 'subEstadosAdmision'}
			}
		},
		comboSubestadoAdmisionNuevoFiltrado: {//
			model: 'HreRem.model.DDBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/comboSubestadoAdmisionNuevoFiltrado'
			}
		}, 

		storeGridEvolucion:{
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.ActivoEvolucion',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activoadmisionevolucion/getActivoAgendaEvolucion',
				extraParams: {id: '{activo.id}'}
			}
		},
		storeAgendaRevisionTitulo: {
			 pageSize: $AC.getDefaultPageSize(),
			 model: 'HreRem.model.AgendaRevisionTituloGridModel',
     	     proxy: {
     	        type: 'uxproxy',
     	        remoteUrl: 'admision/getListAgendaRevisionTitulo',
     	        extraParams: {idActivo: '{activo.id}'}
         	 }
		},
		
		storeSaneamientoAgendaGrid: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.SaneamientoAgenda',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getSaneamientosAgendaByActivo',
				extraParams: {idActivo: '{activo.id}'}
			}
		},
		
		storeTipologiaAgendaSaneamiento: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoagendasaneamiento'}
			},
			autoLoad: true
		},
		
		comboDDValidado: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'validado'}
			}
		},
				
		comboMotivoExento: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivoExento'}
			}
		},
		
		storeSubtipologiaAgendaSaneamiento: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionarioSubtipologiaAgendaSaneamiento',
				extraParams: {codTipo: '{comboTipologiaRef.value}'}
			}
		},

		comboEstadoRegistral: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadoRegistral'}
			}
		},

		comboSubtipoTituloActivo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'subtiposTitulo'}
			},
			filters: {
                property: 'codigoTipoTitulo',
                value: '{admisionRevisionTitulo.tipoTituloActivo}'
			}
		},
		
		storeCalifiacionNegativaAdicional:{
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.CalificacionNegativaAdicionalModel', //
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getCalificacionNegativaAdicional', //
				extraParams: {id: '{activo.id}'}
			},
			autoLoad: true
		},
		storeComplementoTitulo: {    	
			 model : 'HreRem.model.ActivoComplementoTituloModel',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'activo/getListComplementoTituloById',
		       extraParams: {id: '{activo.id}'}
	    	 }
	    	
		},
		storeTipoTituloComplemento: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoTituloComplemento'}
			}
		},

		comboBBVATipoAlta:{
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboBBVATipoAlta',
				extraParams: {idRecovery: '{activo.idRecovery}'}
			}
		},
		
		storeTipoGastoAsociado: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoGastoAsociado'}
			}
		},
		storeGastosAsociadosAdquisicion: {    	
			 model : 'HreRem.model.GastoAsociadoAdquisicionModel',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'activo/getListGastosAsociadosAdquisicion',
		        extraParams: {id: '{activo.id}'}
		     },
	 	 	autoload: true, 
	        listeners: 
	        	{
       			 	load: 'cargarCamposCalculados'
	        	}
		},

		comboTipoSegmento: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getComboTipoSegmentoActivo',
   				extraParams: {codSubcartera: '{activo.subcarteraCodigo}'}
			}
		},

		storeHistoricoTramitacionTituloAdicional:{
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.HistoricoTramitacionTituloAdicionalModel', 
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getHistoricoTramitacionTituloAdicional', 
				extraParams: {id: '{activo.id}'}
			},
			autoLoad: true
		},
		
		comboMotivoGestionComercialActivo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivoGestionComercial'}
			}
		},
		// Stores para el grid observaciones. Se crean 3 para solucionar problemas de instancia 
		/*

		 * Valor de la constante 
		  	OBSERVACIONES_TAB_LAUNCH: {
			ACTIVO : 'activo',
			SANEAMIENTO: 'saneamiento',
			REVISION_TITULO: 'revisionTitulo'
		}*/
		/*storeObservaciones_activo: {    
		 pageSize: $AC.getDefaultPageSize(),
		 model: 'HreRem.model.Observaciones',
	     proxy: {
	        type: 'uxproxy',
	        remoteUrl: 'activo/getListObservaciones',
	        extraParams: {} // Dynamic.
    	 }
		},
		storeObservaciones_saneamiento: {    
		 pageSize: $AC.getDefaultPageSize(),
		 model: 'HreRem.model.Observaciones',
	     proxy: {
	        type: 'uxproxy',
	        remoteUrl: 'activo/getListObservaciones',
	        extraParams: {} // Dynamic.
    	 }
		},
		storeObservaciones_revisionTitulo: {    
		 pageSize: $AC.getDefaultPageSize(),
		 model: 'HreRem.model.Observaciones',
	     proxy: {
	        type: 'uxproxy',
	        remoteUrl: 'activo/getListObservaciones',
	        extraParams: {} // Dynamic.
    	 }
		},*/
		comboTipoTransmision: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoTransmision'}
			}
		},
		comboTipoAlta: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoAlta'}
			}/*,autoLoad: true*/
		},
		//Admite mascota
		comboAdmiteMascota: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposAdmiteMascota'}
			}
		},		
		comboDDTipoCorrectivoSareb: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoCorrectivoSareb'}
			}
		},
		comboDDTipoCuotaComunidad: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoCuotaComunidad'}
			}
		},
		comboSegmetacionSareb: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'segmentacionSareb'}
			}
		},

		comboPlanta: {
			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'plantaEdificio'}
				}
		},

		comboEscalera: {
			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'escaleraEdificio'}
				}
		},

		comboEstadoTecnico: {
			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadoTecnico'}
				}
		},

		comboTipoProcedenciaProducto: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoProcedenciaProducto'}
			}
		},
		comboCategoriaComercializacion: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'categoriaComercializacion'}
				}
		},
		comboDistritoCodPostal: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getComboTipoDistritoByCodPostal',
   				extraParams: {codPostal: '{activo.codPostal}'}
			},
			autoLoad: true
		},
		storeSituacionOcupacional: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.SituacionOcupacionalGridModel',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getListHistoricoOcupadoTitulo',
				extraParams: {id: '{activo.id}'}
		   }
	   },

	   comboMotivoNecesidadArras: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivoNecesidadArras'}
			},
			autoLoad: true   
	   },
	   comboDisponibleAdministrativo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'disponibleAdministrativo'}
			},
			autoLoad: true   
	   },	   
	   comboVinculoCaixa: {
		   	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'vinculoCaixa'}
			}
	   },	   

	   comboDisponibleAdministrativo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'disponibleAdministrativo'}
			}
		},
	   
	   comboRiesgoOperacion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoRiesgoOperacion'}
			}
	   },

		comboEstadoComercialVenta: {
			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadoComercialVenta'}
				}
		},

		comboEstadoComercialAlquiler: {
			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadoComercialAlquiler'}
				}
		},

		storeDescuentoColectivos: {
      		 model: 'HreRem.model.DescuentoColectivosGridModel',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'activo/getDescuentoColectivos',
		        extraParams: {id: '{activo.id}'}
	    	 }
   		},
		
		storePreciosVigentesCaixa: {
   		 model: 'HreRem.model.PreciosVigentesCaixaGridModel',
	     proxy: {
	        type: 'uxproxy',
	        remoteUrl: 'activo/getPreciosVigentesCaixaById',
	        extraParams: {id: '{activo.id}'}
    	 }
		},
		
		comboSociedadOrigenCaixa: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'sociedadOrigenCaixa'}
			}
		},

		comboDisponibleTecnico: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'disponibleTecnico'}

			}
		},
		
		comboBancoOrigenCaixa: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'bancoOrigenCaixa'}
			}
		},
		
		comboTributPropClienteExentoIva: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tributacionPropClienteExentoIva'}
			}
	   },
	   comboTributacionPropuestaVenta: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tributacionPropVenta'}
			}
	   },
	   
	   comboSiNoBoolean: {
	    	data : [
	    		{"codigo":"true", "descripcion":"Si"},
	    		{"codigo":"false", "descripcion":"No"}
	    		]  
	    },

		comboRiesgoOperacion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoRiesgoOperacion'}
			}
		},
		comboDisponibleTecnico: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'disponibleTecnico'}
			}
		},
		comboMotivoTecnico: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tributacionPropVenta'}
			}
	   },

		comboMotivoTecnico: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivoTecnico'}
			}
		},
		storeTipoFoto :{
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposFoto'}
			},
			autoLoad: true
    	},
		comboEstadoDeposito: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadoDeposito'}
			},
			autoLoad: true
		},
		comboMunicipioAnterior: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboMunicipioSinFiltro'
			},
			autoLoad: true
		},
		comboMetodoValoracion: {    		
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'metodoValoracion'}
			},
			autoLoad: true
		},
		comboDesarrolloPlanteamiento: {    		
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'desarrolloPlanteamiento'}
			},
			autoLoad: true
		},
		comboFaseGestion: {    		
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'faseGestion'}
			},
			autoLoad: true
		},
		comboProductoDesarrollar: {    		
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'productoDesarrollar'}
			},
			autoLoad: true
		},
		comboProximidadRespectoNucleoUrbano: {    		
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'proximidadRespectoNucleoUrbano'}
			},
			autoLoad: true
		},
		comboSistemaGestion: {    		
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'sistemaGestion'}
			},
			autoLoad: true
		},
		comboTipoSuelo: {    		
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'subtiposActivo'}
			},
			autoLoad: true
		},
		comboProductoDesarrollarPrevisto: {    		
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'productoDesarrollarPrevisto'}
			},
			autoLoad: true
		},
		comboTipoDatoUtilizadoInmuebleComparable: {    		
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoDatoUtilizadoInmuebleComparable'}
			},
			autoLoad: true
		},
		comboTasadoraCaixa: {    		
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tasadoraCaixa'}
			},
			autoLoad: true
		}
	 }
});