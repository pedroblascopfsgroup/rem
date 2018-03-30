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
					'HreRem.view.activos.detalle.HistoricoCondicionesList', 'HreRem.model.EstadoPublicacion', 'HreRem.view.activos.detalle.HistoricoEstadosPublicacionList'],
	listeners	: {
		boxready:'cargarTabData',
        activate:'onActivateTabDatosPublicacion'
	},

	initComponent: function () {
		var me = this;
		me.setTitle(HreRem.i18n('title.datos.publicacion.activo'));

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
										columns: 3,
										rAttrs: {height: '30px', width: '100%'},
										tdAttrs: {width: '33%'},
										tableAttrs: {
											style: {
												width: '100%'
											}
										}
									},
									items :
										[
											{
												fieldLabel:  HreRem.i18n('fieldlabel.datos.publicacion.estados.estado.venta'),
												bind: '{datospublicacionactivo.estadoPublicacionVenta}',
												readOnly: true
											},
											{
												xtype: 'currencyfieldbase',
												fieldLabel:  HreRem.i18n('fieldlabel.datos.publicacion.estados.precio.web'),
												bind: '{datospublicacionactivo.precioWebVenta}',
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
												bind: {
													readOnly: '{datospublicacionactivo.deshabilitarCheckPublicarVenta}',
													value: '{datospublicacionactivo.publicarVenta}'
												}
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
												}
											},
											{
												fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.publicar.sin.precio'),
												reference: 'chkbxpublicarsinprecioventa',
												bind: {
													readOnly: '{datospublicacionactivo.deshabilitarCheckPublicarSinPrecioVenta}',
													value: '{datospublicacionactivo.publicarSinPrecioVenta}'
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
												bind: {
													readOnly: '{datospublicacionactivo.deshabilitarCheckOcultarVenta}',
													store: '{comboMotivosOcultacion}',
													value: '{datospublicacionactivo.motivoOcultacionVentaCodigo}'
												},
												listeners: {
													change: 'onChangeComboMotivoOcultacion'
												}
											},
											{
												xtype: 'label',
												colspan: 2
											},
											{
												xtype: 'label',
												colspan: 1
											},
											{
												xtype: 'textareafieldbase',
												reference: 'textareaMotivoOcultacionManualVenta',
												disabled: true,
												bind: {
													readOnly: '{datospublicacionactivo.deshabilitarCheckOcultarVenta}',
													value: '{datospublicacionactivo.motivoOcultacionManualVenta}'
												},
												maxLength: 200,
												height: 80
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
										columns: 3,
										rAttrs: {height: '30px', width: '100%'},
										tdAttrs: {width: '33%'},
										tableAttrs: {
											style: {
												width: '100%'
											}
										}
									},
									items :
										[
											{
												fieldLabel:  HreRem.i18n('fieldlabel.datos.publicacion.estados.estado.alquiler'),
												bind: '{datospublicacionactivo.estadoPublicacionAlquiler}',
												readOnly: true
											},
											{
												xtype: 'currencyfieldbase',
												fieldLabel:  HreRem.i18n('fieldlabel.datos.publicacion.estados.precio.web'),
												bind: '{datospublicacionactivo.precioWebAlquiler}',
												readOnly: true
											},
											{
                                                xtype: 'comboboxfieldbase',
                                                fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.adecuacion'),                                                
                                                bind: {
                                                    store: '{comboAdecuacionAlquiler}',
                                                    value: '{datospublicacionactivo.adecuacionAlquilerCodigo}'
                                                },
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
												reference: 'chkbxpublicaralquiler',
												bind: {
													readOnly: '{datospublicacionactivo.deshabilitarCheckPublicarAlquiler}',
													value: '{datospublicacionactivo.publicarAlquiler}'
												}
											},
											{
												fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.ocultar'),
												reference: 'chkbxocultaralquiler',
												comboRefChained: 'comboMotivoOcultacionAlquiler',
												bind: {
													readOnly: '{datospublicacionactivo.deshabilitarCheckOcultarAlquiler}',
													value: '{datospublicacionactivo.ocultarAlquiler}'
												},
												listeners: {
                                                    dirtychange: 'onChangeCheckboxOcultar'
                                                }
											},
											{
												fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.publicar.sin.precio'),
												reference: 'chkbxpublicarsinprecioalquiler',
												bind: {
													readOnly: '{datospublicacionactivo.deshabilitarCheckPublicarSinPrecioAlquiler}',
													value: '{datospublicacionactivo.publicarSinPrecioAlquiler}'
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
									        	bind: {
								            		readOnly: '{datospublicacionactivo.deshabilitarCheckOcultarAlquiler}',
								            		store: '{comboMotivosOcultacion}',
								            		value: '{datospublicacionactivo.motivoOcultacionAlquilerCodigo}'
								            	},
					    						listeners: {
								                	change: 'onChangeComboMotivoOcultacion'
								            	}
									        },
									        {
												xtype: 'label',
												colspan: 2
											},
											{
												xtype: 'label',
												colspan: 1
											},
											{
												xtype: 'textareafieldbase',
												reference: 'textareaMotivoOcultacionManualAlquiler',
												disabled: true,
												bind: {
													readOnly: '{datospublicacionactivo.deshabilitarCheckOcultarAlquiler}',
													value: '{datospublicacionactivo.motivoOcultacionManualAlquiler}'
												},
												maxLength: 200,
												height: 80
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
							trAttrs: {height: '30px', width: '100%'},
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
												reference: "historicocondicioneslist"
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
									fieldLabel: HreRem.i18n('title.publicaciones.estados.totalDiasPublicado'),
									bind: '{datospublicacionactivo.totalDiasPublicadoVenta}',
									readOnly: true
								},
								{
									fieldLabel: HreRem.i18n('title.publicaciones.estado.portalesExternos'),
									bind: '{activoCondicionantesDisponibilidad.portalesExternosDescripcion}',
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
									fieldLabel: HreRem.i18n('title.publicaciones.estados.totalDiasPublicado'),
									bind: '{datospublicacionactivo.totalDiasPublicadoAlquiler}',
									readOnly: true
								},
								{
									fieldLabel: HreRem.i18n('title.publicaciones.estado.portalesExternos'),
									bind: '{activoCondicionantesDisponibilidad.portalesExternosDescripcion}',
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
	}
});