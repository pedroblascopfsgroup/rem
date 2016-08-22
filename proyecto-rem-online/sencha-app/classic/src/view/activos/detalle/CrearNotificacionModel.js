Ext.define('HreRem.view.activos.detalleCrearNotificacionModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.crearnotificacion',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.Gestor', 'HreRem.model.GestorActivo', 'HreRem.model.AdmisionDocumento', 'HreRem.model.AdjuntoActivo' ],
    
    data: {
    	activo: null
    	
    },
    

    stores: {
    		
    		storeGestores: {
				model: 'HreRem.model.GestorActivo',
			   	proxy: {
			   		type: 'uxproxy',
			   	    remoteUrl: 'activo/getGestores',
			   	    extraParams: {idActivo: '{idActivo}'}
			    }
    		},
    		comboUsuarios: {
				model: 'HreRem.model.ComboBase',
				proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getComboUsuarios',
				extraParams: {idTipoGestor: '{tipoGestor.selection.id}'}
				}
    		}
	
     }    
});