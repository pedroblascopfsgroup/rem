Ext.define('HreRem.view.activos.tramites.LanzarTareaAdministrativaModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.lanzartareaadministrativa',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase' ],
    
    data: {
    	tramite: null,
    	idExpediente: null
    },
    

    stores: {
		
    	comboSiNoRem: {
			data : [
		        {"codigo":"1", "descripcion":eval(String.fromCharCode(34,83,237,34))},
		        {"codigo":"0", "descripcion":"No"}
		    ]
		},
		comboComiteSancion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'comitesSancion'}
			}
		},
		/*Este es el que se utiliza para sacar los comites de la cartera*/
		comboComites: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getComitesByIdExpediente',
		        extraParams: {idExpediente: '{idExpediente}'}
	    	}	    	
	    },
	    
		comboMotivoAnulacionExpediente: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivoAnulacionExpediente'}
			}
		},
		comboTipoArras: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposArras'}
			}
		},
		comboTareaDestinoSalto: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tareaDestinoSalto'}
			}
		},
		
		comboResolucionComite: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionarioTareas',
				extraParams: {diccionario: 'DDResolucionComite'}
			}
		}		
    	
    }
    
});