Ext.define('HreRem.view.gastos.GastoDetalleModel', {
	extend : 'HreRem.view.common.GenericViewModel',
	alias : 'viewmodel.gastodetalle',
	requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase',
			'HreRem.model.GastoActivo', 'HreRem.model.GestionGasto',
			'HreRem.model.BusquedaTrabajo', 'HreRem.model.AdjuntoGasto',
			'HreRem.model.GastoRefacturableGridExistenteStore', 'HreRem.model.BusquedaTrabajoGasto',
			'HreRem.model.LineaDetalleGastoGridModel', 'HreRem.model.TasacionesGasto'],

	data : {
		gasto : null,
		gestion : null
	},

	formulas : {

		getConEmisor : function(get) {
			var me = this;
			var gasto = me.getData().gasto;
			if (Ext.isEmpty(gasto)) {
				return false;
			} else {
				var nifEmisor = gasto.get('nifEmisor');
				var nombreEmisor = gasto.get('nombreEmisor');
				var codigoEmisor = gasto.get('codigoEmisor');
			}

			if (Ext.isEmpty(nifEmisor) && Ext.isEmpty(nombreEmisor)
					&& Ext.isEmpty(codigoEmisor)) {
				return false;
			}

			return true;
		},

		getConPropietario : function(get) {
			var me = this;
			var gasto = me.getData().gasto;
			if (Ext.isEmpty(gasto)) {
				return false;
			} else {
				var nifPropietario = gasto.get('nifPropietario');
				var nombrePropietario = gasto.get('nombrePropietario');
			}

			if (Ext.isEmpty(nifPropietario) && Ext.isEmpty(nombrePropietario)) {
				return false;
			}

			return true;
		},
		
		esPropietarioBankia : function(get){
			var me = this;
			var gasto = me.getData().gasto;
			if (Ext.isEmpty(gasto)) {
				return false;
			} else {
				var nombrePropietario = gasto.get('nombrePropietario');
			}

			if ( Ext.isEmpty(nombrePropietario)) {
				return false;
			}
			
			if(nombrePropietario == CONST.NOMBRE_CARTERA2['BANKIA'] || nombrePropietario == CONST.NOMBRE_SUBCARTERA['BANKIA_HABITAT']){
				return true;
			}
			else{
				return false;
			}
			
		},
		ocultarBotonesTrabajos : function(get) {
			var me = this;
			var codigoEstadoCodigo = get('gasto.estadoGastoCodigo');
			var lineasNoDeTrabajos = me.getData().gasto.getData().lineasNoDeTrabajos
			if(lineasNoDeTrabajos){
				return true;
			}
			if (codigoEstadoCodigo == CONST.ESTADOS_GASTO['INCOMPLETO']
					|| codigoEstadoCodigo == CONST.ESTADOS_GASTO['RECHAZADO']
					|| codigoEstadoCodigo == CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO']
					|| codigoEstadoCodigo == CONST.ESTADOS_GASTO['PENDIENTE']) {
				return false;
			} else {
				return true;
			}
		},

		ocultarBotonesActivos : function(get) {
			var me = this;

			var estadoParaGuardar = me.getView().getViewModel().getData().gasto.getData().estadoModificarLineasDetalleGasto;
	    	var isGastoRefacturado = me.getView().getViewModel().getData().gasto.getData().isGastoRefacturadoPorOtroGasto;
	    	var isGastoRefacturadoPadre = me.getView().getViewModel().getData().gasto.getData().isGastoRefacturadoPadre;
	    	
			if(!estadoParaGuardar || isGastoRefacturado || isGastoRefacturadoPadre){
				return true;
			}
			
			return get('gasto.autorizado') || get('gasto.asignadoATrabajos');
		},

		asignadoAActivosPropietarioSareb : function(get) {
			var me = this;
			var gasto = me.getData().gasto;
			var esSareb = gasto.data.nombrePropietario == CONST.NOMBRE_CARTERA2['SAREB'];
			var esTango = gasto.data.nombrePropietario == CONST.NOMBRE_CARTERA2['TANGO'];
			var esGiants = gasto.data.nombrePropietario == CONST.NOMBRE_CARTERA2['GIANTS'];

			return get('gasto.asignadoAActivos') || esSareb || esTango
					|| esGiants;

		},

		esCarteraBakia : function(get) {
			return get('detalleeconomico.cartera') == CONST.CARTERA['BANKIA'];
		},

		esCarteraSareb : function(get) {
			return get('detalleeconomico.cartera') == CONST.CARTERA['SAREB'];
		},

		esReembolsoPago : function(get) {
			return (get('detalleeconomico.reembolsoTercero') == "true" || get('detalleeconomico.reembolsoTercero') == true);
		},

		seleccionadoAbonar : function(get) {
			return (get('detalleeconomico.abonoCuenta') == "true" || get('detalleeconomico.abonoCuenta') == true);
		},
		importeRecargoVacio : function(get) {
			var me = this;
			if (get('detalleeconomico.importeRecargo') == 0
					|| get('detalleeconomico.importeRecargo') == null) {
				return false;
			} else {
				return true;
			}
		},
		seleccionadoPagadoBankia : function(get) {
			return (get('detalleeconomico.pagadoConexionBankia') == "true" || get('detalleeconomico.pagadoConexionBankia') == true);

		},

		seleccionadoAnticipo : function(get) {
			return (get('detalleeconomico.anticipo') == "true" || get('detalleeconomico.anticipo') == true);

		},

		sumatorioConceptosgasto : function(get) {

			var sumatorioTotal = parseFloat('0');
			var importePrincipalSujeto = parseFloat(get('detalleeconomico.importePrincipalSujeto'));
			var importePricipalNoSujeto = parseFloat(get('detalleeconomico.importePrincipalNoSujeto'));
			var importeRecargo = parseFloat(get('detalleeconomico.importeRecargo'));
			var importeInteresDemora = parseFloat(get('detalleeconomico.importeInteresDemora'));
			var importeCostas = parseFloat(get('detalleeconomico.importeCostas'));
			var importeOtrosIncrementos = parseFloat(get('detalleeconomico.importeOtrosIncrementos'));
			var importeProvisionesSuplidos = parseFloat(get('detalleeconomico.importeProvisionesSuplidos'));
			var impuestoIndirectoCuota = 0;
			var cbOperacionExenta = get('detalleeconomico.impuestoIndirectoExento');
			var cbRenunciaExencion = get('detalleeconomico.renunciaExencionImpuestoIndirecto');
			if (cbOperacionExenta == false
					|| (cbOperacionExenta == true && cbRenunciaExencion == true)) {
				impuestoIndirectoCuota = parseFloat(get('detalleeconomico.impuestoIndirectoCuota'));
			}

			if (get('esCarteraSareb')) {
				sumatorioTotal = sumatorioTotal
						+ parseFloat(get('detalleeconomico.importeGastosRefacturables'));
			}

			sumatorioTotal = sumatorioTotal + importePrincipalSujeto
					+ importePricipalNoSujeto + importeRecargo
					+ importeInteresDemora + importeCostas
					+ importeOtrosIncrementos + importeProvisionesSuplidos
					+ impuestoIndirectoCuota;

			return sumatorioTotal;

		},

//		calcularImporteTotalGasto : function(get) {
//			var irpfCuota = get('detalleeconomico.irpfCuota');
//			var sumatorioConceptosGasto = get('sumatorioConceptosgasto');
//
//			return sumatorioConceptosGasto - irpfCuota;
//
//		},

		esGastoAnulado : function(get) {
			var e = !Ext.isEmpty(get('gestion.comboMotivoAnulado'));
			return e;
		},

		calcularImpuestoIndirecto : function(get) {

			var tipo = get('detalleeconomico.impuestoIndirectoTipoImpositivo');
			return tipo * get('detalleeconomico.importePrincipalSujeto') / 100;

		},

		calcularImpuestoDirecto : function(get) {

			var tipo = get('detalleeconomico.irpfTipoImpositivo');
			return tipo * get('detalleeconomico.importePrincipalSujeto') / 100;

		},

		esGastoEditable : function(get) {
			return get('gasto.esGastoEditable');
		},

		esAutorizable : function(get) {
			var me = this;
			var estaAutorizado = get('gasto.autorizado');
			var estaContabilizado = CONST.ESTADOS_GASTO['CONTABILIZADO'] == get('gasto.estadoGastoCodigo');
			var estaAnulado = CONST.ESTADOS_GASTO['ANULADO'] == get('gasto.estadoGastoCodigo');
			var estaEnviado = get('gasto.enviado');
			var estaRetenido = CONST.ESTADOS_GASTO['RETENIDO'] == get('gasto.estadoGastoCodigo');
			var estaIncompleto = CONST.ESTADOS_GASTO['INCOMPLETO'] == get('gasto.estadoGastoCodigo');
			var estaRechazadoPropietario = CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO'] == get('gasto.estadoGastoCodigo');
			var estaAutorizadoAdministracion = CONST.ESTADOS_GASTO['AUTORIZADO'] == get('gasto.estadoGastoCodigo');
			var estaAutorizadoPropietario = CONST.ESTADOS_GASTO['AUTORIZADO_PROPIETARIO'] == get('gasto.estadoGastoCodigo');

			return !estaEnviado && !estaAutorizado && !estaContabilizado
					&& !estaAnulado && !estaRetenido && !estaIncompleto
					&& !estaRechazadoPropietario
					&& !estaAutorizadoAdministracion
					&& !estaAutorizadoPropietario;

		},

		esRechazable : function(get) {
			var estaRechazado = get('gasto.rechazado');
			var estaContabilizado = CONST.ESTADOS_GASTO['CONTABILIZADO'] == get('gasto.estadoGastoCodigo');
			var estaPagadoSinJustificante = CONST.ESTADOS_GASTO['PAGADO_SIN_JUSTIFICANTE'] == get('gasto.estadoGastoCodigo');
			var estaAnulado = CONST.ESTADOS_GASTO['ANULADO'] == get('gasto.estadoGastoCodigo');
			var estaEnviado = get('gasto.enviado');
			var estaRetenido = CONST.ESTADOS_GASTO['RETENIDO'] == get('gasto.estadoGastoCodigo');
			var estaSubsanadoYAutorizado = get('gasto.autorizado')
					&& CONST.ESTADOS_GASTO['SUBSANADO'] == get('gasto.estadoGastoCodigo');
			var estaIncompleto = CONST.ESTADOS_GASTO['INCOMPLETO'] == get('gasto.estadoGastoCodigo');
			var estaRechazadoAdministracion = CONST.ESTADOS_GASTO['RECHAZADO'] == get('gasto.estadoGastoCodigo');
			var estaRechazadoPropietario = CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO'] == get('gasto.estadoGastoCodigo');
			var estaAutorizadoAdministracion = CONST.ESTADOS_GASTO['AUTORIZADO'] == get('gasto.estadoGastoCodigo');
			var estaAutorizadoPropietario = CONST.ESTADOS_GASTO['AUTORIZADO_PROPIETARIO'] == get('gasto.estadoGastoCodigo');

			return !estaEnviado && !estaRechazado && !estaContabilizado
					&& !estaAnulado && !estaRetenido
					&& !estaSubsanadoYAutorizado && !estaIncompleto
					&& !estaRechazadoAdministracion
					&& !estaRechazadoPropietario
					&& !estaAutorizadoAdministracion
					&& !estaAutorizadoPropietario && !estaPagadoSinJustificante;
		},

		getSrcCartera : function(get) {

			var cartera = get('gasto.entidadPropietariaDescripcion');
			var src = null;
			if (!Ext.isEmpty(cartera)) {
				src = CONST.IMAGENES_CARTERA[cartera.toUpperCase()];
			}
			if (Ext.isEmpty(src)) {
				return null;
			} else {
				return 'resources/images/' + src;
			}
		},

		getTipoGasto : function(get) {

			var tipoGastoDescripcion = get('gasto.tipoGastoDescripcion');
			var tipoOperacion = get('gasto.tipoOperacionDescripcion');
			return tipoGastoDescripcion;

		},

		esCerberusDivarianApple : function(get) {
			var me = this;
			if (me.getData().gasto != null) {
				var cartera = me.getData().gasto.get('cartera');
				var subcartera = me.getData().gasto.get('subcartera');

				if (CONST.CARTERA['CERBERUS'] == cartera
						&& (CONST.SUBCARTERA['DIVARIANARROW'] == subcartera
								|| CONST.SUBCARTERA['DIVARIANREMAINING'] == subcartera || CONST.SUBCARTERA['APPLEINMOBILIARIO'] == subcartera)) {
					return true;
				}
			}
			return false;
		},

		getTipoOperacion : function(get) {

			var tipoOperacionDescripcion = get('gasto.tipoOperacionDescripcion');
			return Ext.isEmpty(tipoOperacionDescripcion) ? "" : " - "
					+ tipoOperacionDescripcion;

		},

		deshabilitarGridGastosRefacturados : function(get) {
			var me = this;

			var isGastoRefacturable = get('detalleeconomico.gastoRefacturableB');
			var bloquearCheckRefacturado = get('detalleeconomico.bloquearCheckRefacturado');

			if (isGastoRefacturable == true || isGastoRefacturable == "true"
					|| bloquearCheckRefacturado == true
					|| bloquearCheckRefacturado == "true") {

				return true;

			}
			return false;
		},

		deshabilitarCheckEstadoAutorizado : function(get) {
			var me = this;
			var bloquearCheckRefacturado = get('detalleeconomico.bloquearCheckRefacturado');

			if (bloquearCheckRefacturado == true
					|| bloquearCheckRefacturado == "true") {
				return true;
			}
			return false;
		},

		deshabilitarCheckGastoRefacturable : function(get) {
			var me = this;
			var user = $AU.userIsRol("HAYASUPER") || $AU.userIsRol("HAYAADM")
					|| $AU.userIsRol("HAYASADM");
			var isGastoRefacturable = get('detalleeconomico.bloquearCheckRefacturado');
			if (!user || isGastoRefacturable) {
				return true;
			}
			return false;
		},

		emisorSoloLectura : function(get) {
			if ($AU.userIsRol(CONST.PERFILES['PROVEEDOR']) || get('gasto.tieneGastosRefacturables')){
				return true;
			} else if (get('gasto.tieneTrabajos')){
				return true;
			} else {
				return false;
			}
		},
		
		esLiberbank : function(get) {
			var cartera = get('detalleeconomico.cartera');
			if(CONST.CARTERA['LIBERBANK'] == cartera){
				return true;
			}
			return false;
		},
		
		condicionesSolicitudPagoUrgente : function(get) {
			var me = this;
			
			if (me.getData().gasto != null && me.getData().gasto.get('cartera') != null) {
				var cartera = me.getData().gasto.get('cartera');
				var user = $AU.userIsRol("HAYASUPER") || $AU.userIsRol("HAYASADM");
				
				if(CONST.CARTERA['BBVA'] == cartera && user){
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		},
		
		esPropietarioCaixaAlquiler : function(get){
			var me = this;
			var gasto = me.getData().gasto;
			if (Ext.isEmpty(gasto)) {
				return false;
			} 
			var codCarteraPropietario = gasto.get('carteraPropietarioCodigo');
			var tipoGasto = gasto.get('tipoGastoCodigo');

			if(codCarteraPropietario == CONST.CARTERA['BANKIA'] && tipoGasto ==  CONST.TIPO_GASTO['ALQUILER']){
				return true;
			}
			
			return false;
		}
	},

	stores : {

		comboPeriodicidad : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'tipoPeriocidad'
				}
			}
		},

		comboTiposGasto : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'tiposGasto'
				}
			}
		},

		comboTipoOperacion : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'tipoOperacionGasto'
				}
			}
		},

		comboSubtiposGasto : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getComboSubtipoGasto',
				extraParams : {
					codigoTipoGasto : '{gasto.tipoGastoCodigo}'
				}
			},
			autoLoad: true
		},

		comboSubtiposNuevoGasto : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getComboSubtipoGasto',
				extraParams : {
					codigoTipoGasto : '{gastoNuevo.tipoGastoCodigo}'
				}
			}
		},

		comboPropietarios : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'propietariosGasto'
				}
			}
		},

		comboDestinatarios : {

			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'destinatariosGasto'
				}
			}
		},

		comboPagadoPor : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'tipoPagador'
				}
			}
		},

		comboDestinatarioPago : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'destinataioPago'
				}
			}
		},

		comboTipoImpuesto : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getTiposImpuestoFiltered',
				extraParams : {
					esBankia : 'false'
				}
			},
			autoLoad: true
		},

		storeActivosAfectados : {
			pageSize : $AC.getDefaultPageSize(),
			model : 'HreRem.model.GastoActivo',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'gastosproveedor/getListActivosGastos',
				extraParams : {
					idGasto : '{gasto.id}'
				}
			}
		},

		storeTrabajosAfectados : {
			pageSize : $AC.getDefaultPageSize(),
			model : 'HreRem.model.BusquedaTrabajo',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'gastosproveedor/getListTrabajosGasto',
				extraParams : {
					idGasto : '{gasto.id}'
				}
			}
		},

		comboEjercicioContabilidad : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getComboEjercicioContabilidad'
			}
		},

		comboMotivoAutorizacion : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'motivosAutorizacionPropietaro'
				}
			}
		},

		comboEstadoAutorizacionHaya : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'estadosAutorizacionHaya'
				}
			}
		},

		comboMotivoRechazoHaya : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'motivosRechazoHaya'
				}
			}
		},

		comboEstadoAutorizacionPropietario : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'estadosAutorizacionPropietario'
				}
			}
		},

		comboMotivoAnulado : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'motivosAnulados'
				}
			}
		},

		comboMotivoRetenerPago : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'motivosRetenerPago'
				}
			}
		},

		comboResultadoImpugnacion : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'resultadosImpugnacion'
				}
			}
		},

		comboEstadosGasto : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'estadoGasto'
				}
			}
		},
		
		
		filtroComboTipoTrabajo : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'gastosproveedor/getTiposTrabajoByIdGasto',
				extraParams : {
					idGasto : '{gasto.id}'
				}
			}

		},

		filtroComboSubtipoTrabajo : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'gastosproveedor/getSubTiposTrabajoByIdGasto',
				extraParams : {
					idGasto : '{gasto.id}'
				}
			}

		},
		
		seleccionTrabajosGasto : {
			pageSize : $AC.getDefaultPageSize(),
			model : 'HreRem.model.BusquedaTrabajoGasto',
			proxy : {
				type : 'uxproxy',
				localUrl : '/trabajosgasto.json',
				remoteUrl : 'trabajo/findBuscadorGastos',
				actionMethods : {
					read : 'POST'
				}
			},
			remoteSort : true,
			remoteFilter : true,
			listeners : {
				beforeload : 'paramLoading'

			}
		},

		storeDocumentosGasto : {
			pageSize : $AC.getDefaultPageSize(),
			model : 'HreRem.model.AdjuntoGasto',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'gastosproveedor/getListAdjuntos',
				extraParams : {
					idGasto : '{gasto.id}'
				}
			},
			groupField : 'descripcionTipo'
		},

		comboTipoRecargo : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'tiposDeRecargo'
				}
			},
			autoLoad: true
		},

		storeGastosRefacturablesExistentes : {
			model : 'HreRem.model.GastoRefacturableGridExistenteStore',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'gastosproveedor/getGastosRefacturablesGastoCreado',
				extraParams : {
					id : '{gasto.id}'
				}
			}
		},

		comboSubpartidaPresupuestaria : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getComboSubpartidaPresupuestaria',
				extraParams : {
					idGasto : '{gasto.id}'
				}
			}
		},
		
		comboSiNoGastos : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'DDSiNo'
				}
			}
		},

        comboSiNoContabilidad: {
            data : [
                {"codigo":"01", "descripcion":"Si"},
                {"codigo":"02", "descripcion":"No"}
            ]
        },
        
        storeLineaGastoDetalle : {
			model : 'HreRem.model.LineaDetalleGastoGridModel',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'gastosproveedor/getGastoLineaDetalle',
				extraParams : {
					idGasto : '{gasto.id}'
				}
			}
		},
		
		storeVImporteGastoLbkGrid : {
			model : 'HreRem.model.VImporteGastoLbkGrid',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'gastosproveedor/getVImporteGastoLbk',
				extraParams : {
					idGasto : '{gasto.id}'
				}
			}
		},
		comboSiNoGastoBoolean : {
			data : [
                {"codigo":true, "descripcion":"Si"},
                {"codigo":false, "descripcion":"No"}
            ],
			autoLoad: true
		},

		comboTipoComision : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {
					diccionario: 'tipoComision'
				}
			}
		},
		
		storeElementosAfectados : {
			pageSize : $AC.getDefaultPageSize(),
			model : 'HreRem.model.GastoProveedor',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'gastosproveedor/getElementosAfectados',
				extraParams : {
					idLinea : -1
				}
			},
			
			autoLoad: false
		},
		
		comboLineasDetallePorGasto : {
			model : 'HreRem.model.GastoActivo',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'gastosproveedor/getLineasDetalleGastoCombo',
				extraParams : {
					idGasto : '{gasto.id}'
				}
			},
			autoLoad: true
		},
		storeTipoElemento : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getComboTipoElementoGasto',
				extraParams : {
					//cargaDinamica
				}
			}
		},
		
		storeSubpartidas : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getComboSubpartidaPresupuestaria',
				extraParams : {
					idGasto : '{gasto.id}'
				}
			},
			autoLoad: false
		},
		
		comboTipoRetencion : {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getDiccionario',
				extraParams : {
					diccionario : 'tipoRetencion'
				}
			},
			autoLoad: true
		},
		
		storeRechazosPropietario : {
			model : 'HreRem.model.RechazosPropietarioGridModel',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'gastosproveedor/getRechazosPropietario',				
				extraParams : {
					idGasto : '{gasto.id}'
				}
			}
		},

		seleccionTasacionesGasto : {
			pageSize : $AC.getDefaultPageSize(),
			model : 'HreRem.model.TasacionesGasto',
			proxy : {
				type : 'uxproxy',
				localUrl : '/tasaciones.json',
				remoteUrl : 'activo/findTasaciones',
				actionMethods : {
					read : 'POST'
				}
			},
			remoteSort : true,
			remoteFilter : true,
			listeners : {
				beforeload : 'paramLoadingTasaciones'

			}
		},

        storeTasacionesGasto : {
            pageSize : $AC.getDefaultPageSize(),
            model : 'HreRem.model.TasacionesGasto',
            proxy : {
                type : 'uxproxy',
                remoteUrl : 'gastosproveedor/getListTasacionesGasto',
                extraParams : {
                    idGasto : '{gasto.id}'
                }
            }
        },
        
        comboSubtiposGastoFiltered: {
			model : 'HreRem.model.ComboBase',
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'generic/getComboSubtipoGastoFiltered',
				extraParams : {
					codCartera: '{gasto.carteraPropietarioCodigo}',
					codigoTipoGasto : '{gasto.tipoGastoCodigo}'
				}
			},
			autoLoad: true
		},
    	
    	comboSubtipoGastoFiltered: {
    		model: 'HreRem.model.ComboBase',
    		proxy: {
    			type: 'uxproxy',
    			remoteUrl: 'generic/getComboSubtipoGastoFiltered'
    		}
    	}
	}
});
