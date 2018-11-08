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
	    	 return get('agrupacionficha.codigoCartera') == CONST.CARTERA['LIBERBANK'];
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