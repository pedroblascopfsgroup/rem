Ext.define('HreRem.view.activos.detalle.ComercialActivo', {
    extend			: 'HreRem.view.common.FormBase',
    cls				: 'panel-base shadow-panel',
    xtype			: 'comercialactivo',
    reference		: 'comercialactivoref',
    scrollable		: 'y',
    refreshAfterSave: true,
    recordName		: "comercial",
	recordClass		: "HreRem.model.ComercialActivoModel",
    requires		: ['HreRem.model.ComercialActivoModel', 'HreRem.view.activos.detalle.ComercialActivoTabPanel'],

    listeners		: {
		boxready:'cargarTabData'
    },

    initComponent: function () {
    	var me = this;
    	var isLogUsuGestComerSupComerSupAdmin = me.lookupViewModel().get('activo.isLogUsuGestComerSupComerSupAdmin');
    	me.setTitle(HreRem.i18n('title.comercial'));

    	me.items = [
    		{
    			xtype: 'label',
    			cls:'x-form-item',
    			html: HreRem.i18n('msg.oferta.activo.no.tramitable'),
    			style: 'color: red; font-weight: bold; font-size: small;',
    			readOnly: true,
    			hidden: true,
    			reference: 'labelActivoNoTramitable',
    			bind : {
    				hidden: '{comercial.tramitable}'
    			},
    			listeners:{
    				
    				afterrender: function(){
    					var me = this;
    					me.lookupController().usuarioTieneFuncionPermitirTramitarOferta();
    					
    				}
				}
    		},
    		{
    			xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				collapsible: true,
				reference: 'activoComercialBloqueRef',
				items :
					[
					// Fila 0
						{
				        	xtype : 'comboboxfieldbasedd',
				        	fieldLabel: HreRem.i18n('header.situacion.comercial'),
				        	reference: 'cbSituacionComercial',
				        	readOnly: true,
				        	bind : {
							      store : '{comboSituacionComercial}',
							      value : '{comercial.situacionComercialCodigo}',
							      rawValue : '{comercial.situacionComercialDescripcion}'
							}
				        },
				        {
				        	xtype: 'datefieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.fecha.venta'),
				        	reference: 'dtFechaVenta',
				        	allowBlank: false,
				        	bind : {
				        		readOnly: '{activoPertenceAgrupacionComercialOrRestringida}',
				        		value: '{comercial.fechaVenta}',
				        		disabled: '{!comercial.ventaExterna}'
				        	}
						},
						{ 
							xtype: 'textareafieldbase',
				        	fieldLabel:  HreRem.i18n('fieldlabel.observaciones'),
				        	bind: '{comercial.observaciones}',
				        	reference: 'taObservaciones',
							maxLength: 250,
							rowspan: 2,
				        	height: 80
				        },
				        
				        
					// Fila 1
				        {
				        	xtype : 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('header.estado.comercial.venta'),
				        	reference: 'estadoComercialVentaRef',
				        	readOnly: true,
				        	bind : {
							      store : '{comboEstadoComercialVenta}',
							      value : '{comercial.estadoComercialVentaCodigo}' ,
							      hidden: '{!isCarteraBankia}'
							}
				        },
				        {
				        	xtype: 'datefieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.fecha.estado.comercial.venta'),
				        	reference: 'fechaEstadoComericalVentaRef',
				        	allowBlank: true,
				        	readOnly: true,
				        	bind : {
				        		value: '{comercial.fechaEstadoComercialVenta}',
				        		hidden: '{!isCarteraBankia}'
				        	}
						},
				        {
				        	xtype : 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('header.estado.comercial.alquiler'),
				        	reference: 'estadoComercialAlquilerRef',
				        	readOnly: true,
				        	bind : {
							      store : '{comboEstadoComercialAlquiler}',
							      value : '{comercial.estadoComercialAlquilerCodigo}',
							      hidden: '{!isCarteraBankia}'
							}

				        },
				        {
				        	xtype: 'datefieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.fecha.estado.comercial.alquiler'),
				        	reference: 'fechaEstadoComericalAlquilerRef',
				        	allowBlank: true,
				        	readOnly: true,
				        	bind : {
				        		value: '{comercial.fechaEstadoComercialAlquiler}',
				        		hidden: '{!isCarteraBankia}'
				        	}
						},
				        {
						   xtype: 'checkboxfieldbase',
						   fieldLabel: HreRem.i18n('fieldlabel.venta.externa'),
						   reference: 'checkVentaExterna',
						   allowBlank: false,
						   bind : {
				        		value: '{comercial.ventaExterna}'
						   },
						   listeners: {
							change: function(checkbox, newVal, oldVal) {
								
								if (newVal && !oldVal) {
									var val = true;
								 	if(checkbox.up('activosdetallemain').getViewModel().get('comercial.expedienteComercialVivo')){
								 		val = false;
								 		me.fireEvent("errorToast", HreRem.i18n("msg.expediente.vivo"));
								 		return;
								 		
								 	}
								 	if(checkbox.up('activosdetallemain').getViewModel().get('comercial.situacionComercialCodigo') == CONST.SITUACION_COMERCIAL['NO_COMERCIALIZABLE']){
								 		val = false;
								 		me.fireEvent("errorToast", HreRem.i18n("msg.no.comercializable"));
								 		return;
								 	}
								 	if(checkbox.up('activosdetallemain').getViewModel().get('activoPerteneceAgrupacionComercial')){
								 		val = false;
								 		me.fireEvent("errorToast", HreRem.i18n("msg.activo.incluido.lote.comercial"));
								 		return;
								 	}
								 	if(checkbox.up('activosdetallemain').getViewModel().get('activoPerteneceAgrupacionRestringida')){
								 		val = false;
								 		me.fireEvent("errorToast", HreRem.i18n("msg.activo.incluido.agrupacion.restringida"));
								 		return;
								 	}								 								 		
								}
								if(!newVal && oldVal && null != checkbox.up('activosdetallemain').getViewModel().get('comercial.fechaVenta')){
									val = true;
									me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.activo.vendido"));
									return;
								}
								//checkbox.setValue(val);
							}
                          }
						},
						{
						   xtype: 'currencyfieldbase',
						   fieldLabel: HreRem.i18n('fieldlabel.importe.venta'),
						   reference: 'cncyImporteVenta',
						   allowBlank: false,
						   bind : {
				        		value: '{comercial.importeVenta}',
				        		disabled: '{!comercial.ventaExterna}'
						   }
						},
						{
						   xtype: 'checkboxfieldbase',
						   fieldLabel: HreRem.i18n('fieldlabel.puja'),
						   reference: 'checkSubasta',
						   allowBlank: false,
						   bind : {
					     		value: '{comercial.puja}'
						   },
						   disabled: !isLogUsuGestComerSupComerSupAdmin
						},
						{ 
							xtype: 'comboboxfieldbasedd',
							fieldLabel:	HreRem.i18n('fieldlabel.direccion.comercial'),
							bind: {
								allowBlank: '{!esSubcarteraAppleDivarian}',
								readOnly: '{!editableCES}',
								store: '{comboDireccionComercial}',
								value: '{comercial.direccionComercial}',
								rawValue: '{comercial.direccionComercialDescripcion}'							
							}
						},
						{				        	
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.venta.sobre.plano'),
							readOnly: true,
					        bind: {
				            	store: '{comboSiNoBoolean}',
				            	value:'{comercial.ventaSobrePlano}'
				           	}
						},
						{
							xtype: 'currencyfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.importe.comunidad.mensual.sareb'),
							reference: 'comunidadMensualSareb',
							bind : {
				        		hidden: '{!isCarteraSareb}',
				        		readOnly: '{!noEditableUASSoloSuper}',
				        		value: '{comercial.importeComunidadMensualSareb}'
							}						
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.siniestro.sareb'),
							reference: 'siniestroSarebRef',
							bind : {
				        		store: '{comboSiNoDict}',
				        		hidden: '{!isCarteraSareb}',
				        		readOnly: '{!noEditableUASSoloSuper}',
				        		value: '{comercial.siniestroSareb}'
							}						
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.tipo.correctivo.sareb'),
							reference: 'tipoCorrectivoSarebRef',
							bind : {
				        		store: '{comboDDTipoCorrectivoSareb}',
				        		hidden: '{!isCarteraSareb}',
				        		readOnly: '{!noEditableUASSoloSuper}',
				        		value: '{comercial.tipoCorrectivoSareb}'
							}						
						},
						{
							xtype: 'datefieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.fecha.fin.correctivo.sareb'),
							reference: 'fechaFinCorrectivoSarebRef',
							bind : {
				        		hidden: '{!isCarteraSareb}',
				        		readOnly: '{!noEditableUASSoloSuper}',
				        		value: '{comercial.fechaFinCorrectivoSareb}'
							}						
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.tipo.cuota.comunidad'),
							reference: 'tipoCuotaComunidadRef',
							bind : {
				        		store: '{comboDDTipoCuotaComunidad}',
				        		hidden: '{!isCarteraSareb}',
				        		readOnly: '{!noEditableUASSoloSuper}',
				        		value: '{comercial.tipoCuotaComunidad}'
							}						
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.ggaa.sareb'),
							reference: 'ggaaSarebRef',
							readOnly: true,
			        		editable: false,
							bind : {
				        		store: '{comboSiNoDict}',
				        		hidden: '{!isCarteraSareb}',
				        		value: '{comercial.ggaaSareb}'
							}						
						},{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.segmentacion.sareb'),
							reference: 'segmentacionSarebRef',
							readOnly: true,
			        		editable: false,
							bind : {
				        		store: '{comboSegmetacionSareb}',
				        		hidden: '{!isCarteraSareb}',
				        		value: '{comercial.segmentacionSareb}'
							}						
						},{
							xtype:'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.combo.obra.nueva.comercializacion'),					
							reference:'activoObraNuevaComercializacion',
					        bind: {
				            	store: '{comboSiNoDict}',
				            	readOnly: '{!esPerfilSuperYSupercomercial}',
				            	value:'{comercial.activoObraNuevaComercializacion}'
				           	}
						},{
							xtype: 'datefieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.combo.obra.nueva.f.comercializacion'),
				        	reference: 'activoObraNuevaComercializacionFecha',
				        	readOnly:true,
				        	colspan:2,
				        	 bind: {
				        	 	value:'{comercial.activoObraNuevaComercializacionFecha}'
				        	 }
						},
						{
						   xtype: 'checkboxfieldbase',
						   fieldLabel: HreRem.i18n('fieldlabel.necesidadIf'),
						   reference: 'necesidadIfActivoRef',
						   //allowBlank: false,
						   bind : {
					     		value: '{comercial.necesidadIfActivo}'
					     		//hidden: '{esCarteraSarebBbvaBankiaCajamarLiberbank}'
						   },
						   hidden: true
						},
						{
			    			xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							collapsible: true,
							reference: 'informacionBC',
							title: HreRem.i18n('title.informacion.BC'),
							colspan:3,
							bind:{
								hidden: '{!isCarteraBankia}'
							},
							items :
								[
									{
									   xtype: 'checkboxfieldbase',
									   fieldLabel: HreRem.i18n('fieldlabel.necesidad.arras'),
									   reference: 'checkNecesidadArrasRef',
									   allowBlank: true,
									   bind : {
								     		value: '{comercial.necesidadArras}',
								     		readOnly: '{isCarteraBankia}'
									   }						   
									},
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel:	HreRem.i18n('fieldlabel.canal.venta.bc'),
										reference: 'canalVentaBC',
										bind: {
											readOnly: '{!esSuperUsuario}',
											store: '{comboTipoComercializarActivo}',
											value: '{comercial.canalPublicacionVentaCodigo}'
										}
									},
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel:	HreRem.i18n('fieldlabel.canal.alquiler.bc'),
										reference: 'canalAlquilerBC',
										bind: {
											readOnly: '{!esSuperUsuario}',
											store: '{comboTipoComercializarActivo}',
											value: '{comercial.canalPublicacionAlquilerCodigo}'
										}
									},
									{ 
										xtype: 'textareafieldbase',
										fieldLabel:	HreRem.i18n('fieldlabel.motivo.necesidad.arras'),
										reference: 'motivosNecesidadRef',
										bind: {								
											value: '{comercial.motivosNecesidadArras}',
											disabled: '{!comercial.necesidadArras}',
											readOnly: '{isCarteraBankia}'
										}
									},
									{
										xtype: 'comboboxfieldbase',
										fieldLabel:	HreRem.i18n('fieldlabel.tributacion.propuesta.cliente.exento.iva'),
										reference: 'tributacionPropuestaClienteExentoIvaRef',										
										bind: {
											editable:true,
											readOnly: false,
											store: '{comboTributPropClienteExentoIva}',
											value: '{comercial.tributacionPropuestaClienteExentoIvaCod}'
										}
									},
									{
										xtype: 'comboboxfieldbase',
										fieldLabel:	HreRem.i18n('fieldlabel.tributacion.propuesta.venta'),
										reference: 'tributacionPropuestaVentaRef',

										bind: {
											editable:true,
											
											store: '{comboTributacionPropuestaVenta}',
											value: '{comercial.tributacionPropuestaVentaCod}'
										}
									},
									{
									   xtype: 'checkboxfieldbase',
									   fieldLabel: HreRem.i18n('fieldlabel.cartera.concentrada'),
									   reference: 'carteraConcentradaRef',
									   readOnly: true,
									   bind : {
								     		value: '{comercial.carteraConcentrada}'
									   }						   
									},
									{
									   xtype: 'checkboxfieldbase',
									   fieldLabel: HreRem.i18n('fieldlabel.activo.aamm'),
									   reference: 'activoAAMMRef',
									   readOnly: true,
									   bind : {
								     		value: '{comercial.activoAAMM}'
									   }						   
									},
									{
									   xtype: 'checkboxfieldbase',
									   fieldLabel: HreRem.i18n('fieldlabel.activo.promociones.estrategicas'),
									   reference: 'activoPromocionesEstrategicasRef',
									   readOnly: true,
									   bind : {
								     		value: '{comercial.activoPromocionesEstrategicas}'
									   }						   
									},
									{
							        	xtype: 'datefieldbase',
							        	fieldLabel: HreRem.i18n('fieldlabel.fecha.inicio.concurrencia'),
							        	reference: 'fechaInicioConcurrenciaRef',
							        	bind : {
							        		readOnly: true,
							        		value: '{comercial.fechaInicioConcurrencia}'
							        	}
									},
									{
							        	xtype: 'datefieldbase',
							        	fieldLabel: HreRem.i18n('fieldlabel.fecha.fin.concurrencia'),
							        	reference: 'fechaFinConcurrenciaRef',
							        	bind : {
							        		readOnly: true,
							        		value: '{comercial.fechaFinConcurrencia}'
							        	}
									},{
							        	xtype: 'displayfieldbase',
							        	fieldLabel: HreRem.i18n('fieldlabel.campanya.venta'),
							        	reference: 'campanyaVentaRef',
							        	bind : {
							        		value: '{comercial.campanyaVenta}'
							        	}
									},{
							        	xtype: 'displayfieldbase',
							        	fieldLabel: HreRem.i18n('fieldlabel.campanya.alquiler'),
							        	reference: 'campanyaAlquilerRef',
							        	bind : {
							        		value: '{comercial.campanyaAlquiler}'
							        	}
									},
									{
										xtype:'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.activobbva.tipoTransmision'),
										bind: {											
											store: '{comboTipoTransmision}',
											value: '{comercial.tipoTransmisionCodigo}',
											rawValue: '{comercial.tipoTransmisionDescripcion}'
										}
									}
									
								]
						}
				]
			}, 
			{
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				collapsible: true,
				reference: 'autorizacionTramOfertas',
				hidden: true,
				title: HreRem.i18n('title.autorizacion.tramitacion.ofertas'),
				items :
					[{
						xtype : 'comboboxfieldbasedd',
			        	fieldLabel: HreRem.i18n('fieldlabel.motivo.autorizacion'),
			        	reference: 'motivoAutorizacionTramitacionCodigo',
			        	editable: true,
			        	bind : {
						      store : '{comboMotivoAutorizacionTramitacion}',
						      rawValue : '{comercial.motivoAutorizacionTramitacionDescripcion}',
						      value : '{comercial.motivoAutorizacionTramitacionCodigo}'
			        	}
					},
					{
						xtype: 'textareafieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.observaciones'),
			        	reference: 'observacionesAutorizacionTramite',
						maxLength: 250,
						bind:{
							value: '{comercial.observacionesAutoTram}',
							disabled: '{!esOtrosotivoAutorizacionTramitacion}'
						}

					},
					{
						xtype: 'button',
						text: HreRem.i18n('btn.autorizar.tramitacion.ofertas'),
						reference: 'insertarAutoTramOfer',
						handler: 'onInsertarAutorizacionTramOfertas',
						bind: {
							disabled: '{!esSelecionadoAutorizacionTramitacion}'	
						}
					}
				]
			},
			{
				xtype: 'comercialactivotabpanel' 
			}
    	];

    	me.callParent();
    	
    },

    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.lookupController().cargarTabDataComercial(me);
		me.up('activosdetallemain').lookupReference('comercialactivotabpanelref').funcionRecargar();
		me.evaluarEdicion();
		
		if(me.up('activosdetallemain').lookupReference('ofertascomercialactivolistref')){
			me.up('activosdetallemain').lookupReference('ofertascomercialactivolistref').calcularMostrarBotonClonarExpediente();
		}
    },
    
   evaluarEdicion: function() {
		var me = this;
		var activo = me.lookupController().getViewModel().get('activo');
		
		var noContieneTipoAlquiler = false;
		
		 
		if (activo.get('incluyeDestinoComercialAlquiler')) {
			var codigoTipoAlquiler = activo.get('tipoAlquilerCodigo');
			if (codigoTipoAlquiler == null || codigoTipoAlquiler == '') {
				noContieneTipoAlquiler = true;
			}
		}
		
		
		if(activo.get('incluidoEnPerimetro')=="false" || !activo.get('aplicaComercializar') || activo.get('pertenceAgrupacionRestringida')
			|| activo.get('isVendido') || !$AU.userHasFunction('EDITAR_LIST_OFERTAS_ACTIVO') || noContieneTipoAlquiler) {
			me.up('activosdetallemain').lookupReference('ofertascomercialactivolistref').setTopBar(false);
		}
		else{
			me.up('activosdetallemain').lookupReference('ofertascomercialactivolistref').setTopBar(true);
		}		
   }
});