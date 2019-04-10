Ext.define('HreRem.view.expedientes.wizards.comprador.SlideDocumentoIdentidadClienteController', {
	extend: 'Ext.app.ViewController',
	alias: 'controller.slidedocumentoidentidadcliente',

	onActivate: function() {
		var me = this,
			fieldsetDocumentoIdentidad = me.lookupReference('fieldsetDocumentoIdentidad'),
			wizard = me.getView().up('wizardBase');

		if (wizard.expediente.get('tipoExpedienteCodigo') === CONST.TIPOS_EXPEDIENTE_COMERCIAL['ALQUILER']) {
			fieldsetDocumentoIdentidad.setTitle(HreRem.i18n('title.nuevo.inquilino'));
		} else {
			fieldsetDocumentoIdentidad.setTitle(HreRem.i18n('title.nuevo.comprador'));
		}
	},

	onClickCancelar: function() {
		var me = this,
			wizard = me.getView().up('wizardBase');

		wizard.closeWindow();
	},

	onClickContinuar: function() {
		var me = this,
			form = me.getView(),
			wizard = form.up('wizardBase');

		if (me.comprobarDocumentoIdentidadCliente()) {
			wizard.codTipoDocumento = form.lookupReference('tipoDocumentoNuevoComprador').getValue();
			wizard.numDocumento = form.lookupReference('nuevoCompradorNumDoc').getValue();

			Ext.Ajax.request({
				url: $AC.getRemoteUrl('ofertas/checkPedirDoc'),
				method: 'POST',
				params: {
					idExpediente: wizard.expediente.get('id'),
					dniComprador: wizard.numDocumento,
					codtipoDoc: wizard.codTipoDocumento
				},
				success: function(response, opts) {
					var datos = Ext.decode(response.responseText);
					wizard.idComprador = datos.compradorId;

					wizard.nextSlide();
				},
				failure: function(record, operation) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			   }
			});

		} else {
			me.fireEvent('errorToast', HreRem.i18n('msg.numero.documento.comprador.incorrecto'));
		}
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
	}

});