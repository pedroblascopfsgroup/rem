Ext.define('HreRem.view.common.GenericViewModel', {
    extend: 'HreRem.view.common.DDViewModel',
    alias: 'viewmodel.genericviewmodel',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.Gestor', 'HreRem.model.GestorActivo'],

    stores: {
    		
    		comboTipoVia: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposVia'}
				},
				autoLoad: true
    		},
    		
    		comboTipoActivo: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposActivo'}
				},
				autoLoad: true
    		},
    		
    		comboSubtipoActivo: {
    			model: 'HreRem.model.ComboBase',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'generic/getDiccionario',
    				extraParams: {diccionario: 'subtiposActivo'}
    			},
    			autoLoad: true
    		},
    		
    		comboTipoActivoBde: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposActivoBde'}
				},
				autoLoad: true
    		},
    		
    		comboSubtipoActivoBde: {
    			model: 'HreRem.model.ComboBase',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'generic/getDiccionario',
    				extraParams: {diccionario: 'subtiposActivoBde'}
    			},
    			autoLoad: true
    		},
    		
    		comboEstadoActivo: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadosActivo'}
				}/*,autoLoad: true*/
    		},
    		
    		comboSiNo: {
    			data : [
			        {"codigo":"01", "descripcion": eval(String.fromCharCode(34,83,237,34))},
			        {"codigo":"0", "descripcion":"No"} 
			    ]
    		},
    		
    		comboSiNoBoolean: {
    			data : [
			        {"codigo":"true", "descripcion": eval(String.fromCharCode(34,83,237,34))},
			        {"codigo":"false", "descripcion":"No"} 
			    ]
    		},
    		
    		comboSiNoNSRem: {
    			data : [
			        {"codigo":"1", "descripcion": eval(String.fromCharCode(34,83,237,34))},
			        {"codigo":"0", "descripcion":"No"},
			        {"codigo":undefined, "descripcion":"-"}
			    ]
    		},
    		comboSiNoDict: {
    			data : [
			        {"codigo":"01", "descripcion": eval(String.fromCharCode(34,83,237,34))},
			        {"codigo":"02", "descripcion":"No"}
			    ]
    		},
    		comboBuenoMaloRem: {
    			data : [
			        {"codigo":"1", "descripcion":"Bueno"},
			        {"codigo":"0", "descripcion":"Malo"},
			        {"codigo":undefined, "descripcion":"-"} 
			    ]
    		},
    		
    		comboPais: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'paises'}
				},
				filters: {
                    property: 'codigo',
                    value: '011'
				}
    		},
    		
    		comboDireccionComercial: {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'direccionComercial'}
				}  			
    		},    		
    		
    		comboTipoCuota: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposCuota'}
				}/*,autoLoad: true*/
    		},
    		
    		comboTipoVpo: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposVpo'}
				}/*,autoLoad: true*/
    		},
    		
    		comboTipoPosesorio: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposPosesorio'}
				}/*,autoLoad: true*/
    		},
    		
    		comboTipoGestor: {
				model: 'HreRem.model.ComboBase',
				proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboTipoGestor'
				}/*,autoLoad: true*/
    		},
    		comboTipoGestorByActivo: {
				model: 'HreRem.model.ComboBase',
				proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboTipoGestorByActivo',
				extraParams: {idActivo: '{activo.id}'} 
				}/*,autoLoad: true*/
    		},

    		comboEstadoObraNueva: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadosObraNueva'}
				}/*,autoLoad: true*/
    		},
    		
    		comboEstadoDivHorizontal: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadosDivHorizontal'}
				}/*,autoLoad: true*/
    		},
    		
    		comboGradoPropiedad: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposGradoPropiedad'}
				}/*,autoLoad: true*/
    		},
    		comboEstadoTitulo: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadosTitulo'}
				}/*,autoLoad: true*/
    		},
    		comboCalificacionNegativa: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'calificacionNegativa'}
				}
    		},
    		comboMotivoCalificacionNegativa: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadoMotivoCalificacionNegativa'}
				}
    		},
    		comboResponsableSubsanar: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'responsableSubsanar'}
				}
    		},
    		comboAdministracion: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'administracion'}
				}/*,autoLoad: true*/
    		},
    		
    		comboTipoUbicacion: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'ubicacionActivo'}
				}/*,autoLoad: true*/
    		},
    		
    		comboEstadoConstruccion: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadosConstruccion'}
				}/*,autoLoad: true*/
    		},
    		
    		comboEstadoConservacion: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadosConservacion'}
				}/*,autoLoad: true*/
    		},
    		
    		comboUbicacionAparcamiento: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'ubicacionesAparcamiento'}
				}/*,autoLoad: true*/
    		},
    		
    		comboTipoFachada: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposFachada'}
				}/*,autoLoad: true*/
    		},
    		
    		comboTipoVivienda: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposVivienda'}
				}/*,autoLoad: true*/
    		},
    		
    		comboTipoOrientacion: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposOrientacion'}
				}/*,autoLoad: true*/
    		},
    		
    		comboTipoRenta: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposRenta'}
				}/*,autoLoad: true*/
    		},
    		
    		comboTipoCarga: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'tiposCarga'}
					}
    		},
    		
    		comboEstadoCarga: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'estadosCarga'}
					}
    		},
    		
    		comboSubEstadoCarga: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'subestadosCarga'}
					}
    		},
    		
    		comboSituacionCarga: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'situacionCarga'}
					}
    		},

    		comboEstadoAdjudicacion: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadosAdjudicacion'}
				}
    		},
    		
    		comboFavorableDesfavorable: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'favorableDesfavorable'}
				}
    		},
    		
    		comboTiposJuzgado: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposJuzgado'}
				}
    		},
    		
    		comboTiposJuzgadoPlaza: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getJuzgadosPlaza',
					extraParams: {idPlaza: '{comboPlaza.selection.id}'}
				}
    		},
    		
    		
    		comboTiposJuzgadoPlazaAdmision: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getJuzgadosPlaza',
					extraParams: {idPlaza: '{comboPlazaAdmision.selection.id}'}
				}
    		},
    		
    		comboTiposPlaza: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposPlaza'}
				}
    		},
    		
    		comboEntidadesAdjudicatarias: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'entidadesAdjudicacion'}
				}
    		},
    		
    	    comboEntidadesEjecutantes: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'entidadEjecutante'}
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
			    	
    		comboTipoTrabajo: {
	    		model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposTrabajo'}
				}
    		},
    		
    		comboTipoTrabajoCreaFiltered: {
	    		model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboTipoTrabajoCreaFiltered'
				}
    		},    	    	

    		comboEstadoTrabajo: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadoTrabajo'}
				}
			},
			
			comboValoracionTrabajo: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'valoracionTrabajo'}
				}
			},
			
    		comboTipoTitulo: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposTitulo'}
				}
    		}, 		
    		
    		
    		storeComunidadesAutonomas: {
	    		model: 'HreRem.model.ComboBase',
		    	proxy: {
			        type: 'ajax',
			        url: 'resources/data/comunidadesautonomas.json',
			       	reader: {
				        rootProperty: 'data',
				        type: 'json'
			    	}
		    	}
	    	},
	    	
	   		comboInscritaNoInscrita: {
    			data : [
			        {"codigo":"1", "descripcion":"Inscrita"},
			        {"codigo":"0", "descripcion":"No inscrita"}
			    ]
    		},
    		
    		comboCiasAseguradoras: {				
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboEspecial',
					extraParams: {diccionario: 'DDSeguros'}
				}
				
			},
    		
			comboSubtipoPlazaGaraje: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'subtipoPlazaGaraje'}
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
    		comboEstadoGasto: {
		    	model: 'HreRem.model.ComboBase',
		    	proxy: {
			        type: 'uxproxy',
			        remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadoGasto'}
		    	},
		    	autoLoad: true
	    	},	    
    		
    		storeComboImpideVenta: {
    			model: 'HreRem.model.ComboBase',
    			proxy: {
	    			type: 'uxproxy',
	    			remoteUrl: 'activo/getComboImpideVenta',
	    			extraParams: {codEstadoCarga: '{comboestadocargaref.value}'}
    			}
    		},
    		// Stores para el grid observaciones. Se crean 3 para solucionar problemas de instancia 
    		/*

    		 * Valor de la constante 
    		  	OBSERVACIONES_TAB_LAUNCH: {
				ACTIVO : 'activo',
				SANEAMIENTO: 'saneamiento',
				REVISION_TITULO: 'revisionTitulo'
			}*/
    		storeObservaciones_activo: {    
    		 pageSize: $AC.getDefaultPageSize(),
    		 model: 'HreRem.model.Observaciones',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'activo/getListObservaciones',
		        extraParams: {} // Dynamic.
	    	 },
	    	 autoLoad: true
    		},
    		storeObservaciones_saneamiento: {    
    		 pageSize: $AC.getDefaultPageSize(),
    		 model: 'HreRem.model.Observaciones',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'activo/getListObservaciones',
		        extraParams: {} // Dynamic.
	    	 },
	    	 autoLoad: true
    		},
    		storeObservaciones_revisionTitulo: {    
    		 pageSize: $AC.getDefaultPageSize(),
    		 model: 'HreRem.model.Observaciones',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'activo/getListObservaciones',
		        extraParams: {} // Dynamic.
	    	 },
	    	 autoLoad: true
    		}
     }    
});