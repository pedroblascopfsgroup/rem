Ext.define('HreRem.view.gastos.GastoDetalleModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.gastodetalle',
    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.GastoActivo', 'HreRem.model.GestionGasto',
    			'HreRem.model.BusquedaTrabajo', 'HreRem.model.AdjuntoGasto'],

    
    data: {
    	gasto: null,
    	gestion: null
    },
    
    formulas: {   
    	
	     getConEmisor: function(get){
	     	var me= this;
	     	var gasto= me.getData().gasto;
	     	if(Ext.isEmpty(gasto)) {
	     		return false
	     	} else {
		     	var nifEmisor= gasto.get('nifEmisor');
		     	var nombreEmisor= gasto.get('nombreEmisor');
		     	var codigoEmisor= gasto.get('codigoEmisor');
	     	}
	     	
	     	if(Ext.isEmpty(nifEmisor) && Ext.isEmpty(nombreEmisor) && Ext.isEmpty(codigoEmisor)){
	     		return false
	     	}
	     	
	     	return true;
	     },
	     
		getConPropietario: function(get){
	     	var me= this;
	     	var gasto= me.getData().gasto;
	     	if(Ext.isEmpty(gasto)) {
	     		return false;
	     	} else {
		     	var nifPropietario= gasto.get('nifPropietario');
		     	var nombrePropietario= gasto.get('nombrePropietario');
	     	}
	     	
	     	if(Ext.isEmpty(nifPropietario) && Ext.isEmpty(nombrePropietario)){
	     		return false
	     	}
	     	
	     	return true;
	     },
	     
	     ocultarBotonesTrabajos: function(get) {
	     	return get('gasto.autorizado') || get('gasto.asignadoAActivos');

	     },
	     
	     ocultarBotonesActivos: function(get) {
	     	
	     	return get('gasto.autorizado') || get('gasto.asignadoATrabajos');
	     },


	     esReembolsoPago: function(get){
	     	var me= this;
	     	if(get('detalleeconomico.reembolsoTercero')=="true" || get('detalleeconomico.reembolsoTercero')==true){
	     		return true;
	     	}
	     	else{
	     		return false;
	     	}
//	     	var esReembolsoPago= Ext.isEmpty(get('detalleeconomico.reembolsoTercero')) || get('detalleeconomico.reembolsoTercero')==0 ? false : true 
//	     	return esReembolsoPago;
	     },
	     
	     seleccionadoAbonar: function(get){
	     	var me= this;
	     	if(get('detalleeconomico.abonoCuenta')=="true" || get('detalleeconomico.abonoCuenta')==true){
	     		return true;
	     	}
	     	else{
	     		return false;
	     	}
	     },
	     
	     seleccionadoPagadoBankia: function(get){
	     	var me= this;
	     	if(get('detalleeconomico.pagadoConexionBankia')=="true" || get('detalleeconomico.pagadoConexionBankia')==true){
	     		return true;
	     	}
	     	else{
	     		return false;
	     	}

	     },
	     
	     sumatorioConceptosgasto: function(get) {
	     	
	     	var importePrincipalSujeto = get('detalleeconomico.importePrincipalSujeto');
			var importePricipalNoSujeto = get('detalleeconomico.importePrincipalNoSujeto');
			var importeRecargo = get('detalleeconomico.importeRecargo');
			var importeInteresDemora = get('detalleeconomico.importeInteresDemora');
	     	var importeCostas = get('detalleeconomico.importeCostas');
	     	var importeOtrosIncrementos = get('detalleeconomico.importeOtrosIncrementos')
	     	var importeProvisionesSuplidos = get('detalleeconomico.importeProvisionesSuplidos');
	     	var impuestoIndirectoCuota = get('detalleeconomico.impuestoIndirectoCuota');
	     	var irpfCuota = get('detalleeconomico.irpfCuota');
	     	
	     	return importePrincipalSujeto + importePricipalNoSujeto + importeRecargo + importeInteresDemora
	     	+ importeCostas+ importeOtrosIncrementos + importeProvisionesSuplidos + impuestoIndirectoCuota
	     	
	     	
	     },
	     	
	     
	     calcularImporteTotalGasto: function(get) {
	     	
	     	var irpfCuota = get('detalleeconomico.irpfCuota');
	     	var sumatorioConceptosGasto = get('sumatorioConceptosgasto');
	     	return sumatorioConceptosGasto - irpfCuota; 
	     	
	     },
	     
	     esGastoAnulado: function(get) {
	     	var e= !Ext.isEmpty(get('gestion.comboMotivoAnulado'));
	     	return e;	     	
	     },
	     
	     calcularImpuestoIndirecto: function(get) {
	     	
	     	var tipo =  get('detalleeconomico.impuestoIndirectoTipoImpositivo');	     	
	     	return tipo *  get('detalleeconomico.importePrincipalSujeto') / 100;
	     	
	     },
	     
	     calcularImpuestoDirecto: function(get) {
	     	
	     	var tipo =  get('detalleeconomico.irpfTipoImpositivo');	     	
	     	return tipo * get('detalleeconomico.importePrincipalSujeto') / 100;
	     	
	     },
	     
	     esGastoEditable: function(get){
	     	return get('gasto.esGastoEditable');
	     },
	     
	     esAutorizable: function(get) {
	     	debugger;
	     	var esEditable = get('esGastoEditable');
	     	var autorizado = get('gasto.autorizado');
	     	
	     	return esEditable && !autorizado;
	     },
	     
	     esRechazable: function(get) {	     
	     	debugger;
	     	var esEditable = get('esGastoEditable');
	     	var rechazado = get('gasto.rechazado');
	     	
	     	return esEditable && !rechazado

	     }
	     
		
	 },


    stores: {
    	
		comboPeriodicidad: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoPeriocidad'}
			}   
    	},
    	
    	comboTiposGasto: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposGasto'}
			}   
    	},
    	
    	comboDestinatarios: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'destinatariosGasto'}
			}   
    	},
    	
    	comboTipoOperacion: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoOperacionGasto'}
			}   
    	},
    	
    	comboSubtiposGasto: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboSubtipoGasto',
				extraParams: {codigoTipoGasto: '{gasto.tipoGastoCodigo}'}
			} 
    	},

    	comboSubtiposNuevoGasto: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboSubtipoGasto',
				extraParams: {codigoTipoGasto: '{gastoNuevo.tipoGastoCodigo}'}
			}   
    	},
    	
    	comboPropietarios: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'propietariosGasto'}
			}   
    	},
    	
    	comboPagadoPor: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoPagador'}
			}  
    	},
    	
    	comboDestinatarioPago: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'destinataioPago'}
			}  
    	},
    	
    	comboTipoImpuesto: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposImpuestos'}
			}
    	},

    	storeActivosAfectados: {    
    		 pageSize: $AC.getDefaultPageSize(),
    		 model: 'HreRem.model.GastoActivo',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'gastosproveedor/getListActivosGastos',
		        extraParams: {idGasto: '{gasto.id}'}
	    	 }
    	},
    	
    	storeTrabajosAfectados: {
    		pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.BusquedaTrabajo',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'gastosproveedor/getListTrabajosGasto',
		        extraParams: {idGasto: '{gasto.id}'}
	    	 }
    	},
    	
    	comboEjercicioContabilidad: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboEjercicioContabilidad'
			}
    	},
    	
    	comboMotivoAutorizacion: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivosAutorizacionPropietaro'}
			}
    	},
    	
    	comboEstadoAutorizacionHaya: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosAutorizacionHaya'}
			}
    	},
    	
    	comboMotivoRechazoHaya: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivosRechazoHaya'}
			}
    	},
    	
    	comboEstadoAutorizacionPropietario: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosAutorizacionPropietario'}
			}
    	},
    	
    	comboMotivoAnulado: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivosAnulados'}
			}
    	},
    	
    	comboMotivoRetenerPago: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivosRetenerPago'}
			}
    	},
    	
    	comboResultadoImpugnacion: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'resultadosImpugnacion'}
			}
    	},
    	
    	comboEstadosGasto: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadoGasto'}
			}	
    	},
    	
    	filtroComboSubtipoTrabajo: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'subtiposTrabajo'}
			}		
    		
    	},
    	
    	
    	seleccionTrabajosGasto: {
    		pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.BusquedaTrabajo',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/trabajosgasto.json',
		        remoteUrl: 'trabajo/findAll',
		        actionMethods: {read: 'POST'}
	    	},
	    	remoteSort: true,
	    	remoteFilter: true,
	        listeners : {
	            beforeload : 'paramLoading'

	        }    	
    	},
    	
    	storeDocumentosGasto: {
    			 pageSize: $AC.getDefaultPageSize(),
    			 model: 'HreRem.model.AdjuntoGasto',
	      	     proxy: {
	      	        type: 'uxproxy',
	      	        remoteUrl: 'gastosproveedor/getListAdjuntos',
	      	        extraParams: {idGasto: '{gasto.id}'}
	          	 },
	          	 groupField: 'descripcionTipo'
    		}
    	}

  
});