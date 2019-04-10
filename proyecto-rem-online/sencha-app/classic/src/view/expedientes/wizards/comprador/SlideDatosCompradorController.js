Ext.define('HreRem.view.expedientes.wizards.comprador.SlideDatosCompradorController', {
	extend: 'Ext.app.ViewController',
	alias: 'controller.slidedatoscomprador',

	onActivate: function() {
		var me = this,
			wizard = me.getView().up('wizardBase'),
			model = Ext.create('HreRem.model.FichaComprador'),
			idComprador = wizard.idComprador,
			idExpediente = wizard.expediente.get('id'),
			form = me.getView().getForm();

		wizard.mask(HreRem.i18n('msg.mask.loading'));

		model.setId(idComprador);
		model.load({
			params: {
				idExpedienteComercial: idExpediente
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

	comprobarObligatoriedadCamposNexos: function() {
		var me = this,
			form = me.getView(),
			wizard = form.up('wizardBase'),
			venta = null,
			campoEstadoCivil = form.lookupReference('estadoCivil'),
			campoRegEconomico = form.lookupReference('regimenMatrimonial'),
			campoNumConyuge = form.lookupReference('numRegConyuge'),
			campoTipoConyuge = form.lookupReference('tipoDocConyuge'),
			campoNombreRte = form.lookupReference('nombreRazonSocialRte'),
			campoTipoRte = form.lookupReference('tipoDocumentoRte'),
			campoNumRte = form.lookupReference('numeroDocumentoRte'),
			campoPaisRte = form.lookupReference('paisRte'),
			campoApellidosRte = form.lookupReference('apellidosRte'),
			campoApellidos = form.lookupReference('apellidos');

		if (wizard.expediente.get('tipoExpedienteCodigo') == null) {
			if (wizard.expediente.get('esOfertaVentaFicha')) {
				venta = true;
			} else {
				venta = false;
			}
		}

		me.comprobarObligatoriedadRte();

		if (wizard.expediente.get('tipoExpedienteCodigo') === CONST.TIPOS_EXPEDIENTE_COMERCIAL['ALQUILER'] || !venta) {
			if (form.lookupReference('tipoPersona').getValue() === CONST.TIPO_PERSONA['FISICA']) {
				if (!Ext.isEmpty(campoApellidos)) {
					campoApellidos.setDisabled(false);
				}
				if (!Ext.isEmpty(campoEstadoCivil)) {
					campoEstadoCivil.allowBlank = false;
					if (campoEstadoCivil.getValue() === CONST.ESTADO_CIVIL['CASADO']) {
						if (!Ext.isEmpty(campoRegEconomico)) {
							campoRegEconomico.allowBlank = false;
						}
						if (wizard.expediente.get('esCarteraLiberbank') || me.getViewModel().get('comprador.entidadPropietariaCodigo') === CONST.CARTERA['LIBERBANK']) {
							if (!Ext.isEmpty(campoNumConyuge)) {
								campoNumConyuge.allowBlank = false;
							}
							if (!Ext.isEmpty(campoRegEconomico) && !Ext.isEmpty(campoNumConyuge)) {
								if (campoRegEconomico.getValue() === CONST.REGIMENES_MATRIMONIALES['GANANCIALES'] || campoRegEconomico.getValue() === CONST.REGIMENES_MATRIMONIALES['PARTICIPACION']) {
									campoNumConyuge.allowBlank = false;
								} else if (campoRegEconomico.getValue() === '02') {
									campoNumConyuge.allowBlank = true;
								}
							}

						} else {
							if (!Ext.isEmpty(campoNumConyuge)) {
								campoNumConyuge.allowBlank = true;
							}
						}

					} else {
						campoRegEconomico.setValue('');
						campoRegEconomico.allowBlank = true;

						campoTipoConyuge.setValue('');
						campoNumConyuge.setValue('');
						campoNumConyuge.allowBlank = true;
						campoTipoConyuge.allowBlank = true;

					}
				}

			} else {
				if (!Ext.isEmpty(campoEstadoCivil)) {
					campoEstadoCivil.allowBlank = true;
				}
				if (!Ext.isEmpty(campoRegEconomico)) {
					campoRegEconomico.allowBlank = true;
				}
				if (!Ext.isEmpty(campoApellidos)) {
					campoApellidos.setDisabled(true);
				}
			}

			if (!Ext.isEmpty(campoEstadoCivil)) {
				campoEstadoCivil.validate();
			}
			if (!Ext.isEmpty(campoRegEconomico)) {
				campoRegEconomico.validate();
			}
			if (!Ext.isEmpty(campoNumConyuge)) {
				campoNumConyuge.validate();
			}

		} else {
			if (me.lookupReference('tipoPersona').getValue() === CONST.TIPO_PERSONA['FISICA']) {

				if (!Ext.isEmpty(campoNombreRte)) {
					campoNombreRte.allowBlank = true;
				}
				if (!Ext.isEmpty(campoApellidosRte)) {
					campoApellidosRte.allowBlank = true;
				}
				if (!Ext.isEmpty(campoTipoRte)) {
					campoTipoRte.allowBlank = true;
				}
				if (!Ext.isEmpty(campoNumRte)) {
					campoNumRte.allowBlank = true;
				}
				if (!Ext.isEmpty(campoPaisRte)) {
					campoPaisRte.allowBlank = true;
				}

				if (!Ext.isEmpty(campoApellidos)) {
					campoApellidos.setDisabled(false);
					campoApellidos.allowBank = false;
				}
				if (!Ext.isEmpty(campoEstadoCivil)) {
					campoEstadoCivil.allowBlank = false;
					if (campoEstadoCivil.getValue() === CONST.ESTADO_CIVIL['CASADO']) {
						if (!Ext.isEmpty(campoRegEconomico)) {
							campoRegEconomico.allowBlank = false;
							campoRegEconomico.setDisabled(false);
							if (campoRegEconomico.getValue() == CONST.REGIMENES_MATRIMONIALES['GANANCIALES']) {
								campoTipoConyuge.allowBlank = false;
								campoNumConyuge.allowBlank = false;
							} else {
								campoTipoConyuge.allowBlank = true;
								campoTipoConyuge.setValue('');
								campoNumConyuge.allowBlank = true;
								campoNumConyuge.setValue('');
							}
						}

					} else {
						campoRegEconomico.setValue('');
						campoRegEconomico.allowBlank = true;
						campoTipoConyuge.setValue('');
						campoNumConyuge.setValue('');
						campoNumConyuge.allowBlank = true;
						campoTipoConyuge.allowBlank = true;

					}
				}

			} else {
				//  Si el tipo de persona es 'Jurídica'
				if (!Ext.isEmpty(campoEstadoCivil)) {
					campoEstadoCivil.allowBlank = true;
				}
				if (!Ext.isEmpty(campoRegEconomico)) {
					campoRegEconomico.allowBlank = true;
				}
				if (!Ext.isEmpty(campoApellidos)) {
					campoApellidos.setDisabled(true);
				}

				if (!Ext.isEmpty(campoNombreRte)) {
					campoNombreRte.allowBlank = false;
				}
				if (!Ext.isEmpty(campoApellidosRte)) {
					campoApellidosRte.allowBlank = false;
				}
				if (!Ext.isEmpty(campoTipoRte)) {
					campoTipoRte.allowBlank = false;
				}
				if (!Ext.isEmpty(campoNumRte)) {
					campoNumRte.allowBlank = false;
				}
				if (!Ext.isEmpty(campoPaisRte)) {
					campoPaisRte.allowBlank = false;
				}
			}
		}
	},

	onNumeroDocumentoChange: function(field) {
		var me = this,
			form = me.getView(),
			fieldClientesUrsus = form.lookupReference('seleccionClienteUrsus'),
			btnDatosClienteUrsus = form.lookupReference('btnVerDatosClienteUrsus');

		fieldClientesUrsus.reset();
		btnDatosClienteUrsus.setDisabled(true);
		fieldClientesUrsus.recargarField = true;
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

	comprobarObligatoriedadRte: function() {
		var me = this,
			form = me.getView(),
			wizard = form.up('wizardBase'),
			venta = null;

		if (wizard.expediente.get('tipoExpedienteCodigo') == null) {
			if (wizard.expediente.get('esOfertaVentaFicha')) {
				venta = true;
			} else {
				venta = false;
			}
		}

		var campoProvinciaRte = form.lookupReference('provinciaComboRte'),
			campoMunicipioRte = form.lookupReference('municipioComboRte'),
			campoProvincia = form.lookupReference('provinciaCombo'),
			campoMunicipio = form.lookupReference('municipioCombo');

		if (wizard.expediente.get('tipoExpedienteCodigo') === CONST.TIPOS_EXPEDIENTE_COMERCIAL['VENTA'] || venta) {
			if (form.lookupReference('tipoPersona').getValue() === '2') {
				if (form.lookupReference('pais').getValue() == '28') {
					if (!Ext.isEmpty(campoProvincia)) {
						campoProvincia.allowBlank = false;
					}
					if (!Ext.isEmpty(campoMunicipio)) {
						campoMunicipio.allowBlank = false;
					}

				} else {
					if (!Ext.isEmpty(campoProvincia)) {
						campoProvincia.allowBlank = true;
					}
					if (!Ext.isEmpty(campoMunicipio)) {
						campoMunicipio.allowBlank = true;
					}
				}
				if (form.lookupReference('paisRte').getValue() == '28') {
					if (!Ext.isEmpty(campoProvinciaRte)) {
						campoProvinciaRte.allowBlank = false;
					}
					if (!Ext.isEmpty(campoMunicipioRte)) {
						campoMunicipioRte.allowBlank = false;
					}

				} else {
					if (!Ext.isEmpty(campoProvinciaRte)) {
						campoProvinciaRte.allowBlank = true;
					}
					if (!Ext.isEmpty(campoMunicipioRte)) {
						campoMunicipioRte.allowBlank = true;
					}
				}

			} else if (form.lookupReference('tipoPersona').getValue() === '1') {
				if (form.lookupReference('pais').getValue() === '28') {
					if (!Ext.isEmpty(campoProvincia)) {
						campoProvincia.allowBlank = false;
					}
					if (!Ext.isEmpty(campoMunicipio)) {
						campoMunicipio.allowBlank = false;
					}

				} else {
					if (!Ext.isEmpty(campoProvincia)) {
						campoProvincia.allowBlank = true;
					}
					if (!Ext.isEmpty(campoMunicipio)) {
						campoMunicipio.allowBlank = true;
					}
				}
				if (!Ext.isEmpty(campoProvinciaRte)) {
					campoProvinciaRte.allowBlank = true;
				}
				if (!Ext.isEmpty(campoMunicipioRte)) {
					campoMunicipioRte.allowBlank = true;
				}
			}
		}
	},

	establecerNumClienteURSUS: function(field, e) {
		var me = this,
			form = me.getView(),
			numeroUrsus = form.lookupReference('seleccionClienteUrsus').getValue(),
			fieldNumeroClienteUrsus = form.lookupReference('numeroClienteUrsusRef'),
			fieldNumeroClienteUrsusBh = form.lookupReference('numeroClienteUrsusBhRef'),
			btnDatosClienteUrsus = form.lookupReference('btnVerDatosClienteUrsus');

		btnDatosClienteUrsus.setDisabled(false);

		if (!Ext.isEmpty(fieldNumeroClienteUrsus)) {
			fieldNumeroClienteUrsusBh.setValue(numeroUrsus);
		}

		if (!Ext.isEmpty(fieldNumeroClienteUrsus)) {
			fieldNumeroClienteUrsus.setValue(numeroUrsus);
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
			numeroUrsus = form.lookupReference('seleccionClienteUrsus').getValue(),
			wizard = form.up('wizardBase'),
			idExpediente = wizard.expediente.get('id');

		wizard.mask(HreRem.i18n('msg.mask.loading'));

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
				} else {
					Utils.defaultRequestFailure(response, opts);
				}
			},
			failure: function(response) {
				wizard.unmask();
				Utils.defaultRequestFailure(response, opts);
			}
		});
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
				clienteUrsus: datosClienteUrsus
			});

		wizard.setX(Ext.Element.getViewportWidth() / 30);
		wizard.add(datosClienteUrsusWindow);
		datosClienteUrsusWindow.show();
	},

	/**
	 * Este método comprueba si el documento de identidad introducido tiene un formato acorde al tipo de documento
	 * al que se refiere.
	 * 
	 * @returns True si el documento cumple con los criterios de formato, False si no los cumple.
	 */
	comprobarDocumentoIdentidadCliente: function() {
		var me = this,
			form = me.getView(),
			documentoCliente = form.lookupReference('nuevoCompradorNumDoc').getValue(),
			tipoDocumento = form.lookupReference('tipoDocumentoNuevoComprador').getValue();

		if (tipoDocumento == CONST.TIPO_DOCUMENTO_IDENTIDAD['DNI'] || tipoDocumento == CONST.TIPO_DOCUMENTO_IDENTIDAD['NIF'] || tipoDocumento == CONST.TIPO_DOCUMENTO_IDENTIDAD['TARJETA_DE_RESIDENTE_NIE']) {
			var validChars = 'TRWAGMYFPDXBNJZSQVHLCKET',
				nifRexp = /^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i,
				nieRexp = /^[XYZ]{1}[0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i,
				str = documentoCliente.toString().toUpperCase();

			if (!nifRexp.test(str) && !nieRexp.test(str)) {
				return false;
			}

			var nie = str.replace(/^[X]/, '0').replace(/^[Y]/, '1').replace(/^[Z]/, '2'),
				letter = str.substr(-1),
				charIndex = parseInt(nie.substr(0, 8)) % 23;

			return validChars.charAt(charIndex) === letter;

		} else if (tipoDocumento == CONST.TIPO_DOCUMENTO_IDENTIDAD['CIF']) {
			var texto = documentoCliente.toUpperCase(),
				pares = 0,
				impares = 0,
				suma,
				ultima,
				unumero,
				uletra = new Array('J', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'),
				xxx,
				regular = new RegExp(/^[ABCDEFGHKLMNPQS]\d\d\d\d\d\d\d[0-9,A-J]$/g);

			if (!regular.exec(texto)) {
				return false;
			}

			ultima = texto.substr(8, 1);

			for (var cont = 1; cont < 7; cont++) {
				xxx = (2 * parseInt(texto.substr(cont++, 1))).toString() + '0';
				impares += parseInt(xxx.substr(0, 1)) + parseInt(xxx.substr(1, 1));
				pares += parseInt(texto.substr(cont, 1));
			}

			xxx = (2 * parseInt(texto.substr(cont, 1))).toString() + '0';
			impares += parseInt(xxx.substr(0, 1)) + parseInt(xxx.substr(1, 1));
			suma = (pares + impares).toString();
			unumero = parseInt(suma.substr(suma.length - 1, 1));
			unumero = (10 - unumero).toString();

			if (unumero == 10) {
				unumero = 0;
			}

			return (ultima == unumero) || (ultima == uletra[unumero]);

		} else if (tipoDocumento == CONST.TIPO_DOCUMENTO_IDENTIDAD['PASAPORTE']) {
			var expr = /^[a-z]{3}[0-9]{6}[a-z]?$/i;

			documentoCliente = documentoCliente.toLowerCase();

			return expr.test(documentoCliente);

		} else {
			return true;
		}
	},

	/**
	 * Este método comprueba los datos introducidos en el formulario de datos comprador. Si están
	 * correctos continua. Si se requieren documentos avanza el wizard hacia el slide de documentos,
	 * si no se requiere documentos guarda el comprador y finaliza el wizard.
	 */
	comprobarDatosFormularioComprador: function() {
		var me = this,
			form = me.getView(),
			wizard = form.up('wizardBase'),
			pedirDocValor = form.getForm().findField('pedirDoc').getValue(),
			modelComprador = form.getRecord();

		if (!form.isValid()) {
			me.fireEvent('errorToast', HreRem.i18n('msg.form.invalido'));
			return;
		}

		form.updateRecord();

		if (pedirDocValor === 'false') {
			wizard.comprador = modelComprador;
			wizard.nextSlide();

		} else {
			me.guardarModeloComprador();
		}
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
	}

});