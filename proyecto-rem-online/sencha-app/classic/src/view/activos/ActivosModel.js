Ext.define('HreRem.view.activos.ActivosModel', {
    extend: 'HreRem.view.common.DDViewModel',
    alias: 'viewmodel.activos',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.Gestor', 'HreRem.model.Tramite' , 'HreRem.model.BusquedaActivoGrid'],

    data: {	
    },
    
    stores: {
    
    		gridBusquedaActivos: {
    				pageSize: $AC.getDefaultPageSize(),
			    	model: 'HreRem.model.BusquedaActivoGrid',
			    	proxy: {
				        type: 'uxproxy',				   
				        remoteUrl: 'activo/getBusquedaActivosGrid',
					    actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
			    	},
			    	session: true,
			    	remoteSort: true,
			    	remoteFilter: true,
			    	autoLoad:false,
			    	listeners : {
			            beforeload : 'paramLoading'
			        }

    		},
    		
    		comboCartera: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'entidadesPropietarias'}
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
					remoteUrl: 'generic/getComboSubtipoActivoFiltered'
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
				},
				autoLoad: false,
				remoteFilter: false,
				remoteSort: false
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

			comboDireccionComercial: {
				model : 'HreRem.model.ComboBase',
				proxy : {
					type : 'uxproxy',
					remoteUrl : 'generic/getDiccionario',
					extraParams : {
						diccionario : 'tipoDireccionComercial'
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
	     	},
	     	
     		comboSituacionPagoAnterior: {
    			model: 'HreRem.model.ComboBase',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'generic/getDiccionario',
    				extraParams: {diccionario: 'situacionPagoAnterior'}
    			}
     		},

			comboTiposPublicacionActivo: {
				model : 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tipoPublicacion'}
				}
			},
     		
     		comboSiNoRemActivo: {
				data : [
			        {"codigo":"1", "descripcion":"Si"},
			        {"codigo":"0", "descripcion":"No"}
			    ]
			},

            comboEquipoGestion: {
                model: 'HreRem.model.ComboBase',
                proxy: {
                    type: 'uxproxy',
                    remoteUrl: 'generic/getDiccionario',
                    extraParams: {diccionario: 'tiposEquipoGestion'}
                }
            },
            comboEstadoActivoDND: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'estadoFisicoActivoDND'}
					}
    		},

            comboSociedadAnteriorBBVA: {
				model : 'HreRem.model.ComboBase',
				proxy : {
					type : 'uxproxy',
					remoteUrl : 'generic/getcomboSociedadAnteriorBBVA'
				}
			},
			
			comboTipoSegmento: {
				model : 'HreRem.model.ComboBase',
				proxy : {
					type : 'uxproxy',
					remoteUrl : 'activo/getComboTipoSegmento',
					extraParams:  {codSubcartera: '{comboSubcarteraRef.value}'}
				}
			},

			comboPlanta: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'plantaEdificio'}
					}
			},

			comboEscalera: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'escaleraEdificio'}
					}
			},

			comboEstadoComercialVenta: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'estadoComercialVenta'} 
					}
			},

			comboEstadoComercialAlquiler: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'estadoComercialAlquiler'} 
					}
			},
			
			comboGestionDnd: {
				model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'generic/getDiccionario',
						extraParams: {diccionario: 'DDSiNo'}
					}
    		}
    		
     }

});