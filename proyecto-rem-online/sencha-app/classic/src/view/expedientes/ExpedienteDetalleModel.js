Ext.define('HreRem.view.expedientes.ExpedienteDetalleModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.expedientedetalle',
    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.TextosOferta', 'HreRem.model.ActivosExpediente', 'HreRem.model.DatosClienteUrsus', 
                'HreRem.model.EntregaReserva', 'HreRem.model.ObservacionesExpediente', 'HreRem.model.AdjuntoExpedienteComercial', 'HreRem.model.DatosBasicosOferta',
                'HreRem.model.Posicionamiento', 'HreRem.model.ComparecienteVendedor', 'HreRem.model.Subsanacion', 'HreRem.model.Notario',
                'HreRem.model.ComparecienteBusqueda', 'HreRem.model.Honorario','HreRem.model.HstcoSeguroRentas','HreRem.model.TipoDocumentoExpediente',
				'HreRem.model.CompradorExpediente', 'HreRem.model.FichaComprador','HreRem.model.BloqueoActivo','HreRem.model.TanteoActivo',
				'HreRem.model.ExpedienteScoring', 'HreRem.model.HistoricoExpedienteScoring', 'HreRem.model.SeguroRentasExpediente', 'HreRem.model.HistoricoCondiciones',
				'HreRem.model.OfertasAgrupadasModel', 'HreRem.model.OrigenLead', 'HreRem.model.AuditoriaDesbloqueo', 'HreRem.model.ActivoAlquiladosGrid', 'HreRem.model.Testigos',
				'HreRem.model.FechaArrasModel', 'HreRem.model.GastosRepercutidosModel', 'HreRem.model.ActualizacionRentaModel','HreRem.model.SancionesModel'],
    
    data: {
    },
    
    formulas: {   

    	 comprobacionCreacionModificacionCompradores: function(get){
    		if(get('esCarteraBankia')){
				if(get('8')){
				    if($AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['SUPER_EDITA_COMPRADOR'])){
				        if(get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['FIRMADO'] || get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['ANULADO'] || get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['VENDIDO']){
				            return false;
				        }
				    }else{
                        if(get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['APROBADO'] || get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['FIRMADO'] || get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['ANULADO'] || get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['VENDIDO']){
                            return false;
                        }
				    }
				}
				else{
					if(get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['RESERVADO'] || get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['FIRMADO'] || get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['ANULADO'] || get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['VENDIDO']){
						return false;
					}
				}
			}
    		return true; 
    	 },
    	 
    	 expedienteEstaAprobado: function(get){
    		 return get('expediente.codigoEstado') == CONST.ESTADOS_EXPEDIENTE['APROBADO'];
    	 },
    	
		 puedeCrearEliminarCompradores: function(get) {
    		return get('comprobacionCreacionModificacionCompradores') && $AU.userHasFunction(['EDITAR_TAB_COMPRADORES_EXPEDIENTES']);
		 },
    	
		 puedeModificarCompradores: function(get) {
    		return $AU.userHasFunction(['TAB_COMPRADORES_EXP_DETALLES_COMPRADOR']);
		 },
    		
	     getSrcCartera: function(get) {
	     	
	     	var cartera = get('expediente.entidadPropietariaDescripcion');
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
	     isEmptySrcCartera: function(get) {
	     	var cartera = get('expediente.entidadPropietariaDescripcion');
	     	var src=null;
	     	if(!Ext.isEmpty(cartera)) {
	     		src = CONST.IMAGENES_CARTERA[cartera.toUpperCase()];
	     	}
        	if(Ext.isEmpty(src)) {
        		return 	true;
        	}else {
        		return false;	     
        	}     	
	     	
	     },
	     
	     esCarteraBankia: function(get) {
	     	var carteraCodigo = get('expediente.entidadPropietariaCodigo');
	     	return CONST.CARTERA['BANKIA'] == carteraCodigo;
	     },
	     
	     visibleBotonAuditoriaDesbloqueo: function(get){
	    	var me = this;
	    	var finEconomico = false;
	    	if (get('expediente.finalizadoCierreEconomico') != null){
	    		finEconomico = get('expediente.finalizadoCierreEconomico');
	    	}
			var usuariosValidos = $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['PERFGCONTROLLER']);
			return usuariosValidos && finEconomico;
			
	     },
	     
	     esBankiaHabitat: function(get) {
		    	var subCartera = get('expediente.propietario');
		     	return CONST.NOMBRE_SUBCARTERA['BANKIA_HABITAT'] == subCartera;
	     },
	  	     
	     fechaIngresoChequeReadOnly: function(get) {
	    	 
	    	 if($AU.userIsRol("HAYASUPER")){
	    		 return false;
	    	 }
	    	 
	    	 var carteraCodigo = get('expediente.entidadPropietariaCodigo');
	    	 var subCartera = get('expediente.propietario');
	    	 return (CONST.CARTERA['BANKIA'] == carteraCodigo && CONST.NOMBRE_SUBCARTERA['BANKIA_HABITAT'] != subCartera) 
	    	 		|| CONST.CARTERA['LIBERBANK'] == carteraCodigo || CONST.CARTERA['CERBERUS'] == carteraCodigo;
	     },
	     
	     fechaContabilizacionReservaReadOnly: function(get) {
	    	 
	    	 if($AU.userIsRol("HAYASUPER")){
	    		 return false;
	    	 }

	    	 return true;
	     },
	     
	     comiteSancionadorNoEditable: function(get) {
	     	var carteraCodigo = get('expediente.entidadPropietariaCodigo');
	     	return CONST.CARTERA['BANKIA'] == carteraCodigo || CONST.CARTERA['CAJAMAR'] == carteraCodigo || CONST.CARTERA['LIBERBANK'] == carteraCodigo || CONST.CARTERA['BBVA'] == carteraCodigo;	
	     }, 
	     
	     esCarteraSareb: function(get) {
	     	
	     	var carteraCodigo = get('expediente.entidadPropietariaCodigo');
	     	return CONST.CARTERA['SAREB'] == carteraCodigo;
	     },
	     
	     esCarteraTango: function(get) {
		     	
	     	var carteraCodigo = get('expediente.entidadPropietariaCodigo');
	     	return CONST.CARTERA['TANGO'] == carteraCodigo;
	     },
	     
	     esCarteraGaleon: function(get) {
		     	
	     	var carteraCodigo = get('expediente.entidadPropietariaCodigo');
	     	return CONST.CARTERA['GALEON'] == carteraCodigo;
	     },
	     
	     esCarteraGiants: function(get) {
		     	
	     	var carteraCodigo = get('expediente.entidadPropietariaCodigo');
	     	return CONST.CARTERA['GIANTS'] == carteraCodigo;
	     },
	     esCarteraZeus: function(get) {
		     	
		     	var carteraCodigo = get('expediente.entidadPropietariaCodigo');
		     	return CONST.CARTERA['ZEUS'] == carteraCodigo;
		 },
		     
		 esCarteraGaleonOZeus: function(get) {
			 var carteraCodigo = get('expediente.entidadPropietariaCodigo');
			 return CONST.CARTERA['GALEON'] == carteraCodigo || CONST.CARTERA['ZEUS'] == carteraCodigo;
		 },
	     
		 esCarteraAgora: function(get) {
			 var carteraCodigo = get('expediente.entidadPropietariaCodigo');
			 var subcarteraCodigo = get('expediente.subcarteraCodigo');
			 return CONST.CARTERA['CERBERUS'] == carteraCodigo && (CONST.SUBCARTERA['AGORAINMOBILIARIO'] == subcarteraCodigo || CONST.SUBCARTERA['AGORAFINANCIERO'] == subcarteraCodigo) ;
		 },
		 
		 esCarteraApple: function(get) {
			 var carteraCodigo = get('expediente.entidadPropietariaCodigo');
			 var subcarteraCodigo = get('expediente.subcarteraCodigo');
			 return CONST.CARTERA['CERBERUS'] == carteraCodigo && CONST.SUBCARTERA['APPLEINMOBILIARIO'] == subcarteraCodigo ;
		 },
		 
		 esCarteraAppleOrArrowOrRemaining: function(get) {
			 var carteraCodigo = get('expediente.entidadPropietariaCodigo');
			 var subcarteraCodigo = get('expediente.subcarteraCodigo');
			 return CONST.CARTERA['CERBERUS'] == carteraCodigo &&  (CONST.SUBCARTERA['APPLEINMOBILIARIO'] == subcarteraCodigo || 
			  CONST.SUBCARTERA['DIVARIANARROW'] == subcarteraCodigo || CONST.SUBCARTERA['DIVARIANREMAINING'] == subcarteraCodigo || CONST.SUBCARTERA['JAGUAR'] == subcarteraCodigo) ;
		 },

		 esCarteraAppleOrRemainingOrJaguar: function(get) {
			 var carteraCodigo = get('expediente.entidadPropietariaCodigo');
			 var subcarteraCodigo = get('expediente.subcarteraCodigo');
			 return CONST.CARTERA['CERBERUS'] == carteraCodigo && (CONST.SUBCARTERA['APPLEINMOBILIARIO'] == subcarteraCodigo ||
			  CONST.SUBCARTERA['DIVARIANREMAINING'] == subcarteraCodigo || CONST.SUBCARTERA['JAGUAR'] == subcarteraCodigo) ;
		 },
		 
		 esCarteraAppleOAgora: function(get) {
			 var carteraCodigo = get('expediente.entidadPropietariaCodigo');
			 var subcarteraCodigo = get('expediente.subcarteraCodigo');
			 return (CONST.CARTERA['CERBERUS'] == carteraCodigo && CONST.SUBCARTERA['APPLEINMOBILIARIO'] == subcarteraCodigo) || CONST.CARTERA['CERBERUS'] == carteraCodigo && (CONST.SUBCARTERA['AGORAINMOBILIARIO'] == subcarteraCodigo || CONST.SUBCARTERA['AGORAFINANCIERO'] == subcarteraCodigo) ;
		 },
		 
		 esCarteraAppleoLiberbank: function(get) {
		 	 var carteraCodigo = get('expediente.entidadPropietariaCodigo');
			 var subcarteraCodigo = get('expediente.subcarteraCodigo');
			 return CONST.CARTERA['CERBERUS'] == carteraCodigo && CONST.SUBCARTERA['APPLEINMOBILIARIO'] == subcarteraCodigo || CONST.CARTERA['LIBERBANK'] == carteraCodigo;
		 },
	     esCarteraCajamar: function(get) {
		     	
	     	var carteraCodigo = get('expediente.entidadPropietariaCodigo');
	     	return CONST.CARTERA['CAJAMAR'] == carteraCodigo;
	     },
	     
	     esCarteraLiberbank: function(get) {
		     	
	     	var carteraCodigo = get('expediente.entidadPropietariaCodigo');
	     	return CONST.CARTERA['LIBERBANK'] == carteraCodigo;
		 },
		 
		 esCarteraLiberbankVenta: function(get) {
		     	
		     	var carteraCodigo = get('expediente.entidadPropietariaCodigo');
		     	var tipoExpediente = get('expediente.tipoExpedienteCodigo');
		     	return CONST.CARTERA['LIBERBANK'] == carteraCodigo && CONST.TIPOS_EXPEDIENTE_COMERCIAL['VENTA'] == tipoExpediente;
		 },
	     
	     esCarteraBBVA: function(get) {
		     	
	     	var carteraCodigo = get('expediente.entidadPropietariaCodigo');
	     	return CONST.CARTERA['BBVA'] == carteraCodigo;
		 },
		 
		 esReadOnly: function(get) {
			 var subcarteraCodigo = get('expediente.subcarteraCodigo');
			 var carteraCodigo = get('expediente.entidadPropietariaCodigo');
			 
			 if(CONST.CARTERA['BANKIA'] == carteraCodigo && CONST.SUBCARTERA['BH'] != subcarteraCodigo){
				 return true;
			 }else if(CONST.CARTERA['LIBERBANK'] == carteraCodigo){
				 return true;
			 }
			 
		     return false;
		 },
	     
	     getTipoExpedienteCabecera: function(get) {
	     
	     	var tipoExpedidenteDescripcion =  get('expediente.tipoExpedienteDescripcion');
	     	var idAgrupacion = get('expediente.idAgrupacion');
			var numEntidad = get('expediente.numEntidad');
			var descEntidad = Ext.isEmpty(idAgrupacion) ? ' Activo ' : ' Agrupación '
			
			return tipoExpedidenteDescripcion + descEntidad + numEntidad;
	     
	     },
	     
	     esImpuestoMayorQueCero: function(get){
	     	var impuesto= get('condiciones.impuestos');
	     	if(impuesto > 0){
	     		return true;
	     	}
	     	return false;
	     	
	     },
	     esEditableCompradores : function(get){
	     	var me = this;
	     	if(get('esCarteraBankia')){
			return (get('expediente.codigoEstado') != CONST.ESTADOS_EXPEDIENTE['FIRMADO']
					    && get('expediente.codigoEstado') != CONST.ESTADOS_EXPEDIENTE['VENDIDO'] )
					    && $AU.userHasFunction(['EDITAR_TAB_COMPRADORES_EXPEDIENTES']);
	     	}else{
	     		return false;
	     	}
					    
		},
	     esComunidadesMayorQueCero: function(get){
	     	var comunidades= get('condiciones.comunidades');
	     	if(comunidades > 0){
	     		return true;
	     	}
	     	return false;
	     	
	     },  
	     
	     
	     onEstaSujetoTanteo: function(get){
	     	var sujeto= get('condiciones.sujetoTramiteTanteo');
	     	if(sujeto==1){
	     		return true;
	     	}
	     	return false;
	     },
	     
	     esDestinoActivoOtros: function(get){
	     	var destinoActivo= get('destinoActivo');
	     	if(destinoActivo=='05'){
	     		return true;
	     	}
	     	return false;
	     },

		esOfertaVenta: function(get){
			var me= this;
		
			var tipoOferta= get('expediente.tipoExpedienteDescripcion');
	     	if(tipoOferta=='Venta'){
	     		return true;
	     	}
	     	return false;
	     },
	     
	     getStoreMotivoAnulacionOrRechazoByTipoExpediente: function(get){
			var tipoExpedienteCodigo = get('expediente.tipoExpedienteCodigo');
			if (tipoExpedienteCodigo == CONST.TIPOS_EXPEDIENTE_COMERCIAL["VENTA"]) {
	     		return this.data.storeMotivoAnulacion;
	     	} else {
	     		return this.data.storeMotivoRechazoExp;
	     	}
		 },
		 
		 getMotivoAnulacionOrRechazo: function(get){
				var tipoExpedienteCodigo = get('expediente.tipoExpedienteCodigo');
				if (tipoExpedienteCodigo == CONST.TIPOS_EXPEDIENTE_COMERCIAL["VENTA"]) {
		     		return get('expediente.descMotivoAnulacion');
		     	} else if (tipoExpedienteCodigo == CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"]) {
		     		if (get('expediente.descMotivoAnulacion')){
		     			return get('expediente.descMotivoAnulacion');
		     		} else if (get('expediente.descMotivoRechazoExp')) {
		     			return get('expediente.descMotivoRechazoExp');
		     		} else if (get('expediente.descMotivoAnulacionAlq')){
		     			return get('expediente.descMotivoAnulacionAlq');
		     		} else {
		     			return null;
		     		}
		     	}
		 },
		 
	     compradorTipoEsAlquiler: function(get){

			var tipoOferta= get('expediente.tipoExpedienteCodigo');
			var comprador = HreRem.i18n('fieldlabel.comprador');
			
	     	if(tipoOferta==CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"]){
	     		
				comprador = HreRem.i18n('fieldlabel.inquilino');
	     		return comprador;
	     	}
	     	return comprador;
	     },
	     	     
	     reservaTipoEsAlquiler: function(get){
				
				var tipoOferta= get('expediente.tipoExpedienteCodigo');
				var reserva= HreRem.i18n('fieldlabel.fecha.reserva');
				
		     	if(tipoOferta==CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"]){
		     		
		     		reserva = HreRem.i18n('fieldlabel.fecha.scoring');
		     		return reserva;
		     	}
		     	return reserva;
		     },
		     fechaVentaEsAlquiler: function(get){
					
					var tipoOferta= get('expediente.tipoExpedienteCodigo');
					var fVenta= HreRem.i18n('fieldlabel.fecha.venta');
					
			     	if(tipoOferta==CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"]){
			     		
			     		fVenta = HreRem.i18n('fieldlabel.fecha.contrato');
			     		return fVenta;
			     	}
			     	return fVenta;
			     },
	     
	     esExpedienteSinReserva: function(get) {
	     	
	     	
	     	if(!Ext.isEmpty(get('expediente.solicitaReserva'))) {
	    	 	return get('expediente.solicitaReserva') == "0";
	     	} else {
	    	 	return !get('expediente.tieneReserva');
	    	}

	     	
	     },
		
		esOfertaVentaFicha: function(get){
	     	var me = this;
	     	var expediente= me.getData().expediente;
	     	if(!Ext.isEmpty(expediente)){
		     	var tipoOferta= expediente.get('tipoExpedienteCodigo');
		     	if(CONST.TIPOS_EXPEDIENTE_COMERCIAL["VENTA"] == tipoOferta){
		     		return true;
		     	}
	     	}
	     	//se oculta el bloque por HREOS-4775 por el tercer puntito
	     	return false;
	     },
	     
	     esAlquilerConOpcionCompra: function(get){
	     	var me = this;
			if(!Ext.isEmpty(me.getData().expediente)){
				if(me.getData().expediente.get('alquilerOpcionCompra')==1){
					return true;
				}
			}
	     	return false;
	     },
	     
	     esExpedienteNoSujetoTramiteTanteo: function(get) {
		     	
	     	var ocultarPestTanteo = get('expediente.ocultarPestTanteoRetracto');
	     	return ocultarPestTanteo === "true";
	     	
	     },
	     
	     esExpedienteSinReservaOdeTipoAlquiler: function(get) {
	    	 var me = this;
	    	 return get('esExpedienteSinReserva') ||  get('expediente.tipoExpedienteCodigo') === "02";	    	 
	     },
	     
	     esExpedienteBloqueado: function(get) {
		     	
		     	var bloqueado = get('expediente.bloqueado') === "01";
		     	return bloqueado;
		     	
		 },

		 
	     esTipoAlquiler: function(get){
			var tipoExpedienteCodigo = get('expediente.tipoExpedienteCodigo');
						
			return (tipoExpedienteCodigo == CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"]);
	     },
	     
	     esEstadoPendiente: function(get) {
		     	
		     	var pendiente = get('segurorentasexpediente.estado');
		     	return pendiente;
		     	
		 },
		 
	     enRevision: function(get) {
		     	
		     	var revision = get('segurorentasexpediente.revision');
		     	return revision == 'true';
		     	
		 },
		 esOfertaAlquiler: function(get) {
			 var tipoOfertaCodigo = get('datosbasicosoferta.tipoOfertaCodigo');
			 
			 if(tipoOfertaCodigo == CONST.TIPOS_OFERTA["ALQUILER"]){
				 return true
			 }else{
				 return false;
			 }
		 },

		 	mostrarBotonLanzarPBC: function(get){

             var tieneInterlocutoresNoEnviados = get('datosbasicosoferta.tieneInterlocutoresNoEnviados');

         	return $AU.userIsRol(CONST.PERFILES['HAYASUPER']) && tieneInterlocutoresNoEnviados ;

         	},

		 esOfertaTramitada: function(get){
			 var tipoOfertaDesc = get('datosbasicosoferta.estadoDescripcion');
			 
			 if(tipoOfertaDesc == "Tramitada"){
				 return true;
			 }else return false;
		 },
		 fechaMinima: function(get){
			 var fechaMinima = get('condiciones.fechaMinima');
			 if(!Ext.isEmpty(fechaMinima)) {
				 fechaMinima= fechaMinima.split('T',1);
				 fechaFinal= fechaMinima.toString();
			 } else {
				 fechaFinal = '';
			 }
			 return fechaFinal;
			 
		 },
		 esObligatorio: function(){
		 	var me = this;
		    if(!Ext.isEmpty(me.getView().expediente)){
		    	if(me.getView().expediente.data.tipoExpedienteCodigo == "01"){
			    	return false;
			    }else{
			    	return true;
			    }
		    }

		    },

		 esEntidadFinancieraBankia: function(get) {
			 var entidadFinancieraCod = get('financiacion.entidadFinancieraCodigo') == "01";
			 var esBankia = get("expediente.esBankia");
			 var vCombo = CONST.COMBO_ENTIDAD_FINANCIERA['BANKIA'];
			 
			 if(!Ext.isEmpty(entidadFinancieraCod)) {
				 if (esBankia && entidadFinancieraCod == vCombo) {
					 return false; // Se muestra el bloque bankia
				 } else if ((esBankia && entidadFinancieraCod != vCombo) || (!esBankia && entidadFinancieraCod == vCombo) || (!esBankia && entidadFinancieraCod != vCombo)) {
					 return true; // Se esconde el boque bankia
				 }
			}
		 },
		
		isGestorFormalizacion: function(){
			if($AU.userIsRol(CONST.PERFILES['HAYAGESTFORM']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTIAFORM'])){
				return false;
			}else{
				return true;
			}
		},
		
		requisitosEdicionExclusionBulk: function(get){
			var tarea = get('datosbasicosoferta.tareaAdvisoryNoteFinalizada');
			return ($AU.userIsRol(CONST.PERFILES['GESTOR_COMERCIAL_SINGULAR']) || $AU.userIsRol(CONST.PERFILES['GESTOR_COMERCIAL_BO_INM']) && (tarea == false || tarea == 'false'));
		},
		
		requisitosEdicionIdAdvisoryNote: function(get){
			var tarea = get('datosbasicosoferta.tareaAdvisoryNoteFinalizada');
			return ($AU.userIsRol(CONST.PERFILES['GESTOR_COMERCIAL_BO_INM']) && (tarea == false || tarea == 'false'));
		},
		requisitosVisibleBotonExcluirBulk: function(get){
			var tareaAn = get('datosbasicosoferta.tareaAdvisoryNoteFinalizada');
			var tareaPro = get('datosbasicosoferta.tareaAutorizacionPropiedadFinalizada');
			var idAn = get('datosbasicosoferta.idAdvisoryNote');
			var exclusion = get('datosbasicosoferta.exclusionBulk');
			return (($AU.userIsRol(CONST.PERFILES['GESTOR_COMERCIAL_BO_INM']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER'])) 
				&& !Ext.isEmpty(idAn) && !Ext.isEmpty(exclusion) && (tareaAn == true || tareaAn == 'true') 
				&& (tareaPro == false || tareaPro == 'false'));
		},
		esPerfilPMyCEs: function(get){
			
			var tipoOfertaDesc = get('datosbasicosoferta.estadoDescripcion');
			 
			 if(tipoOfertaDesc == "Tramitada"){
				if($AU.userIsRol('HAYAGRUPOCES') || $AU.userIsRol('HAYAGESTPORTMAN') ){
					return false;
				}else{
					return true;
				} 	
			 }else{
			 	return false;
			 }
		},
			
		esBankia: function(get) {
			var carteraCodigo = get('expediente.entidadPropietariaCodigo');
	     	
	     	if(CONST.CARTERA['BANKIA'] == carteraCodigo){
	     		return true;
	     	}else{
	     		return false;
	     	}
		},
		ocultarBtnDevolverReserva: function(get){
			var me = this;
			if(get('expediente.tieneReserva') && get('expediente.codigoEstado') == '16' && CONST.CARTERA['BANKIA'] != get('expediente.entidadPropietariaCodigo') &&
					CONST.CARTERA['LIBERBANK'] != get('expediente.entidadPropietariaCodigo') && get('expediente.noEsOfertaFinalGencat')){
				return false;
			}else{
				return true;
			}			
		},
		
		esOfertaVentaEsCajamar: function(get){
			var me= this;
			var tipoOferta= get('expediente.tipoExpedienteDescripcion');
			var carteraCodigo = get('expediente.entidadPropietariaCodigo');

	     	if(tipoOferta=='Venta' && carteraCodigo==CONST.CARTERA['CAJAMAR']){
	     		return true;
	     	}
	     	return false;
	     },
 		esOfertaVentaEsCaixa: function(get){
			var me= this;
			var tipoOferta= get('expediente.tipoExpedienteDescripcion');
			var carteraCodigo = get('expediente.entidadPropietariaCodigo');

	     	if(tipoOferta=='Venta' && carteraCodigo==CONST.CARTERA['BANKIA']){
	     		return true;
	     	}
	     	return false;
	     },
	     
	 	
	 	mostrarPrescriptorCajamar: function(get){
	 		var me = this;
	 		var esCajamar = me.getView().getViewModel().get('esCarteraCajamar');
	 		var esTipoAlquiler = me.getView().getViewModel().get('esTipoAlquiler');
	 		
	 		if(esCajamar && !esTipoAlquiler){
	 			return true;
	 		}
	 		
	 		return false;
	 	},
	 	
	 	esSubcarteraRemainingOAppleOArrow: function(get){
	 		var me = this;	 	
	 		var isApple = CONST.SUBCARTERA['APPLEINMOBILIARIO'] === me.get('expediente.subcarteraCodigo');
	 		var isRemaining = CONST.SUBCARTERA['DIVARIANREMAINING'] === me.get('expediente.subcarteraCodigo');
	 		var isArrow = CONST.SUBCARTERA['DIVARIANARROW'] === me.get('expediente.subcarteraCodigo');
	 		var isJaguar = CONST.SUBCARTERA['JAGUAR'] === me.get('expediente.subcarteraCodigo');
	 		
	 		return isApple == true || isRemaining == true || isArrow == true || isJaguar == true; 			
	 	},
	 	
	 	esComiteHaya: function(get){
	 		var me = this;
	 		return me.get('expediente.esComiteHaya');
	 	},

	 	readOnlyGestBoarding: function(get){
	 		var me = this;
			var carteraCodigo = get('expediente.entidadPropietariaCodigo');
			var isSuper = $AU.userIsRol(CONST.PERFILES['HAYASUPER']);
	 		var isBoarding = $AU.userIsRol(CONST.PERFILES['GESTBOARDING']);
	 		return !isSuper && !isBoarding;//CARTERAS BANCO
	 	},
	 	
	 	habilitarBotonGenerarFicha: function(get){
			 var me = this;
			 var codExpediente = get('expediente.codigoEstado');
			 	if (CONST.ESTADOS_EXPEDIENTE['EN_TRAMITACION'] == codExpediente
			 		|| CONST.ESTADOS_EXPEDIENTE['PENDIENTE_SANCION'] == codExpediente
			 		|| CONST.ESTADOS_EXPEDIENTE['PEN_RES_OFER_COM'] == codExpediente
			 		|| CONST.ESTADOS_EXPEDIENTE['PTE_DE_SANCION_COMITE'] == codExpediente
			 		|| CONST.ESTADOS_EXPEDIENTE['PTE_SANCION_COMITE'] == codExpediente
			 		|| CONST.ESTADOS_EXPEDIENTE['CONTRAOFERTADO'] == codExpediente
			 		|| CONST.ESTADOS_EXPEDIENTE['RPTA_OFERTANTE'] == codExpediente
			 		|| CONST.ESTADOS_EXPEDIENTE['PTE_RESOLUCION_COMITE'] == codExpediente
			 		|| CONST.ESTADOS_EXPEDIENTE['CONT_CES'] == codExpediente) {
			 		
			 		return true;
			 	}else{
			 		return false;
			 	}
				
	 	},
		esBbva: function(get) {
			var carteraCodigo = get('expediente.entidadPropietariaCodigo');
	     	
	     	if(CONST.CARTERA['BBVA'] == carteraCodigo){
	     		return true;
	     	}else{
	     		return false;
	     	}

		},esCarteraSarebBbvaBankiaCajamarLiberbank: function (get){
			var carteraCodigo = get('expediente.entidadPropietariaCodigo');			
			
			if (CONST.CARTERA['BBVA'] == carteraCodigo || CONST.CARTERA['SAREB'] == carteraCodigo || CONST.CARTERA['BANKIA'] == carteraCodigo
				|| CONST.CARTERA['CAJAMAR'] == carteraCodigo || CONST.CARTERA['LIBERBANK'] == carteraCodigo) {
				return false;
			}else{
				return true;
			}
		},
		
		habilitarBotonValidar: function(get) {
			var estadoActual = get('expediente.codigoEstado');
			
			if(Ext.isEmpty(estadoActual)){
				var expediente = this.getData().expediente;
				if(!Ext.isEmpty(expediente.modified)){
					estadoActual =expediente.modified.codigoEstado;
				}
			}
			var estadosAntesAprobado = [CONST.ESTADOS_EXPEDIENTE['EN_TRAMITACION'],CONST.ESTADOS_EXPEDIENTE['PTE_FIRMA'],CONST.ESTADOS_EXPEDIENTE['CONTRAOFERTADO'],
				CONST.ESTADOS_EXPEDIENTE['PTE_RESOLUCION_CES'],CONST.ESTADOS_EXPEDIENTE['RPTA_OFERTANTE'],CONST.ESTADOS_EXPEDIENTE['PEN_RES_OFER_COM'],CONST.ESTADOS_EXPEDIENTE['PTE_RESOLUCION_CES']];
			
    		if(estadosAntesAprobado.includes(estadoActual)) {
    			return true;   			
    		} else {
    			return false;   			
    		}
    	},
    	
    	habilitarBotonEnviar: function(get) {
    		var estadoActual = get('expediente.codigoEstado');
			
			if(Ext.isEmpty(estadoActual)){
				var expediente = this.getData().expediente;
				if(!Ext.isEmpty(expediente.modified)){
					estadoActual =expediente.modified.codigoEstado;
				}
			}
			var estadosAntesAprobado = [CONST.ESTADOS_EXPEDIENTE['EN_TRAMITACION'],CONST.ESTADOS_EXPEDIENTE['PTE_FIRMA'],CONST.ESTADOS_EXPEDIENTE['CONTRAOFERTADO'],
				CONST.ESTADOS_EXPEDIENTE['PTE_RESOLUCION_CES'],CONST.ESTADOS_EXPEDIENTE['RPTA_OFERTANTE'],CONST.ESTADOS_EXPEDIENTE['PEN_RES_OFER_COM'],CONST.ESTADOS_EXPEDIENTE['PTE_RESOLUCION_CES']];
			var estadosDespuesReservado = [CONST.ESTADOS_EXPEDIENTE['RESERVADO'],CONST.ESTADOS_EXPEDIENTE['PTE_PBC'],CONST.ESTADOS_EXPEDIENTE['PTE_CIERRE'], CONST.ESTADOS_EXPEDIENTE['PTE_POSICIONAMIENTO']];

			if(estadosAntesAprobado.includes(estadoActual) || estadosDespuesReservado.includes(estadoActual)) {
    			return true;   			
    		} else {
    			return false;   			
    		}
    	},
    	
    	puedeAnyadirRegistrosPosicionamiento: function(get){
    		var estadoExpediente = get('expediente.codigoEstado');
    		var estadosNoAnyadir = [CONST.ESTADOS_EXPEDIENTE['VENDIDO'],CONST.ESTADOS_EXPEDIENTE['FIRMADO']];
    		var bloqueado = get('esExpedienteBloqueado');
    		var puedeEditar = false;
    		
    		if(!estadosNoAnyadir.includes(estadoExpediente) && !bloqueado) {
    			puedeEditar = true;
    		}
    		
    		return puedeEditar;
    	},
    	esCarteraGaleonOZeusOBk: function(get) {
			 var carteraCodigo = get('expediente.entidadPropietariaCodigo');
			 return CONST.CARTERA['GALEON'] == carteraCodigo || CONST.CARTERA['ZEUS'] == carteraCodigo || CONST.CARTERA['BANKIA'] == carteraCodigo;
		},
		readOnlyDatosCfv: function(get) {
	     	var carteraCodigo = get('expediente.codigoEstado');
	     	var ofertaEspecial = get('datosbasicosoferta.ofertaEspecial');
	     	if(CONST.ESTADOS_EXPEDIENTE['APROBADO'] == carteraCodigo || CONST.ESTADOS_EXPEDIENTE['AP_CES_PTE_MAN'] == carteraCodigo
	     			|| ofertaEspecial){
	     		return true;
	     	}
	     	return false;
	     },
	     esBankiaAlquiler: function(get){
			 var me = this;
			 var isAlquiler = get('expediente.tipoExpedienteCodigo')  == CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"];
			 var isBK = get('expediente.entidadPropietariaCodigo') == CONST.CARTERA['BANKIA'];
			
			 return isAlquiler && isBK;
		 },
		 esAlquilerNoBk: function(get){
			 var me = this;
			 var isAlquiler = get('expediente.tipoExpedienteCodigo')  == CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"];
			 var isBK = get('expediente.entidadPropietariaCodigo') == CONST.CARTERA['BANKIA'];
			
			 return isAlquiler && !isBK;
		 },
	     esBankiaAlquilerOAlquilerNoComercial: function(get){
	    	 var isAlquiler = get('expediente.tipoExpedienteCodigo')  == CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"];
	    	 var isAlquilerNoComercial = get('expediente.tipoExpedienteCodigo')  == CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER_NO_COMERCIAL"];
			 var isBK = get('expediente.entidadPropietariaCodigo') == CONST.CARTERA['BANKIA'];
			 
			 return (isAlquiler || isAlquilerNoComercial) && isBK;
		 },
	     esAlquilerNoComercial: function(get){
			 var me = this;

			 return get('expediente.tipoExpedienteCodigo')  == CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER_NO_COMERCIAL"];;
		 },
		 esBankiaVenta: function(get){
	    	 var isVenta = get('expediente.tipoExpedienteCodigo')  == CONST.TIPOS_EXPEDIENTE_COMERCIAL["VENTA"];
			 var isBK = get('expediente.entidadPropietariaCodigo') == CONST.CARTERA['BANKIA'];
			 
			 return isVenta && isBK;
		 },
        esOfertaVentaOrCarteraCaixa: function(get){
          var me= this;
          var tipoOferta= get('expediente.tipoExpedienteDescripcion');
          var carteraCodigo = get('expediente.entidadPropietariaCodigo');

          return tipoOferta == CONST.TIPO_COMERCIALIZACION_ACTIVO['VENTA'] || carteraCodigo == CONST.CARTERA['BANKIA'];
        }

	 },
	

    stores: {
    	

    	storeTextosOferta: {    
    		 pageSize: $AC.getDefaultPageSize(),
    		 model: 'HreRem.model.TextosOferta',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getListTextosOfertaById',
		        extraParams: {id: '{expediente.id}'}
	    	 }
    	},
    	
    	storeEntregasACuenta: {    
    		 pageSize: $AC.getDefaultPageSize(),
    		 model: 'HreRem.model.EntregaReserva',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getListEntregasReserva',
		        extraParams: {id: '{expediente.id}'}
	    	 }
    	},
    	
    	comboEstadosVisitaOferta: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosVisitaOferta'}
			}   
    		
    	},
    	comboTipoAlquiler: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposAlquilerActivo'}
			}   
    		
    	},
    	comboTiposInquilino: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposInquilino'}
			}   
    		
    	},
    	comboEstadoScoring: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadoScoring'}
			}   
    		
    	},
    	
    	storeTiposArras: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposArras'}
			}   
    		
    	},
    	
    	comboEstadosFinanciacion: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosFinanciacion'}
			}   
    	},
    	comboMotivoDesbloqueo: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivosDesbloqueo'}
			}   
    	},
    	
    	comboTiposFinanciacion: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposFinanciacion'}
			}   
    	},
    	
    	comboEntidadesFinancieras: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'entidadesFinancieras'}
			}   
    	},
    	
    	comboEntidadFinanciera: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'entidadFinanciera'}
			}   
    	},
    	comboEntidadFinancieraFiltro: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'expedientecomercial/getEntidadFinancieraFiltro',
				extraParams: {idExpediente: '{expediente.id}'}
			},
			session: true,
			autoLoad: true,
			remoteFilter: false,
			remoteSort: false   
    	},
    	
    	comboEntidadesAvalistas: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'entidadesAvalistas'}
			}   
    	},
    	
    	comboTipoCalculo: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionarioByTipoOferta',
				extraParams: {
					diccionario: 'tiposCalculo',
					codTipoOferta : '{expediente.tipoExpedienteCodigo}'
				}
			}   
    	},

    	comboTiposPorCuenta: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionarioPorCuenta',
				extraParams: {
					tipoCodigo: '{expediente.tipoExpedienteCodigo}'
				}
			}
    	},

    	comboTiposImpuesto: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposImpuestos'}
			}   
    	},
    	
    	comboSituacionTitulo: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosTitulo'}
			}   
    	},
    	
    	comboSituacionPosesoria: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'situacionesPosesoria'}
			}   
    	},
    	
    	storeObservaciones: {
			
    		pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.ObservacionesExpediente',
	    	proxy: {
	    		type: 'uxproxy',
	    		remoteUrl: 'expedientecomercial/getObservaciones',
	    		extraParams: {idExpediente: '{expediente.id}'}
	    	},
	    	remoteSort: true,
	    	remoteFilter: true
    	},

    	storeActivosExpediente: {
    		pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.ActivosExpediente',
	    	proxy: {
	    		type: 'uxproxy', 
	    		remoteUrl: 'expedientecomercial/getActivosExpediente',
	    		extraParams: {idExpediente: '{expediente.id}'}
	    	}
    	},

    	storeDocumentosExpediente: {
			 pageSize: $AC.getDefaultPageSize(),
			 model: 'HreRem.model.AdjuntoExpedienteComercial',
      	     proxy: {
      	        type: 'uxproxy',
      	        remoteUrl: 'expedientecomercial/getListAdjuntos',
      	        extraParams: {idExpediente: '{expediente.id}'}
          	 },
          	 groupField: 'descripcionTipo'
		},
		// @TO-DO Store Activos Ofetas Agrupados
		/*storeActivosAgrupadosLbk:{
			model:'HreRem.model.ActivosOfertaAgrupadaLbk',
			proxy:{
				type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getActivosOfertaAgrupados',
		        extraParams: {idExpediente: '{expediente.id}'}
			}
		},*/
		
		tareasTramiteExpediente: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.TareaList',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getTramitesTareas',
		        extraParams: {idExpediente: '{expediente.id}'},
		        rootProperty: 'tramite.tareas'
	    	}/*,
	    	remoteSort: true,
	    	remoteFilter: true
			*/
		},
		
		storeCompradoresExpediente: {
			pageSize: 10,
	    	model: 'HreRem.model.CompradorExpediente',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getCompradoresExpediente',
		        extraParams: {idExpediente: '{expediente.id}'}
	    	},
	    	listeners: {
				load: function(store, items, success, opts){
					 store.porcentajeCompra = Ext.decode(opts._response.responseText).porcentajeCompra;
				}
			}
		},
		
		comboTipoPersona : {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoPersona'}
			}
    	},
    	
	    comboTipoDocumento: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposDocumentos'}
			}
		
	    }, 
    	
	    comboEstadoCivil: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosCiviles'}
			}   	
	    },
	    
	    comboClienteUrsus: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'expedientecomercial/buscarClientesUrsus',
				extraParams: {numeroDocumento: null, tipoDocumento: null}
			}   	
	    },
	    
	    comboDestinoActivo: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'usosActivo'}
			} 
	    },
	    
	    comboRegimenesMatrimoniales: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'regimenesMatrimoniales'}
			}
	    },

		storePosicionamientos: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Posicionamiento',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getPosicionamientosExpediente',
		        extraParams: {idExpediente: '{expediente.id}'}
	    	}
		},
		
		storeSubsanaciones: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Subsanacion',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getSubsanacionesExpediente',
		        extraParams: {idExpediente: '{expediente.id}'}
	    	}
		},
		
		storeNotarios: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Notario',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getContactosNotario',
		        extraParams: {idProveedor: '{posicionamSelected.idProveedorNotario}'}
	    	}
		},
		
