Ext.define('HreRem.view.precios.PreciosModel', {
    extend: 'HreRem.view.common.DDViewModel',
    alias: 'viewmodel.precios',
    
    stores: {
    	
    	
    		activos: {
			    pageSize: $AC.getDefaultPageSize(),
		    	proxy: {
			        type: 'uxproxy',
			        remoteUrl: 'precios/getActivos',
			        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
		    	},
		    	remoteSort: true,
		    	remoteFilter: true,
		    	listeners : {
		            beforeload : 'beforeLoadActivos'
		        }
    		},
    		
    		    	
    		propuestas: {
			    pageSize: $AC.getDefaultPageSize(),
		    	proxy: {
			        type: 'uxproxy',
			        remoteUrl: 'precios/getPropuestas',
			        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
		    	},
		    	remoteSort: true,
		    	remoteFilter: true,
		    	listeners : {
		            beforeload : 'beforeLoadPropuestas'
		        }
		        
    		},
    		
    		comboSiNoRem: {
				data : [
			        {"codigo":"1", "descripcion":eval(String.fromCharCode(34,83,237,34))},
			        {"codigo":"0", "descripcion":"No"}
			    ]
			},
			
			comboTipoTitulo: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposTitulo'}
				}
    		}, 
    		
    		comboSubtipoTitulo: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'subtiposTitulo'}
				}
    		},
    		
    		comboTiposComercializacion: {
				data : [
			        {"codigo":"01", "descripcion": "Alquiler"},
			        {"codigo":"02", "descripcion": "Venta"},
			        {"codigo":"03", "descripcion": "Ambos"}
			    ]
    		},
    		
    		comboEstadoInformeComercial: {
				data : [
			        {"codigo":"01", "descripcion": "Emitido"},
			        {"codigo":"02", "descripcion": "Aprobado"}
			    ]
    		},
    		
    		comboTiposPopuesta: {
    			data : [
			        {"codigo":"01", "descripcion": "Preciar"},
			        {"codigo":"02", "descripcion": "Repreciar"},
			        {"codigo":"03", "descripcion": "De descuento"}
			    ]
    		},
    		
    		comboTiposFecha: {
    			data : [
			        {"codigo":"01", "descripcion": "Fecha de generacion"},
			        {"codigo":"02", "descripcion": "Fecha de envio al propietario"},
			        {"codigo":"03", "descripcion": "Fecha de sancion"},
			        {"codigo":"04", "descripcion": "Fecha de carga"}
			    ]
    			
    		}
    }
});