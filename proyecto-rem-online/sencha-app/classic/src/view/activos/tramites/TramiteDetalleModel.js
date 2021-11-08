Ext.define('HreRem.view.activos.tramites.TramiteDetalleModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.tramitedetalle',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.Gestor' ],
    
    data: {
    	tramite: null
    	
    },
    
    formulas: {
    
		getSrcCartera: function(get) {
	     	
	     	var cartera = get('tramite.cartera');
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
	     	var cartera = get('tramite.cartera');
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
		
		getSrcMultiActivo: function(get) {
		 	var esMultiActivo = get('tramite.esMultiActivo');
		 	
		 	if(esMultiActivo == true) {
		 		return 'resources/images/ico_agrupaciones_column.svg';
		 	} else {
		 		return 'resources/images/ico_agrupaciones_active.svg';
		 	}
		 	
		},
		
		esEnTramite: function(get) {
			var estado = get('tramite.estado');
			if (estado === 'En trámite') {
				return true;
			} else {
				return false;
			}
		}
		
    },
    
    stores: {
    		
    	tareasTramite: {
				
				pageSize: $AC.getDefaultPageSize(),
		    	model: 'HreRem.model.TareaList',
		    	proxy: {
			        type: 'uxproxy',
			        remoteUrl: 'activo/getTareasTramite',
			        extraParams: {idTramite: '{tramite.idTramite}'}
		    	},		    	
		    	session: true,
		    	remoteSort: true,
		    	remoteFilter: true,
		    	sorters: [{
		            property: 'fechaVenc',
		            direction: 'ASC'
		        }]
		},
			historicoTareas: {
				
				pageSize: $AC.getDefaultPageSize(),
		    	model: 'HreRem.model.TareaList',
		    	proxy: {
			        type: 'uxproxy',
			        remoteUrl: 'activo/getTareasTramiteHistorico',
			        extraParams: {idTramite: '{tramite.idTramite}'}
		    	},		    	
		    	remoteSort: true,
		    	remoteFilter: true

		},
		
		activosTramite: {
    			pageSize: $AC.getDefaultPageSize(),
				 model: 'HreRem.model.ActivoTramite',
				 proxy: {
				    type: 'uxproxy',
					remoteUrl: 'activo/getActivosTramite',
					extraParams: {idTramite: '{tramite.idTramite}'}
				 }
    	},
    	
    	comboUsuariosReasignacion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
			type: 'uxproxy',
			remoteUrl: 'activo/getComboUsuarios',
			extraParams: {idTipoGestor: '{tipoGestor.selection.id}'}
			}
		},
		
		comboSupervisorReasignacion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
			type: 'uxproxy',
			remoteUrl: 'activo/getComboUsuarios',
			extraParams: {idTipoGestor: '{tipoGestorSupervisor.selection.id}'}
			}
		},
		
		comboMotivoAnulacionAlquiler: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getMotivoAnulacionExpediente'
			}
		},

        comboMotivoAnulacionCaixa: {
            model: 'HreRem.model.ComboBase',
            proxy: {
                type: 'uxproxy',
                remoteUrl: 'activo/getMotivoAnulacionExpedienteCaixa'
            }
        }
     }    
});