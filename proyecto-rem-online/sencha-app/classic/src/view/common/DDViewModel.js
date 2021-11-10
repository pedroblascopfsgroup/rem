Ext.define('HreRem.view.common.DDViewModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ddviewmodel',

    stores: {	    	
			
    		comboFiltroProvincias: {
    	   		source: 'provincias',
    	   		loadSource: true
    		},

    		comboFiltroMunicipios: {
    	   		source: 'municipios',
    	   		loadSource: true
    		},

    	   	comboEntidadPropietaria: {
    	   		source: 'entidadPropietaria',
    	   		loadSource: true
    		},
    		
    		comboSubentidadPropietaria: {
    			model: 'HreRem.model.ComboBase',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'generic/getDiccionario',
    				extraParams: {diccionario: 'subentidadesPropietarias'}
    			}
    		},

    		comboEstadosPropuesta: {
    			source: 'estadosPropuesta',
    	   		loadSource: true
    		},

    		comboEstadosPropuestaActivo: {
    			source: 'estadosPropuestaActivo',
    	   		loadSource: true
    		},

    		comboSiNoRem: {
				data : [
			        {"codigo":"1", "descripcion":eval(String.fromCharCode(34,83,237,34))},
			        {"codigo":"0", "descripcion":"No"}
			    ]
			},

			comboTiposComercializacion: {
				data : [
			        {"codigo":"04", "descripcion": "Alquiler"},
			        {"codigo":"02", "descripcion": "Alquiler y venta"},
			        {"codigo":"01", "descripcion": "Venta"}
			       
			    ]
    		},

    		comboEstadoInformeComercial: {
				data : [
			        {"codigo":"01", "descripcion": "Emitido"},
			        {"codigo":"02", "descripcion": "Aprobado"}
			    ]
    		},

    		comboTiposPropuesta: {
    			data : [
			        {"codigo":"01", "descripcion": "Preciar"},
			        {"codigo":"02", "descripcion": "Repreciar"},
			        {"codigo":"03", "descripcion": "De descuento"}
			    ]
    		},
    		
    		comboTiposPropuestaManual: {
    			data : [
			        {"codigo":"01", "descripcion": "Preciar"},
			        {"codigo":"02", "descripcion": "Repreciar"}
			    ]
    		},

    		comboTiposFecha: {
    			data : [
			        {"codigo":"01", "descripcion": "Fecha de generacion"},
			        {"codigo":"02", "descripcion": "Fecha de envio al propietario"},
			        {"codigo":"03", "descripcion": "Fecha de sancion"},
			        {"codigo":"04", "descripcion": "Fecha de carga"}
			    ]
    		},

    		comboAceptadoRechazado: {
				data : [
			        {"codigo": "0", "descripcion": "Rechazado"},
			        {"codigo": "1", "descripcion": "Aprobado"}
			    ]
    		},
    		
    		comboPosibleInforme: {
				data : [
			        {"codigo": 1, "descripcion": eval(String.fromCharCode(34,83,237,34))},
			        {"codigo": 0, "descripcion": "No"}
			    ]
    		},
    		
    		comboAcuerdo: {
				data : [
			        {"codigo": 0, "descripcion": "No Solucionar"},
			        {"codigo": 1, "descripcion": "Solucionar"}
			    ]
    		},
    		comboPaises: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {
						diccionario: 'paises'
					}
				}
			},
			comboProvincia: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {
						diccionario: 'provincias'
					}
				}
			},
			comboMunicipio: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboMunicipio',
					extraParams: {codigoProvincia: '{plusvalia.provinciaCodigo}'}
				}
			},
			comboTipoPersona: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {
						diccionario: 'tipoPersona'
					}
				}
			},
			comboRegimenesMatrimoniales: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {
							diccionario: 'regimenesMatrimoniales'
						}
					}
			},
			comboEstadoContraste: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {
						diccionario: 'estadoContraste'
					}
				}
			}
     }
});