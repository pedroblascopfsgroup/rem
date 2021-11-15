Ext.define('HreRem.view.expedientes.wizards.comprador.SlideDatosCompradorController', {
	extend: 'Ext.app.ViewController',
	alias: 'controller.slidedatoscomprador',

	onActivate: function() {
		var me = this,
			wizard = me.getView().up('wizardBase'),
			model = Ext.create('HreRem.model.FichaComprador'),
			idComprador = wizard.idComprador,
			idExpediente = wizard.expediente.get('id'),
			form = me.getView().getForm(),
			visualizar = wizard.visualizar;
		wizard.mask(HreRem.i18n('msg.mask.loading'));

		model.setId(idComprador);
		model.load({
			params: {
				idExpedienteComercial: idExpediente,
				visualizar: visualizar
			},
			success: function(record) {
				if (Ext.isEmpty(idComprador)) {
					model.setId(undefined);
					model.set('numDocumento', wizard.numDocumento);
					model.set('codTipoDocumento', wizard.codTipoDocumento);
				}
				if(CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"] === wizard.expediente.get('tipoExpedienteCodigo') || !Ext.isEmpty(wizard.numDocumento)) {
					form.findField('numDocumento').setReadOnly(true);
					form.findField('codTipoDocumento').setReadOnly(true);
				}
				form.loadRecord(record);
				me.getViewModel().set('comprador', record);
				wizard.unmask();
				me.bloquearCampos();
				me.getAdvertenciaProblemasUrsus(me.getViewModel().get('comprador').data.problemasUrsus)
			},
			failure: function(record, operation) {
				me.fireEvent('errorToast', HreRem.i18n('msg.operacion.ko'));
				wizard.unmask();
			}
		});

		me.getViewModel().set('esObligatorio', wizard.expediente.get('esObligatorio'));

		Ext.Array.each(me.getView().query('field[isReadOnlyEdit]'), function(field) {
			field.setReadOnly(!wizard.modoEdicion);
		});
		if(me.getView().up().expediente.data.esBankia){
			me.getViewModel().getStore("comboTipoDocumento").filterBy(function(record){
				return record.data.codigoC4C != null;
			});
		}
		
	},

	onClickCancelar: function() {
		var me = this,
			wizard = me.getView().up('wizardBase'),
			documentoIdentidadCliente = me.getView().getForm().findField('numDocumento').getValue();

		Ext.Msg.show({
			title: HreRem.i18n('wizard.msg.show.title'),
			msg: HreRem.i18n('wizard.msh.show.text'),
			buttons: Ext.MessageBox.YESNO,
			fn: function(buttonId) {
				if (buttonId == 'yes') {
					Ext.Ajax.request({
						url: $AC.getRemoteUrl('expedientecomercial/deleteTmpClienteByDocumento'),
						method: 'POST',
						params: {
							docCliente: documentoIdentidadCliente
						}
					});

					wizard.closeWindow();
				}
			}
		});
	},

	onClickContinuar: function() {
		
		var me = this;
		var	idExpediente = me.getViewModel().get("comprador").data.idExpedienteComercial;
		me.comprobarDatosFormularioComprador();	
		
	},

	permitirEdicionDatos: function() {
		var me = this;

		if ($AU.userIsRol('HAYASUPER')) {
			return true;
		}

		if ($AU.userHasFunction(['MODIFICAR_TAB_COMPRADORES_EXPEDIENTES'])) {
			if (!$AU.userHasFunction(['MODIFICAR_TAB_COMPRADORES_EXPEDIENTES_RESERVA']) && me.checkCoe()) {
				return false;
			}
			return true;
		}

		return false;
	},
	
	bloquearCampos: function() {
		var me = this,
		expediente = me.getView().up('wizardBase').expediente,
		idExpediente = expediente.get('id'),
		tieneReserva = expediente.get('tieneReserva'),
		estadoExpediente = expediente.getData().codigoEstado;
		
		var campoTipoPersona = me.lookupReference('tipoPersona'),
		numeroDocumentoConyuge = me.lookupReference('numRegConyuge'),
		campoTipoDocumentoRte = me.lookupReference('tipoDocumento'),
		campoNumeroDocumentoRte = me.lookupReference('numeroDocumento'),
		campoSeleccionClienteUrsus = me.lookupReference('seleccionClienteUrsus'),
		campoEstadoCivil = me.lookupReference('estadoCivil'),
		campoRegEconomico = me.lookupReference('regimenMatrimonial'),
		campoTipoDocumentoConyuge = me.lookupReference('tipoDocConyuge'),
		campoNumeroDocumentoConyugue = me.lookupReference('numRegConyuge'),
		campoNumeroUrsus = me.lookupReference('numeroClienteUrsusRef'),
		campoNumeroUrsusBh = me.lookupReference('numeroClienteUrsusBhRef');
		if (((tieneReserva && (estadoExpediente != CONST.ESTADOS_EXPEDIENTE['EN_TRAMITACION'] && estadoExpediente != CONST.ESTADOS_EXPEDIENTE['APROBADO']))
                       || (!tieneReserva && estadoExpediente != CONST.ESTADOS_EXPEDIENTE['EN_TRAMITACION']))
				&& me.esBankia() && (!Ext.isEmpty(campoNumeroUrsus.getValue()) || !Ext.isEmpty(campoNumeroUrsusBh.getValue())) ) {

			campoTipoPersona.disable();
			campoTipoDocumentoRte.disable();
			campoNumeroDocumentoRte.disable();
			campoSeleccionClienteUrsus.disable();
			campoEstadoCivil.disable();
			campoRegEconomico.disable();
			campoTipoDocumentoConyuge.disable();
			campoNumeroDocumentoConyugue.disable();
			campoNumeroUrsus.setReadOnly(true);
			campoNumeroUrsusBh.setReadOnly(true);			
			numeroDocumentoConyuge.disable();
		}
		if (campoEstadoCivil.getValue() != CONST.TIPOS_ESTADO_CIVIL['CASADO'] && campoRegEconomico.getValue() != CONST.TIPOS_REG_ECONOMICO_MATRIMONIAL['GANANCIALES']) {
			campoTipoDocumentoConyuge.clearValue;
			campoNumeroDocumentoConyugue.clearValue;
		}				
	},

	checkCoe: function() {
		var me = this,
			expediente = me.getView().up('wizardBase').expediente,
			estadoExpediente = expediente.getData().codigoEstado,
			solicitaReserva = expediente.getData().solicitaReserva;

		if ((solicitaReserva == 0 || solicitaReserva == null) && (estadoExpediente == CONST.ESTADOS_EXPEDIENTE['RESERVADO'] || estadoExpediente == CONST.ESTADOS_EXPEDIENTE['APROBADO'] ||
				estadoExpediente == CONST.ESTADOS_EXPEDIENTE['FIRMADO'] || estadoExpediente == CONST.ESTADOS_EXPEDIENTE['ANULADO'] || estadoExpediente == CONST.ESTADOS_EXPEDIENTE['VENDIDO'])) {
			return true;
		}

		if (solicitaReserva == 1 && (estadoExpediente == CONST.ESTADOS_EXPEDIENTE['RESERVADO'] || estadoExpediente == CONST.ESTADOS_EXPEDIENTE['FIRMADO'] ||
				estadoExpediente == CONST.ESTADOS_EXPEDIENTE['ANULADO'] || estadoExpediente == CONST.ESTADOS_EXPEDIENTE['VENDIDO'])) {
			return true;
		}

		return false;
	},
	
	esBankia: function() {
		var me = this,
			wizard = me.getView().up('wizardBase'),
			esBankia = wizard.expediente.get('esBankia');
		if (esBankia){
			return true;
		} else {
			return false;
		}
	},
	
	esBankiaAlquiler: function() {
		var me = this,
			wizard = me.getView().up('wizardBase'),
			esBankia = wizard.expediente.get('esBankia'),
			esAlquiler = wizard.expediente.get('tipoExpedienteCodigo') === CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"];
		if (esBankia && esAlquiler){
			return true;
		} else {
			return false;
		}
	},
	
	esBankiaBH: function() {
		var me = this,
			wizard = me.getView().up('wizardBase'),
			esBankiaBH = CONST.SUBCARTERA['BH'] == wizard.expediente.get('subcarteraCodigo');
		
		if (esBankiaBH){
			return true;
		} else {
			return false;
		}
	},
		
	comprobarObligatoriedadCamposNexos: function(field, newValue, oldValue) {
		var me = this,
		wizard = me.getView().up('wizardBase'),
		esBankia = wizard.expediente.get('esBankia');
		
		try{
			var me = this,
				wizard = me.getViewModel().getView().up('wizardBase'),
				form = me.getViewModel().getView();
			
			me.comprobarObligatoriedadRte();
			var comprador;

			if(!Ext.isEmpty(form.getViewModel())){
				comprador = form.getViewModel().get('comprador');
			}else{
				comprador = me.getViewModel().get('comprador');
			}

			var bloqueDatosRepresentante = me.lookupReference('datosRepresentante'),
				campoAntDeudor = me.lookupReference('antiguoDeudor'),
				campoApellidos = me.lookupReference('apellidos'),
				campoApellidosRte = me.lookupReference('apellidosRte'),
				campoCodigoPostalRte = me.lookupReference('codigoPostalRte'),
				campoDireccion = me.lookupReference('direccion'),
				campoDireccionRte = me.lookupReference('direccionRte'),
				campoEmailRte = me.lookupReference('emailRte'),
				campoEstadoCivil = me.lookupReference('estadoCivil'),
				campoMunicipio = me.lookupReference('municipioCombo'),
				campoNombre = me.lookupReference('nombreRazonSocial'),
				campoNombreRazonSocialRte = me.lookupReference('nombreRazonSocialRte'),
				campoNombreRte = me.lookupReference('nombreRazonSocialRte'),
				campoNumConyuge = me.lookupReference('numRegConyuge'),
				campoNumRte = me.lookupReference('numeroDocumentoRte'),
				campoPais = me.lookupReference('pais'),
				campoPaisRte = me.lookupReference('paisRte'),
				campoPorcionCompra = me.lookupReference('porcionCompra'),
				campoPovinciaRte = me.lookupReference('provinciaComboRte'),
				campoProvincia = me.lookupReference('provinciaCombo'),
				campoRegEconomico = me.lookupReference('regimenMatrimonial'),
				campoRelacionHre = me.lookupReference('relacionHre'),
				campoRelAntDeudor = me.lookupReference('relacionAntDeudor'),
				campoTelefono1Rte = me.lookupReference('telefono1Rte'),
				campoTelefono2Rte = me.lookupReference('telefono2Rte'),
				campoTipoConyuge = me.lookupReference('tipoDocConyuge'),
				campoTipoPersona = me.lookupReference('tipoPersona'),
				campoTipoRte = me.lookupReference('tipoDocumentoRte'),
		   	 	campoProvinciaRpr = me.lookupReference('provinciaNacimientoRepresentanteCodigo'),
		   		fechaNacRep = me.lookupReference('fechaNacimientoRepresentante'),
		   	 	campoMunicipioRpr = me.lookupReference('localidadNacimientoRepresentanteCodigo'),
		   	 	campoPaisRpr = me.lookupReference('paisNacimientoRepresentanteCodigo'),
				codigoTipoExpediente = wizard.expediente.get('tipoExpedienteCodigo'),
				seleccionClienteUrsusConyuge = me.lookupReference('seleccionClienteUrsusConyuge'),
				codigoPaisRte = me.lookupReference('paisRte');

				if(!Ext.isEmpty(campoTipoPersona.getValue())){
					if(!Ext.isEmpty(campoEstadoCivil)){
						campoEstadoCivil.allowBlank = false;
						if(!Ext.isEmpty(campoEstadoCivil.getValue())){
							if(campoEstadoCivil.getValue() == CONST.TIPOS_ESTADO_CIVIL['CASADO']) {
								// Si el Estado civil es 'Casado', entonces Reg. económico es obligatorio.
								if(!Ext.isEmpty(campoRegEconomico)){
									campoRegEconomico.enable();
									campoRegEconomico.allowBlank = false;
								}						
								if(!Ext.isEmpty(campoRegEconomico) && !Ext.isEmpty(campoNumConyuge)){
									if(!Ext.isEmpty(campoRegEconomico.getValue())){
										if(campoRegEconomico.getValue() === "01"){
											campoNumConyuge.allowBlank = false;
											campoTipoConyuge.allowBlank = false;
										}else{
											campoNumConyuge.allowBlank = true;
											campoTipoConyuge.allowBlank = true;
										}
									}
								}								
							}else {
								campoRegEconomico.allowBlank = true;
								campoNumConyuge.allowBlank = true;
								campoTipoConyuge.allowBlank = true;
								campoRegEconomico.disable();
								campoRegEconomico.setValue();
							}
						}						
					}	
					// Si el tipo de persona es FÍSICA, entonces el campos Estado civil es obligatorio y se habilitan campos dependientes.
					if(campoTipoPersona.getValue() == CONST.TIPO_PERSONA['FISICA']) {
						if(!Ext.isEmpty(campoApellidos)){
							campoApellidos.setDisabled(false);
						}
						if(!Ext.isEmpty(campoEstadoCivil)){
							campoEstadoCivil.allowBlank = false;
						}						
						if(!Ext.isEmpty(campoNombreRazonSocialRte)){
							campoNombreRazonSocialRte.allowBlank = true;
						}						
						if(!Ext.isEmpty(campoApellidosRte)){
							campoApellidosRte.allowBlank = true;
						}
						if(!Ext.isEmpty(campoTipoRte)){
							campoTipoRte.allowBlank = true;
						}
						if(!Ext.isEmpty(campoNumRte)){
							campoNumRte.allowBlank = true;
						}
						if(!Ext.isEmpty(campoPaisRte)){
							campoPaisRte.allowBlank = true;
						}
						if (!Ext.isEmpty(campoProvinciaRpr)) {
							campoProvinciaRpr.allowBlank = true;
						}
						if (!Ext.isEmpty(campoMunicipioRpr)) {
							campoMunicipioRpr.allowBlank = true;
						}
						if (!Ext.isEmpty(campoPaisRpr)) {
							campoPaisRpr.allowBlank = true;
							campoPaisRpr.setValue(null);
						}
						if (!Ext.isEmpty(codigoPaisRte)) {
							codigoPaisRte.allowBlank = true;
							codigoPaisRte.setValue(null);
						}
						if (!Ext.isEmpty(fechaNacRep)) {
							campoMunicipioRpr.allowBlank = true;
						}
											
					} else {
						//  Si el tipo de persona es 'Jurídica'
						if(!Ext.isEmpty(campoEstadoCivil)){
							campoEstadoCivil.allowBlank = true;
						}						
						if(!Ext.isEmpty(campoApellidos)){
							campoApellidos.setDisabled(true);
						}
						if(!Ext.isEmpty(campoNombreRazonSocialRte)){
							campoNombreRazonSocialRte.allowBlank = false;
						}						
						if(!Ext.isEmpty(campoApellidosRte)){
							campoApellidosRte.allowBlank = false;
						}
						if(!Ext.isEmpty(campoTipoRte)){
							campoTipoRte.allowBlank = false;
						}
						if(!Ext.isEmpty(campoNumRte)){
							campoNumRte.allowBlank = false;
						}
						if(!Ext.isEmpty(campoPaisRte)){
							campoPaisRte.allowBlank = false;
						}
						if (!Ext.isEmpty(campoProvinciaRpr) && esBankia) {
							campoProvinciaRpr.allowBlank = false;
						}
						if (!Ext.isEmpty(campoMunicipioRpr)&& esBankia) {
							campoMunicipioRpr.allowBlank = false;
						}
						if (!Ext.isEmpty(campoPaisRpr) && esBankia) {
							campoPaisRpr.allowBlank = false;
							if (campoPaisRpr.value == null) {
								campoPaisRpr.setValue("28");
							}
						}
						if (!Ext.isEmpty(codigoPaisRte)) {
							codigoPaisRte.allowBlank = false;
							if (codigoPaisRte.value == null) {
								codigoPaisRte.setValue("28");
							}
						}
						if (!Ext.isEmpty(fechaNacRep) && esBankia) {
							campoMunicipioRpr.allowBlank = false;
						}
						
					}
				}
			if(!Ext.isEmpty(field) && Ext.isEmpty(newValue)){
				field.setValue();
			}			
			if(!Ext.isEmpty(campoTipoPersona)) campoTipoPersona.validate();
			if(!Ext.isEmpty(campoPorcionCompra)) campoPorcionCompra.validate();
			if(!Ext.isEmpty(campoNombre)) campoNombre.validate();
	    	if(!Ext.isEmpty(campoEstadoCivil)) campoEstadoCivil.validate();
			if(!Ext.isEmpty(campoRegEconomico)) campoRegEconomico.validate();
			if(!Ext.isEmpty(campoNumConyuge)) campoNumConyuge.validate();
			if(!Ext.isEmpty(campoTipoConyuge)) campoTipoConyuge.validate();
			if(!Ext.isEmpty(campoNombreRte)) campoNombreRte.validate();
			if(!Ext.isEmpty(campoTipoRte)) campoTipoRte.validate();
			if(!Ext.isEmpty(campoNumRte)) campoNumRte.validate();
			if(!Ext.isEmpty(campoPaisRte)) campoPaisRte.validate();
			if(!Ext.isEmpty(campoApellidosRte)) campoApellidosRte.validate();	
			if(!Ext.isEmpty(campoApellidos)) campoApellidos.validate();
			if(!Ext.isEmpty(campoDireccion)) campoDireccion.validate();
			if(!Ext.isEmpty(campoProvincia)) campoProvincia.validate();
			if(!Ext.isEmpty(campoMunicipio)) campoMunicipio.validate();
			if(!Ext.isEmpty(campoPais)) campoPais.validate();
			if(esBankia){
				if(!Ext.isEmpty(campoPaisRpr)) campoPaisRpr.validate();
				if(!Ext.isEmpty(codigoPaisRte)) codigoPaisRte.validate();
				if(!Ext.isEmpty(campoProvinciaRpr)) campoProvinciaRpr.validate();
				if(!Ext.isEmpty(campoMunicipioRpr)) campoMunicipioRpr.validate();
				if(!Ext.isEmpty(fechaNacRep)) fechaNacRep.validate();
			}
			form.recordName = "comprador";
			form.recordClass = "HreRem.model.FichaComprador";	
			console.log(form);
			me.bloquearCampos();
		}catch(err) {
			Ext.global.console.log(err);
		}
	},

	onNumeroDocumentoChange: function(field, newValue, oldValue) {		
		var me = this,
			form = me.getView(),
			fieldClientesUrsus = form.lookupReference('seleccionClienteUrsus'),
			btnDatosClienteUrsus = form.lookupReference('btnVerDatosClienteUrsus');
		if(field.getReference() == 'numeroDocumento'){
			fieldClientesUrsus.setValue();
			fieldClientesUrsus.recargarField = true;
		}
		me.comprobarObligatoriedadCamposNexos(field, newValue, oldValue);
	},

	onChangeComboProvincia: function(combo) {
		var me = this,
			form = me.getView(),
			chainedCombo = form.lookupReference(combo.chainedReference);

		if (Ext.isEmpty(combo.getValue())) {
			chainedCombo.clearValue();
		}

		chainedCombo.getStore().load({
			params: {
				codigoProvincia: combo.getValue()
			},
			callback: function(records, operation, success) {
				if (!Ext.isEmpty(records) && records.length > 0) {
					chainedCombo.setDisabled(false);
				} else {
					chainedCombo.setDisabled(true);
				}
			}
		});

		if (form.lookupReference(chainedCombo.chainedReference) != null) {
			var chainedDos = form.lookupReference(chainedCombo.chainedReference);
			if (!chainedDos.isDisabled()) {
				chainedDos.clearValue();
				chainedDos.getStore().removeAll();
				chainedDos.setDisabled(true);
			}
		}
	},

	comprobarObligatoriedadRte: function(){
    	
    	var me = this;
    	var venta = null;
    	var wizard = me.getViewModel().getView().up('wizardBase');
    	if(wizard.expediente.get('tipoExpedienteCodigo') == null){
    		if (me.getViewModel().data.esOfertaVentaFicha == true){
    			venta = true;
    		}else{
    			venta = false;
    		}
    	}
    	campoProvinciaRte = me.lookupReference('provinciaComboRte');
		campoMunicipioRte = me.lookupReference('municipioComboRte');
		campoDireccion = me.lookupReference('direccion');
		campoProvincia = me.lookupReference('provinciaCombo');
		campoMunicipio = me.lookupReference('municipioCombo');

    	if(wizard.expediente.get('tipoExpedienteCodigo') == "01" || venta == true){
    		if(me.lookupReference('tipoPersona').getValue() === CONST.TIPO_PERSONA['JURIDICA']) {
    			if(me.lookupReference('pais').getValue() == "28"){
    				if(!Ext.isEmpty(campoProvincia)){
						campoProvincia.allowBlank = false;
					}
    				if(!Ext.isEmpty(campoMunicipio)){
    					campoMunicipio.allowBlank = false;
					}					
				}else{
    				if(!Ext.isEmpty(campoProvincia)){
    					campoProvincia.allowBlank = true;
					}
    				if(!Ext.isEmpty(campoMunicipio)){
    					campoMunicipio.allowBlank = true;
					}
				}
    			if(me.lookupReference('paisRte').getValue() == "28"){
					if(!Ext.isEmpty(campoProvinciaRte)){
						campoProvinciaRte.allowBlank = false;
					}
					if(!Ext.isEmpty(campoMunicipioRte)){
						campoMunicipioRte.allowBlank = false;
					}
					
				}else{
					if(!Ext.isEmpty(campoProvinciaRte)){
						campoProvinciaRte.allowBlank = true;
					}
					if(!Ext.isEmpty(campoMunicipioRte)){
						campoMunicipioRte.allowBlank = true;
					}
				}
    		}else if (me.lookupReference('tipoPersona').getValue() === CONST.TIPO_PERSONA['FISICA']){
    			if(me.lookupReference('pais').getValue() == "28"){
    				if(!Ext.isEmpty(campoProvincia)){
    					campoProvincia.allowBlank = false;
					}
    				if(!Ext.isEmpty(campoMunicipio)){
    					campoMunicipio.allowBlank = false;
					}
				}else{
    				if(!Ext.isEmpty(campoProvincia)){
    					campoProvincia.allowBlank = true;
					}
    				if(!Ext.isEmpty(campoMunicipio)){
    					campoMunicipio.allowBlank = true;
					}
				}
    			if(!Ext.isEmpty(campoProvinciaRte)){
					campoProvinciaRte.allowBlank = true;
				}
				if(!Ext.isEmpty(campoMunicipioRte)){
					campoMunicipioRte.allowBlank = true;
				}
    		}
    		campoProvinciaRte.validate();
    		campoMunicipioRte.validate();
    		campoDireccion.validate();
    		campoProvincia.validate();
    		campoMunicipio.validate();
    	}
    },

	establecerNumClienteURSUS: function(field, e) {		
		var me = this;

		var form = me.getView(),
			wizard = me.getView().up('wizardBase'),
			numeroUrsus = form.lookupReference('seleccionClienteUrsus').getValue(),
			fieldNumeroClienteUrsus = form.lookupReference('numeroClienteUrsusRef'),
			fieldNumeroClienteUrsusBh = form.lookupReference('numeroClienteUrsusBhRef'),
			btnDatosClienteUrsus = form.lookupReference('btnVerDatosClienteUrsus'),
			estadoCivilUrsus = form.lookupReference('estadoCivilUrsus'),
			regimenMatrimonialUrsus = form.lookupReference('regimenMatrimonialUrsus'),
			numeroClienteUrsusRefConyugeUrsus = form.lookupReference('numeroClienteUrsusRefConyugeUrsus'),
			nombreConyugeUrsus = form.lookupReference('nombreConyugeUrsus'),
			esBankiaBH = CONST.SUBCARTERA['BH'] == me.getView().up('wizardBase').expediente.get('subcarteraCodigo');
			idExpediente = wizard.expediente.get('id');
			
		wizard.mask(HreRem.i18n('msg.mask.loading'));
		
		// Se hace la llamada Ayax al WEB-SERVICE (servicioGMPAJC93_INS) de BANKIA
		Ext.Ajax.request({
			url: $AC.getRemoteUrl('expedientecomercial/buscarDatosClienteNumeroUrsus'),
			params: {
				numeroUrsus: numeroUrsus,
				idExpediente: idExpediente
			},
			method: 'GET',
			success: function(response, opts) {
				var data = {};
				wizard.unmask();
				try {
					data = Ext.decode(response.responseText);
				} catch(e) {
					data = {};
				}
				if (data.success == 'true' && !Utils.isEmptyJSON(data.data)) {
					estadoCivilUrsus.setValue(data.data.codigoEstadoCivil);
			
					if(data.data.codigoEstadoCivil ===  CONST.D_ESTADOS_CIVILES["COD_CASADO"]){
						if (data.data.numeroClienteUrsusConyuge != 0 && !Ext.isEmpty(data.data.numeroClienteUrsusConyuge)) {
							regimenMatrimonialUrsus.setValue(CONST.DD_REGIMEN_MATRIMONIAL["COD_GANANCIALES"]);
						} else if (data.data.numeroClienteUrsusConyuge === 0) {
							regimenMatrimonialUrsus.setValue(CONST.DD_REGIMEN_MATRIMONIAL["COD_SEPARACION_BIENES"]);
						}
					}
					
					if (data.data.numeroClienteUrsusConyuge != 0) {
						numeroClienteUrsusRefConyugeUrsus.setValue(data.data.numeroClienteUrsusConyuge);
					}
					
					if (!Utils.isEmptyJSON(data.data.nombreYApellidosConyuge)) {
						nombreConyugeUrsus.setValue(data.data.nombreYApellidosConyuge);
					}
					
				} else {
					Utils.defaultRequestFailure(response, opts);
				}
			},
			failure: function(response) {
				wizard.unmask();
				Utils.defaultRequestFailure(response, opts);
			}
		});

		if (esBankiaBH && !Ext.isEmpty(fieldNumeroClienteUrsusBh)){
			btnDatosClienteUrsus.setDisabled(false);
			fieldNumeroClienteUrsusBh.setValue(numeroUrsus);
		} else if (!esBankiaBH && !Ext.isEmpty(fieldNumeroClienteUrsus)){
			btnDatosClienteUrsus.setDisabled(false);
			fieldNumeroClienteUrsus.setValue(numeroUrsus);
		}
	},
	
	establecerNumClienteURSUSConyuge: function(field, e) {
		var me = this,
			form = me.getView(),
			comboUrsusConyuge = form.lookupReference('seleccionClienteUrsusConyuge'),
			numeroUrsusConyuge = comboUrsusConyuge.getValue(),
			fieldNumeroClienteUrsusConyuge = form.lookupReference('numeroClienteUrsusRefConyuge'),
			fieldNumeroClienteUrsusBhConyuge = form.lookupReference('numeroClienteUrsusBhRefConyuge'),
			esBankiaBH = CONST.SUBCARTERA['BH'] == me.getView().up('wizardBase').expediente.get('subcarteraCodigo');

		if (esBankiaBH && !Ext.isEmpty(fieldNumeroClienteUrsusBhConyuge)){
			fieldNumeroClienteUrsusBhConyuge.setValue(numeroUrsusConyuge);
		} else if (!esBankiaBH && !Ext.isEmpty(fieldNumeroClienteUrsusConyuge)){
			fieldNumeroClienteUrsusConyuge.setValue(numeroUrsusConyuge);
		} else if(esBankiaBH && Ext.isEmpty(fieldNumeroClienteUrsusBhConyuge) ){
			fieldNumeroClienteUrsusBhConyuge.reset();
		} else if (!esBankiaBH && Ext.isEmpty(fieldNumeroClienteUrsusConyuge)){
			fieldNumeroClienteUrsusConyuge.reset();
		}
	},
	
	buscarClientesUrsus: function(field) {
		var me = this,
			wizard = me.getView().up('wizardBase'),
			form = me.getView(),
			tipoDocumento = form.lookupReference('tipoDocumento').getValue(),
			numeroDocumento = form.lookupReference('numeroDocumento').getValue(),
			idExpediente = wizard.expediente.get('id');

		if (Ext.isEmpty(tipoDocumento) || Ext.isEmpty(numeroDocumento) || Ext.isEmpty(idExpediente)) {
			me.fireEvent('errorToast', HreRem.i18n('msg.operacion.ko.ursus.necesita.tipo.documento'));
			return;
		}

		var fieldClientesUrsus = form.lookupReference('seleccionClienteUrsus'),
			storeClientesUrsus = fieldClientesUrsus.getStore();

		if (Ext.isEmpty(storeClientesUrsus.getData().items) || fieldClientesUrsus.recargarField) {
			storeClientesUrsus.removeAll();
			storeClientesUrsus.getProxy().setExtraParams({
				numeroDocumento: numeroDocumento,
				tipoDocumento: tipoDocumento,
				idExpediente: idExpediente
			});
			storeClientesUrsus.load({
				callback: function(records, operation, success) {
					if (success) {
						fieldClientesUrsus.recargarField = false;
					} else {
						Utils.defaultRequestFailure(operation.getResponse());
					}
				}
			});
		}
	},

	buscarClientesUrsusConyuge: function(field) {
		var me = this,
			wizard = me.getView().up('wizardBase'),
			form = me.getView(),
			tipoDocumento = form.lookupReference('tipoDocConyuge').getValue(),
			numeroDocumento = form.lookupReference('numRegConyuge').getValue(),
			idExpediente = wizard.expediente.get('id');

		if (Ext.isEmpty(tipoDocumento) || Ext.isEmpty(numeroDocumento) || Ext.isEmpty(idExpediente)) {
			me.fireEvent('errorToast', HreRem.i18n('msg.operacion.ko.ursus.necesita.tipo.documento'));
			return;
		}

		var fieldClientesUrsus = form.lookupReference('seleccionClienteUrsusConyuge'),
			storeClientesUrsus = fieldClientesUrsus.getStore();

		if (Ext.isEmpty(storeClientesUrsus.getData().items) || fieldClientesUrsus.recargarField) {
			storeClientesUrsus.removeAll();
			storeClientesUrsus.getProxy().setExtraParams({
				numeroDocumento: numeroDocumento,
				tipoDocumento: tipoDocumento,
				idExpediente: idExpediente
			});
			storeClientesUrsus.load({
				callback: function(records, operation, success) {
					if (success) {
						fieldClientesUrsus.recargarField = false;
					} else {
						Utils.defaultRequestFailure(operation.getResponse());
					}
				}
			});
		}
	},

	onChangeComboboxTipoDocumento: function(combo, value) {
		var me = this,
			form = me.getView();

		if (value) {
			form.lookupReference('numeroDocumentoRte').allowBlank = false;
		} else {
			form.lookupReference('numeroDocumentoRte').allowBlank = true;
			form.lookupReference('numeroDocumentoRte').setValue('');
		}
	},

	onChangeTextfieldNumDocumentoRte: function(field, value) {
		var me = this,
			form = me.getView();

		if (value) {
			form.lookupReference('tipoDocumentoRte').allowBlank = false;
		}
	},

	onClickVerDetalleClienteUrsus: function() {
		var me = this,
			form = this.getView(),
			numeroUrsus = form.lookupReference('numeroClienteUrsusRef').getValue(),
			wizard = form.up('wizardBase'),
			fieldNumeroClienteUrsus = form.lookupReference('numeroClienteUrsusRef'),
			fieldNumeroClienteUrsusBh = form.lookupReference('numeroClienteUrsusBhRef'),
			btnDatosClienteUrsus = form.lookupReference('btnVerDatosClienteUrsus'),
			estadoCivilUrsus = form.lookupReference('estadoCivilUrsus'),
			regimenMatrimonialUrsus = form.lookupReference('regimenMatrimonialUrsus'),
			numeroClienteUrsusRefConyugeUrsus = form.lookupReference('numeroClienteUrsusRefConyugeUrsus'),
			nombreConyugeUrsus = form.lookupReference('nombreConyugeUrsus'),
			esBankiaBH = CONST.SUBCARTERA['BH'] == me.getView().up('wizardBase').expediente.get('subcarteraCodigo');
			idExpediente = wizard.expediente.get('id');
			
		wizard.mask(HreRem.i18n('msg.mask.loading'));
		
		if(esBankiaBH){
			numeroUrsus = fieldNumeroClienteUrsusBh.getValue();
		}

		if(!Ext.isEmpty(numeroUrsus)){
			Ext.Ajax.request({
				url: $AC.getRemoteUrl('expedientecomercial/buscarDatosClienteNumeroUrsus'),
				params: {
					numeroUrsus: numeroUrsus,
					idExpediente: idExpediente
				},
				method: 'GET',
				success: function(response, opts) {
					var data = {};
					wizard.unmask();
					try {
						data = Ext.decode(response.responseText);
					} catch (e) {
						data = {};
					}
					if (data.success == 'true' && !Utils.isEmptyJSON(data.data)) {
						me.abrirDatosClienteUrsus(data.data);
						estadoCivilUrsus.setValue(data.data.codigoEstadoCivil);
				
						if(data.data.codigoEstadoCivil ===  CONST.D_ESTADOS_CIVILES["COD_CASADO"]){
							if (data.data.numeroClienteUrsusConyuge != 0 && !Ext.isEmpty(data.data.numeroClienteUrsusConyuge)) {
								regimenMatrimonialUrsus.setValue(CONST.DD_REGIMEN_MATRIMONIAL["COD_GANANCIALES"]);
							} else if (data.data.numeroClienteUrsusConyuge === 0) {
								regimenMatrimonialUrsus.setValue(CONST.DD_REGIMEN_MATRIMONIAL["COD_SEPARACION_BIENES"]);
							}
						}
						
						if (data.data.numeroClienteUrsusConyuge != 0) {
							numeroClienteUrsusRefConyugeUrsus.setValue(data.data.numeroClienteUrsusConyuge);
						}
						
						if (!Utils.isEmptyJSON(data.data.nombreYApellidosConyuge)) {
							nombreConyugeUrsus.setValue(data.data.nombreYApellidosConyuge);
						}
						
					} else {
						Utils.defaultRequestFailure(response, opts);
					}
					
				},
				failure: function(response) {
					wizard.unmask();
					Utils.defaultRequestFailure(response, opts);
				}
			});
		}else{
			wizard.unmask();
			me.fireEvent("errorToast", "Seleccione un cliente ursus");
		}
	},

	/**
	 * Este método abre una nueva instancia de la ventana de datos del cliente URSUS
	 * rellena con el modelo de datos del cliente que recibe como parámetrto.
	 *
	 * @param {Ext.data.Model} datosClienteUrsus modelo de datos del cliente URSUS.
	 */
	abrirDatosClienteUrsus: function(datosClienteUrsus) {
		var me = this,
			wizard = me.getView().up('wizardBase'),
			datosClienteUrsusWindow = Ext.create('HreRem.view.expedientes.DatosClienteUrsus', {
				clienteUrsus: datosClienteUrsus,
				storeProblemasVenta: me.getViewModel().get('storeProblemasVenta'),
				alquiler: me.esBankiaAlquiler()
			});
		wizard.setX(Ext.Element.getViewportWidth() / 30);
		wizard.add(datosClienteUrsusWindow);
		datosClienteUrsusWindow.show();
	},

	comprobarNIF: function(fieldDoc, fieldTipoDoc){
		var me = this;
		if(fieldTipoDoc.value == "01" || fieldTipoDoc.value == "15"
			|| fieldTipoDoc.value == "03"){

			 var validChars = 'TRWAGMYFPDXBNJZSQVHLCKET';
			 var nifRexp = /^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
			 var nieRexp = /^[XYZ]{1}[0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
			 var str = fieldDoc.value.toString().toUpperCase();

			 if (!nifRexp.test(str) && !nieRexp.test(str)){			 
				 return false;
			 }

			 var nie = str
			     .replace(/^[X]/, '0')
			     .replace(/^[Y]/, '1')
			     .replace(/^[Z]/, '2');

			 var letter = str.substr(-1);
			 var charIndex = parseInt(nie.substr(0, 8)) % 23;

			 if (validChars.charAt(charIndex) === letter){
				 return true;
			 }else{
				 return false;
			 }

		}else if(fieldTipoDoc.value == "02"){
			var texto=fieldDoc.value;
	        var pares = 0; 
	        var impares = 0; 
	        var suma; 
	        var ultima; 
	        var unumero; 
	        var uletra = new Array("J", "A", "B", "C", "D", "E", "F", "G", "H", "I"); 
	        var xxx; 
	         
	        texto = texto.toUpperCase(); 

	        var regular = new RegExp(/^[ABCDEFGHJKLMNPQRSUVW]\d\d\d\d\d\d\d[0-9,A-J]$/g);
         	if (!regular.exec(texto)) {
				return false;		
			}
	        ultima = texto.substr(8,1); 
	 
	        for (var cont = 1 ; cont < 7 ; cont ++){ 
	             xxx = (2 * parseInt(texto.substr(cont++,1))).toString() + "0"; 
	             impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
	             pares += parseInt(texto.substr(cont,1)); 
	         } 
	         
	         xxx = (2 * parseInt(texto.substr(cont,1))).toString() + "0"; 
	         impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
	          
	         suma = (pares + impares).toString(); 
	         unumero = parseInt(suma.substr(suma.length - 1, 1)); 
	         unumero = (10 - unumero).toString(); 
	         if(unumero == 10){
	        	 unumero = 0; 
	         }
	          
	         if ((ultima == unumero) || (ultima == uletra[unumero])) {
	        	 return true;
	         }else{
	        	 return false;
	         }
		} else {
			return true;
		}
	},
	
	/**
	 * Este método comprueba si el documento de identidad introducido tiene un formato acorde al tipo de documento
	 * al que se refiere.
	 * 
	 * @returns True si el documento cumple con los criterios de formato, False si no los cumple.
	 */
	comprobarFormato: function() {
		var me = this,
		valueComprador = me.lookupReference('numeroDocumento'),
		valueConyuge = me.lookupReference('numRegConyuge'),
		valueRte = me.lookupReference('numeroDocumentoRte'),
		resultado = true;
		if(valueComprador != null){
			resultado = me.comprobarNIF(valueComprador, me.lookupReference('tipoDocumento'));
			if(!resultado) valueComprador.markInvalid('NIF incorrecto');			
		}
		if(resultado && valueConyuge != null){
			resultado = me.comprobarNIF(valueConyuge, me.lookupReference('tipoDocConyuge'));
			if(!resultado) valueConyuge.markInvalid('NIF incorrecto');
		}
		if(resultado && valueRte != null){
			resultado = me.comprobarNIF(valueRte, me.lookupReference('tipoDocumentoRte'));
			if(!resultado) valueRte.markInvalid('NIF incorrecto');
		}
		return resultado;
			
	},		

	/**
	 * Este método comprueba los datos introducidos en el formulario de datos comprador. Si están
	 * correctos continua. Si se requieren documentos avanza el wizard hacia el slide de documentos,
	 * si no se requiere documentos guarda el comprador y finaliza el wizard.
	 */
	comprobarDatosFormularioComprador: function() {
		var me = this,
			form = me.getView();

		me.comprobarObligatoriedadCamposNexos();

		if (!me.comprobarFormato() || !form.isValid()) {
			me.fireEvent('errorToast', HreRem.i18n('msg.form.invalido'));
			return;
		}
		form.updateRecord();
		
//		if(me.getViewModel().get("comprador").data.esCarteraBankia){
//			me.discrepanciasVeracidadDatosComprador();
//		} else {
			me.continuarSiguienteSlide();
//		}
	},
	
	continuarSiguienteSlide: function() {
	    var me = this,
			form = me.getView(),
			modelComprador = form.getRecord(),
			pedirDocValor = form.getForm().findField('pedirDoc').getValue(),
			wizard = form.up('wizardBase');
	    if(!Ext.isEmpty(modelComprador.modified.numDocumento) && modelComprador.modified.numDocumento != modelComprador.get('numDocumento')){
		    Ext.Ajax.request({
				url: $AC.getRemoteUrl('expedientecomercial/existeComprador'),
				params: {
					numDocumento: modelComprador.get('numDocumento')
				},
				method: 'GET',
				success: function(response, opts){
					var data = {};
					data = Ext.decode(response.responseText);
					if(data.success == 'true' && !Utils.isEmptyJSON(data.data)){
						if(data.data == 'true' || data.data == true){
							me.fireEvent("errorToast", "El NIF indicado ya existe para otro comprador");
						}
						else if(data.data == 'false' || data.data == false){
							if (pedirDocValor === 'false') {
								wizard.comprador = modelComprador;
								wizard.nextSlide();
							} else {
								me.guardarModeloComprador();
							}					
						}
					}else{
						me.fireEvent("errorToast", HreRem.i18n('msg.operacion.ko'));
					}
				},
				failure: function(response){
					me.fireEvent("errorToast", HreRem.i18n('msg.operacion.ko'));
				}
		    });
	    }else{
	    	if (pedirDocValor === 'false') {
				wizard.comprador = modelComprador;
				wizard.nextSlide();
			} else {
				me.guardarModeloComprador();
			}	
	    }		
    },

    discrepanciasVeracidadDatosComprador: function() {

		var me = this,
			form = me.getView(),
			wizard = form.up('wizardBase'),
			modelComprador = form.getRecord(),
			numeroClienteUrsusConyuge = me.lookupReference('numeroClienteUrsusRefConyuge').value;
			wizard.mask(HreRem.i18n('msg.mask.espere'));
		Ext.Ajax.request({
			url: $AC.getRemoteUrl('expedientecomercial/discrepanciasVeracidadDatosComprador'),
			params: {
				idExpedienteComercial: modelComprador.get('idExpedienteComercial'),
				id: modelComprador.get('id'),
				codEstadoCivil:modelComprador.get('codEstadoCivil'),
				documentoConyuge: modelComprador.get('documentoConyuge'),
				codigoRegimenMatrimonial:modelComprador.get('codigoRegimenMatrimonial'),
				codTipoDocumento:modelComprador.get('codTipoDocumento'),
				numeroClienteUrsusConyuge:numeroClienteUrsusConyuge,
				numeroClienteUrsus:modelComprador.get('numeroClienteUrsus')
			},
			success: function(response, opts) {
				wizard.unmask();
			
				me.continuarSiguienteSlide();
			},
			failure: function(response) {
				wizard.unmask();
				me.fireEvent('errorToast', HreRem.i18n('msg.operacion.ko'));
			}
		});
	},

	/**
	 * Este método guarda los datos del formulario de datos comprador y los envía para su guardado en la DB.
	 * Al finalizar este método llama al método de ocultar el wizard con el parámetro de reiniciar su contenido.
	 */
	guardarModeloComprador: function() {
		var me = this,
			form = me.getView(),
			wizard = form.up('wizardBase');

		/*form.recordName = 'comprador';
		form.recordClass = 'HreRem.model.FichaComprador';*/
		wizard.mask(HreRem.i18n('msg.mask.espere'));

		var record = form.getRecord();
		record.save({
			success: function(a, operation, c) {
				wizard.unmask();
				me.fireEvent('infoToast', HreRem.i18n('msg.operacion.ok'));
				wizard.lookupController().getView().down('expedientedetallemain').getController().refrescarExpediente(true);
				wizard.hideWizard(true);
			},
			failure: function(a, operation) {
				wizard.unmask();
				me.fireEvent('errorToast', HreRem.i18n('msg.operacion.ko'));
			}
		});
	},
	
	/**
	 * Este metodo cambia el titulo en función de si la cartera es Bankia o no. 
	 */
	onLoadCambiaTituloRemoNexos: function (get){
		var me = this,
			expediente = me.getView().up('wizardBase').expediente;
		
		if (expediente.get('esBankia'))
			me.lookupReference('cambioTitulo').setTitle(HreRem.i18n('title.datos.rem'));
		else 
			me.lookupReference('cambioTitulo').setTitle(HreRem.i18n('title.nexos'));
	},
	
	getAdvertenciaProblemasUrsus : function(problemasUrsusComprador) {
		var me = this, expediente = me.getView().up('wizardBase').expediente
		, form = me.getViewModel().getView()
		, problemasUrsus = expediente.get('problemasUrsus')
		, esBankia = expediente.get('esBankia');
		
		if (esBankia && problemasUrsus == "true" && !Ext.isEmpty(problemasUrsusComprador) && problemasUrsusComprador.toUpperCase()=="SI") {
			me.getViewModel().set('textoAdvertenciaProblemasUrsus','Problemas URSUS');
		}
	},
	
	habilitarLupaClientes: function() {
		var me = this;
		var wizard = me.getView().up('wizardBase');
		var expediente = me.getView().up('wizardBase').expediente;
		estadoExpediente = expediente.getData().codigoEstado;
		var estados = [CONST.ESTADOS_EXPEDIENTE['EN_TRAMITACION']
		, CONST.ESTADOS_EXPEDIENTE['PTE_FIRMA']
		, CONST.ESTADOS_EXPEDIENTE['CONTRAOFERTADO']
		, CONST.ESTADOS_EXPEDIENTE['PTE_RESOLUCION_CES']
		, CONST.ESTADOS_EXPEDIENTE['RPTA_OFERTANTE']
		, CONST.ESTADOS_EXPEDIENTE['PEN_RES_OFER_COM']
		, CONST.ESTADOS_EXPEDIENTE['PTE_RESOLUCION_CES']];
		var comprador = wizard.idComprador;
		
		if((comprador == undefined || comprador == null) || estados.includes(estadoExpediente)) {
			return true;
		} else {
			return false;
		}
	},
	
	habilitarClienteUrsus: function() {
		var me = this;
		var wizard = me.getView().up('wizardBase');
		var expediente = wizard.expediente;
		estadoExpediente = expediente.getData().codigoEstado;
		var estados = [CONST.ESTADOS_EXPEDIENTE['RESERVADO'],
			CONST.ESTADOS_EXPEDIENTE['PTE_PBC']
		, CONST.ESTADOS_EXPEDIENTE['PTE_CIERRE'],
		CONST.ESTADOS_EXPEDIENTE['PTE_POSICIONAMIENTO']];
		var comprador = wizard.idComprador;
		
		if((comprador == undefined || comprador == null) || me.habilitarLupaClientes() || estados.includes(estadoExpediente)) {
			return true;
		} else {
			return false;
		}
	},
	
	verCampoEstadoContraste: function(){
		if ($AU.userIsRol('HAYASUPER')) {
			return false;
		}else{
			return true;
		}
	}
});