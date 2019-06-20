Ext.define('HreRem.view.expedientes.wizards.comprador.SlideAdjuntarDocumentoController', {
	extend: 'Ext.app.ViewController',
	alias: 'controller.slideadjuntardocumento',

	requires: [
		'HreRem.view.common.adjuntos.AdjuntarDocumentoOfertacomercial'
	],
	firstExecution : true,

	onActivate: function() {
		var me = this,
			form = me.getView(),
			wizard = form.up('wizardBase');
		me.firstExecution = true;
		if(wizard.expediente){
			wizard.mask(HreRem.i18n('msg.mask.espere'));
			Ext.Ajax.request({
				url: $AC.getRemoteUrl('ofertas/esCarteraInternacional'),
				method: 'POST',
				params: {
					idActivo: null,
					idAgrupacion: null,
					idExpediente: wizard.expediente.get('id')
				},
				success: function(response, opts) {
					var data = Ext.decode(response.responseText);
					if (!Ext.isEmpty(data)) {
						form.getForm().findField('carteraInternacional').setValue(data.carteraInternacional);
					}
				},
				failure: function(record, operation) {
					me.fireEvent('errorToast', HreRem.i18n('msg.comprobacion.cartera.internacional.ko'));
				}
			});
			Ext.Ajax.request({
				url: $AC.getRemoteUrl('expedientecomercial/getListAdjuntosComprador'),
				method: 'GET',
				params: {
					docCliente: wizard.comprador.get('numDocumento'),
					idExpediente: wizard.comprador.get('idExpedienteComercial')
				},
				success: function(response, opts) {
					wizard.unmask();
					var data = Ext.decode(response.responseText);
					if (!Ext.isEmpty(data.data)) {
						form.getForm().findField('docOfertaComercial').setValue(data.data[0].nombre);
						form.lookupReference('btnBorrarDocumentoAdjunto').show();						
					}
				},
				failure: function(record, operation) {
					me.fireEvent('errorToast', HreRem.i18n('msg.operacion.ko'));
					wizard.unmask();
				}
			});

			form.getForm().findField('cesionDatos').setValue(wizard.comprador.get('cesionDatos'));
			form.getForm().findField('comunicacionTerceros').setValue(wizard.comprador.get('comunicacionTerceros'));
			form.getForm().findField('transferenciasInternacionales').setValue(wizard.comprador.get('transferenciasInternacionales'));
			form.cesionHaya = wizard.comprador.get('cesionDatos');
			form.comunicacionTerceros = wizard.comprador.get('comunicacionTerceros');
			form.tranferenciasInternacionales = wizard.comprador.get('transferenciasInternacionales');
			//form.lookupReference('btnFinalizar').enable();
		}
	},

	onClickContinuar: function() {
		var me = this;

		me.onClickCrearOferta();
	},

	onClickAtras: function() {
		var me = this,
			form = me.getView(),
			wizard =form.up('wizardBase'),
			btnGenerarDoc = form.lookupReference('btnGenerarDocumento'),
			esInternacional = form.getForm().findField('carteraInternacional').getValue(),
			cesionDatos = form.getForm().findField('cesionDatos').getValue(),
			checkTransInternacionales = form.getForm().findField('transferenciasInternacionales').getValue();

		if (cesionDatos) {
			if (esInternacional) {
				if (checkTransInternacionales) {
					btnGenerarDoc.enable();
				} else {
					btnGenerarDoc.disable();
				}

			} else {
				btnGenerarDoc.enable();
			}

		} else {
			btnGenerarDoc.disable();
			form.getForm().findField('comunicacionTerceros').enable();
			form.getForm().findField('transferenciasInternacionales').enable();
		}

		form.lookupReference('btnFinalizar').disable();
		me.firstExecution = true;
		wizard.previousSlide();
	},
	activarFinalizar: function(form){
		var me = this,
		checkTransInternacionales = form.getForm().findField('transferenciasInternacionales').getValue(),
		esInternacional = form.getForm().findField('carteraInternacional').getValue(),
		checkCesionDatos = form.getForm().findField('cesionDatos').getValue(),
		checkComunicacionTerceros = form.getForm().findField('comunicacionTerceros').getValue(),
		documentoAdjunto = form.getForm().findField('docOfertaComercial').getValue(),
		btnFinalizar = form.lookupReference('btnFinalizar');
		if(!Ext.isEmpty(me.getView().up('wizardBase').expediente)){
			idExpediente = me.getView().up('wizardBase').expediente.get('id');	
		}else{
			idExpediente = "";
		}
		
		if(Ext.isEmpty(idExpediente)){
			if(me.firstExecution && Ext.isEmpty(checkCesionDatos) && Ext.isEmpty(checkTransInternacionales) && Ext.isEmpty(checkComunicacionTerceros)){
				if(esInternacional){
						if(!Ext.isEmpty(checkCesionDatos) && !Ext.isEmpty(checkTransInternacionales) && checkTransInternacionales=="true" && !Ext.isEmpty(documentoAdjunto)){
							btnFinalizar.enable();
						}else{
							btnFinalizar.disable();
						}
				}else{
					if(!Ext.isEmpty(checkCesionDatos) && !Ext.isEmpty(checkTransInternacionales) && !Ext.isEmpty(checkComunicacionTerceros) && !Ext.isEmpty(documentoAdjunto)){
						btnFinalizar.enable();
					}else{
						btnFinalizar.disable();
					}
				}
			}else{
				btnFinalizar.disable();
			}
			if(!Ext.isEmpty(checkCesionDatos) && !Ext.isEmpty(checkTransInternacionales) && !Ext.isEmpty(checkComunicacionTerceros)){
				me.firstExecution = false;	
			}
		}else{
			if(me.firstExecution && !Ext.isEmpty(checkCesionDatos) && !Ext.isEmpty(checkTransInternacionales) && !Ext.isEmpty(checkComunicacionTerceros)){
				if(esInternacional){
						if(!Ext.isEmpty(checkCesionDatos) && !Ext.isEmpty(checkTransInternacionales) && checkTransInternacionales=="true"){
							btnFinalizar.enable();
						}else{
							btnFinalizar.disable();
						}
				}else{
					if(!Ext.isEmpty(checkCesionDatos) && !Ext.isEmpty(checkTransInternacionales) && !Ext.isEmpty(checkComunicacionTerceros)){
						btnFinalizar.enable();
					}else{
						btnFinalizar.disable();
					}
				}
			}else{
				btnFinalizar.disable();
			}
			if(!Ext.isEmpty(checkCesionDatos) && !Ext.isEmpty(checkTransInternacionales) && !Ext.isEmpty(checkComunicacionTerceros)){
				me.firstExecution = false;	
			}
			
		}
		
	},
	onChangeCheckboxCesionDatos: function(checkbox, newVal, oldVal) {
		var me = this,
			form = me.getView(),
			wizard =form.up('wizardBase'),
			checkTransInternacionales = form.getForm().findField('transferenciasInternacionales').getValue(),
			esInternacional = form.getForm().findField('carteraInternacional').getValue(),
			checkCesionDatos = form.getForm().findField('cesionDatos').getValue(),
			btnGenerarDoc = form.lookupReference('btnGenerarDocumento'),
			btnSubirDoc = form.lookupReference('btnSubirDocumento'),
			docOfertaComercial = form.getForm().findField('docOfertaComercial'),
			btnFinalizar = form.lookupReference('btnFinalizar');

		if (checkbox.getValue()=="true") {
			if (esInternacional) {
				if (checkTransInternacionales) {
					btnGenerarDoc.enable();
					btnSubirDoc.enable();

				} else {
					btnGenerarDoc.disable();
					btnSubirDoc.disable();
				}

			} else {
				btnGenerarDoc.enable();
				btnSubirDoc.enable();
			}

		} else {
			btnGenerarDoc.disable();
			btnSubirDoc.disable();
		}
		
		me.activarFinalizar(form);
	},

	onChangeCheckboxComunicacionTerceros: function(checkbox, newVal, oldVal) {
		var me = this,
			form = me.getView(),
			wizard =form.up('wizardBase'),
			checkCesionDatos = form.getForm().findField('cesionDatos').getValue(),
			checkTransInternacionales = form.getForm().findField('transferenciasInternacionales').getValue(),
			esInternacional = form.getForm().findField('carteraInternacional').getValue(),
			btnGenerarDoc = form.lookupReference('btnGenerarDocumento'),
			btnSubirDoc = form.lookupReference('btnSubirDocumento'),
			docOfertaComercial = form.getForm().findField('docOfertaComercial'),
			btnFinalizar = form.lookupReference('btnFinalizar');

		if (checkCesionDatos=="true") {
			if (esInternacional) {
				if (checkTransInternacionales) {
					btnGenerarDoc.enable();
					btnSubirDoc.enable();

				} else {
					btnGenerarDoc.disable();
					btnSubirDoc.disable();
				}

			} else {
				btnGenerarDoc.enable();
				btnSubirDoc.enable();
			}

		} else {
			btnGenerarDoc.disable();
			btnSubirDoc.disable();
		}
		me.activarFinalizar(form);
	},
	
	hayCambios: function(){
		var me = this,
		form = me.getView(),
		wizard = form.up('wizardBase'),
		checkCesionDatos = form.getForm().findField('cesionDatos').getValue(),
		checkTransInternacionales = form.getForm().findField('transferenciasInternacionales').getValue(),
		comunicacionTerceros = form.getForm().findField('comunicacionTerceros').getValue();
		if(form.cesionHaya == checkCesionDatos
				&& form.comunicacionTerceros == comunicacionTerceros
				&& form.tranferenciasInternacionales == checkTransInternacionales){
			return false;
		}else{
			return true;
		}
		return true;
	},
	
	onRenderTextfieldDocumentoOfertaComercial: function(text) {
		var tip = Ext.create('Ext.tip.Tip', {
			html: ''
		});

		text.getEl().on('mouseover', function() {
			tip.setHtml(text.value);
			if (!Ext.isEmpty(tip.html)) {
				tip.showAt(text.getEl().getX() - 10, text.getEl().getY() + 45);
			}
		});

		text.getEl().on('mouseleave', function() {
			tip.hide();
		});
	},

	onChangeCheckboxTransferenciasInternacionales: function(checkbox) {
		var me = this,
			form = me.getView(),
			wizard =form.up('wizardBase'),
			checkCesionDatos = form.getForm().findField('cesionDatos').getValue(),
			esInternacional = form.getForm().findField('carteraInternacional').getValue(),
			checkTransInternacionales = form.getForm().findField('transferenciasInternacionales').getValue(),
			btnGenerarDoc = form.lookupReference('btnGenerarDocumento'),
			btnSubirDoc = form.lookupReference('btnSubirDocumento'),
			docOfertaComercial = form.getForm().findField('docOfertaComercial'),
			btnFinalizar = form.lookupReference('btnFinalizar');

		if (checkCesionDatos=="true") {
			if (esInternacional) {
				if (checkbox.getValue()) {
					btnGenerarDoc.enable();
					btnSubirDoc.enable();

				} else {
					btnGenerarDoc.disable();
					btnSubirDoc.disable();
				}

			} else {
				btnGenerarDoc.enable();
				btnSubirDoc.enable();
			}

		} else {
			btnGenerarDoc.disable();
			btnSubirDoc.disable();
		}

		me.activarFinalizar(form);
	},

	onClickBotonGenerarDoc: function(btn) {
		var me = this,
			form = me.getView(),
			wizard = form.up('wizardBase');
		var tipoPersona = null;
		var nombre;
		var direccion = null;
		var email = null;
		var idExpediente = null;
		var telefono = null;
		var documento = null;
		var codPrescriptor = null;
		if(wizard.comprador){
			tipoPersona = wizard.comprador.get('codTipoPersona');
			if (tipoPersona == CONST.TIPO_PERSONA['FISICA']) {
				nombre = wizard.comprador.get('nombreRazonSocial') + ' ' + wizard.comprador.get('apellidos');
			} else {
				nombre = wizard.comprador.get('nombreRazonSocial');
			}
			direccion = wizard.comprador.get('direccion');
			email = wizard.comprador.get('email');
			idExpediente = wizard.comprador.get('idExpedienteComercial');
			telefono = wizard.comprador.get('telefono1');
			documento = wizard.comprador.get('numDocumento');
			codPrescriptor = wizard.comprador.get('codigoPrescriptor');
		}else{
			var formOferta = wizard.down('slidedatosoferta').getForm();
			if (Ext.isEmpty(formOferta.findField('razonSocialCliente').getValue()) || formOferta.findField('razonSocialCliente').getValue() == '') {
				nombre = formOferta.findField('nombreCliente').getValue() + ' ' + formOferta.findField('apellidosCliente').getValue();
			}else {
				nombre = formOferta.findField('razonSocialCliente').getValue();
			}
			documento = formOferta.findField('numDocumentoCliente').getValue();
			codPrescriptor = formOferta.findField('buscadorPrescriptores').getValue();
		}
		

		

		config = {
			url: $AC.getRemoteUrl('activo/generarUrlGDPR'),
			method: 'POST',
			params: {
				codPrescriptor: codPrescriptor,
				cesionDatos: form.getForm().findField('cesionDatos').getValue(),
				transIntern: form.getForm().findField('transferenciasInternacionales').getValue(),
				comTerceros: form.getForm().findField('comunicacionTerceros').getValue(),
				documento: documento,
				nombre: nombre,
				direccion: direccion,
				email: email,
				idExpediente: idExpediente,
				telefono: telefono
			}
		};

		Ext.global.console.log('Generando documento para ' + nombre);
		me.fireEvent('downloadFile', config);
	},

	abrirFormularioAdjuntarDocumentoOferta: function(grid) {
		var me = this,
			form = me.getView(),
			wizard = form.up('wizardBase'),
			idEntidad = null,
			entidad = null,
			docCliente = null;

		if (!Ext.isEmpty(wizard.oferta)) {
			if (!Ext.isEmpty(wizard.oferta.get('idActivo'))) {
				idEntidad = wizard.oferta.get('idActivo');
				entidad = 'activo';
			} else {
				idEntidad = wizard.oferta.get('idAgrupacion');
				entidad = 'agrupacion';
			}
			docCliente = wizard.oferta.get('numDocumentoCliente');

		} else {
			idEntidad = wizard.comprador.get('idExpedienteComercial');
			entidad = 'expediente';
			docCliente = wizard.comprador.get('numDocumento');
		}

		Ext.create('HreRem.view.common.adjuntos.AdjuntarDocumentoOfertacomercial', {
			entidad: entidad,
			idEntidad: idEntidad,
			docCliente: docCliente,
			parent: wizard
		}).show();
	},

	onClickCrearOferta: function() {
		var me = this,
			form = me.getView(),
			wizard = form.up('wizardBase'),
			valueDestComercial,
			destinoComercialActivo;

		if (!form.isValid()) {
			me.fireEvent('errorToast', HreRem.i18n('msg.form.invalido'));
			return;
		}
		if (!Ext.isEmpty(wizard.oferta)) {
			// TODO: terminar esta parte con respecto al wizard de oferta.
			if (form.config.xtype.indexOf('slideadjuntardocumento') >= 0) {
				valueDestComercial = wizard.oferta.data.destinoComercial;
				destinoComercialActivo = wizard.oferta.data.destinoComercialActivo;
			} else {
				valueDestComercial = form.getForm().findField('tipoOferta').getSelection().data.descripcion;
				destinoComercialActivo = wizard.oferta.data.destinoComercial;
				wizard.oferta.data.valueDestComercial = valueDestComercial;
				wizard.oferta.data.destinoComercialActivo = destinoComercialActivo;
			}

			if (destinoComercialActivo === valueDestComercial || destinoComercialActivo === CONST.TIPO_COMERCIALIZACION_ACTIVO['ALQUILER_VENTA']) {
				if (form.config.xtype.indexOf('slideadjuntardocumento') >= 0 && wizard.oferta) {
					var cesionDatos = form.getForm().findField('cesionDatos').getValue(),
						comunicacionTerceros = form.getForm().findField('comunicacionTerceros').getValue(),
						transferenciasInternacionales = form.getForm().findField('transferenciasInternacionales').getValue();
					form.up().down('slidedatosoferta').getForm().findField('cesionDatos').setValue(cesionDatos);
					form.up().down('slidedatosoferta').getForm().findField('comunicacionTerceros').setValue(comunicacionTerceros);
					form.up().down('slidedatosoferta').getForm().findField('transferenciasInternacionales').setValue(transferenciasInternacionales);
	
					me.onClickBotonGuardarOferta();
	
				} else if (form.config.xtype.indexOf('slidedatosoferta') >= 0) {
	
					var pedirDocValor = form.findField('pedirDoc').getValue();
	
					if (pedirDocValor == 'false') {
						var docCliente = me.getViewModel().get('oferta.numDocumentoCliente');
						me.getView().mask(HreRem.i18n('msg.mask.loading'));
						var url = $AC.getRemoteUrl('activooferta/getListAdjuntos');
						var idActivo = wizard.oferta.data.idActivo,
						idAgrupacion = wizard.oferta.data.idAgrupacion;
	
						Ext.Ajax.request({
							url: url,
							method: 'GET',
							waitMsg: HreRem.i18n('msg.mask.loading'),
							params: {
								docCliente: docCliente,
								idActivo: idActivo,
								idAgrupacion: idAgrupacion
							},
	
							success: function(response, opts) {
								var data = Ext.decode(response.responseText);
								var ventanaWizardAdjuntarDocumento = wizard.down('slideadjuntardocumento'),
										esInternacional = ventanaWizardAdjuntarDocumento.getForm().findField('carteraInternacional').getValue(),
										cesionDatos = ventanaWizardAdjuntarDocumento.getForm().findField('cesionDatos'),
										transferenciasInternacionales = ventanaWizardAdjuntarDocumento.getForm().findField('transferenciasInternacionales');
									var btnFinalizar = ventanaWizardAdjuntarDocumento.down('button[reference=btnFinalizar]');
								if (!Ext.isEmpty(data.data)) {									
									ventanaWizardAdjuntarDocumento.getForm().findField('docOfertaComercial').setValue(data.data[0].nombre);
									ventanaWizardAdjuntarDocumento.down().down('panel').down('button').show();
									ventanaWizard.unmask()
								}							
							},
	
							failure: function(record, operation) {
								me.fireEvent('errorToast', HreRem.i18n('msg.operacion.ko'));
							}
	
						});
	
						var valorCesionDatos = form.findField('cesionDatos').getValue(),
							valorComTerceros = form.findField('comunicacionTerceros').getValue(),
							valorTransferInternacionales = form.findField('transferenciasInternacionales').getValue();
						wizard.down('slideadjuntardocumento').getForm().findField('cesionDatos').setValue(valorCesionDatos);
						wizard.down('slideadjuntardocumento').getForm().findField('comunicacionTerceros').setValue(valorComTerceros);
						wizard.down('slideadjuntardocumento').getForm().findField('transferenciasInternacionales').setValue(valorTransferInternacionales);
	
						wizard.height = Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() - 100;
						wizard.setY(Ext.Element.getViewportHeight() / 2 - ((Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() - 100) / 2));

						me.getView().unmask();
						wizard.nextSlide();
	
					} else {
	
						me.onClickBotonGuardarOferta();
					}
				}

			} else {
				me.fireEvent('errorToast', HreRem.i18n('wizardOferta.operacion.ko.nueva.oferta') + valueDestComercial);
			}

		} else {
			if(!Ext.isEmpty(wizard.down('slidedatoscomprador').getForm().findField('seleccionClienteUrsus'))){
				wizard.down('slidedatoscomprador').getForm().findField('seleccionClienteUrsus').suspendEvents();
			}			
			wizard.down('slidedatoscomprador').getForm().findField('numDocumento').suspendEvents();
			me.guardarModeloComprador();
		}
	},

	borrarDocumentoAdjuntoOferta: function(grid, record) {
		var me = this,
			form = me.getView(),
			wizard = form.up('wizardBase'),
			docCliente,
			url;

		wizard.mask(HreRem.i18n('msg.mask.loading'));

		if (!Ext.isEmpty(wizard.oferta)) {
			url = $AC.getRemoteUrl('activooferta/eliminarDocumentoAdjuntoOferta');
			docCliente = wizard.oferta.get('numDocumentoCliente');
		} else {
			url = $AC.getRemoteUrl('expedientecomercial/eliminarDocumentoAdjuntoComprador');
			docCliente = wizard.comprador.get('numDocumento');
		}

		Ext.Ajax.request({
			url: url,
			params: {
				docCliente: docCliente
			},
			success: function(a, operation, context) {
				var data = Ext.decode(a.responseText);
				if (data) {
					grid.up().down('textfieldbase').setValue('');
				}

				wizard.unmask();
				grid.hide();
				me.fireEvent('infoToast', HreRem.i18n('msg.operacion.ok'));
				form.lookupReference('btnFinalizar').disable();
				form.lookupReference('btnGenerarDocumento').enable();
				form.getForm().findField('comunicacionTerceros').enable();
				form.getForm().findField('cesionDatos').enable();
				form.getForm().findField('transferenciasInternacionales').enable();
			},
			failure: function(a, operation, context) {
				me.fireEvent('errorToast', HreRem.i18n('msg.operacion.ko'));
				wizard.unmask();
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
			wizard = form.up('wizardBase'),
			record = wizard.comprador;

		wizard.mask(HreRem.i18n('msg.mask.espere'));

		record.set('cesionDatos', form.getForm().findField('cesionDatos').getValue());
		record.set('comunicacionTerceros',form.getForm().findField('comunicacionTerceros').getValue());
		record.set('transferenciasInternacionales', form.getForm().findField('transferenciasInternacionales').getValue());

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

	onSaveFormularioCompletoOferta : function(form, window) {
		var me = this,
		record = form.getForm().getValues(),
		ofertaForm = null,
		wizardAltaOferta = form.up('wizardBase');

		model = me.getViewModel().get('oferta');

		if(!Ext.isEmpty(wizardAltaOferta.down('slidedatosoferta'))) {
			ofertaForm = wizardAltaOferta.down('slidedatosoferta').form;
		}

		if (ofertaForm.isValid()) {

			window.mask(HreRem.i18n("msg.mask.espere"));

			model.save({
				success : function(record) {
					form.reset();
					ofertaForm.reset();
					window.unmask();
					if (Ext.isDefined(model.data.idActivo)){
						window.parent.up('activosdetalle').lookupController().refrescarActivo(true);
					}
					else {
						window.setController('agrupaciondetalle');
						window.getController().refrescarAgrupacion(true);
					}
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					window.destroy();
				},
				failure : function(record, operation) {
						me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
						window.unmask();
				}

			});

		} else {
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}
	},
	
	onClickBotonGuardarOferta: function(){
		var me = this,
		window = me.getView().up('wizardBase'),
		form = window.down('form'),
		model = null,
		data = window.oferta.data,
		ventanaDetalle = window.down('slidedatosoferta');

		bindRecord = ventanaDetalle.getForm().getValues();
		if(Ext.isDefined(data.idActivo)){
			model = Ext.create('HreRem.model.OfertaComercialActivo', {
				idActivo : data.idActivo,
				importeOferta: bindRecord.importeOferta,
				tipoOferta: bindRecord.tipoOferta,
				numDocumentoCliente: bindRecord.numDocumentoCliente,
				tipoDocumento: bindRecord.tipoDocumento,
				nombreCliente: bindRecord.nombreCliente,
				apellidosCliente: bindRecord.apellidosCliente,
				cesionDatos: bindRecord.cesionDatos,
				comunicacionTerceros: bindRecord.comunicacionTerceros,
				transferenciasInternacionales: bindRecord.transferenciasInternacionales,
				codigoPrescriptor: bindRecord.buscadorPrescriptores,
				regimenMatrimonial: bindRecord.regimenMatrimonial,
				estadoCivil: bindRecord.estadoCivil,
				codigoSucursal: bindRecord.buscadorSucursales,
				intencionFinanciar: bindRecord.intencionfinanciar,
				tipoPersona: bindRecord.tipoPersona,
				razonSocialCliente: bindRecord.razonSocialCliente,
				deDerechoTanteo: bindRecord.dederechotanteo
			});
		}else{
			model = Ext.create('HreRem.model.OfertaComercial', {
				idAgrupacion : data.idAgrupacion,
				importeOferta: bindRecord.importeOferta,
				tipoOferta: bindRecord.tipoOferta,
				numDocumentoCliente: bindRecord.numDocumentoCliente,
				tipoDocumento: bindRecord.tipoDocumento,
				nombreCliente: bindRecord.nombreCliente,
				apellidosCliente: bindRecord.apellidosCliente,
				cesionDatos: bindRecord.cesionDatos,
				comunicacionTerceros: bindRecord.comunicacionTerceros,
				transferenciasInternacionales: bindRecord.transferenciasInternacionales,
				codigoPrescriptor: bindRecord.buscadorPrescriptores,
				regimenMatrimonial: bindRecord.regimenMatrimonial,
				estadoCivil: bindRecord.estadoCivil,
				codigoSucursal: bindRecord.buscadorSucursales,
				intencionFinanciar: bindRecord.intencionfinanciar,
				tipoPersona: bindRecord.tipoPersona,
				razonSocialCliente: bindRecord.razonSocialCliente,
				deDerechoTanteo: bindRecord.dederechotanteo
			});
		}

		me.getViewModel().set('oferta', model);

		me.onSaveFormularioCompletoOferta(form, window);
	}

});