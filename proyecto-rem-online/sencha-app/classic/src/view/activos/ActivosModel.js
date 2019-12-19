Ext.define('HreRem.view.activos.ActivosModel', {
    extend: 'HreRem.view.common.DDViewModel',
    alias: 'viewmodel.activos',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.BusquedaActivo', 'HreRem.model.ComboBase', 'HreRem.model.Gestor', 'HreRem.model.Tramite' ],

    data: {	
    },
    
    stores: {
    		
    		activos: {
    				pageSize: $AC.getDefaultPageSize(),
			    	model: 'HreRem.model.BusquedaActivo',
			    	proxy: {
				        type: 'uxproxy',
				        localUrl: '/activos.json',
				        remoteUrl: 'activo/do/busqueda',
				        remApi: true,
				        rootProperty : 'content',
				        actionMethods: {read: 'GET'}
			    	},
			    	session: true,
			    	remoteSort: true,
			    	remoteFilter: true,
			    	autoLoad:false,
			    	listeners : {
			            beforeload : 'paramLoading'
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
    		    		
    		comboTipoUsoDestino: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'tiposUsoDestino'}
					}
    		},
    		
    		comboCountries: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'countries'}
				}
    		},
    		
    		comboTipoVia: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposVia'}
				}
    		},

    		comboFiltroSubtipoActivo: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'subtiposActivo'}
					}
    		},

    		comboFiltroTipoActivo: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'tiposActivo'}
					}
    		},

    		comboEstadoActivo: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'estadosActivo'}
					}
    		},

			comboSubcartera: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'subentidadesPropietarias'}
					}
			},
			
			comboSubcarteraFiltered: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getComboSubcartera'
					}
			},

			comboTiposUsoDestino: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'tiposUsoDestino'}
					}
			},

			comboClaseActivoBancario: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'claseActivoBancario'}
					}
			},

			comboSubtipoClaseActivoBancario: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'subtipoClaseActivoBancario'}
					}
			},

			comboSubtiposTitulo: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'subtiposTitulo'}
					}
			},

			comboSituacionComercial: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'situacionComercial'}
					}
			},

			comboTiposComercializacionActivo: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'tiposComercializacionActivo'}
					}
			},

			comboRatingActivo: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'ratingActivo'}
					}
			},

	    	comboTipoGestorOfertas: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboTipoGestorActivos'
				}
			},

			comboUsuarios: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'activo/getComboUsuarios',
					extraParams: {
						idTipoGestor: '{tipoGestor.selection.id}'
					}
				}
			},

			comboAdecuaciones: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'adecuaciones'}
					}
			},

			comboTipoTituloPosesorio: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposPosesorio'}
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

			comboDDTipoTituloActivo: {
				model : 'HreRem.model.ComboBase',
				proxy : {
					type : 'uxproxy',
					remoteUrl : 'generic/getDiccionario',
					extraParams : {
						diccionario : 'tipoTituloActivoTPA'
					}
				}
			},

			comboFasePublicacion: {
				model : 'HreRem.model.ComboBase',
				proxy : {
					type : 'uxproxy',
					remoteUrl : 'activo/getDiccionarioFasePublicacion'
				}
			},

			comboDireccionTerritorial: {
				model : 'HreRem.model.ComboBase',
				proxy : {
					type : 'uxproxy',
					remoteUrl : 'generic/getDiccionario',
					extraParams : {
						diccionario : 'direccionTerritorial'
					}
				}
			},			

			comboApiPrimario: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'activo/getComboApiPrimario'
				},
			    displayField: 'nombre',
				valueField: 'id'				
			},
			
			comboMotivoAutorizacionTramitacion: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'motivoAutorizacionTramitacion'}
					}
			},
			
			comboEstadoPublicacionVenta: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadosPublicacion'}
				}
			
			},
		
			comboEstadoPublicacionAlquiler: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadosPublicacionAlquiler'}
				}
     		},
     		
     		comboMotivoOcultacion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivosOcultacion'}
			}
			
		}
    }

});