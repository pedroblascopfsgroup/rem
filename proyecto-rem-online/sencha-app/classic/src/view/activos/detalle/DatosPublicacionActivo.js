Ext.define('HreRem.view.activos.detalle.DatosPublicacionActivo', {
	extend		: 'HreRem.view.common.FormBase',
	xtype		: 'datospublicacionactivo',
	cls			: 'panel-base shadow-panel',
	collapsed	: false,
	scrollable	: 'y',
	saveMultiple: true,
	refreshAfterSave: true,
	disableValidation: false,
	records		: ['datospublicacionactivo', 'activoCondicionantesDisponibilidad'],
	recordsClass: ['HreRem.model.DatosPublicacionActivo', 'HreRem.model.ActivoCondicionantesDisponibilidad'],
	requires	: ['HreRem.model.ActivoCondicionantesDisponibilidad', 'HreRem.model.DatosPublicacionActivo', 'HreRem.model.CondicionEspecifica',
					'HreRem.view.activos.detalle.HistoricoCondicionesList', 'HreRem.model.HistoricoEstadosPublicacion', 'HreRem.view.activos.detalle.HistoricoEstadosPublicacionList'],
	listeners	: {
		boxready:'cargarTabData',
        activate:'onActivateTabDatosPublicacion'
	},

	initComponent: function () {
		var me = this;
		me.setTitle(HreRem.i18n('title.datos.publicacion.activo'));

		var isCarteraLiberbank = me.lookupViewModel().get('activo.isCarteraLiberbank');

		me.items = [
// Resumen estado publicación.
					{
						xtype:'fieldsettable',
						items :
							[
								{
									xtype: 'textfieldbase',
									fieldLabel:  HreRem.i18n('fieldlabel.perimetro.destino.comercial'),
									bind: '{activo.tipoComercializacionDescripcion}',
									readOnly: true
								},
								{
									xtype: 'comboboxfieldbase',
									fieldLabel:  HreRem.i18n('title.publicaciones.estadoDisponibilidadComercial'),
									reference: 'fieldEstadoDisponibilidadComercial',
									bind: {
										store: '{storeEstadoDisponibilidadComercial}',
										value: '{activoCondicionantesDisponibilidad.estadoCondicionadoCodigo}'
									},
									readOnly: true
								}
							]
					},
// Estados de Publicación Venta.
					{
						xtype: 'fieldsettable',
						title: HreRem.i18n('title.datos.publicacion.estados.venta'),
						bind: {
							hidden: '{!activo.incluyeDestinoComercialVenta}'
						},
						items:
							[
								{
									xtype: 'panel',
									defaultType: 'textfieldbase',
									cls: 'panel-fieldset-base',
									colspan: 3,
									layout: {
										type: 'table',
										columns: 4,
										rAttrs: {height: '30px', width: '100%'},
										tdAttrs: {width: '25%'},
										tableAttrs: {
											style: {
												width: '100%'
											}
										}
									},
									items :
										[
											
											{
									        	xtype:'fieldset',
									        	height: '100%',
									        	border: false,
												layout: {
												        type: 'table',
												        // The total column count must be specified here
												        columns: 2,
												        trAttrs: {height: '30px', width: '100%'},
												        tdAttrs: {width: '55%'},
												        tableAttrs: {
												            style: {
												                width: '100%'
																}
												        }
												},
									        	defaultType: 'textfieldbase',
												rowspan: 1,
												items: [
													{ 	
										            	hidden: true
													},
											        {
														fieldLabel:  HreRem.i18n('fieldlabel.datos.publicacion.estados.estado.venta'),
														bind: '{datospublicacionactivo.estadoPublicacionVenta}',
														readOnly: true,
										            	labelWidth: 140,
										            	width: 240,
										            	style:'margin-top:10px'
											        },
											        {
														fieldLabel:  HreRem.i18n('fieldlabel.ultima.modificacion'),
														bind: '{datospublicacionactivo.diasCambioPublicacionVenta}',
														readOnly: true,
														hidden: (me.lookupController().getViewModel().get('activo').get('entidadPropietariaCodigo')!=CONST.CARTERA['BANKIA']),
										            	labelWidth: 90,
										            	width: 60,
										            	style:'margin-top:10px'
											        }


												]
											},
											{
									        	xtype:'fieldset',
									        	height: '100%',
									        	border: false,
												layout: {
												        type: 'table',
												        // The total column count must be specified here
												        columns: 2,
												        trAttrs: {height: '30px', width: '100%'},
												        tdAttrs: {width: '50%'},
												        tableAttrs: {
												            style: {
												                width: '100%'
																}
												        }
												},
									        	defaultType: 'textfieldbase',
												rowspan: 1,
												items: [
													{ 	
										            	hidden: true
													},
											        {
														xtype: 'currencyfieldbase',
														fieldLabel:  HreRem.i18n('fieldlabel.datos.publicacion.estados.precio.web'),
														reference: 'precioWebVenta',
														bind: '{onInitChangePrecioWebVenta}',
														readOnly: true,
										            	labelWidth: 100,
										            	width: 200,
										            	style:'margin-top:10px'
											        },
											        {
														fieldLabel:  HreRem.i18n('fieldlabel.ultima.modificacion'),
														bind: '{datospublicacionactivo.diasCambioPrecioVentaWeb}',
														readOnly: true,
														hidden: (me.lookupController().getViewModel().get('activo').get('entidadPropietariaCodigo')!=CONST.CARTERA['BANKIA']),
										            	labelWidth: 110,
										            	width: 60,
										            	style:'margin-top:10px'
											        }


												]
											},
											{
	                                            xtype: 'datefieldbase',
	                                            fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.estado.fecha'),
	                                            bind:		'{datospublicacionactivo.fechaInicioEstadoVenta}',
	                                            readOnly	: true
	                                        },
	                                        {
                                                fieldLabel:  HreRem.i18n('fieldlabel.datos.publicacion.estados.tipo.publicacion'),
                                                bind: '{esVisibleTipoPublicacionVenta}',
                                                readOnly: true
                                            }
										]
								},
								{
									xtype: 'label',
									colspan: 3
								},
								{
									xtype: 'panel',
									defaultType: 'checkboxfieldbase',
									cls: 'panel-fieldset-base',
									colspan: 3,
									layout: {
										type: 'table',
										columns: 4,
										rAttrs: {height: '30px', width: '100%'},
										tdAttrs: {width: '25%'},
										tableAttrs: {
											style: {
												width: '100%'
											}
										}
									},
									items:
										[
											{
												fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.publicar'),
												reference: 'chkbxpublicarventa',
												textareaRefChained: 'textareaMotivoPublicacionVenta',
												bind: {
													readOnly: '{datospublicacionactivo.deshabilitarCheckPublicarVenta}',
													value: '{datospublicacionactivo.publicarVenta}'
												},
											    listeners: {
											        dirtychange: 'onChangeCheckboxPublicarVenta'
											   },
											   style:'margin-left:10px'
											},
											{   
												reference: 'chkbxpublicarControlPrimeravez',
												value:true,
												hidden:true,
												
												
											},
											   
											{
												fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.ocultar'),
												reference: 'chkbxocultarventa',
												comboRefChained: 'comboMotivoOcultacionVenta',
												bind: {
													readOnly: '{datospublicacionactivo.deshabilitarCheckOcultarVenta}',
													value: '{datospublicacionactivo.ocultarVenta}'
												},
												listeners: {
													dirtychange: 'onChangeCheckboxOcultar'
												},
												style:'margin-left:10px'
											},
											{
												fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.publicar.sin.precio'),
												reference: 'chkbxpublicarsinprecioventa',
												bind: {
													readOnly: '{datospublicacionactivo.deshabilitarCheckPublicarSinPrecioVenta}',
													value: '{datospublicacionactivo.publicarSinPrecioVenta}'
												},
                                                listeners: {
                                                     dirtychange: 'onChangeCheckboxPublicarSinPrecioVenta'
                                                }
											},
											{
												fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.no.mostrar.precio'),
												reference: 'chkbxnomostrarprecioventa',
												bind: {
													readOnly: '{datospublicacionactivo.deshabilitarCheckNoMostrarPrecioVenta}',
													value: '{datospublicacionactivo.noMostrarPrecioVenta}'
												}
												
											},
											{
												xtype: 'label',
												colspan: 1
											},
											{
												xtype: 'comboboxfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.motivos.ocultacion'),
												reference: 'comboMotivoOcultacionVenta',
												textareaRefChained: 'textareaMotivoOcultacionManualVenta',
												disabled: true,
												bind: {
													store: '{comboMotivosOcultacionVenta}',
													value: '{datospublicacionactivo.motivoOcultacionVentaCodigo}'
												},
												listeners: {
													change: 'onChangeComboMotivoOcultacionVenta'
												},
												style:'margin-left:10px'
											},
											{
												xtype: 'label',
												colspan: 1
											},
											{
												xtype: 'label',
												colspan: 1
											},
											{
												xtype: 'textareafieldbase',
												reference: 'textareaMotivoPublicacionVenta',
												textareaRefChained: 'chkbxpublicarventa',
												flex:1,
												bind: {
													value: '{datospublicacionactivo.motivoPublicacion}',
													disabled: '{!datospublicacionactivo.publicarVenta}'
												},
												maxLength: 200,
												width: 400,
												height: 80,
												style:'margin-bottom:10px'
											},
											{
												xtype: 'textareafieldbase',
												reference: 'textareaMotivoOcultacionManualVenta',
												disabled: true,
												bind: {
													value: '{datospublicacionactivo.motivoOcultacionManualVenta}'
												},
												maxLength: 200,
												width: 400,
												height: 80,
												style:'margin-bottom:10px'
											}
										]
								}
							]
					},
// Estados de Publicación Alquiler.
					{
						xtype: 'fieldsettable',
						title: HreRem.i18n('title.datos.publicacion.estados.alquiler'),
						bind: {
							hidden: '{!activo.incluyeDestinoComercialAlquiler}'
						},
						items:
							[
								{
									xtype: 'panel',
									defaultType: 'textfieldbase',
									cls: 'panel-fieldset-base',
									colspan: 3,
									layout: {
										type: 'table',
										columns: 4,
										rAttrs: {height: '30px', width: '100%'},
										tdAttrs: {width: '25%'},
										tableAttrs: {
											style: {
												width: '100%'
											}
										}
									},
									items :
										[
											{
									        	xtype:'fieldset',
									        	height: '100%',
									        	border: false,
												layout: {
												        type: 'table',
												        // The total column count must be specified here
												        columns: 2,
												        trAttrs: {height: '30px', width: '100%'},
												        tdAttrs: {width: '60%'},
												        tableAttrs: {
												            style: {
												                width: '100%'
																}
												        }
												},
									        	defaultType: 'textfieldbase',
												rowspan: 1,
												items: [
													{ 	
										            	hidden: true
													},
											        {
														fieldLabel:  HreRem.i18n('fieldlabel.datos.publicacion.estados.estado.alquiler'),
														bind: '{datospublicacionactivo.estadoPublicacionAlquiler}',
														readOnly: true,
										            	labelWidth: 140,
										            	width: 240,
										            	style:'margin-top:10px'
											        },
											        {
														fieldLabel:  HreRem.i18n('fieldlabel.ultima.modificacion'),
														bind: '{datospublicacionactivo.diasCambioPublicacionAlquiler}',
														readOnly: true,
														hidden: (me.lookupController().getViewModel().get('activo').get('entidadPropietariaCodigo')!= CONST.CARTERA['BANKIA']),
										            	labelWidth: 90,
										            	width: 60,
										            	style:'margin-top:10px'
											        }


												]
											},
											{
									        	xtype:'fieldset',
									        	height: '100%',
									        	border: false,
												layout: {
												        type: 'table',
												        // The total column count must be specified here
												        columns: 2,
												        trAttrs: {height: '30px', width: '100%'},
												        tdAttrs: {width: '40%'},
												        tableAttrs: {
												            style: {
												                width: '100%'
																}
												        }
												},
									        	defaultType: 'textfieldbase',
												rowspan: 1,
												items: [
													{ 	
										            	hidden: true
													},
											        {
														xtype: 'currencyfieldbase',
														fieldLabel:  HreRem.i18n('fieldlabel.datos.publicacion.estados.precio.web'),
														bind: '{onInitChangePrecioWebAlquiler}',
														readOnly: true,
										            	labelWidth: 100,
										            	width: 200,
										            	style:'margin-top:10px'
											        },
											        {
														fieldLabel:  HreRem.i18n('fieldlabel.ultima.modificacion'),
														bind: '{datospublicacionactivo.diasCambioPrecioAlqWeb}',
														readOnly: true,
														hidden: (me.lookupController().getViewModel().get('activo').get('entidadPropietariaCodigo')!=CONST.CARTERA['BANKIA']),
										            	labelWidth: 110,
										            	width: 60,
										            	style:'margin-top:10px'
											        }


												]
											},
	                                        {
	                                            xtype: 'datefieldbase',
	                                            fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.estado.fecha'),
	                                            bind:		'{datospublicacionactivo.fechaInicioEstadoAlquiler}',
	                                            readOnly	: true
	                                        },
	                                        {
	                                             fieldLabel:  HreRem.i18n('fieldlabel.datos.publicacion.estados.tipo.publicacion'),
	                                             bind: '{esVisibleTipoPublicacionAlquiler}',
	                                             readOnly: true
	                                        },
	                                        {
	                                            xtype: 'comboboxfieldbase',
	                                            fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.adecuacion'),
	                                            bind: {
	                                                store: '{comboAdecuacionAlquiler}',
	                                                value: '{datospublicacionactivo.adecuacionAlquilerCodigo}'
	                                            },
	                                            readOnly: true,
	                                            style:'margin-left:10px'
	                                        }
										]
								},
								{
	                                xtype: 'label',
	                                colspan: 3
	                            },
								{
									xtype: 'panel',
									defaultType: 'checkboxfieldbase',
									cls: 'panel-fieldset-base',
									colspan: 3,
									layout: {
										type: 'table',
										columns: 4,
										rAttrs: {height: '30px', width: '100%'},
										tdAttrs: {width: '25%'},
										tableAttrs: {
											style: {
												width: '100%'
											}
										}
									},
									items:
										[
											{
												fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.publicar'),
												reference: 'chkbxpublicaralquiler',
												bind: {
													readOnly: '{datospublicacionactivo.deshabilitarCheckPublicarAlquiler}',
													value: '{datospublicacionactivo.publicarAlquiler}'
												},
                                                listeners: {
                                                     dirtychange: 'onChangeCheckboxPublicarAlquiler'
                                                },
                                                style:'margin-left:10px'
											},
											{
												fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.ocultar'),
												reference: 'chkbxocultaralquiler',
												comboRefChained: 'comboMotivoOcultacionAlquiler',
												textareaRefChained: 'textareaMotivoOcultacionManualAlquiler',
												bind: {
													readOnly: '{datospublicacionactivo.deshabilitarCheckOcultarAlquiler}',
													value: '{datospublicacionactivo.ocultarAlquiler}'
												},
												listeners: {
                                                    dirtychange: 'onChangeCheckboxOcultar'
                                                },
                                                style:'margin-left:10px'
											},
											{
												fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.publicar.sin.precio'),
												reference: 'chkbxpublicarsinprecioalquiler',
												bind: {
													readOnly: '{datospublicacionactivo.deshabilitarCheckPublicarSinPrecioAlquiler}',
													value: '{datospublicacionactivo.publicarSinPrecioAlquiler}'
												},
	                                            listeners: {
	                                                 dirtychange: 'onChangeCheckboxPublicarSinPrecioAlquiler'
	                                            }
											},
											{
												fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.no.mostrar.precio'),
												reference: 'chkbxnomostrarprecioalquiler',
												bind: {
													readOnly: '{datospublicacionactivo.deshabilitarCheckNoMostrarPrecioAlquiler}',
													value: '{datospublicacionactivo.noMostrarPrecioAlquiler}'
												}
											},
											{
												xtype: 'label',
												colspan: 1
											},
											{
									        	xtype: 'comboboxfieldbase',
									        	fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.motivos.ocultacion'),
												reference: 'comboMotivoOcultacionAlquiler',
												textareaRefChained: 'textareaMotivoOcultacionManualAlquiler',
												disabled: true,
												bind: {
								            		store: '{comboMotivosOcultacionAlquiler}',
								            		value: '{datospublicacionactivo.motivoOcultacionAlquilerCodigo}'
								            	},
												listeners: {
													change: 'onChangeComboMotivoOcultacionAlquiler'
												},
												style:'margin-left:10px'
									        },
									        {
												xtype: 'label',
												colspan: 1
											},
											{
												xtype: 'label',
												colspan: 1
											},
											{
												xtype: 'textareafieldbase',
												reference: 'textareaMotivoPublicacionAlquiler',
												textareaRefChained: 'chkbxpublicaralquiler',
												flex:1,
												disabled: true,
												bind: {
													value: '{datospublicacionactivo.motivoPublicacionAlquiler}',
													disabled: '{!datospublicacionactivo.publicarAlquiler}'
												},
												maxLength: 200,
												width: 400,
												height: 80,
												style:'margin-bottom:10px'
											},
											{
												xtype: 'textareafieldbase',
												reference: 'textareaMotivoOcultacionManualAlquiler',
												disabled: true,
												bind: {
													value: '{datospublicacionactivo.motivoOcultacionManualAlquiler}'
												},
												maxLength: 200,
												width: 400,
												height: 80,
												style:'margin-bottom:10px'
											}
										]
								}
							]
					},
// Circunstancias concretas.
					{
						xtype: 'fieldsettable',
						title: HreRem.i18n('title.publicaciones.circunstancias'),
						layout: {
							type: 'table',
							columns: 1,
							tdAttrs: {width: '100%'},
							tableAttrs: {
								style: {
									width: '100%'
								}
							}
						},
						items :
							[
							// Condicionantes a la disponibilidad.
								{
									xtype: 'fieldsettable',
									defaultType: 'button',
									title: HreRem.i18n('title.publicaciones.condicionantes'),
									border: false,
									collapsible: false,
									collapsed: false,
									items:
										[
											{
												cls: 'no-pointer',
												html: '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.ruina')+'</div>',
												style: 'background: transparent; border: none;',
												bind: {
													iconCls:'{getIconClsCondicionantesRuina}'
												},
												iconAlign:'left'
											},
											{
												cls: 'no-pointer',
												html: '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.pendiente')+'</div>',
												style: 'background: transparent; border: none;',
												bind: {
													iconCls:'{getIconClsCondicionantesPendiente}'
												},
												iconAlign:'left'
											},
											{
												cls: 'no-pointer',
												html: '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.obraterminada')+'</div>',
												style: 'background: transparent; border: none;',
												bind: {
													iconCls: '{getIconClsCondicionantesObraTerminada}'
												},
												iconAlign: 'left'
											},
											{
												cls: 'no-pointer',
												html: '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.sinposesion')+'</div>',
												style: 'background: transparent; border: none;',
												bind: {
													iconCls: '{getIconClsCondicionantesSinPosesion}'
												},
												iconAlign: 'left'
											},
											{
												cls: 'no-pointer',
												html: '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.proindiviso')+'</div>',
												style: 'background: transparent; border: none;',
												bind: {
													iconCls: '{getIconClsCondicionantesProindiviso}'
												},
												iconAlign: 'left'
											},
											{
												cls: 'no-pointer',
												html: '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.obranueva')+'</div>',
												style: 'background: transparent; border: none;',
												bind: {
													iconCls: '{getIconClsCondicionantesObraNueva}'
												},
												iconAlign: 'left'
											},
											{
												cls: 'no-pointer',
												html: '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.ocupadocontitulo')+'</div>',
												style: 'background: transparent; border: none;',
												bind: {
													iconCls: '{getIconClsCondicionantesOcupadoConTitulo}'
												},
												iconAlign: 'left'
											},
											{
												cls: 'no-pointer',
												html: '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.tapiado')+'</div>',
												style: 'background: transparent; border: none;',
												bind: {
													iconCls: '{getIconClsCondicionantesTapiado}'
												},
												iconAlign: 'left'
											},
											{
												cls: 'no-pointer',
												html: '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.ocupadosintitulo')+'</div>',
												style: 'background: transparent; border: none;',
												bind: {
													iconCls: '{getIconClsCondicionantesOcupadoSinTitulo}'
												},
												iconAlign: 'left'
											},
											{
												cls: 'no-pointer',
												html: '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.activodivhorizontal')+'</div>',
												style: 'background: transparent; border: none;',
												bind: {
													iconCls: '{getIconClsCondicionantesDivHorizontal}'
												},
												iconAlign: 'left'
											},
											{
												cls: 'no-pointer',
												html: '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.conCargas')+'</div>',
												style: 'background: transparent; border: none;',
												bind: {
													iconCls: '{getIconClsCondicionantesConCargas}'
												},
												iconAlign: 'left'
											},
											{
												cls: 'no-pointer',
												html: '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.sinInformeAprobado')+'</div>',
												style: 'background: transparent; border: none;',
												bind: {
													iconCls: '{getIconClsCondicionantesSinInformeAprobado}'
												},
												iconAlign: 'left'
											},
											{
						                		xtype: 'button',
						                		cls: 'no-pointer',
									    		html : '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.vandalizado')+'</div>',
									    		style : 'background: transparent; border: none;',
						                		bind: {
						                			iconCls: '{getIconClsCondicionantesVandalizado}'
						                		},
						                		iconAlign: 'left'
						                	},
						                	{
                                                xtype: 'button',
                                                cls: 'no-pointer',
                                                hidden: !isCarteraLiberbank,
                                                html : '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.sinAcceso')+'</div>',
                                                style : 'background: transparent; border: none;',
                                                bind: {
                                                    iconCls: '{getIconClsCondicionantesSinAcceso}'
                                                },
                                                iconAlign: 'left'
                                            },
											{
												xtype: 'comboboxfieldbase',
												fieldLabel:  HreRem.i18n('title.publicaciones.condicion.otro'),
												reference: 'comboCondicionanteOtro',
												bind: {
													store: '{comboSiNoRem}',
													value: '{getSiNoFromOtro}'
												},
												listeners: {
													change: 'onChangeComboOtro'
												}
											},
											{
												xtype: 'textareafieldbase',
												reference: 'fieldtextCondicionanteOtro',
												bind: {
													value: '{activoCondicionantesDisponibilidad.otro}',
													hidden: '{!activoCondicionantesDisponibilidad.otro}'
												},
												maxLength: '255'
											}
										]
								},
								// Condiciones específicas.
								{
									xtype: 'fieldsettable',
									title: HreRem.i18n('title.publicaciones.condiciones.especificas'),
									border: false,
									collapsible: false,
									collapsed: false,
									items:
										[
											{
												xtype: "historicocondicioneslist",
												reference: "historicocondicioneslist",
												idPrincipal : 'activo.id',
												propagationButton: true,
												targetGrid	: 'condicionesespecificas',
											    bind: {
											        store: '{historicocondiciones}'
											    },
											    dockedItems : [
								      		        {
								      		            xtype: 'pagingtoolbar',
								      		            dock: 'bottom',
								      		            itemId: 'activosPaginationToolbar',
								      		            inputItemWidth: 60,
								      		            displayInfo: true,
								      		            bind: {
								      		                store: '{historicocondiciones}'
								      		            }
								      		        }
								      		    ]
											}
										]
								}
							]
					},
