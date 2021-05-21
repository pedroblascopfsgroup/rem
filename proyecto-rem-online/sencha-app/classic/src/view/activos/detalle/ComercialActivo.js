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
				listeners:
				{
					afterrender: 'isNotCarteraBankia'
				},
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
				        	xtype : 'comboboxfieldbasedd',
				        	fieldLabel: HreRem.i18n('header.estado.comercial.venta'),
				        	reference: 'estadoComercialVentaRef',
				        	readOnly: true,
				        	bind : {
							      store : '{comboEstadoComercialVenta}',
							      value : '{comercial.estadoComercialVentaCodigo}',
							      rawValue : '{comercial.estadoComercialVentaDescripcion}'
							}
//				        	,
//							listeners:{
//								afterrender: 'isNotCarteraBankia'
//							}
				        },
				        {
				        	xtype: 'datefieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.fecha.estado.comercial.venta'),
				        	reference: 'fechaEstadoComericalVentaRef',
				        	allowBlank: false,
				        	readOnly: true,
				        	bind : {
				        		value: '{comercial.fechaEstadoComercialVenta}'
				        	}
						},
				        {
				        	xtype : 'comboboxfieldbasedd',
				        	fieldLabel: HreRem.i18n('header.estado.comercial.alquiler'),
				        	reference: 'estadoComercialAlquilerRef',
				        	readOnly: true,
				        	bind : {
							      store : '{comboEstadoComercialAlquiler}',
							      value : '{comercial.estadoComercialAlquilerCodigo}',
							      rawValue : '{comercial.estadoComercialAlquilerDescripcion}'
							}
//							,
//							listeners:{
//								afterrender: 'isNotCarteraBankia'
//							}
				        },
				        {
				        	xtype: 'datefieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.fecha.estado.comercial.alquiler'),
				        	reference: 'fechaEstadoComericalAlquilerRef',
				        	allowBlank: false,
				        	readOnly: true,
				        	bind : {
				        		value: '{comercial.fechaEstadoComercialAlquiler}'
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
					        bind: {
				            	store: '{comboSiNoBoolean}',
				            	value:'{comercial.ventaSobrePlano}',
				            	readOnly: true  //'{!esAgrupacionObraNueva}'
				           	}
						},{
							xtype:'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.combo.obra.nueva.comercializacion'),					
							reference:'activoObraNuevaComercializacion',
					        bind: {
				            	store: '{comboSiNoDict}',
				            	value:'{comercial.activoObraNuevaComercializacion}',
				            	readOnly: '{!esPerfilSuperYSupercomercial}' 
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
						   fieldLabel: HreRem.i18n('fieldlabel.necesidad.arras'),
						   reference: 'checkNecesidadArrasRef',
						   allowBlank: false,
						   bind : {
					     		value: '{comercial.necesidadArras}',
					     		readOnly: true
						   }						   
						},
						{ 
							xtype: 'comboboxfieldbasedd',
							fieldLabel:	HreRem.i18n('fieldlabel.motivo.necesidad.arras'),
							reference: 'motivoNecesidadRef',
							bind: {								
								//readOnly: '{!editableCES}',
								readOnly: true,
								store: '{comboMotivoNecesidadArras}',
								value: '{comercial.motivoNecesidadArrasCod}',
								rawValue: '{comercial.motivoNecesidadArrasDesc}',
								disabled: '{!comercial.necesidadArras}'/*,
								hidden: 'isNotCarteraBankia'*/
							}
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
						      value : '{comercial.motivoAutorizacionTramitacionCodigo}',
						      rawValue : '{comercial.motivoAutorizacionTramitacionDescripcion}'
						      
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