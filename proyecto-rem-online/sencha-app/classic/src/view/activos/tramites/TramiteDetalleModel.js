Ext.define('HreRem.view.activos.tramites.TramiteDetalleModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.tramitedetalle',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.Gestor' ],
    
    data: {
    	tramite: null
    	
    },
    
    formulas: {
    
		getSrcCartera: function(get) {
		 	var cartera = get('tramite.cartera');
		 	
		 	if(!Ext.isEmpty(cartera)) {
		 		return 'resources/images/logo_'+cartera.toLowerCase()+'.svg'	     		
		 	} else {
		 		return '';
		 	}
		 	
		 	
		},
		
		getSrcMultiActivo: function(get) {
		 	var esMultiActivo = get('tramite.esMultiActivo');
		 	
		 	if(esMultiActivo == true) {
		 		return 'resources/images/ico_agrupaciones_column.svg';
		 	} else {
		 		return 'resources/images/ico_agrupaciones_active.svg';
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
    	}  		
	
     }    
});