// Histórico de estados de publicación venta.
					{
						xtype: 'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.publicaciones.historico.venta'),
						bind: {
							hidden: '{!activo.incluyeDestinoComercialVenta}'
						},
						items:
							[
								{
									xtype: "historicoestadospublicacionlist",
									reference: "historicoestadospublicacionventalist",
									colspan: 3,
									bind:{store: '{historicoEstadosPublicacionVenta}'},
									dockedItems: [
										{
											xtype: 'pagingtoolbar',
											dock: 'bottom',
											displayInfo: true,
											bind: {
												store: '{historicoEstadosPublicacionVenta}'
											}
										}
									]
								},
								{
									fieldLabel: HreRem.i18n('title.publicaciones.estados.totalDiasPublicadoUltimaPublicacion'),
									bind: '{datospublicacionactivo.totalDiasPublicadoVenta}',
									readOnly: true
								},
								{
									fieldLabel: HreRem.i18n('title.publicaciones.estado.portalesExternos'),
									bind: '{activoCondicionantesDisponibilidad.portalesExternosDescripcion}',
									readOnly: true
								},
								{
									fieldLabel: HreRem.i18n('title.publicaciones.estados.totalDiasPublicado'),
									bind: '{datospublicacionactivo.totalDiasPublicadoHistoricoVenta}',
									readOnly: true
								}
								
							]
					},
