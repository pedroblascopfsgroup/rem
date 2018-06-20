Ext.define('HreRem.view.trabajos.detalle.TrabajoDetalleModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.trabajodetalle',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.ActivoTrabajo', 'HreRem.model.ActivoTrabajoSubida',
    'HreRem.model.AdjuntoTrabajo', 'HreRem.model.TareaList', 'HreRem.model.ObservacionesTrabajo', 'HreRem.model.Llaves'],
    
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
			 var fechaEjecucionReal = get('trabajo.fechaEjecucionReal');
			 var fechaCierreEco = get('trabajo.fechaCierreEconomico');
			 var fechaEmisionFactura = get('trabajo.fechaEmisionFactura');
	    	 var esTarificado = get('gestionEconomica.esTarificado');
	    	 var isSupervisorActivo = $AU.userIsRol('HAYASUPACT') || $AU.userIsRol('HAYASUPADM') || $AU.userIsRol('HAYASUPER');
		     var isGestorActivos = $AU.userIsRol('HAYAGESACT') || $AU.userIsRol('HAYAGESTADM');
		     var isProveedor = $AU.userIsRol('HAYAPROV') || $AU.userIsRol('HAYACERTI') 
		     				   || $AU.userIsRol('GESTOCED') || $AU.userIsRol('GESTOADM');

		     if(!Ext.isEmpty(fechaEmisionFactura)){
		    	 return true;	    		
		     } else if(isSupervisorActivo){
		    	return false;		    		
		     } else if(isGestorActivos){
		    	if (!Ext.isEmpty(fechaCierreEco))
			    	 return true;
			    else {
				   	 if (esTarificado)
				   		 return false;
				    else
				    	 return true;
			    }	    		
		    } else if(isProveedor){
		    	if (Ext.isEmpty(fechaEjecucionReal))
	    			return false;
	    		else {
	    			return true;
	    		}
		    } else {
		    	return true;
		    }
	    	 
	    	 
	    	 
	    },
	    
	    editableTarificacionProveedor: function (get){
	    	return true;
	    	 
	    },
	    
	    disablePresupuesto: function (get) {
	    	
	    	 var fechaCierreEco = get('trabajo.fechaCierreEconomico');
	    	 var esTarificado = get('gestionEconomica.esTarificado');
	    	
	    	 if (!Ext.isEmpty(fechaCierreEco))
	    		 return true;
	    	 else {
		    	 if (esTarificado || Ext.isEmpty(esTarificado))
		    		 return true;
		    	 else
		    		 return false;
	    	 }
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
	    
	    esVisibleFechaAutorizacionPropietario: function(get){
			 if(get('trabajo.cartera')=='Liberbank') 
				 return true;
			 else 
				 return false;
		}
	    
    },
    
    stores: {
    		
    		activosTrabajo: {
    			pageSize: $AC.getDefaultPageSize(),
				 model: 'HreRem.model.ActivoTrabajo',
				 proxy: {
				    type: 'uxproxy',
					remoteUrl: 'trabajo/getListActivos',
					extraParams: {idTrabajo: '{trabajo.id}'}
				 }
    		},
    	
    	    comboSubtipoTrabajo: {    		
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'generic/getComboSubtipoTrabajo',
					extraParams: {tipoTrabajoCodigo: '{trabajo.tipoTrabajoCodigo}'}
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
					extraParams: {idActivo: '{idActivo}'}
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
    			}
    		},
    		
    		comboProveedorContacto : {
    			model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboProveedorContacto',
					extraParams: {idProveedor: '{gestionEconomica.idProveedor}'}
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
					remoteUrl: 'trabajo/getComboResponsableTrabajo'
				}  		
    		}

    }
    
});