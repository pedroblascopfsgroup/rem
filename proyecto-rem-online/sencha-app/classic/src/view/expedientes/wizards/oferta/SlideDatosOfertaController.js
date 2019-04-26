Ext.define('HreRem.view.expedientes.wizards.oferta.SlideDatosOfertaController', {
	extend: 'Ext.app.ViewController',
	alias: 'controller.slidedatosoferta',

	onActivate: function() {
		var me = this,
			wizard = me.getView().up('wizardBase');
		Ext.Array.each(wizard.query('field[isReadOnlyEdit]'), function(field, index) {
			field.fireEvent('edit');
			if(index == 0) field.focus();
		});
	},

	onClickCancelar: function() {
		var me = this,
			wizard = me.getView().up('wizardBase'),
			documentoIdentidadCliente = me.getView().getForm().findField('numDocumentoCliente').getValue();

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
	buscarPrescriptor: function(field, e){
		
		var me= this;
		var url =  $AC.getRemoteUrl('proveedores/searchProveedorCodigo');
		var codPrescriptor = field.getValue();
		var data;
		var re = new RegExp("^((04$))|^((18$))|^((28$))|^((29$))|^((31$))|^((37$))|^((30$))|^((35$))|^((23$))|^((38$)).*$");

		
		Ext.Ajax.request({
		    			
		 		url: url,
		   		params: {codigoUnicoProveedor : codPrescriptor},
		    		
		    	success: function(response, opts) {
			    	data = Ext.decode(response.responseText);
		    		var buscadorPrescriptor = field.up('form').down('[name=buscadorPrescriptores]'),
		    		nombrePrescriptorField = field.up('form').down('[name=nombrePrescriptor]');
			    	if(!Utils.isEmptyJSON(data.data)){
						var id= data.data.id;
						var tipoProveedorCodigo = data.data.tipoProveedor.codigo;
						
		    		    var nombrePrescriptor= data.data.nombre;
		    		    
		    		    if(re.test(tipoProveedorCodigo)){
			    		    if(!Ext.isEmpty(buscadorPrescriptor)) {
			    		    	buscadorPrescriptor.setValue(codPrescriptor);
			    		    }
			    		    if(!Ext.isEmpty(nombrePrescriptorField)) {
			    		    	nombrePrescriptorField.setValue(nombrePrescriptor);
	
				    		}
		    		    }else{
		    		    	nombrePrescriptorField.setValue('');
		    				me.fireEvent("errorToast", "El cÃ³digo del Proveedor introducido no es un Prescriptor");
		    			}
			    	} else {
			    		if(!Ext.isEmpty(nombrePrescriptorField)) {
			    			nombrePrescriptorField.setValue('');
		    		    }
			    		me.fireEvent("errorToast", HreRem.i18n("msg.buscador.no.encuentra.proveedor.codigo"));
			    		buscadorPrescriptor.markInvalid(HreRem.i18n("msg.buscador.no.encuentra.proveedor.codigo"));		    		    
			    	}		    		    	 
		    	},
		    	failure: function(response) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    	},
		    	callback: function(options, success, response){
				}   		     
		});		
	},
	
	buscarSucursal: function(field, e){

		var me= this;
		var url =  $AC.getRemoteUrl('proveedores/searchProveedorCodigoUvem');
		var carteraBankia = me.view.up().lookupController().getViewModel().get('activo.isCarteraBankia');
		var carteraCajamar = me.view.up().lookupController().getViewModel().get('activo.isCarteraCajamar');
		var codSucursal = '';
		var nombreSucursal = '';
		if(carteraBankia){
			codSucursal = '2038' + field.getValue();
			nombreSucursal = ' (Oficina Bankia)';
		}else if(carteraCajamar){
			codSucursal = '3058' + field.getValue();
			nombreSucursal = ' (Oficina Cajamar)'
		}
		var data;
		var re = new RegExp("^[0-9]{8}$");
		
		Ext.Ajax.request({
		    			
		 		url: url,
		   		params: {codigoProveedorUvem : codSucursal},
		    		
		    	success: function(response, opts) {
			    	data = Ext.decode(response.responseText);
		    		var buscadorSucursal = field.up('form').down('[name=buscadorSucursales]'),
		    		nombreSucursalField = field.up('form').down('[name=nombreSucursal]');

			    	if(!Utils.isEmptyJSON(data.data)){
						var id= data.data.id;
		    		    nombreSucursal = data.data.nombre + nombreSucursal;
		    		    
		    		    if(re.test(codSucursal) && nombreSucursal != null && nombreSucursal != ''){
			    		    if(!Ext.isEmpty(nombreSucursalField)) {
			    		    	nombreSucursalField.setValue(nombreSucursal);	
				    		}
		    		    }else{
		    		    	nombreSucursalField.setValue('');
		    				me.fireEvent("errorToast", "El código de la Sucursal introducido no corresponde con ninguna Oficina");
		    			}
			    	} else {
			    		if(!Ext.isEmpty(nombreSucursalField)) {
			    			nombreSucursalField.setValue('');
		    		    }
			    		me.fireEvent("errorToast", HreRem.i18n("msg.buscador.no.encuentra.sucursal.codigo"));
			    		buscadorSucursal.markInvalid(HreRem.i18n("msg.buscador.no.encuentra.sucursal.codigo"));		    		    
			    	}		    		    	 
		    	},
		    	failure: function(response) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    	},
		    	callback: function(options, success, response){
				}   		     
		});		
	},

	onClickCrearOferta: function(btn){
        var me = this;
        var ventanaDetalle = btn.up('form'),
        wizard = ventanaDetalle.up(),
        url = null;
        var form = ventanaDetalle.getForm();
        if(form.isValid()){
            var valueDestComercial,destinoComercialActivo;

            if(wizard.oferta)
            {
                if(ventanaDetalle.config.xtype.indexOf('slideadjuntardocumento') >= 0 ){
                    valueDestComercial = wizard.oferta.data.destinoComercial;
                    destinoComercialActivo = wizard.oferta.data.destinoComercialActivo;
                }else{
                    valueDestComercial = form.findField('tipoOferta').getSelection().data.descripcion;
                    destinoComercialActivo = wizard.oferta.data.destinoComercial;
                    wizard.oferta.data.valueDestComercial = valueDestComercial;
                    wizard.oferta.data.destinoComercialActivo = destinoComercialActivo;
                }
            }

            if(destinoComercialActivo === valueDestComercial || destinoComercialActivo === CONST.TIPO_COMERCIALIZACION_ACTIVO["ALQUILER_VENTA"]){
                if (ventanaDetalle.config.xtype.indexOf('slideadjuntardocumento') >= 0 && wizard.oferta) {
                    ventanaDetalle.setController('activodetalle');
                    var esCarteraInternacional = ventanaDetalle.getForm().findField('carteraInternacional').getValue();
                    var cesionDatos = form.findField('cesionDatos').getValue(),
                    comunicacionTerceros = form.findField('comunicacionTerceros').getValue(),
                    transferenciasInternacionales = form.findField('transferenciasInternacionales').getValue();
                    ventanaDetalle.up().down('anyadirnuevaofertadetalle').getForm().findField('cesionDatos').setValue(cesionDatos);
                    ventanaDetalle.up().down('anyadirnuevaofertadetalle').getForm().findField('comunicacionTerceros').setValue(comunicacionTerceros);
                    ventanaDetalle.up().down('anyadirnuevaofertadetalle').getForm().findField('transferenciasInternacionales').setValue(transferenciasInternacionales);

                    me.onClickBotonGuardarOferta(btn);

                } else if (ventanaDetalle.config.xtype.indexOf('slidedatosoferta') >= 0) {

                    pedirDocValor = form.findField('pedirDoc').getValue();

                    if (pedirDocValor == 'false'){
                        var docCliente = me.getViewModel().get("oferta.numDocumentoCliente");
                        me.getView().mask(HreRem.i18n("msg.mask.loading"));
                        var url = $AC.getRemoteUrl('activooferta/getListAdjuntos'),
                        idActivo = wizard.oferta.data.idActivo,
                        idAgrupacion = wizard.oferta.data.idAgrupacion;
						wizard.mask("Cargando documentos comprador");
                        Ext.Ajax.request({
                             url: url,
                             method : 'GET',
                             waitMsg: HreRem.i18n('msg.mask.loading'),
                             params: {docCliente: docCliente, idActivo: idActivo, idAgrupacion: idAgrupacion},

                             success: function(response, opts) {
                             	 data = Ext.decode(response.responseText);
                                 if(!Ext.isEmpty(data.data)){
                                    var ventanaWizardAdjuntarDocumento = wizard.down('slideadjuntardocumento'),
                                    esInternacional = ventanaWizardAdjuntarDocumento.getForm().findField('carteraInternacional').getValue(),
                                    cesionDatos = ventanaWizardAdjuntarDocumento.getForm().findField('cesionDatos'),
                                    transferenciasInternacionales = ventanaWizardAdjuntarDocumento.getForm().findField('transferenciasInternacionales'),
                                    btnGenerarDoc = ventanaWizardAdjuntarDocumento.down('button[reference=btnGenerarDocumento]');
                                    btnFinalizar =  ventanaWizardAdjuntarDocumento.down('button[reference=btnFinalizar]');
                                    if (esInternacional) {
                                    	Ext.global.console.log("internacional");
                                    	Ext.global.console.log("cesion datos "+cesionDatos.getValue());
                                    	Ext.global.console.log("transferenciasInternacionales datos "+transferenciasInternacionales.getValue());
										if (transferenciasInternacionales.getValue()) {
											btnFinalizar.enable();
										}else{
											btnFinalizar.disable();
										}
									} else {
										Ext.global.console.log("no internacional");
										Ext.global.console.log("cesion datos "+cesionDatos.getValue());
                                    	Ext.global.console.log("transferenciasInternacionales datos "+transferenciasInternacionales.getValue());
										if (cesionDatos.getValue()) {
											btnFinalizar.enable();
										}else{
											btnFinalizar.disable();
										}
									}

                                    ventanaWizardAdjuntarDocumento.getForm().findField('docOfertaComercial').setValue(data.data[0].nombre);
                                    ventanaWizardAdjuntarDocumento.down().down('panel').down('button').show();                                    
                                 }
                                 wizard.unmask();
                             },

                             failure: function(record, operation) {
                                me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                                wizard.unmask();
                             }

                        });

                        var valorCesionDatos = form.findField('cesionDatos').getValue(),
                        valorComTerceros = form.findField('comunicacionTerceros').getValue(),
                        valorTransferInternacionales = form.findField('transferenciasInternacionales').getValue();
                        wizard.down('slideadjuntardocumento').getForm().findField('cesionDatos').setValue(valorCesionDatos);
                        wizard.down('slideadjuntardocumento').getForm().findField('comunicacionTerceros').setValue(valorComTerceros);
                        wizard.down('slideadjuntardocumento').getForm().findField('transferenciasInternacionales').setValue(valorTransferInternacionales);

                        wizard.height = Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight()-100;
                        wizard.setY( Ext.Element.getViewportHeight()/2 - ((Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() -100)/2));

                        me.getView().unmask();
                                               
                        wizard.nextSlide();

                    }else{

                        me.onClickBotonGuardarOferta(btn);
                    }

                }else if (ventanaDetalle.config.xtype.indexOf('activoadjuntardocumento') >= 0 && wizard.expediente) {
                    ventanaDetalle.setController('expedientedetalle');
                    ventanaDetalle.getController().onClickBotonCrearComprador(btn);
                }
            }else{
                me.fireEvent("errorToast", HreRem.i18n("wizardOferta.operacion.ko.nueva.oferta")+valueDestComercial);
            }
        }
    }

});