// Histórico de estados de publicación alquiler.
					{
						xtype: 'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.publicaciones.historico.alquiler'),
						bind: {
							hidden: '{!activo.incluyeDestinoComercialAlquiler}'
						},
						items:
							[
								{
									xtype: "historicoestadospublicacionlist",
									reference: "historicoestadospublicacionalquilerlist",
									colspan: 3,
									bind:{store: '{historicoEstadosPublicacionAlquiler}'},
									dockedItems: [
										{
											xtype: 'pagingtoolbar',
											dock: 'bottom',
											displayInfo: true,
											bind: {
												store: '{historicoEstadosPublicacionAlquiler}'
											}
										}
									]
								},
								{
									fieldLabel: HreRem.i18n('title.publicaciones.estados.totalDiasPublicadoUltimaPublicacion'),
									bind: '{datospublicacionactivo.totalDiasPublicadoAlquiler}',
									readOnly: true
								},
								{
									fieldLabel: HreRem.i18n('title.publicaciones.estado.portalesExternos'),
									bind: '{activoCondicionantesDisponibilidad.portalesExternosDescripcion}',
									readOnly: true
								},
								{
									fieldLabel: HreRem.i18n('title.publicaciones.estados.totalDiasPublicado'),
									bind: '{datospublicacionactivo.totalDiasPublicadoHistoricoAlquiler}',
									readOnly: true
								}
							]
					}
		];

		me.callParent();
	},

	funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
			grid.getStore().load();
		});
		var combo1 = me.down('comboboxfieldbase[reference=comboMotivoOcultacionAlquiler]');
		combo1.setDisabled(true);
		var combo2 = me.down('comboboxfieldbase[reference=comboMotivoOcultacionVenta]');
		combo2.setDisabled(true);
	}
});