Ext.define('HreRem.view.trabajos.detalle.TrabajoDetalleModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.trabajodetalle',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.ActivoTrabajo', 'HreRem.model.ActivoTrabajoSubida',
    'HreRem.model.AdjuntoTrabajo', 'HreRem.model.TareaList', 'HreRem.model.ObservacionesTrabajo', 'HreRem.model.Llaves', 'HreRem.model.FichaTrabajo',
    'HreRem.model.HistoricoDeCamposModel','HreRem.model.TarifasGridModel'],
    
    data: {
    	trabajo: null
    },
    
    formulas: {
    	tituloActivosTrabajo: function (get) {   	
	     	
	     	 var numAgrupacion = get('trabajo.numAgrupacion');
	     	 var tipoAgrupacion = get('trabajo.tipoAgrupacionDescripcion');

	     	 return Ext.isEmpty(numAgrupacion) ? "" : HreRem.i18n("fieldlabel.agrupacion") + " " + numAgrupacion + " " + tipoAgrupacion;
	     },
    
		showTarificacion: function (get) {   	
	     	
	    	 var esTarificado = get('gestionEconomica.esTarificado');
	    	 if (esTarificado || Ext.isEmpty(esTarificado))
	    		 return true;
	    	 else
	    		 return false;
	    	 
	    },
	    
	    showPresupuesto: function (get) {
	    	 var esTarificado = get('gestionEconomica.esTarificado');
	    	 if (!esTarificado || Ext.isEmpty(esTarificado))
	    		 return true;
	    	 else
	    		 return false;
	    },
	    
		disableTarificacion: function (get) {
	    	 var isSupervisorActivo = $AU.userIsRol('HAYASUPER');
		     var isGestorActivos = $AU.userIsRol('HAYAGESACT');
		     var isProveedor = $AU.userIsRol('HAYAPROV');
		     var perteneceGastoOPrefactura = get('trabajo.perteneceGastoOPrefactura');
		     
		     if (perteneceGastoOPrefactura == 'true') {
		    	 return false;
		     }

		     return isSupervisorActivo || isGestorActivos || isProveedor;
	    	 
	    },
	    
	    mostrarTotalProveedor: function(get){
	    	var isGestorActivos = $AU.userIsRol('HAYAGESACT');
	    	var isSuper = $AU.userIsRol('HAYASUPER');
	    	var isProveedor = $AU.userIsRol('HAYAPROV');
	    	return isGestorActivos || isSuper || isProveedor;
	    },
	    
	    mostrarTotalCliente: function(get){
	    	var isGestorActivos = $AU.userIsRol('HAYAGESACT');
	    	var isSuper = $AU.userIsRol('HAYASUPER');
	    	var isUsuarioCliente = get('gestionEconomica.esUsuarioCliente');
	    	return isGestorActivos || isSuper || isUsuarioCliente;
	    },
	    
	    editableTarificacionProveedor: function (get){
	    	me = this;
	    	var isProveedor = $AU.userIsRol('HAYAPROV');
	    	
	    	if (isProveedor && CONST.ESTADOS_TRABAJO["VALIDADO"] == me.get('trabajo.estadoCodigo')) {
	    		return false;
	    	} else {
	    		return true;
	    	}
	    },
	    
	    disablePresupuesto: function (get) {
    		var isSupervisorActivo = $AU.userIsRol('HAYASUPER');
		    var isGestorActivos = $AU.userIsRol('HAYAGESACT');
		    var isProveedor = $AU.userIsRol('HAYAPROV');
		    var perteneceGastoOPrefactura = get('trabajo.perteneceGastoOPrefactura');
		     
		    if (perteneceGastoOPrefactura == 'true') {
		    	return false;
		    }
		    
		    return isSupervisorActivo || isGestorActivos || isProveedor;
	    },
	    
	    enableAddPresupuesto: function(get) {
	    	var esTarificado = get('gestionEconomica.esTarificado');
	    	if (!Ext.isEmpty(esTarificado))
	    		 return true;
	    	 else
	    		 return false;
	    },
	    
	    disablePorCierreEconomico: function(get) {
	    	var fechaCierreEco = get('trabajo.fechaCierreEconomico');
	    	if (!Ext.isEmpty(fechaCierreEco))
	    		 return true;
	    	 else
	    		 return false;
	    },
	    
	    disablePorCierreEconomicoSuplidos: function(get) {
	    	var fechaCierreEco = get('trabajo.fechaCierreEconomico');
	    	var esSuperGestorActivos = $AU.userIsRol('SUPERGESTACT');
		    var perteneceGastoOPrefactura = get('trabajo.perteneceGastoOPrefactura');
		    
	    	if ((!Ext.isEmpty(fechaCierreEco) && !esSuperGestorActivos) || perteneceGastoOPrefactura == 'true')
	    		 return true;
	    	 else
	    		 return false;
	    },
	    
	    esVisibleFechaAutorizacionPropietario: function(get){
	    	 me = this;
			 if(get('trabajo.cartera')=='Unicaja' && CONST.TIPOS_TRABAJO["ACTUACION_TECNICA"] == me.get('trabajo.tipoTrabajoCodigo')) 
				 return true;
			 else 
				 return false;
		},
	    
		esVisibleFechaEjecucionReal: function(get){
	    	 me = this;
			 if(CONST.TIPOS_TRABAJO["ACTUACION_TECNICA"] == me.get('trabajo.tipoTrabajoCodigo')) 
				 return true;
			 else 
				 return false;
		},
		
		esVisibleFechaValidacion: function(get){
	    	 me =  this;
			 if(CONST.TIPOS_TRABAJO["ACTUACION_TECNICA"] == me.get('trabajo.tipoTrabajoCodigo')) 
				 return true;
			 else 
				 return false;
		},
		
	 	mostrarVentanaTrabajoGridActivo: function(get){
	 		me = this;
	 		var resultado = me.getView().idActivo == null ? true : false;
	 		return resultado;
	 	},
		
		esVisibleGasto: function(get){
	    		me = this;
	    		
	    		if(CONST.ESTADOS_GASTO["ANULADO"] == me.get('trabajo.estadoGasto')){
	    		me.set('trabajo.gastoProveedor', null);
	    			return true;
	    		}else
					return false;
	    },
	    
	    deshabilitarCheckMultiactivo: function(get){
	    	me = this;
	    	var deshabilitar = me.getView().idActivo != null || me.getView().idAgrupacion != null;
	    	var checkboxMultiActivo = me.getView().lookupReference('checkMultiActivo');
	    	if(checkboxMultiActivo != null) {
	    		checkboxMultiActivo.checked = !deshabilitar;
	    		checkboxMultiActivo.setValue(!deshabilitar);
	    		checkboxMultiActivo.fireEvent('change', null, !deshabilitar, deshabilitar, null);
	    	}
	    	return true;
	    }
	   
    },
    
    stores: {
    		
    		activosTrabajo: {
    			pageSize: $AC.getDefaultPageSize(),
				model: 'HreRem.model.ActivoTrabajo',
				proxy: {
				    type: 'uxproxy',
					remoteUrl: 'trabajo/getListActivos',
					extraParams: {idTrabajo: '{trabajo.id}'},
					timeout: 120000
				},
    	    	remoteSort: true,
    	    	remoteFilter: true,
				listeners: {
					load: function(store, items, success, opts){
						 store.participacion = Ext.decode(opts._response.responseText).participacion;
					}
				}
    		},
    	
    	    comboSubtipoTrabajo: {    		
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoTrabajo',
					extraParams: {tipoTrabajoCodigo: '{trabajo.tipoTrabajoCodigo}',idActivo: '{idActivo}'}
				}  		
    		},
    		
    		comboSubtipoTrabajoFicha: {    		
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoTrabajo',
					extraParams: {tipoTrabajoCodigo: '{trabajo.tipoTrabajoCodigo}',idActivo: '{trabajo.idActivo}'}
				}  		
    		},
    		
    		comboSubtipoTrabajoCreaFiltered: {    		
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoTrabajoCreaFiltered',
					extraParams: {tipoTrabajoCodigo: '{trabajo.tipoTrabajoCodigo}'}
				}  		
    		},
    		
    	    comboSubtipoTrabajoTarificado: {    		
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoTrabajoTarificado',
					extraParams: {tipoTrabajoCodigo: '{trabajo.tipoTrabajoCodigo}'}
				}  		
    		},

    		storeDocumentosTrabajo: {
    			 pageSize: $AC.getDefaultPageSize(),
    			 model: 'HreRem.model.AdjuntoTrabajo',
	      	     proxy: {
	      	        type: 'uxproxy',
	      	        remoteUrl: 'trabajo/getListAdjuntos',
	      	        extraParams: {id: '{trabajo.id}'}
	          	 },
	          	 groupField: 'descripcionTipo'
    		},
    		
    		tareasTramiteTrabajo: {
				
    			pageSize: $AC.getDefaultPageSize(),
		    	model: 'HreRem.model.TareaList',
		    	proxy: {
			        type: 'uxproxy',
			        remoteUrl: 'trabajo/getTramitesTareas',
			        extraParams: {idTrabajo: '{trabajo.id}'},
			        rootProperty: 'tramite.tareas'
		    	}

			},
			
			storeObservaciones: {
				
				pageSize: $AC.getDefaultPageSize(),
		    	model: 'HreRem.model.ObservacionesTrabajo',
		    	proxy: {
			        type: 'uxproxy',
			        remoteUrl: 'trabajo/getObservaciones',
			        extraParams: {idTrabajo: '{trabajo.id}'}
		    	}
			},

			storeFotosTrabajoSolicitante: {    			
    		 model: 'HreRem.model.Fotos',
		     proxy: {
		        type: 'uxproxy',
		        api: {
		            read: 'trabajo/getFotosById',
		            create: 'trabajo/getFotosById',
		            update: 'trabajo/updateFotosById',
		            destroy: 'trabajo/destroy'
		        },
		        extraParams: {id: '{trabajo.id}', solicitanteProveedor: false}
		     }, autoLoad: false
    		},
    		
    		storeFotosTrabajoProveedor: {    			
    		 model: 'HreRem.model.Fotos',
		     proxy: {
		        type: 'uxproxy',
		        api: {
		            read: 'trabajo/getFotosById',
		            create: 'trabajo/getFotosById',
		            update: 'trabajo/updateFotosById',
		            destroy: 'trabajo/destroy'
		        },
		        extraParams: {id: '{trabajo.id}', solicitanteProveedor: true}
		     }, autoLoad: false
    		},
    		
    		storeSeleccionTarifas: {
    		 pageSize: 10,
       		 model: 'HreRem.model.SeleccionTarifas',
       		 proxy: {
			    type: 'uxproxy',
				remoteUrl: 'trabajo/getSeleccionTarifasTrabajo'
			 },
			 listeners : {
			        beforeload : 'addParamsTrabajo'
			 }
    		},
    		
    		storeTarifasTrabajo: {
			 pageSize: 10,
      		 model: 'HreRem.model.TarifasTrabajo',
      		 proxy: {
      			 type: 'uxproxy',
      			 remoteUrl: 'trabajo/getTarifasTrabajo'
   			 },
			 listeners : {
			        beforeload : 'addParamIdTrabajo'
			 }
    		},
    		
    		storePresupuestosTrabajo: {
   			 pageSize: 10,
         		 model: 'HreRem.model.PresupuestosTrabajo',
         		 proxy: {
         			 type: 'uxproxy',
         			 remoteUrl: 'trabajo/getPresupuestosTrabajo'
      			 },
      			 listeners : {
   			        beforeload : 'addParamIdTrabajo'
      			 }
       		},
			
			activosAgrupacion: {
				 pageSize: 10,
				 model: 'HreRem.model.ActivoTrabajo',
				 proxy: {
				    type: 'uxproxy',
					remoteUrl: 'trabajo/getListActivosAgrupacion'
				 },
				 listeners : {
			        beforeload : 'addParamAgrupacion'
			     }
			},
			
    		comboTipoTrabajo: {
	    		model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'tiposTrabajo'}
				}
    		},
    		
    		storeTipoTrabajoCreaFiltered: {
	    		model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboTipoTrabajoCreaFiltered',
					extraParams: {
						idActivo: '{idActivo}'
					}
				}
    		},
    		
    		storeTipoTrabajoFichaFiltered: {
	    		model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboTipoTrabajoFiltered',
					extraParams: {
						idActivo: '{trabajo.idActivo}',
						numTrabajo: '{trabajo.numTrabajo}'
					}
				}
    		},
    		
    		comboProveedor: {    		
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboProveedor',
					extraParams: {idTrabajo: '{trabajo.id}'}
				}
    		},

    		storeRecargosProveedor: {
		    	model: 'HreRem.model.RecargoProveedor',
		    	proxy: {
			        type: 'uxproxy',
			        remoteUrl: 'trabajo/getRecargosProveedor',
		        	extraParams: {idTrabajo: '{trabajo.id}'}
		    	}			
    			
    		},

    		storeProvisionesSuplidos: {
		    	model: 'HreRem.model.ProvisionSuplido',
		    	proxy: {
			        type: 'uxproxy',
			        remoteUrl: 'trabajo/getProvisionesSuplidos',
		        	extraParams: {idTrabajo: '{trabajo.id}'}
		    	}    			
    		},
    		
    		comboProveedorEdicion: {    		
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboProveedor',
					extraParams: {idTrabajo: '{trabajo.id}'}
				}
    		},
    		
			comboProveedorFiltradoManual: {
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboProveedorFiltradoManual',
					extraParams: {idTrabajo: '{trabajo.id}'}
				},
				autoLoad: false
			},
			
    		comboEstadoPresupuesto: {
	    		model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadosPresupuesto'}
				}
    		},
    		
    		listaActivosSubida: {
    			pageSize: 10,
    			model:'HreRem.model.ActivoTrabajoSubida',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'trabajo/getListActivosByProceso',
    				extraParams: {idProceso: 'idProceso'}
    			},
    	    	remoteSort: true,
    	    	remoteFilter: true,
    	    	listeners: {
					load: 'getPlazoComiteProveedor'
				}
    		},
    		
    		listaActivosAgrupacion: {
    			pageSize: 10,
    			model:'HreRem.model.ActivoTrabajoSubida',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'trabajo/getListActivosByID',
    				extraParams: {idActivo: '{idActivo}', idAgrupacion:'{idAgrupacion}'}
    			},
    	    	remoteSort: true,
    	    	remoteFilter: true,
    	    	autoLoad: true
    		},
    		
    		comboProveedorContacto : {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboProveedorContacto',
					extraParams: {idProveedor: '{presupuesto.idProveedor}'}
				}, 
				autoLoad: false
    		},
    		
    		comboProveedorContactoGE : {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboProveedorContacto',
					extraParams: {idProveedor: '{gestionEconomica.idProveedor}'}
				}, 
				autoLoad: false
    		},
    		
    		comboProveedorReceptor: {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboProveedorContactoLlaves',
					extraParams: {idProveedor: '{trabajo.idProveedorLlave}'}
				}, 
				autoLoad: false
    		},
    		
    		comboTipoProveedorFiltered : {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboTipoProveedorFiltered',
					extraParams: {idTrabajo: '{trabajo.id}'}
				}
    		},
    		
    		comboProveedorFiltered : {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboProveedorFiltered',
					extraParams: {
						idTrabajo: '{trabajo.id}',
						codigoTipoProveedor: '{comboTipoProveedorGestionEconomica.selection.codigo}'
						
					}
				},
				autoLoad: false
    		},
    		comboProveedorFilteredLlaves : {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboProveedorFiltered',
					extraParams: {
						idTrabajo: '{trabajo.id}',
						codigoTipoProveedor: '05'
					}
				},
				autoLoad: false
    		},
    		comboTipoProveedorFilteredA : {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboTipoProveedorFiltered',
					extraParams: {idTrabajo: '{trabajo.id}'}
				}
    		},
    		comboProveedorFilteredA : {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboProveedorFiltered',
					extraParams: {
						idTrabajo: '{trabajo.id}',
						codigoTipoProveedor: '{comboTipoProveedorGestionEconomica2.selection.codigo}'
					}
				},
				autoLoad: false
    		},
    		comboProveedorContactoA : {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboProveedorContacto',
					extraParams: {idProveedor: '{comboProveedorGestionEconomica2.selection.idProveedor}'}
				}, 
				autoLoad: false
    		},
    		comboTipoProveedorFilteredM : {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboTipoProveedorFiltered',
					extraParams: {idTrabajo: '{trabajo.id}'}
				}
    		},
    		comboProveedorFilteredM : {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboProveedorFiltered',
					extraParams: {
						idTrabajo: '{trabajo.id}',
						codigoTipoProveedor: '{comboTipoProveedorGestionEconomica3.selection.codigo}'
					}
				},
				autoLoad: false
    		},
    		comboProveedorContactoM : {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboProveedorContacto',
					extraParams: {idProveedor: '{comboProveedorGestionEconomica3.selection.idProveedor}'}
				}, 
				autoLoad: false
    		},

    		comboGestorActivoResponsable: {    		
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'activo/getComboUsuariosGestorActivos'
				}  		
    		},
    		
    		comboSupervisorActivoResponsable: {    		
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'activo/getComboSupervisorActivos'
				}  		
    		},

    		comboResponsableTrabajo: {    		
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboResponsableTrabajo',
					extraParams: {
						idTrabajo: '{trabajo.id}'
					}	
				}
    		},	    
    		
    		comboEstadoSegunEstadoGdaOProveedor: {
    			model: 'HreRem.model.ComboBase',
    			proxy: {
	    			type: 'uxproxy',
	    			remoteUrl: 'trabajo/getComboEstadoSegunEstadoGdaOProveedor',
	    			extraParams: {idTrabajo: '{trabajo.id}'}
    			}
    		},
    		storeHistorificacionDeCampos: {
		    	model: 'HreRem.model.HistoricoDeCamposModel',
		    	proxy: {
			        type: 'uxproxy',
			        remoteUrl: 'trabajo/getHistoricoDeCampos'
		    	}
    		},
    		comboEstadoTrabajo: {    		
    			model: 'HreRem.model.ComboBase',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'generic/getDiccionario',
    				extraParams: {diccionario: 'estadoTrabajo'}
    			},
    			autoLoad: true
        	},
    		comboApiPrimario: {
    			model: 'HreRem.model.ComboBase',
    			proxy: {
    				type: 'uxproxy',
    				remoteUrl: 'albaran/getProveedores'
    			},
    		    displayField: 'descripcion',
    			valueField: 'id'				
    		},
    		comboAprobacionComite: {    		
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboAprobacionComite'
				}
    		},
    		storeAgendaTrabajo: {
		    	model: 'HreRem.model.AgendaTrabajoModel',
		    	proxy: {
			        type: 'uxproxy',
			        remoteUrl: 'trabajo/getAgendaTrabajo',
			        extraParams: {idTrabajo: '{trabajo.id}'}
		    	}    			
    		},
    		comboEstadoTrabajoFicha:{
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboEstadoTrabajo'
				}
    		},
    		comboEstadoGastosFicha:{
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboEstadoGasto'
				}
    		},
    		comboIdentificadorReam: {
	    		model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'identificadorReam'}
				},
				listeners: {
					load: function(store, records) {
						store.insert(0, [{
							descripcion: "--",
							id: null
						}]);
					}
				
				}
    		},
			comboEstadoGastos: {
		    	model: 'HreRem.model.ComboBase',
		    	proxy: {
			        type: 'uxproxy',
			        remoteUrl: 'generic/getDiccionario',
					extraParams: {diccionario: 'estadoGasto'}
		    	}
		    	
	    	}
    		
    }

});