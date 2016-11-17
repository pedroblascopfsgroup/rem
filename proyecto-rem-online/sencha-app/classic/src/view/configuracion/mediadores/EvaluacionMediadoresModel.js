Ext.define('HreRem.view.configuracion.mediadores.EvaluacionMediadoresModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.evaluacionmediadoresmodel',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 
    			'HreRem.model.MediadorEvaluarModel', 'HreRem.model.CarteraMediadorEvaluarModel', 
    			'HreRem.model.OfertaMediadorEvaluarModel'],
    
    data: {
    	proveedor: null
    },
    
    stores: {
		listaMediadoresEvaluar: {    
   		 	pageSize: $AC.getDefaultPageSize(),
   		 	model: 'HreRem.model.MediadorEvaluarModel',
       		proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'proveedores/getMediadoresEvaluar',
		        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
	    	},
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	    	listeners : {
	            beforeload : 'paramLoading'
	        }
   		},

		listaStatsCarteraMediadores: {    
   		 	pageSize: $AC.getDefaultPageSize(),
   		 	model: 'HreRem.model.CarteraMediadorEvaluarModel',
       		proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'proveedores/getStatsCarteraMediadores',
		        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'},
		        extraParams: {id: '{mediadorSelected.id}'}
	    	},
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true
   		},

		listaOfertasMediadores: {    
   		 	pageSize: $AC.getDefaultPageSize(),
   		 	model: 'HreRem.model.OfertaMediadorEvaluarModel',
       		proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'proveedores/getOfertasCarteraMediadores',
		        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'},
		        extraParams: {id: '{mediadorSelected.id}'}
	    	},
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true
   		}
    }
    
});