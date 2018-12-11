Ext.define('HreRem.view.activos.detalle.GencatComercialActivoModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.gencatcomercialactivo',
    
    requires : [
    	'HreRem.ux.data.Proxy', 
    	'HreRem.model.ComboBase',
    	'HreRem.model.OfertasAsociadasActivo',
    	'HreRem.model.ReclamacionActivo',
    	'HreRem.model.DocumentoActivoGencat',
    	'HreRem.model.HistoricoComunicacionGencat'
    ],
    
    data: {
    	/*activo: null,*/
    },
    
    formulas: {
	     
	     /*
	     esOcupacionLegal: function(get) {
	     	
	     	var ocupado = get('situacionPosesoria.ocupado') == "1";
	     	var conTitulo = get('situacionPosesoria.conTitulo') == "1";
	     	
	     	return ocupado && conTitulo
	     	
	     },*/
	     
    },

    stores: {
    	
    	comboSancionGencat: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'sancionGencat'}
			}   	
    	},
    	
    	comboEstadoComunicacionGencat: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadoComunicacionGencat'}
			}   	
    	},
    	
    	comboNotificacionGencat: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoNotificacionGencat'}
			}   	
    	},
    	
    	comboEstadoVisita: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosVisita'}
			}   	
    	},
    	
    	comboSiNo: {
			data : [
		        {"codigo":"true", "descripcion":eval(String.fromCharCode(34,83,237,34))},
		        {"codigo":"false", "descripcion":"No"}
		    ]
		},
		
		storeOfertasAsociadasActivo: {    	
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.VisitasActivo',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'gencat/getOfertasAsociadasByIdActivo',
				extraParams: {id: '{activo.id}'}
			}
		},
		
		storeReclamacionesActivo: {    	
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.ReclamacionActivo',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'gencat/getReclamacionesByIdActivo',
				extraParams: {id: '{activo.id}'}
			}
		},
		
		storeDocumentosActivoGencat: {
			 pageSize: $AC.getDefaultPageSize(),
			 model: 'HreRem.model.DocumentoActivoGencat',
     	     proxy: {
     	        type: 'uxproxy',
     	        remoteUrl: 'gencat/getListAdjuntos',
     	        extraParams: {id: '{activo.id}'}
         	 },
         	 groupField: 'descripcionTipo'
		},
		
		storeHistoricoComunicaciones: {    	
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.HistoricoComunicacionGencat',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'gencat/getHistoricoComunicacionesByIdActivo',
				extraParams: {id: '{activo.id}'}
			}
		},
		
		storeHistoricoOfertasAsociadasActivo: {    	
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.VisitasActivo',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'gencat/getHistoricoOfertasAsociadasIdComunicacionHistorico'/*,
				extraParams: {id: '{activo.id}'}*/
			}
		}
		
    }
});