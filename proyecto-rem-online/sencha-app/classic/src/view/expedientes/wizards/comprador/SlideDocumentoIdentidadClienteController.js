Ext.define('HreRem.view.expedientes.wizards.comprador.SlideDocumentoIdentidadClienteController', {
	extend: 'Ext.app.ViewController',
	alias: 'controller.slidedocumentoidentidadcliente',

	onActivate: function() {
		var me = this,
			fieldsetDocumentoIdentidad = me.lookupReference('fieldsetDocumentoIdentidad'),
			wizard = me.getView().up('wizardBase');
		if(!Ext.isEmpty(wizard.expediente)){
			if (wizard.expediente.get('tipoExpedienteCodigo') === CONST.TIPOS_EXPEDIENTE_COMERCIAL['ALQUILER']) {
				fieldsetDocumentoIdentidad.setTitle(HreRem.i18n('title.nuevo.inquilino'));
			} else {
				fieldsetDocumentoIdentidad.setTitle(HreRem.i18n('title.nuevo.comprador'));
			}
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
		if(form.isValid()){
			if (me.comprobarDocumentoIdentidadCliente()) {
				wizard.codTipoDocumento = form.lookupReference('tipoDocumentoNuevoComprador').getValue();
				wizard.numDocumento = form.lookupReference('nuevoCompradorNumDoc').getValue();
				var datosForm = form.getForm().getValues(), idExpediente, idActivo, idAgrupacion;
				if(!Ext.isEmpty(wizard.expediente)){
					idExpediente = wizard.expediente.get('id');
				}
				if(!Ext.isEmpty(wizard.oferta)){
					idAgrupacion = wizard.oferta.get('idAgrupacion');
					idActivo = wizard.oferta.get('idActivo');
				}
				Ext.Ajax.request({
					url: $AC.getRemoteUrl('ofertas/checkPedirDoc'),
					method: 'POST',
					params: {
						idExpediente: idExpediente,
						idActivo: idActivo,
						idAgrupacion: idAgrupacion,					
						dniComprador: wizard.numDocumento,
						codtipoDoc: wizard.codTipoDocumento
					},
					success: function(response, opts) {
						var datos = Ext.decode(response.responseText);
						wizard.idComprador = datos.compradorId;
						var datos = Ext.decode(response.responseText);
		    			var pedirDoc = Ext.decode(response.responseText).data;
		    			var comprador=datos.comprador;
		    			var destinoComercial= datos.destinoComercial;
		    			var carteraInternacional = datos.carteraInternacional;
		    			var slideDatos;
		    			if(!Ext.isEmpty(wizard.oferta)){
		    				
		    				slideDatos = wizard.down('slidedatosoferta');
		    				wizard.oferta.data.destinoComercial=destinoComercial;
		    				slideDatos.getForm().reset();
		    				if(!Ext.isEmpty(pedirDoc)){
		        				slideDatos.getForm().findField('pedirDoc').setValue(pedirDoc);
		        				if(pedirDoc == "true"){
		        					wizard.down('button[itemId=btnGuardar]').setText("Crear");
		        				}else{
		        					wizard.down('button[itemId=btnGuardar]').setText("Continuar");
		        				}
		        			}
		        			if(!Ext.isEmpty(comprador)){
	
		        				if(!Ext.isEmpty(comprador.nombreCliente)){
		            				slideDatos.getForm().findField('nombreCliente').setValue(comprador.nombreCliente);
		                			slideDatos.getForm().findField('nombreCliente').setReadOnly(true);
		            			}
		            			if(!Ext.isEmpty(comprador.apellidosCliente)){
		            				slideDatos.getForm().findField('apellidosCliente').setValue(comprador.apellidosCliente);
		            				slideDatos.getForm().findField('apellidosCliente').setReadOnly(true);
		            			}
		            			if(!Ext.isEmpty(comprador.razonSocial)){
		            				slideDatos.getForm().findField('razonSocialCliente').setValue(comprador.razonSocial);
		            				slideDatos.getForm().findField('razonSocialCliente').setReadOnly(true);
		            			}
		            			if(!Ext.isEmpty(comprador.documento)){
		            				slideDatos.getForm().findField('numDocumentoCliente').setValue(comprador.documento);
		            				slideDatos.getForm().findField('numDocumentoCliente').setReadOnly(true);
		            			}
		            			if(!Ext.isEmpty(comprador.tipoDocumentoCodigo)){
		            				slideDatos.getForm().findField('tipoDocumento').setValue(comprador.tipoDocumentoCodigo);
		            				slideDatos.getForm().findField('tipoDocumento').setReadOnly(true);
		            			}
		            			if(!Ext.isEmpty(comprador.tipoPersonaCodigo)){
		            				slideDatos.getForm().findField('tipoPersona').setValue(comprador.tipoPersonaCodigo);
		            				slideDatos.getForm().findField('tipoPersona').setReadOnly(true);
		            			}
		            			if(!Ext.isEmpty(comprador.estadoCivilCodigo)){
		            				slideDatos.getForm().findField('estadoCivil').setValue(comprador.estadoCivilCodigo);
		            				slideDatos.getForm().findField('estadoCivil').setReadOnly(true);
		            			}
		            			if(!Ext.isEmpty(comprador.regimenMatrimonialCodigo)){
		            				slideDatos.getForm().findField('regimenMatrimonial').setValue(comprador.regimenMatrimonialCodigo);
		            				slideDatos.getForm().findField('regimenMatrimonial').setReadOnly(true);
		            			}
		            			if(!Ext.isEmpty(comprador.codigoPrescriptor)){
		            				slideDatos.getForm().findField('buscadorPrescriptores').setValue(comprador.codigoPrescriptor);
		            				slideDatos.getForm().findField('buscadorPrescriptores').setReadOnly(true);
		            			}
		            			if(!Ext.isEmpty(comprador.cesionDatos)){
		            				slideDatos.getForm().findField('cesionDatos').setValue(comprador.cesionDatos);
		            			}
		            			if(!Ext.isEmpty(comprador.comunicacionTerceros)){
		            				slideDatos.getForm().findField('comunicacionTerceros').setValue(comprador.comunicacionTerceros);
		            			}
		            			if(!Ext.isEmpty(comprador.transferenciasInternacionales)){
		            				slideDatos.getForm().findField('transferenciasInternacionales').setValue(comprador.transferenciasInternacionales);
		            			}
		            			if(!Ext.isEmpty(comprador.direccion)){
		            				slideDatos.getForm().findField('direccion').setValue(comprador.direccion);
		            				slideDatos.getForm().findField('direccion').setReadOnly(true);
		            			}
		            			if(!Ext.isEmpty(comprador.telefono)){
		            				slideDatos.getForm().findField('telefono').setValue(comprador.telefono);
		            				slideDatos.getForm().findField('telefono').setReadOnly(true);
		            			}
		            			if(!Ext.isEmpty(comprador.email)){
		            				slideDatos.getForm().findField('email').setValue(comprador.email);
		            				slideDatos.getForm().findField('email').setReadOnly(true);
		            				slideDatos.getForm().findField('emailNacimiento').setValue(comprador.email);
		            			}
		            			if(!Ext.isEmpty(comprador.vinculoCaixaCodigo)){
		            				slideDatos.getForm().findField('vinculoCaixa').setValue(comprador.vinculoCaixaCodigo);
		            				slideDatos.getForm().findField('vinculoCaixa').setReadOnly(true);
		            			}
	
		            			if(!Ext.isEmpty(comprador.codigoPais)){
		            				slideDatos.getForm().findField('codigoPais').setValue(comprador.codigoPais);
		            			}
		            		
		            			if(!Ext.isEmpty(comprador.fechaNacimientoConstitucion)){
		            				var date = comprador.fechaNacimientoConstitucion.slice(0, 10);
		            				slideDatos.getForm().findField('fechaNacimientoConstitucion').setValue(date);
		            			}
		            			
		            			if(!Ext.isEmpty(comprador.paisNacimientoCompradorCodigo)){
		            				slideDatos.getForm().findField('paisNacimientoCompradorCodigo').setValue(comprador.paisNacimientoCompradorCodigo);
		            			}else{
		            				slideDatos.getForm().findField('paisNacimientoCompradorCodigo').setValue("28");
		            			}
		            			
		            			if(!Ext.isEmpty(comprador.provinciaCodigo)){
		            				slideDatos.getForm().findField('provinciaCodigo').setValue(comprador.provinciaCodigo);
		            			}

		            			if(!Ext.isEmpty(comprador.municipioCodigo) && !Ext.isEmpty(comprador.provinciaCodigo)){
		            				slideDatos.getForm().findField('municipioCodigo').setValue(comprador.municipioCodigo);
		            			}
		            			
		            			if(!Ext.isEmpty(comprador.direccion)){
		            				slideDatos.getForm().findField('direccionTodos').setValue(comprador.direccion);
		            			}
		            			
		            			if(!Ext.isEmpty(comprador.prp)){
		            				slideDatos.getForm().findField('prp').setValue(comprador.prp);
		            			}
		            			
		            			if(!Ext.isEmpty(comprador.telefono1)){
		            				slideDatos.getForm().findField('telefonoNacimiento1').setValue(comprador.telefono1);
		            			}
		            			
		            			if(!Ext.isEmpty(comprador.telefono2)){
		            				slideDatos.getForm().findField('telefonoNacimiento2').setValue(comprador.telefono2);
		            			}
		            			
		            			if(!Ext.isEmpty(comprador.codigoPostal)){
		            				slideDatos.getForm().findField('codigoPostalNacimiento').setValue(comprador.codigoPostal);
		            			}

		            			if(!Ext.isEmpty(comprador.provinciaNacimientoCodigo)){
		            				slideDatos.getForm().findField('provinciaNacimiento').setValue(comprador.provinciaNacimientoCodigo);
		            			}
		            			
		            			if(!Ext.isEmpty(comprador.localidadNacimientoCompradorCodigo)){
		            				slideDatos.getForm().findField('localidadNacimientoCompradorCodigo').setValue(comprador.localidadNacimientoCompradorCodigo);
		            			}
		            			
		            			if(!Ext.isEmpty(comprador.codigoPaisRte)){
		            				slideDatos.getForm().findField('codigoPaisRte').setValue(comprador.codigoPaisRte);
		            			}else if(comprador.tipoPersonaCodigo == null || comprador.tipoPersonaCodigo == undefined || comprador.tipoPersonaCodigo.value == "2"){
		            				slideDatos.getForm().findField('codigoPaisRte').setValue("28");
		            			}
		            			
		            			if(!Ext.isEmpty(comprador.codigoPais)){
		            				slideDatos.getForm().findField('codigoPais').setValue(comprador.codigoPais);
		            			}else if(comprador.tipoPersonaCodigo == null || comprador.tipoPersonaCodigo == undefined || comprador.tipoPersonaCodigo.value == "2"){
		            				slideDatos.getForm().findField('codigoPais').setValue("28");
		            			}
		            			
		            			if(!Ext.isEmpty(comprador.paisNacimientoRepresentanteCodigo)){
		            				slideDatos.getForm().findField('paisNacimientoRepresentanteCodigo').setValue(comprador.paisNacimientoRepresentanteCodigo);
		            			}else if(comprador.tipoPersonaCodigo == null || comprador.tipoPersonaCodigo == undefined || comprador.tipoPersonaCodigo.value == "2"){
		            				slideDatos.getForm().findField('paisNacimientoRepresentanteCodigo').setValue("28");
		            			}
		            			
		        			}
		        			wizard.width= Ext.Element.getViewportWidth() > 1370 ? Ext.Element.getViewportWidth() / 2 : Ext.Element.getViewportWidth() /1.5;
		        			wizard.setX( Ext.Element.getViewportWidth() / 2 - ((Ext.Element.getViewportWidth() > 1370 ? Ext.Element.getViewportWidth() / 2 : Ext.Element.getViewportWidth() /1.5) / 2));
		        			wizard.height = Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() -100;
		        			wizard.setY( Ext.Element.getViewportHeight()/2 - ((Ext.Element.getViewportHeight() > 600 ? 600 : Ext.Element.getViewportHeight() -100)/2));
	
		    			}else{
	
		    				if(!Ext.isEmpty(wizard.expediente)){
		    				   slideDatos = wizard.down('slidedatoscomprador');
	
		    				   slideDatos.getForm().reset();
	
		    				   if(!Ext.isEmpty(pedirDoc)){
		    					   slideDatos.getForm().findField('pedirDoc').setValue(pedirDoc);
		           		       }
	
		    				   if(!Ext.isEmpty(datos.compradorId)){
		    					   slideDatos.idComprador=datos.compradorId;
		    				   }
		    				   else{
		    					   
		        				   form = wizard.down('slidedocumentoidentidadcliente').form;
		        				   slideDatos.getForm().findField('numDocumento').setValue(form.findField('numDocumentoCliente').getValue());
		        				   slideDatos.getForm().findField('numDocumento').readOnly = true;
		        				   slideDatos.getForm().findField('codTipoDocumento').setValue(form.findField('comboTipoDocumento').getValue());
		        				   slideDatos.getForm().findField('codTipoDocumento').readOnly = true;
		    				   }
	
		    				   if(!Ext.isEmpty(comprador)){
		    					   if(!Ext.isEmpty(comprador.cesionDatos)){
		    					      slideDatos.getForm().findField('cesionDatos').setValue(comprador.cesionDatos);
		    					   }else{
		    					   	  slideDatos.getForm().findField('cesionDatos').setValue("true");
		    					   }
		    					   if(!Ext.isEmpty(comprador.comunicacionTerceros)){
		        				      slideDatos.getForm().findField('comunicacionTerceros').setValue(comprador.comunicacionTerceros);
		    					   }else{
		    					   	  slideDatos.getForm().findField('comunicacionTerceros').setValue("");
		    					   }
		        				   if(!Ext.isEmpty(comprador.transferenciasInternacionales)){
		        				      slideDatos.getForm().findField('transferenciasInternacionales').setValue(comprador.transferenciasInternacionales);
		        				   }else{
		        				      slideDatos.getForm().findField('transferenciasInternacionales').setValue("");		
		        				   }
		        				   
		        				   	if(!Ext.isEmpty(comprador.paisNacimientoCompradorCodigo)){
		            					slideDatos.getForm().findField('paisNacimientoCompradorCodigo').setValue(comprador.paisNacimientoCompradorCodigo);
		            			   	}else{
		            			   		slideDatos.getForm().findField('paisNacimientoCompradorCodigo').setValue("28");
		            			   	}
		            			
			            			if(!Ext.isEmpty(comprador.codigoPaisRte)){
			            				slideDatos.getForm().findField('codigoPaisRte').setValue(comprador.codigoPaisRte);
			            			}else if(comprador.tipoPersonaCodigo == null || comprador.tipoPersonaCodigo == undefined || comprador.tipoPersonaCodigo.value == "2"){
		            				slideDatos.getForm().findField('codigoPaisRte').setValue("28");
		            			}
			            			
			            			if(!Ext.isEmpty(comprador.codigoPais)){
			            				slideDatos.getForm().findField('codigoPais').setValue(comprador.codigoPais);
			            			}else if(comprador.tipoPersonaCodigo == null || comprador.tipoPersonaCodigo == undefined || comprador.tipoPersonaCodigo.value == "2"){
			            				slideDatos.getForm().findField('codigoPais').setValue("28");
			            			}
			            			
			            			if(!Ext.isEmpty(comprador.paisNacimientoRepresentanteCodigo)){
		            					slideDatos.getForm().findField('paisNacimientoRepresentanteCodigo').setValue(comprador.paisNacimientoRepresentanteCodigo);
			            			}else if(comprador.tipoPersonaCodigo == null || comprador.tipoPersonaCodigo == undefined || comprador.tipoPersonaCodigo.value == "2"){
			            				slideDatos.getForm().findField('paisNacimientoRepresentanteCodigo').setValue("28");
			            			}
		            				
		    				   }
		    			   }
		    				wizard.width= Ext.Element.getViewportWidth() > 1370 ? Ext.Element.getViewportWidth() / 2 : Ext.Element.getViewportWidth() /1.5;
		    				wizard.setX( Ext.Element.getViewportWidth() / 2 - ((Ext.Element.getViewportWidth() > 1370 ? Ext.Element.getViewportWidth() / 2 : Ext.Element.getViewportWidth() /1.5) / 2));
		    				wizard.height = Ext.Element.getViewportHeight() > 800 ? 800 : Ext.Element.getViewportHeight() -100;
		        			wizard.setY( Ext.Element.getViewportHeight()/2 - ((Ext.Element.getViewportHeight() > 800 ? 800 : Ext.Element.getViewportHeight() -100)/2));
		    			}
		    			
		    			ventanaAdjuntarDocumento = wizard.down('slideadjuntardocumento');
		    			if(!Ext.isEmpty(datos.carteraInternacional)){
		    				ventanaAdjuntarDocumento.getForm().findField('carteraInternacional').setValue(datos.carteraInternacional);
	 				    }
		    			me.getView().unmask();
						wizard.nextSlide();
					},
					failure: function(record, operation) {
						me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				   }
				});
	
			} else {
				me.fireEvent('errorToast', HreRem.i18n('msg.numero.documento.comprador.incorrecto'));
			}
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
				regular = new RegExp(/^([ABCDEFGHJKLMNPQRSUVW])(\d{7})([0-9A-J])$/g);

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

		} else {
			return true;
		}
	},
	onChangeTipoDocumentoNuevoComprador : function(checkbox, newVal, oldVal){
		
	}

});