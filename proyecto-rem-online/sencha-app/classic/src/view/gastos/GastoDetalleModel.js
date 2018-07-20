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
	    	 var codigoEstadoCodigo = get('gasto.estadoGastoCodigo');
	    	 
	    	 if(codigoEstadoCodigo==CONST.ESTADOS_GASTO['INCOMPLETO'] ||
	    			 codigoEstadoCodigo==CONST.ESTADOS_GASTO['RECHAZADO'] ||
	    			 codigoEstadoCodigo==CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO'] ||
	    			 codigoEstadoCodigo==CONST.ESTADOS_GASTO['PENDIENTE']) {
	    		 return false;
	    	 } else {
	    		 return true;
	    	 }
	     },
	     
	     ocultarBotonesActivos: function(get) {
	     	
	     	return get('gasto.autorizado') || get('gasto.asignadoATrabajos');
	     },
	     
	     asignadoAActivosPropietarioSareb: function(get) {
	    	 var me = this;
	    	 var gasto = me.getData().gasto;
	    	 var esSareb = gasto.data.nombrePropietario == CONST.NOMBRE_CARTERA2['SAREB'];
	    	 var esTango = gasto.data.nombrePropietario == CONST.NOMBRE_CARTERA2['TANGO'];
	    	 var esGiants = gasto.data.nombrePropietario == CONST.NOMBRE_CARTERA2['GIANTS'];
	    	 
	    	 return get('gasto.asignadoAActivos') || esSareb || esTango || esGiants;
	    	 
	     },

	     esCarteraBakia: function(get){
	    	 return get('detalleeconomico.cartera') == CONST.CARTERA['BANKIA'];
	     },
	     
	     esCarteraSareb: function(get){
	    	 return get('detalleeconomico.cartera') == CONST.CARTERA['SAREB'];
	     },
	     
	     esReembolsoPago: function(get){
	     	var me= this;

	     	if(get('detalleeconomico.reembolsoTercero')=="true" || get('detalleeconomico.reembolsoTercero')==true){
	     		return true;
	     	}
	     	else{
	     		return false;
	     	}
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
	     
	     seleccionadoAnticipo: function(get)  {
	     	var me= this;
	     	if(get('detalleeconomico.anticipo')=="true" || get('detalleeconomico.anticipo')==true){
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
	     	var impuestoIndirectoCuota = 0;   	
	     	var cbOperacionExenta = get('detalleeconomico.impuestoIndirectoExento');  
	     	var cbRenunciaExencion = get('detalleeconomico.renunciaExencionImpuestoIndirecto');  
	     	if(cbOperacionExenta==false || (cbOperacionExenta==true && cbRenunciaExencion==true)){
	     		impuestoIndirectoCuota = get('detalleeconomico.impuestoIndirectoCuota');
	     	}

	     	return importePrincipalSujeto + importePricipalNoSujeto + importeRecargo + importeInteresDemora
	     	+ importeCostas+ importeOtrosIncrementos + importeProvisionesSuplidos + impuestoIndirectoCuota; 
	     	
	     	
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

	     	var estaAutorizado = get('gasto.autorizado');
	     	var estaContabilizado = CONST.ESTADOS_GASTO['CONTABILIZADO'] == get('gasto.estadoGastoCodigo');
	     	var estaPagado = CONST.ESTADOS_GASTO['PAGADO'] == get('gasto.estadoGastoCodigo');
	     	var estaAnulado = CONST.ESTADOS_GASTO['ANULADO'] == get('gasto.estadoGastoCodigo');
	     	var estaEnviado = get('gasto.enviado');
	     	var estaRetenido = CONST.ESTADOS_GASTO['RETENIDO'] == get('gasto.estadoGastoCodigo');
	     	var estaIncompleto = CONST.ESTADOS_GASTO['INCOMPLETO'] == get('gasto.estadoGastoCodigo');
	     	var estaRechazadoPropietario = CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO'] == get('gasto.estadoGastoCodigo');
	     	var estaAutorizadoAdministracion = CONST.ESTADOS_GASTO['AUTORIZADO'] == get('gasto.estadoGastoCodigo');
	     	var estaAutorizadoPropietario = CONST.ESTADOS_GASTO['AUTORIZADO_PROPIETARIO'] == get('gasto.estadoGastoCodigo');
	     	
	     	return !estaEnviado && !estaAutorizado && !estaContabilizado && !estaPagado && !estaAnulado && !estaRetenido && !estaIncompleto 
	     			&& !estaRechazadoPropietario && !estaAutorizadoAdministracion && !estaAutorizadoPropietario;
	     },
	     
	     esRechazable: function(get) {	     
	     	var estaRechazado = get('gasto.rechazado');
	     	var estaContabilizado = CONST.ESTADOS_GASTO['CONTABILIZADO'] == get('gasto.estadoGastoCodigo');
	     	var estaPagado = CONST.ESTADOS_GASTO['PAGADO'] == get('gasto.estadoGastoCodigo');
	     	var estaPagadoSinJustificante = CONST.ESTADOS_GASTO['PAGADO_SIN_JUSTIFICANTE'] == get('gasto.estadoGastoCodigo');
	     	var estaAnulado = CONST.ESTADOS_GASTO['ANULADO'] == get('gasto.estadoGastoCodigo');
	     	var estaEnviado = get('gasto.enviado');
	     	var estaRetenido = CONST.ESTADOS_GASTO['RETENIDO'] == get('gasto.estadoGastoCodigo');
	     	var estaSubsanadoYAutorizado = get('gasto.autorizado') && CONST.ESTADOS_GASTO['SUBSANADO'] == get('gasto.estadoGastoCodigo');
	     	var estaIncompleto = CONST.ESTADOS_GASTO['INCOMPLETO'] == get('gasto.estadoGastoCodigo');
	     	var estaRechazadoAdministracion = CONST.ESTADOS_GASTO['RECHAZADO'] == get('gasto.estadoGastoCodigo');
	     	var estaRechazadoPropietario = CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO'] == get('gasto.estadoGastoCodigo');
	     	var estaAutorizadoAdministracion = CONST.ESTADOS_GASTO['AUTORIZADO'] == get('gasto.estadoGastoCodigo');
	     	var estaAutorizadoPropietario = CONST.ESTADOS_GASTO['AUTORIZADO_PROPIETARIO'] == get('gasto.estadoGastoCodigo');
	     	
	     	return  !estaEnviado && !estaRechazado && !estaContabilizado && !estaPagado && !estaAnulado && !estaRetenido && !estaSubsanadoYAutorizado && !estaIncompleto 
	     			&& !estaRechazadoAdministracion && !estaRechazadoPropietario && !estaAutorizadoAdministracion && !estaAutorizadoPropietario && !estaPagadoSinJustificante;
	     },
	     
	     getSrcCartera: function(get) {
	     	
	     	var cartera = get('gasto.entidadPropietariaDescripcion');
	     	var src=null;
	     	if(!Ext.isEmpty(cartera)) {
	     		src = CONST.IMAGENES_CARTERA[cartera.toUpperCase()];
	     	}
        	if(Ext.isEmpty(src)) {
        		return 	null;
        	}else {
        		return 'resources/images/'+src;	     
        	} 
	     },
	     
	     getTipoGasto: function(get) {
	     
	     	var tipoGastoDescripcion =  get('gasto.tipoGastoDescripcion');		
	     	var subtipoGastoDescripcion =  get('gasto.subtipoGastoDescripcion');	
	     	var tipoOperacion = get('gasto.tipoOperacionDescripcion');
			return tipoGastoDescripcion + ' - ' + subtipoGastoDescripcion;
	     
	     },
	     
	     getTipoOperacion: function(get) {
	     
	     	var tipoOperacionDescripcion = get('gasto.tipoOperacionDescripcion');
	     	return Ext.isEmpty(tipoOperacionDescripcion) ? "" : " - " + tipoOperacionDescripcion;
	     	
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
    	
    	comboDestinatarios: {
    		
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'destinatariosGasto'}
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
