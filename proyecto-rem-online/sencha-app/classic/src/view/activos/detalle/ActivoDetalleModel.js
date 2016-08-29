Ext.define('HreRem.view.activos.detalle.ActivoDetalleModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.activodetalle',
    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.Gestor', 'HreRem.model.GestorActivo', 
    'HreRem.model.AdmisionDocumento', 'HreRem.model.AdjuntoActivo', 'HreRem.model.BusquedaTrabajo',
    'HreRem.model.IncrementoPresupuesto', 'HreRem.model.Distribuciones', 'HreRem.model.Observaciones',
    'HreRem.model.Carga', 'HreRem.model.Llaves', 'HreRem.model.PreciosVigentes','HreRem.model.VisitasActivo','HreRem.model.OfertaActivo'],
    
    data: {
    	activo: null,
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
	     	
	     	return ocupado && conTitulo
	     	
	     },
	     
	     esOcupacionIlegal: function(get) {
	     	
	     	var ocupado = get('situacionPosesoria.ocupado') == "1";
	     	var conTitulo = get('situacionPosesoria.conTitulo') == "1";
	     	
	     	return ocupado && !conTitulo;
	     	
	     },
	     
	     getIconClsEstadoAdmision: function(get) {
	     	
	     	var estadoAdmision = get('activo.admision');
	     	
	     	if(estadoAdmision) {
	     		return 'app-tbfiedset-ico icono-ok'
	     	} else {
	     		return 'app-tbfiedset-ico icono-ko'
	     	}
	     },
	     
	     getIconClsEstadoGestion: function(get) {
	     	
	     	var estadoAdmision = get('activo.gestion');
	     	
	     	if(estadoAdmision) {
	     		return 'app-tbfiedset-ico icono-ok'
	     	} else {
	     		return 'app-tbfiedset-ico icono-ko'
	     	}
	     },
	    
	     //Condicionantes
	     getIconClsCondicionantesRuina: function(get) {
	    	 var condicion = get('activoCondicionantesDisponibilidad.ruina');
		     	if(!eval(condicion)) {
		     		return 'app-tbfiedset-ico'
		     	} else {
		     		return 'app-tbfiedset-ico icono-ko'
		     	}
		     },
		     
		 getIconClsCondicionantesPendiente: function(get) {
			 var condicion = get('activoCondicionantesDisponibilidad.pendienteInscripcion');
			   	if(!eval(condicion)) {
			   		return 'app-tbfiedset-ico'
			   	} else {
			   		return 'app-tbfiedset-ico icono-ko'
			   	}
			 },		 
		getIconClsCondicionantesObraTerminada: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.obraNuevaSinDeclarar');
			   	if(!eval(condicion)) {
			   		return 'app-tbfiedset-ico'
			   	} else {
			   		return 'app-tbfiedset-ico icono-ko'
			   	}
			 },			     
		getIconClsCondicionantesSinPosesion: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.sinTomaPosesionInicial');
			   	if(!eval(condicion)) {
			   		return 'app-tbfiedset-ico'
			   	} else {
			   		return 'app-tbfiedset-ico icono-ko'
			   	}
			 },
		getIconClsCondicionantesProindiviso: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.proindiviso');
			   	if(!eval(condicion)) {
			   		return 'app-tbfiedset-ico'
			   	} else {
			   		return 'app-tbfiedset-ico icono-ko'
			   	}
			 },
		getIconClsCondicionantesObraNueva: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.obraNuevaEnConstruccion');
			   	if(!eval(condicion)) {
			   		return 'app-tbfiedset-ico'
			   	} else {
			   		return 'app-tbfiedset-ico icono-ko'
			   	}
			 },					 
		getIconClsCondicionantesOcupadoConTitulo: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.ocupadoConTitulo');
			   	if(!eval(condicion)) {
			   		return 'app-tbfiedset-ico'
			   	} else {
			   		return 'app-tbfiedset-ico icono-ko'
			   	}
			 },							 
		getIconClsCondicionantesTapiado: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.tapiado');
			   	if(!eval(condicion)) {
			   		return 'app-tbfiedset-ico'
			   	} else {
			   		return 'app-tbfiedset-ico icono-ko'
			   	}
			 },	
		getIconClsCondicionantesOtro: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.otro');
			   	if(!eval(condicion)) {
			   		return 'app-tbfiedset-ico'
			   	} else {
			   		return 'app-tbfiedset-ico icono-ko'
			   	}
			 },	
		getIconClsCondicionantesOcupadoSinTitulo: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.ocupadoSinTitulo');
			   	if(!eval(condicion)) {
			   		return 'app-tbfiedset-ico'
			   	} else {
			   		return 'app-tbfiedset-ico icono-ko'
			   	}
			 },	
		getIconClsCondicionantesDivHorizontal: function(get) {
			var condicion = get('activoCondicionantesDisponibilidad.divHorizontalNoInscrita');
			   	if(!eval(condicion)) {
			   		return 'app-tbfiedset-ico'
			   	} else {
			   		return 'app-tbfiedset-ico icono-ko'
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
	     	
	     	if(!Ext.isEmpty(cartera)) {
	     		return 'resources/images/logo_'+cartera.toLowerCase()+'.svg'	     		
	     	} else {
	     		return '';
	     	}
	     	
	     	
	     },
	     
	     getEstadoPublicacionCodigo: function(get) {
			var codigo = Ext.isEmpty(get('activo.estadoPublicacionCodigo')) ? "" : get('activo.estadoPublicacionCodigo');
			return codigo;
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
					extraParams: {codigoProvincia: '{informeComercial.provinciaCodigo}'}
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
    		
    		comboSubtipoCarga: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoCarga',
					extraParams: {codigoTipoCarga: '{carga.tipoCargaCodigo}'}
				}
    		},
    		
    		comboSubtipoCargaEconomica: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoCarga',
					extraParams: {codigoTipoCarga: '{carga.tipoCargaCodigoEconomica}'}
				}
    		},

    		storeCargas: {    	
    		 pageSize: $AC.getDefaultPageSize(),
			 model : 'HreRem.model.Carga',
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
   		     proxy: {
   		        type: 'uxproxy',
   		        remoteUrl: 'activo/getListOfertasActivos',
   		        extraParams: {id: '{activo.id}'}
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
       		
    		storeLlaves: {    			
     		 model: 'HreRem.model.Llaves',
 		     proxy: {
 		        type: 'uxproxy',
 		        remoteUrl: 'activo/getListLlavesById',
 		        extraParams: {id: '{activo.id}'}
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
    		
    		storeTramites: {
    			
    			 model: 'HreRem.model.Tramite',
	      	     proxy: {
	      	        type: 'uxproxy',
	      	        remoteUrl: 'activo/getTramites',
	      	        extraParams: {idActivo: '{activo.id}'}
	          	 },
	          	 remoteSort: true

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
					extraParams: {codigoTipoActivo: '{informeComercial.tipoActivoCodigo}'}
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
    		
    		historicocondiciones: {    
    			pageSize: $AC.getDefaultPageSize(),
    			model: 'HreRem.model.CondicionEspecifica',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'activo/getCondicionEspecificaByActivo',
    				extraParams: {id: '{activo.id}'}
    			}
    		},
    		
    		historicoEstados:{
    			pageSize: $AC.getDefaultPageSize(),
    			model: 'HreRem.model.EstadoPublicacion',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'activo/getEstadoPublicacionByActivo',
    				extraParams: {id: '{activo.id}'}
    			},
				autoload: true
    		},
    		
    		historicoInformeComercial:{
    			pageSize: $AC.getDefaultPageSize(),
    			model: 'HreRem.model.InformeComercial',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'activo/getEstadoInformeComercialByActivo',
    				extraParams: {id: '{activo.id}'}
    			},
				autoload: true
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
				autoload: true
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
	    }
     }    
});