Ext.define('HreRem.view.agrupaciones.detalle.DatosPublicacionAgrupacion', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'datospublicacionagrupacion',
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
	scrollable	: 'y',
	refreshAfterSave: true,
	disableValidation: false,
	recordName	: 'datospublicacionagrupacion',
	recordClass : 'HreRem.model.DatosPublicacionAgrupacion', 
	requires	: ['HreRem.model.DatosPublicacionAgrupacion', 'HreRem.model.HistoricoEstadosPublicacion', 'HreRem.view.activos.detalle.HistoricoEstadosPublicacionList', 'HreRem.model.CondicionEspecificaAgrupacion', 'HreRem.view.activos.detalle.HistoricoCondicionesList'],
	listeners	: {
		boxready:'cargarTabData',
		activate:'onActivateTabDatosPublicacion'
	},

    initComponent: function () {    	
        var me = this;
        me.setTitle(HreRem.i18n('title.publicacion'));

        me.items = [
// Resumen estado publicación
			{
				xtype:'fieldsettable',
				title: HreRem.i18n('title.datos.publicacion.informaciongeneral'),
				items :
				[
					{
						xtype: 'textfieldbase',
						fieldLabel:  HreRem.i18n('fieldlabel.perimetro.destino.comercial'),
						bind: '{agrupacionficha.tipoComercializacionDescripcion}',
						readOnly: true
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel:  HreRem.i18n('title.publicaciones.estadoDisponibilidadComercial'),
						reference: 'fieldEstadoDisponibilidadComercial',
						bind: {
							store: '{storeEstadoDisponibilidadComercial}',
							value: '{datospublicacionagrupacion.estadoCondicionadoCodigo}'
						},
						readOnly: true
					}
				]
			},
// Estados de Publicación Venta
			{
				xtype: 'fieldsettable',
				title: HreRem.i18n('title.datos.publicacion.estados.venta'),
				bind: {
					hidden: '{!agrupacionficha.incluyeDestinoComercialVenta}'
				},
				items: [
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
						items: [
							{
								fieldLabel:  HreRem.i18n('fieldlabel.datos.publicacion.estados.estado.venta'),
								bind: '{datospublicacionagrupacion.estadoPublicacionVenta}',
								readOnly: true
							},
							{
								xtype: 'currencyfieldbase',
								fieldLabel:  HreRem.i18n('fieldlabel.datos.publicacion.estados.precio.web'),
								bind: '{datospublicacionagrupacion.precioWebVenta}',
								readOnly: true
							},
							{
                                xtype: 'datefieldbase',
                                fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.estado.fecha'),
                                bind: '{datospublicacionagrupacion.fechaInicioEstadoVenta}',
                                readOnly: true
                            },
                            {
                                fieldLabel:  HreRem.i18n('fieldlabel.datos.publicacion.estados.tipo.publicacion'),
                                bind: '{datospublicacionagrupacion.tipoPublicacionVentaDescripcion}',
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
						items: [
							{
								fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.publicar'),
								reference: 'chkbxpublicarventa',
								textareaRefChained: 'textareaMotivoPublicacionVenta',
								bind: {
									readOnly: '{datospublicacionagrupacion.deshabilitarCheckPublicarVenta}',
									value: '{datospublicacionagrupacion.publicarVenta}'
								},
								listeners: {
									dirtychange: 'onChangeCheckboxPublicarVenta'
								}
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.ocultar'),
								reference: 'chkbxocultarventa',
								comboRefChained: 'comboMotivoOcultacionVenta',
								bind: {
									readOnly: '{datospublicacionagrupacion.deshabilitarCheckOcultarVenta}',
									value: '{datospublicacionagrupacion.ocultarVenta}'
								},
								listeners: {
									dirtychange: 'onChangeCheckboxOcultar'
								}
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.publicar.sin.precio'),
								reference: 'chkbxpublicarsinprecioventa',
								bind: {
									readOnly: '{datospublicacionagrupacion.deshabilitarCheckPublicarSinPrecioVenta}',
									value: '{datospublicacionagrupacion.publicarSinPrecioVenta}'
								},
                                listeners: {
                                     dirtychange: 'onChangeCheckboxPublicarSinPrecioVenta'
                                }
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.no.mostrar.precio'),
								reference: 'chkbxnomostrarprecioventa',
								bind: {
									readOnly: '{datospublicacionagrupacion.deshabilitarCheckNoMostrarPrecioVenta}',
									value: '{datospublicacionagrupacion.noMostrarPrecioVenta}'
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
									readOnly: '{datospublicacionagrupacion.deshabilitarCheckOcultarVenta}',
									store: '{comboMotivosOcultacionVenta}',
									value: '{datospublicacionagrupacion.motivoOcultacionVentaCodigo}'
								},
								listeners: {
									change: 'onChangeComboMotivoOcultacion'
								}
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
								disabled: true,
								bind: {
									value: '{datospublicacionagrupacion.motivoPublicacion}'
								},
								maxLength: 200,
								height: 80
							},
							{
								xtype: 'textareafieldbase',
								reference: 'textareaMotivoOcultacionManualVenta',
								bind: {
									readOnly: '{datospublicacionagrupacion.deshabilitarCheckOcultarVenta}',
									value: '{datospublicacionagrupacion.motivoOcultacionManualVenta}'
								},
								maxLength: 200,
								height: 80
							}
						]
					}
				]
			},
// Estados de Publicación Alquiler
			{
				xtype: 'fieldsettable',
				title: HreRem.i18n('title.datos.publicacion.estados.alquiler'),
				bind: {
					hidden: '{!agrupacionficha.incluyeDestinoComercialAlquiler}'
				},
				items: [
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
						items : [
							{
								fieldLabel:  HreRem.i18n('fieldlabel.datos.publicacion.estados.estado.alquiler'),
								bind: '{datospublicacionagrupacion.estadoPublicacionAlquiler}',
								readOnly: true
							},
							{
								xtype: 'currencyfieldbase',
								fieldLabel:  HreRem.i18n('fieldlabel.datos.publicacion.estados.precio.web'),
								bind: '{datospublicacionagrupacion.precioWebAlquiler}',
								readOnly: true
							},
                            {
                                xtype: 'datefieldbase',
                                fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.estado.fecha'),
                                bind:		'{datospublicacionagrupacion.fechaInicioEstadoAlquiler}',
                                readOnly	: true
                            },
                            {
                                 fieldLabel:  HreRem.i18n('fieldlabel.datos.publicacion.estados.tipo.publicacion'),
                                 bind: '{datospublicacionagrupacion.tipoPublicacionAlquilerDescripcion}',
                                 readOnly: true
                            },
                            {
                                xtype: 'comboboxfieldbase',
                                fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.adecuacion'),
                                bind: {
                                    store: '{comboAdecuacionAlquiler}',
                                    value: '{datospublicacionagrupacion.adecuacionAlquilerCodigo}'
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
						items: [
							{
								fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.publicar'),
								reference: 'chkbxpublicaralquiler',
								bind: {
									readOnly: '{datospublicacionagrupacion.deshabilitarCheckPublicarAlquiler}',
									value: '{datospublicacionagrupacion.publicarAlquiler}'
								},
                                listeners: {
                                     dirtychange: 'onChangeCheckboxPublicarAlquiler'
                                }
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.ocultar'),
								reference: 'chkbxocultaralquiler',
								comboRefChained: 'comboMotivoOcultacionAlquiler',
								bind: {
									readOnly: '{datospublicacionagrupacion.deshabilitarCheckOcultarAlquiler}',
									value: '{datospublicacionagrupacion.ocultarAlquiler}'
								},
								listeners: {
                                    dirtychange: 'onChangeCheckboxOcultar'
                                }
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.publicar.sin.precio'),
								reference: 'chkbxpublicarsinprecioalquiler',
								bind: {
									readOnly: '{datospublicacionagrupacion.deshabilitarCheckPublicarSinPrecioAlquiler}',
									value: '{datospublicacionagrupacion.publicarSinPrecioAlquiler}'
								},
                                listeners: {
                                     dirtychange: 'onChangeCheckboxPublicarSinPrecioAlquiler'
                                }
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.datos.publicacion.estados.no.mostrar.precio'),
								reference: 'chkbxnomostrarprecioalquiler',
								bind: {
									readOnly: '{datospublicacionagrupacion.deshabilitarCheckNoMostrarPrecioAlquiler}',
									value: '{datospublicacionagrupacion.noMostrarPrecioAlquiler}'
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
				            		readOnly: '{datospublicacionagrupacion.deshabilitarCheckOcultarAlquiler}',
				            		store: '{comboMotivosOcultacionAlquiler}',
				            		value: '{datospublicacionagrupacion.motivoOcultacionAlquilerCodigo}'
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
								bind: {
									readOnly: '{datospublicacionagrupacion.deshabilitarCheckOcultarAlquiler}',
									value: '{datospublicacionagrupacion.motivoOcultacionManualAlquiler}'
								},
								maxLength: 200,
								height: 80
							}
						]
					}
				]
			},
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
				items : [
					// Condicionantes a la disponibilidad.
					{
						xtype: 'fieldsettable',
						defaultType: 'button',
						title: HreRem.i18n('title.publicaciones.condicionantes'),
						border: false,
						collapsible: false,
						collapsed: false,
						items: [
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
									value: '{datospublicacionagrupacion.otro}',
									hidden: '{!datospublicacionagrupacion.otro}'
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
						items: [
							{
								xtype: "historicocondicioneslist",
								reference: "historicocondicioneslist",
								idPrincipal : 'datospublicacionagrupacion.id',	
								propagationButton: true,
								targetGrid	: 'condicionesespecificas',	
							    bind: {
							        store: '{historicocondicionesagrupacion}'
							    },
							    confirmBeforeSave : true,
							    
							    dockedItems : [
				      		        {
				      		            xtype: 'pagingtoolbar',
				      		            dock: 'bottom',
				      		            itemId: 'activosPaginationToolbar',
				      		            inputItemWidth: 60,
				      		            displayInfo: true,
				      		            bind: {
				      		                store: '{historicocondicionesagrupacion}'
				      		            }
				      		        }
				      		    ]
							}
						]
					}
				]
			},
			
// Histórico de estados de publicación venta
			{
				xtype: 'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.publicaciones.historico.venta'),
				bind: {
					hidden: '{!agrupacionficha.incluyeDestinoComercialVenta}'
				},
				items: [
					{
						xtype: "historicoestadospublicacionlist",
						reference: "historicoestadospublicacionventalist",
						colspan: 3,
						bind: {store: '{historicoEstadosPublicacionVenta}'},
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
						bind: '{datospublicacionagrupacion.totalDiasPublicadoVenta}',
						readOnly: true
					},
					{
						fieldLabel: HreRem.i18n('title.publicaciones.estado.portalesExternos'),
						bind: '{datospublicacionagrupacion.portalesExternosDescripcion}',
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
					hidden: '{!agrupacionficha.incluyeDestinoComercialAlquiler}'
				},
				items: [
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
						bind: '{datospublicacionagrupacion.totalDiasPublicadoAlquiler}',
						readOnly: true
					},
					{
						fieldLabel: HreRem.i18n('title.publicaciones.estado.portalesExternos'),
						bind: '{datospublicacionagrupacion.portalesExternosDescripcion}',
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