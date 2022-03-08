Ext.define('HreRem.view.activos.detalle.ValoresPreciosActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'valorespreciosactivo',    
    scrollable	: 'y',
    refreshAfterSave : true,
    
    listeners: {
    	boxready: function() {
    		var me = this;
    		me.lookupController().cargarTabData(me);
    		me.evaluarEdicion();
    	},
    	afterrender: 'mostrarIsCarteraCaixa'
    },
    
    refreshAfterSave: true,
    
    requires: ['HreRem.model.ActivoValoraciones', 'HreRem.view.activos.DescuentoColectivosGrid', 'HreRem.view.activos.PreciosVigentesCaixaGrid'],

    recordName: "valoraciones",

	recordClass: "HreRem.model.ActivoValoraciones",

    initComponent: function () {

        var me = this;
        
        me.startValidityDate = '';
        me.endValidityDate = '';
        
        me.setTitle(HreRem.i18n('title.valoraciones.precios'));
        
        var items= [
            {
				xtype:'fieldsettable',
				cls: 'fieldset-precios-vigentes',
				title: HreRem.i18n('title.precios.vigentes'),
				reference: 'preciosVigentesRef',
				items :	[
					{
						
							xtype		: 'gridBaseEditableRow',
							reference	: 'gridPreciosVigentes',
							cls			: 'grid-no-seleccionable',
							secFunToEdit: 'EDITAR_GRID_PRECIOS_VIGENTES',
							loadAfterBind	: false,
							colspan		: 3,
							minHeight: 220,
							bind		: {
											store: '{storePreciosVigentes}'
							},

							columns		: {
											defaults: {
							    				menuDisabled: true,
							    				sortable: false
							    			},
											items:[
											   {
												dataIndex: 'descripcionTipoPrecio',
												cls: 'grid-no-seleccionable-primera-col',
								        		tdCls: 'grid-no-seleccionable-td',
												flex: 1.5
											   },
											   {
												text: HreRem.i18n('header.importe'),
												cls: 'grid-no-seleccionable-col',
								        		tdCls: 'grid-no-seleccionable-td',
												dataIndex: 'importe',
												renderer: Utils.rendererCurrency,
									        	editor: {
									        		xtype:'textfield',
									        		maskRe: /[0-9.]/,
									        		allowNegative: false,
									        		minValue: 0,
									        		hideTrigger: true,
									        		keyNavEnable: false,
									        		mouseWheelEnable: false,
									        		allowBlank: false,
									        		validator: function(value){
									        			return this.up('activosdetallemain').getController().validatePreciosVigentes(parseFloat(value));
									        	    }
									        	},
												flex: 1
											   },
												{
													text: HreRem.i18n('header.fecha.aprobacion'),
													cls: 'grid-no-seleccionable-col',
													tdCls: 'grid-no-seleccionable-td',
													dataIndex: 'fechaAprobacion',
													formatter: 'date("d/m/Y")',
													flex: 1,
													bind: {
														enabled: false
													},
													editor: {
														xtype:'datefield',
														enabled: '{activarCamposGridPreciosVigentes}'
													}
												},
											   {
												text: HreRem.i18n('header.fecha.carga'),
												cls: 'grid-no-seleccionable-col',
								        		tdCls: 'grid-no-seleccionable-td',												
												dataIndex: 'fechaCarga',
												formatter: 'date("d/m/Y")',
												flex: 1
											   },
											   {
												text: HreRem.i18n('header.fecha.inicio'),
												cls: 'grid-no-seleccionable-col',
								        		tdCls: 'grid-no-seleccionable-td',												
												dataIndex: 'fechaInicio',
												formatter: 'date("d/m/Y")',
												flex: 1,
												editor:{
						                            xtype: 'datefield',
						                            validationEvent: 'change',
						                            reference: 'dateFieldStartDate',
						                            formatText: "",
						                            validator: function(value){
						                                me.startValidityDate=this.getValue();
						                                if(typeof me.endValidityDate !== 'undefined' && !Ext.isEmpty(me.endValidityDate)) {
						                                    if(!Ext.isEmpty(me.startValidityDate) && (me.startValidityDate <= me.endValidityDate)) {
						                                    	return this.up('activosdetallemain').getController().validateFechas(this, value);
						                                    } else {
						                                        return HreRem.i18n('info.datefield.begin.date.msg.validacion');
						                                    }
						                                } else {
						                                	return this.up('activosdetallemain').getController().validateFechas(this, value);
						                                }
						                            }
												  }
											   },
											   {
												text: HreRem.i18n('header.fecha.fin'),
												cls: 'grid-no-seleccionable-col',
								        		tdCls: 'grid-no-seleccionable-td',												
												dataIndex: 'fechaFin',
												formatter: 'date("d/m/Y")',
												flex: 1,
												editor: {
						                            xtype: 'datefield',
						                            formatText: "",
						                            minText: HreRem.i18n('info.datefield.min.date.msg.validacion'),
						                            validationEvent: 'change',
						                            validator: function(value){
						                            	me.endValidityDate=this.getValue();
						                            	return this.up('activosdetallemain').getController().validateFechas(this, value);
						                            }
						                          }
											   },
											   {
												text: HreRem.i18n('header.gestor'),
												cls: 'grid-no-seleccionable-col',
								        		tdCls: 'grid-no-seleccionable-td',
												dataIndex: 'gestor',
												flex: 1
											   },
											   {
												text: HreRem.i18n('header.observaciones'),
												cls: 'grid-no-seleccionable-col',
								        		tdCls: 'grid-no-seleccionable-td',												
												dataIndex: 'observaciones',
												editor: {xtype:'textarea'},
												flex: 1
											   },
											   {
											        xtype: 'actioncolumn',
											        width: 30,	
											        hideable: false,
											        items: [{
											           	iconCls: 'fa fa-remove',
											           	handler: 'onDeletePrecioVigenteClick'
											        }],
											        hidden: !$AU.userHasFunction('EDITAR_GRID_PRECIOS_VIGENTES')
									    		}
						    				]
							},
							saveSuccessFn: function() {
								this.up('valorespreciosactivo').funcionRecargar();
								this.lookupController().refrescarActivo(true);
							}
					},
					{
						xtype: 'container',
						style: {
							backgroundColor: '#E5F6FE'
						},
						padding: 10,
						margin: '5 8 10 8',
						layout: {
							type: 'hbox'
						},
						items: [
								{
									xtype: 'container',
									layout: 'hbox',
									flex: 0.8,
									items: [
								
												{
													xtype: 'checkboxfieldbase',						
													bind:		'{valoraciones.bloqueoPrecio}',
													listeners: {
														change: 'onChangeBloqueo'
													},
													width: 40
												},
												{
													xtype: 'label',
													cls: 'label-read-only-formulario-completo',
													html: '<span style="font-weight: bold;">' + HreRem.i18n('fieldlabel.bloqueo') + ': </span>' + '<span>' + HreRem.i18n('fieldlabel.txt.precios.bloqueado') + '&nbsp;</span>',
													hidden: true,
													bind: {
														hidden: '{!valoraciones.bloqueoPrecioFechaIni}'
													}
													
												},
												{
													xtype: 'label',
													cls: 'label-read-only-formulario-completo',
													html: '<span style="font-weight: bold;">' + HreRem.i18n('fieldlabel.bloqueo') + ': </span>' + '<span>' + HreRem.i18n('fieldlabel.txt.precios.bloquear') + '&nbsp;</span>',
													hidden: true,
													bind: {
														hidden: '{valoraciones.bloqueoPrecioFechaIni}'
													}
												},
											
												{
													xtype: 'datefieldbase',
													readOnly: true,
													reference: 'bloqueoPrecioFechaIni',
													bind:  '{valoraciones.bloqueoPrecioFechaIni}',
													width: 65
												},
												{
													xtype: 'label',
													cls: 'label-read-only-formulario-completo',
													html: HreRem.i18n('fieldlabel.por.gestor') + '&nbsp;',
													hidden: true,
													bind: {
														hidden: '{!valoraciones.gestorBloqueoPrecio}'
													}
												},
												{
													xtype: 'textfieldbase',
													readOnly: true,
													reference: 'gestorBloqueoPrecio',
													bind: '{valoraciones.gestorBloqueoPrecio}'
												}
									]
								}, 
								{
									xtype: 'container',
									layout: 'hbox',
									flex: 0.2,
									items: [
												{
													xtype: 'label',
													width: 175,
													cls: 'label-read-only-formulario-completo',
													html: '<span style="font-weight: bold; color:#d60a3a">' + HreRem.i18n('msg.activo.en.bolsa.preciar') + '</span>',
													hidden: true, // para evitar que se vea mientras se actualiza el bind
													bind: {
														hidden: '{!valoraciones.incluidoBolsaPreciar}'
													}
													
												},
												{
													xtype: 'label',
													width: 175,
													cls: 'label-read-only-formulario-completo',
													html: '<span style="font-weight: bold; color:#d60a3a">' + HreRem.i18n('msg.activo.en.bolsa.repreciar') + '</span>',
													hidden: true, // para evitar que se vea mientras se actualiza el bind
													bind: {
														hidden: '{!valoraciones.incluidoBolsaRepreciar}'
													}
													
												}
									]
									
								}
						]
					}
				]
            },
            {
            	xtype: 'fieldsettable',
            	cls: 'fieldset-precios-vigentes',
            	title: HreRem.i18n('title.precios.vigentes'),
				reference: 'preciosVigentesRefCaixa',
				items :	[
					{
						xtype: 'preciosvigentescaixagrid',
						reference : 'preciosVigentesCaixaGridRef',
						colspan		: 3
					},
					{
						xtype: 'container',
						style: {
							backgroundColor: '#E5F6FE'
						},
						padding: 10,
						margin: '5 8 10 8',
						layout: {
							type: 'hbox'
						},
						items: [
							{
								xtype: 'container',
								layout: 'hbox',
								flex: 0.8,
								items: [
									{
										xtype: 'checkboxfieldbase',						
										bind:		'{valoraciones.bloqueoPrecio}',
										listeners: {
											change: 'onChangeBloqueo'
										},
										width: 40
									},
									{
										xtype: 'label',
										cls: 'label-read-only-formulario-completo',
										html: '<span style="font-weight: bold;">' + HreRem.i18n('fieldlabel.bloqueo') + ': </span>' + '<span>' + HreRem.i18n('fieldlabel.txt.precios.bloqueado') + '&nbsp;</span>',
										hidden: true,
										bind: {
											hidden: '{!valoraciones.bloqueoPrecioFechaIni}'
										}
										
									},
									{
										xtype: 'label',
										cls: 'label-read-only-formulario-completo',
										html: '<span style="font-weight: bold;">' + HreRem.i18n('fieldlabel.bloqueo') + ': </span>' + '<span>' + HreRem.i18n('fieldlabel.txt.precios.bloquear') + '&nbsp;</span>',
										hidden: true,
										bind: {
											hidden: '{valoraciones.bloqueoPrecioFechaIni}'
										}
									},
								
									{
										xtype: 'datefieldbase',
										readOnly: true,
										reference: 'bloqueoPrecioFechaIni',
										bind:  '{valoraciones.bloqueoPrecioFechaIni}',
										width: 65
									},
									{
										xtype: 'label',
										cls: 'label-read-only-formulario-completo',
										html: HreRem.i18n('fieldlabel.por.gestor') + '&nbsp;',
										hidden: true,
										bind: {
											hidden: '{!valoraciones.gestorBloqueoPrecio}'
										}
									},
									{
										xtype: 'textfieldbase',
										readOnly: true,
										reference: 'gestorBloqueoPrecio',
										bind: '{valoraciones.gestorBloqueoPrecio}'
									}
								]
							}, 
							{
								xtype: 'container',
								layout: 'hbox',
								flex: 0.2,
								items: [
									{
										xtype: 'label',
										width: 175,
										cls: 'label-read-only-formulario-completo',
										html: '<span style="font-weight: bold; color:#d60a3a">' + HreRem.i18n('msg.activo.en.bolsa.preciar') + '</span>',
										hidden: true, // para evitar que se vea mientras se actualiza el bind
										bind: {
											hidden: '{!valoraciones.incluidoBolsaPreciar}'
										}
										
									},
									{
										xtype: 'label',
										width: 175,
										cls: 'label-read-only-formulario-completo',
										html: '<span style="font-weight: bold; color:#d60a3a">' + HreRem.i18n('msg.activo.en.bolsa.repreciar') + '</span>',
										hidden: true, // para evitar que se vea mientras se actualiza el bind
										bind: {
											hidden: '{!valoraciones.incluidoBolsaRepreciar}'
										}
										
									}
								]
							}
						]
					}
				]
            },
            {
            	xtype:'fieldsettable',
				cls: 'fieldset-descuentos-vigentes',
				title: HreRem.i18n('title.descuentos.vigentes'),
				reference: 'descuentosVigentesRef',
				items :	[
					{
						xtype: 'descuentocolectivosgrid',
						reference : 'descuentoColectivosGridRef'
					}
				]
            },
            {
				xtype:'fieldsettable',
				title: HreRem.i18n('title.valores.invariables'),
				items :	[
				   {
					   xtype: 'currencyfieldbase',
					   fieldLabel: HreRem.i18n('fieldlabel.valor.adquisicion.no.judicial'),
					   bind:  {
							value: '{valoraciones.valorAdquisicion}',
							readOnly: '{!activo.isCarteraTitulizada}'
					   },
					   margin: '0 0 0 8'
				   },
				   {
				   		xtype: 'displayfield'
				   		// como separador				   		
				   },
				   {
					   xtype: 'currencyfieldbase',
					   readOnly: '{!activo.isCarteraTitulizada}',
					   fieldLabel: HreRem.i18n('fieldlabel.valor.adquisicion.judicial'),
						bind:  {
							value: '{valoraciones.importeAdjudicacion}',
							readOnly: '{!activo.isCarteraTitulizada}'
					   }
					   
				   }
				]
            },
            {
				xtype:'fieldsettable',
				title: HreRem.i18n('title.valores.variables.vigentes'),
				items :	[
					{
						xtype:'fieldset',
						height: 240,
						margin: '0 10 10 0',
						layout: {
					        type: 'table',
							columns: 1
						},
						defaultType: 'textfieldbase',
						title: HreRem.i18n("title.del.propietario"),
						items :
							[
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.valor.neto.contable'),
							   bind:  '{valoraciones.vnc}',
							   hidden: (me.lookupController().getViewModel().get('activo').get('entidadPropietariaCodigo')!='01')
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.valor.de.referencia'),
							   bind:  '{valoraciones.valorReferencia}',
							   hidden: (me.lookupController().getViewModel().get('activo').get('entidadPropietariaCodigo')!='03')  
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.valor.asesoramiento.liquidativo'),
							   bind:  '{valoraciones.valorAsesoramientoLiquidativo}',
							   hidden: (me.lookupController().getViewModel().get('activo').get('entidadPropietariaCodigo')!='03')
							 },
							 {
							   xtype: 'checkboxfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.precio.venta.negociable'),
							   bind:  '{valoraciones.precioVentaNegociable}',
							   hidden: (me.lookupController().getViewModel().get('activo').get('entidadPropietariaCodigo')!='03')
							 },
							 {
							   xtype: 'checkboxfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.precio.alquiler.negociable'),
							   bind:  '{valoraciones.precioAlquilerNegociable}',
							   hidden: (me.lookupController().getViewModel().get('activo').get('entidadPropietariaCodigo')!='03')
							 },
							 {
							   xtype: 'checkboxfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.campanya.precio.venta.negociable'),
							   bind:  '{valoraciones.campanyaPrecioVentaNegociable}',
							   hidden: (me.lookupController().getViewModel().get('activo').get('entidadPropietariaCodigo')!='03')
							 },
 							 {
							   xtype: 'checkboxfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.campanya.precio.alquiler.negociable'),
							   bind:  '{valoraciones.campanyaPrecioAlquilerNegociable}',
							   hidden: (me.lookupController().getViewModel().get('activo').get('entidadPropietariaCodigo')!='03')
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.vacbe'),
							   bind:  '{valoraciones.vacbe}',
							   hidden: (me.lookupController().getViewModel().get('activo').get('entidadPropietariaCodigo')!='02')
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.coste.adquisicion'),
							   bind:  '{valoraciones.costeAdquisicion}',
							   hidden: (me.lookupController().getViewModel().get('activo').get('entidadPropietariaCodigo')!='01')
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.valor.neto.contable'),
							   bind:  '{valoraciones.vnc}',
							   hidden: (me.lookupController().getViewModel().get('activo').get('entidadPropietariaCodigo')!='08')
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
						       fieldLabel: HreRem.i18n('fieldlabel.valor.deuda.bruta'),
							   bind:  '{valoraciones.deudaBruta}',
							   hidden: (me.lookupController().getViewModel().get('activo').get('entidadPropietariaCodigo')!='08')
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.valor.valor.razonable'),
							   bind:  '{valoraciones.valorRazonable}',
							   hidden: (me.lookupController().getViewModel().get('activo').get('entidadPropietariaCodigo')!='08')
							 }
							 
							]
					},
					{
						xtype:'fieldset',
						height: 240,
						margin: '0 10 10 0',
						layout: {
					        type: 'table',
							columns: 2
						},
						defaultType: 'textfieldbase',
						title: HreRem.i18n("title.internos.haya"),
						items :
							[
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.valor.venta.haya'),
							   bind:  '{valoraciones.fsvVenta}'
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.valor.renta.haya'),
							   bind:  '{valoraciones.fsvRenta}'
							 },
							  {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.valor.venta.haya.origen'),
							   bind:  '{valoraciones.fsvVentaOrigen}'
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.valor.renta.haya.origen'),
							   bind:  '{valoraciones.fsvRentaOrigen}'
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.estimado.venta'),
							   bind:  '{valoraciones.valorEstimadoVenta}'
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.estimado.renta'),
							   bind:  '{valoraciones.valorEstimadoRenta}'
							 },
							 {
							   xtype: 'datefieldbase',
							   reference: 'fechaVentaHayaPrecioActivo',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.fecha.venta.haya'),
							   bind:  '{valoraciones.fechaVentaHaya}'
							 },
							 {
							   xtype: 'textfieldbase',
							   reference: 'liquidezPrecioActivo',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.liquidez'),
							   bind:  '{valoraciones.liquidez}'
							 }
							 
							]
					},
					{
						xtype:'fieldset',
						height: 240,
						margin: '0 10 10 0',
						layout: {
					        type: 'table',
							columns: 1
						},
						defaultType: 'textfieldbase',
						title: HreRem.i18n("title.legales"),
						items :
							[
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.vpo'),
							   bind: {
			                		value: '{valoraciones.valorLegalVpo}',
				    				hidden: '{!valoraciones.vpo}'
			                	}
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.catastral.suelo'),
							   bind:  '{valoraciones.valorCatastralSuelo}'
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.catastral.construccion'),
							   bind:  '{valoraciones.valorCatastralConstruccion}'
							 }
							 
							]
					},
					// Valores Económicos
					{
						xtype:'fieldsettable',
						title:HreRem.i18n('title.valores.economicos'),
						defaultType: 'textfieldbase',
						colspan: 3,
						items :
							[
							 	// Venta
								{
									fieldLabel: HreRem.i18n('fieldlabel.info.comercial.valor.min.venta'),
									width:		280,
									bind:		'{valoraciones.valorEstimadoMinVenta}',
									renderer: function(value) {
		   				        		return Ext.util.Format.currency(value);
		   				        	}
								},
								{
									fieldLabel: HreRem.i18n('fieldlabel.info.comercial.valor.max.venta'),
									width:		280,
									bind:		'{valoraciones.valorEstimadoMaxVenta}',
									renderer: function(value) {
		   				        		return Ext.util.Format.currency(value);
		   				        	}
								},
								{
									fieldLabel: HreRem.i18n('fieldlabel.info.comercial.valor.venta'),
									width:		280,
									bind:		'{valoraciones.valorEstimadoVenta}',
									renderer: function(value) {
		   				        		return Ext.util.Format.currency(value);
		   				        	}
								},
				                // Alquiler
								{
									fieldLabel: HreRem.i18n('fieldlabel.info.comercial.valor.min.renta'),
									width:		280,
									bind:		'{valoraciones.valorEstimadoMinRenta}',
									renderer: function(value) {
		   				        		return Ext.util.Format.currency(value);
		   				        	}
								},
								{
									fieldLabel: HreRem.i18n('fieldlabel.info.comercial.valor.max.renta'),
									width:		280,
									bind:		'{valoraciones.valorEstimadoMaxRenta}',
									renderer: function(value) {
		   				        		return Ext.util.Format.currency(value);
		   				        	}
								},
								{
									fieldLabel: HreRem.i18n('fieldlabel.info.comercial.valor.renta'),
									width:		280,
									bind:		'{valoraciones.valorEstimadoVenta}',
									renderer: function(value) {
		   				        		return Ext.util.Format.currency(value);
		   				        	}
								}
						]
					}
				]
            },
            {
				xtype:'fieldsettable',
				title: HreRem.i18n('title.historico.valores.precios'),
				items :	[
							{
								xtype		: 'gridBase',
								reference	: 'gridHistoricoPrecios',
								loadAfterBind: false,
								flex		: 1,
								bind		: {
												store: '{storeHistoricoValoresPrecios}'
								},
								dockedItems: [
									{
										xtype: 'pagingtoolbar',
										dock: 'bottom',
										displayInfo: true,
										bind: {
											store: '{storeHistoricoValoresPrecios}'
										}
									}
								],
								features: [{
						            ftype: 'grouping',
						            groupHeaderTpl: '{name}'
						        }],
								columns		: {
								items:[
								   {   
									   text: HreRem.i18n('header.descripcion'),
									   flex: 0.4
							       },
								   {
									text: HreRem.i18n('header.importe'),
									dataIndex: 'importe',
									renderer: Utils.rendererCurrency,						        		
									flex: 1
								   },
								   {
									text: HreRem.i18n('header.fecha.aprobacion'),
									dataIndex: 'fechaAprobacion',
									formatter: 'date("d/m/Y")',
									flex: 1,
									readOnly: '{datosRegistrales.unidadAlquilable}'
									
								   },
								   {
									text: HreRem.i18n('header.fecha.carga'),										
									dataIndex: 'fechaCarga',
									formatter: 'date("d/m/Y")',
									flex: 1
								   },
								   {
									text: HreRem.i18n('header.fecha.inicio'),									
									dataIndex: 'fechaInicio',
									formatter: 'date("d/m/Y")',
									flex: 1
								   },
								   {
									text: HreRem.i18n('header.fecha.fin'),										
									dataIndex: 'fechaFin',
									formatter: 'date("d/m/Y")',
									flex: 1
								   },
								   {
									text: HreRem.i18n('header.gestor'),											
									dataIndex: 'gestor',
									flex: 1
								   },
								   {
									text: HreRem.i18n('header.observaciones'),										
									dataIndex: 'observaciones',
									flex: 1
								   }
			    				]
							}
						}
				]
            },
            
            //Testigos Opcionales
			{
				xtype:'fieldsettable',
				title: HreRem.i18n('title.info.comercial.testigos.mercado'),
				defaultType: 'textfieldbase',
				items :
					[
						{xtype: "testigosopcionalesgrid", reference: "testigosopcionalesgrid"}
					]
			}
        ];
        
		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
   }, 
   
   	afterLoad: function() {
		var me = this;
		if (me.lookupController().getViewModel().getData().isCarteraBankia == false) {
			me.lookupController().getViewModel().getData().storePreciosVigentes.load();
		}
		me.lookupController().getViewModel().getData().storeHistoricoValoresPrecios.load();
	},
   
   funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
		});
   },
   
 //HREOS-846 Si NO esta dentro del perimetro, ocultamos del grid las opciones de agregar/elminar
   evaluarEdicion: function() {    	
		var me = this;
	
		if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="false"  || me.lookupController().getViewModel().get('activo').get('isActivoEnTramite')) {
			me.down('[reference=gridPreciosVigentes]').rowEditing.clearListeners()
		}
   }
    
});