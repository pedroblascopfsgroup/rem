Ext.define('HreRem.view.agrupaciones.AgrupacionesModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.agrupaciones',
    
    requires: ['HreRem.ux.data.Proxy', 'HreRem.model.Agrupaciones'],
    
 	stores: {
        
        agrupaciones: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Agrupaciones',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/tareas.json',
		        remoteUrl: 'agrupacion/getListAgrupaciones'
	    	},
	    	autoLoad: true,
	    	session: true,
	    	remoteSort: true,
	    	remoteFilter: true,
	        listeners : {
	            beforeload : 'paramLoading'
	        }
    	},

    	comboTipoAgrupacion: {
			pageSize: 10,
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoAgrupacion'}
	    	},
	    	autoLoad: true
    	},
    	
    	comboSiNoRem: {
			data : [
		        {"codigo":"1", "descripcion":eval(String.fromCharCode(34,83,237,34))},
		        {"codigo":"0", "descripcion":"No"}
		    ]
		}
        
        
    }
    
});