//		COMPARECIENTES EN NOMBRE DEL VENDEDOR
		
//		storeComparecientes: {
//			pageSize: $AC.getDefaultPageSize(),
//	    	model: 'HreRem.model.ComparecienteVendedor',
//	    	proxy: {
//		        type: 'uxproxy',
//		        remoteUrl: 'expedientecomercial/getComparecientesExpediente',
//		        extraParams: {idExpediente: '{expediente.id}'}
//	    	}
//		},
//		
//		comboTipoCompareciente: {
//			model: 'HreRem.model.ComboBase',
//			proxy: {
//				type: 'uxproxy',
//				remoteUrl: 'generic/getDiccionario',
//				extraParams: {diccionario: 'tiposComparecientes'}
//			} 
//		},
//		
//		storeBusquedaComparecientes: {
//    		pageSize: $AC.getDefaultPageSize(),
//	    	model: 'HreRem.model.ComparecienteBusqueda',
//	    	proxy: {
//		        type: 'uxproxy',
//		        localUrl: '/busquedacomparecientes.json',
//		        remoteUrl: 'expedientecomercial/getComparecientesBusqueda'
//	    	},
//	    	autoLoad: true,
//	    	session: true,
//	    	remoteSort: true,
//	    	remoteFilter: true,
//	        listeners : {
//	            beforeload : 'paramLoading'
//	        }
//    	}
		
		storeHoronarios: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Honorario',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getHonorarios',
		        extraParams: {idExpediente: '{expediente.id}'}
	    	}
		},
		storeHstcoSeguroRentas: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.HstcoSeguroRentas',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getHstcoSeguroRentas',
		        extraParams: {idExpediente: '{expediente.id}'}
	    	}
		},
		storeBloqueosActivo: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.BloqueoActivo',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getBloqueosActivo',
		        extraParams: {idExpediente: '{expediente.id}',idActivo: '{activoExpedienteSeleccionado.idActivo}'}
	    	}
		},
		storeTanteosActivo: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.TanteoActivo',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getTanteosActivo',
		        extraParams: {idExpediente: '{expediente.id}',idActivo: '{activoExpedienteSeleccionado.idActivo}'}
	    	}
		},	
		comboTipoOferta: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposOfertas'}
			}
	    },
		comboEstadoSeguroRentas: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadoSeguroRentas'}
			}
	    },
	    comboEstadoOferta: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getEstadosOfertaWeb'
			}
	    },
	    
	    comboEstadoReserva: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosReserva'}
			}
	    },
	    
	    comboEstadoExpediente: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosExpediente'}
			}
	    },
	    
	    comboColaboradorPrescriptor: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposColaborador'}
			}
	    },
	    
	    comboCanalPrescripcion: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'canalesPrescripcion'}
			}
	    },
	    
	    comboProvincia: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'provincias'}
			}
	    },
	    
	    comboMunicipio: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboMunicipio'/*,
				extraParams: {codigoProvincia: '{comprador.provinciaCodigo}'}*/
			}
    	},
    	
    	comboMunicipioRte: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboMunicipio'/*,
				extraParams: {codigoProvincia: '{comprador.provinciaRteCodigo}'}*/
			}
    	},
	    comboComites: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getComitesByCartera',
		        extraParams: {
		        	carteraCodigo: '{expediente.entidadPropietariaCodigo}',
		        	subcarteraCodigo: '{expediente.subcarteraCodigo}'
		        }
	    	}	    	
	    },
	    
	    comboComitesPropuestos: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getComitesByCartera',
		        extraParams: {
		        	carteraCodigo: '{expediente.entidadPropietariaCodigo}',
		        	subcarteraCodigo: '{expediente.subcarteraCodigo}'
		        }
	    	}	    	
	    },

	    storeMotivoAnulacion: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
		        extraParams: {diccionario: 'motivoAnulacionExpediente'}
	    	}	    	
	    },
	    
	    storeMotivoAnulacionAlquiler: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
		        extraParams: {diccionario: 'motivoAnulacionOferta'}
	    	}	    	
	    },
	    
	    storeMotivoRechazoExp: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
		        extraParams: {diccionario: 'motivoRechazoExpediente'}
	    	}	    	
	    },
	    
	    storeEstadosDevolucion: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
		        extraParams: {diccionario: 'estadosDevolucion'}
	    	}	    	
	    },
	    
		comboResultadoTanteo: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
		        extraParams: {diccionario: 'resultadoTanteo'}
	    	}	    	
	    },

	    comboAreaBloqueo: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
		        extraParams: {diccionario: 'areaBloqueo'}
	    	},
	    	autoLoad: true
	    },

	    comboTipoBloqueo: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionarioTipoBloqueo'
	    	}
	    },

	    comboTipoBloqueoGrid: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionarioTipoBloqueo',
		        extraParams: {areaCodigo: 'mostrarTodos'}
	    	},
	    	autoLoad: true
	    },
	    
	    storeBloqueosFormalizacion: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.BloqueosFormalizacionModel',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getBloqueosFormalizacion',
		        extraParams: {idExpediente: '{expediente.id}',
		        				id: '{activoExpedienteSeleccionado.idActivo}'}
	    	}
		},
		
		comboUsuarios: {
			model: 'HreRem.model.ComboBase',
			proxy: {
			type: 'uxproxy',
			remoteUrl: 'expedientecomercial/getComboUsuarios',
			extraParams: {idTipoGestor: '{tipoGestor.selection.id}'}
			},
			autoLoad: false,
			remoteFilter: false,
			remoteSort: false
		},
		
		storeGestores: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.GestorActivo',
		   	proxy: {
		   		type: 'uxproxy',
		   	    remoteUrl: 'expedientecomercial/getGestores',
		   	    extraParams: {idExpediente: '{expediente.id}'}
		    }
		},
		
		comboTipoGestorFilteredExpediente: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'expedientecomercial/getComboTipoGestorFiltered',
				extraParams: {idExpediente: '{expediente.id}'}
			}/*,autoLoad: true*/
		},
		
		storeProcedeDevolucion: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
		        extraParams: {diccionario: 'devolucionReserva'}
	    	}	    	
	    },
		activoExpediente: {
    		pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.Gasto',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/provision.json',
		        remoteUrl: 'gastosproveedor/getListGastos',
		        extraParams: {idProvision: '{activoExpedienteSeleccionado.data.idActivo}'}
	    	}
    		
    	},
    	
    	comboTipoGradoPropiedad : {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposGradoPropiedad'}
			}
    	},
    	
    	comboPaises : {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'paises'}
			}
    	},
    	storeHistoricoScoring: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.HistoricoExpedienteScoring',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getHistoricoScoring',
		        extraParams: {idScoring: '{expediente.id}'}
	    	}
		},
		comboComitesAlquiler: {
	    	model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getComitesAlquilerByCarteraCodigo',
		        extraParams: {carteraCodigo: '{expediente.entidadPropietariaCodigo}'}
	    	}	    	
	    },
	    storeHistoricoCondiciones: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.HistoricoCondiciones',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getHistoricoCondiciones',
		        extraParams: {idExpediente: '{expediente.id}'}
	    	}
		},
		
		storeProblemasVenta: {
			model: 'HreRem.model.DatosClienteUrsus',
			autoLoad: true,
			autoSync: true,
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'expedientecomercial/buscarProblemasVentaClienteUrsus',
				extraParams: {numeroUrsus: '', idExpediente: '{expediente.id}'}
			}
		},
		storeOfertasAgrupadas: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.OfertasAgrupadasModel',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'ofertas/getListOfertasAgrupadas',
				extraParams: {numOfertaPrincipal:'{datosbasicosoferta.numOferta}'}
			}
		},
		storeActivosOfertasAgrupadas:{
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.OfertasAgrupadasModel',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'ofertas/getListActivosOfertasAgrupadas',
				extraParams: {numOfertaPrincipal:'{datosbasicosoferta.numOferta}'}
			}
		},
		storeComboGestorPrescriptor:{
			model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getGestorPrescriptor',
		        extraParams: {idExpediente: '{expediente.id}'}
	    	}	  
		},
		
		comboClaseOferta: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {
					diccionario: 'claseOferta'
				}
			}

		},

		comboSiNoExclusionBulk: { 
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {
					diccionario: 'DDSiNo'
				}
			}
		},
		storeOrigenLead: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.OrigenLead',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getOrigenLead',
		        extraParams: {idExpediente: '{expediente.id}'}
	    	}
		},


		storeAuditoriaDesbloqueo: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.AuditoriaDesbloqueo',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getAuditoriaDesbloqueo',
		        extraParams: {idExpediente: '{expediente.id}'}
	    	}
		},

		storeActivosAlquilados: {
			pageSize: $AC.getDefaultPageSize(),
	    	model: 'HreRem.model.ActivoAlquiladosGrid',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getActivosAlquilados',
		        extraParams: {idExpediente: '{expediente.id}'}
	    	},
			autoLoad: true
		},

		comboMotivoAmpliacionArras: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivoAmpliacionArras'}
			}
	    },
	    
		comboTipoResponsable: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoResponsable'}
			}
	    },
	    comboEstadoExpedienteBc: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosExpedienteBc'}
			}
	    },

        storeFechaArras: {
            pageSize: $AC.getDefaultPageSize(),
            model: 'HreRem.model.FechaArrasModel',
            proxy: {
                type: 'uxproxy',
                remoteUrl: 'expedientecomercial/getFechaArras',
                extraParams: {idExpediente: '{expediente.id}'}
            }
        },
	    comboEmpleadoCaixa: {
	    	data : [
	    		{"codigo":"true", "descripcion":"Si"},
	    		{"codigo":"false", "descripcion":"No"}
	    		]  
	    },
	    comboMotivoRescisionArras: {
	    	model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivoRescisionArras'}
			}
	    },
		comboRiesgoOperacion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoRiesgoOperacion'}
			}
		},
		storeClasificacion:{
			model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'clasificacionAlquiler'}
	    	}	  
		},
		storeClaseContrato:{
			model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'claseContratoAlquiler'}
	    	}
		},
		
		comboDDSNS: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {
					diccionario: 'siNoNosabe'
				}
			}
		},
		
		comboTipoFinanciacionTP: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {
					diccionario: 'tipoFinanciacion'
				}
			}
		},
		
		testigosOferta:{
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.Testigos',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'expedientecomercial/getTestigos',
				extraParams: {id: '{datosbasicosoferta.idOferta}'}
			}
		},
		
		comboDDFuenteTestigos: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'fuenteTestigos'}
			}
    	},

		comboDDTipoActivo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposActivo'}
			}
    	},
		
		storeMotivoRechazoAntiguoDeudor:{
			model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivoRechazoAntiguoDeudor'}
	    	}	  
		},
		
		storeGastosRepercutidos:{
			model: 'HreRem.model.GastosRepercutidosModel',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getGastosRepercutidosList',
				extraParams: {idExpediente: '{expediente.id}'}
	    	}	  
		},
		storeActualizacionRenta:{
			model: 'HreRem.model.ActualizacionRentaModel',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getActualizacionRenta',
				extraParams: {idExpediente: '{expediente.id}'}
	    	},
	    	autoLoad: true
		},
		storeSancionesBk:{
			model: 'HreRem.model.SancionesModel',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'expedientecomercial/getSancionesBk',
				extraParams: {idExpediente: '{expediente.id}'}
	    	}	  
		},
		storeRegimenFianzaCCAA:{
			model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'regimenFianzaCCAA'}
	    	}	  
		},
		storeMetodoActualizacionRenta:{
			model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'metodoActualizacionRenta'}
	    	},
	    	autoLoad: true	  
		},
		comboResolucionComite:{
			model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'resolucionComite'}
	    	},
	    	autoLoad: true	  
		},
		comboGrupoImpuesto:{
			model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoGrupoImpuesto'}
	    	},
	    	autoLoad: true	  
		},
		comboCanalDistribucionBc: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposComercializarActivo'}
			}
		},
		comboResultadoHaya: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoResultadoScoring'}
			}
    	},
    	comboResultadoPropiedad: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoResultadoCampo'}
			}
    	},
    	comboResultadoRatingScoring: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'expedientecomercial/getResultadoRatingScoring'
			},
	    	autoLoad: true
    	},
    	comboEntidadBancariaAvalista: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'entidadesAvalistas'}
			}
    	},
		storeTipoOfertaAlquiler:{
			model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoOfertaAlquiler'}
	    	}	  
		},
    	comboEstadoComunicacionC4C: {
  	    	model: 'HreRem.model.ComboBase',
  			proxy: {
  				type: 'uxproxy',
  				remoteUrl: 'generic/getDiccionario',
  				extraParams: {diccionario: 'estadoComunicacionC4C'}
  			}
  	    },
  	  storeTipoGastoRepercutido:{
			model: 'HreRem.model.ComboBase',
	    	proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoGastoRepercutido'}
	    	},
	    	autoLoad: true
		},
	
		storeMotivoAnulacionCaixa: {
            model: 'HreRem.model.ComboBase',
            proxy: {
                type: 'uxproxy',
                remoteUrl: 'activo/getMotivoAnulacionExpedienteCaixa'
            },
	    	autoLoad: true
        },
        comboTipologiaVentaBcOfr: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {
					diccionario: 'tipologiaVentaBc'
				},
			autoLoad: true
			}
		},

    	comboTipoImpuesto: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getTiposImpuestoFiltered',
				extraParams: {esBankia: '{expediente.esBankia}'}
			}   
    	},
    	
    	comboAseguradoraProveedor: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboEspecial',
				extraParams: {
					diccionario: 'DDSegurosVigentes'
				}
			}
    	}
    }
});
