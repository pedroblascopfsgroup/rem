Ext.define('HreRem.view.agrupaciones.detalle.AgrupacionDetalleModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    //extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.agrupaciondetalle',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.ActivoAgrupacion', 
    'HreRem.model.ActivoSubdivision', 'HreRem.model.Subdivisiones', 'HreRem.model.VisitasAgrupacion','HreRem.model.OfertasAgrupacion','HreRem.model.OfertaComercial'],
    
    data: {
    	agrupacionficha: null
    	
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
	     
	     esAgrupacionAsistida: function(get) {
	    	 
	     	var tipoAgrupacion = get('agrupacionficha.tipoAgrupacionCodigo');
	     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['ASISTIDA'])) {
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
	     
	     esAgrupacionObraNuevaOrAsistida: function(get) {
	    	 
	     	return get('esAgrupacionObraNueva') || get('esAgrupacionAsistida');
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
	    	 return (existeFechaBaja || !esAgrupacionObraNueva || !esAgrupacionAsistida);
	    	 
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
				extraParams: {codigoProvincia: '{agrupacionficha.provinciaCodigo}'}
			},autoLoad: true
		},
    	
		storeFotos: {    			
    		 model: 'HreRem.model.Fotos',
		     proxy: {
		        type: 'uxproxy',
		        //remoteUrl: 'activo/getFotosById',
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
			 model: 'HreRem.model.ActivoAgrupacion',
			 proxy: {
			    type: 'uxproxy',
				remoteUrl: 'agrupacion/getListActivosAgrupacionById',
				extraParams: {id: '{agrupacionficha.id}'},
				
				api: {
		            read:    'agrupacion/getListActivosAgrupacionById',
		            create:  'agrupacion/createActivoAgrupacion',
		            destroy: 'agrupacion/deleteActivoAgrupacion'
		        }
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
	    }
    	
    	
     }    
});