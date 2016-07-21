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
	     	
	    	 var esTarificado = get('gestionEconomica.esTarificado');
	    	 if (esTarificado)
	    		 return false;
	    	 else
	    		 return true;
	    	 
	    },
	    
	    disablePresupuesto: function (get) {
	    	 var esTarificado = get('gestionEconomica.esTarificado');
	    	 if (esTarificado || Ext.isEmpty(esTarificado))
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
    		}

    }
    
});