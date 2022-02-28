Ext.define('HreRem.view.expedientes.DatosBasicosExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'datosbasicosexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    refreshAfterSave: true,
    saveMultiple: true,
    reference: 'datosbasicosexpediente',
    scrollable	: 'y',
    records: ['expediente','datosbasicosoferta'],	
    recordsClass: ['HreRem.model.ExpedienteComercial','HreRem.model.DatosBasicosOferta'],    
    requires: ['HreRem.model.ExpedienteComercial','HreRem.model.DatosBasicosOferta'],
    listeners: {
    	boxready:'cargarTabData'
    	},
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.ficha'));

		var storeAnulacion  = me.lookupViewModel().get('expediente.isCarteraBankia') ? '{storeMotivoAnulacionCaixa}' : '{storeMotivoAnulacion}';
        var items= [

			{   
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',				
				title: HreRem.i18n('title.expediente.ficha.objeto'), 
				items :
					[
		                {
		                	xtype: 'displayfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.num.expediente'),
		                	bind:		'{expediente.numExpediente}'

		                },						
						{
							xtype: 'displayfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.cartera'),
							bind:		'{expediente.entidadPropietariaDescripcion}'
						},						
						{
							xtype: 'displayfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.propietario'),
			                bind:		'{expediente.propietario}'
						},
						{ 
							xtype: 'displayfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
		                	bind:		'{expediente.tipoExpedienteDescripcion}'
		                },
		                {  
							xtype:'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.tipo.alquiler'),
							cls: 'cabecera-info-field',
							bind :{ 
								value: '{expediente.tpoAlquiler}',
								hidden: '{esOfertaVenta}',
								store: '{comboTipoAlquiler}'
							}
		                },
		                { 
							xtype: 'displayfieldbase',
							fieldLabel:  HreRem.i18n('fiedlabel.numero.activo.agrupacion'),
		                	bind:		'{expediente.numEntidad}'
		                },

		                { 
		                	xtype:'comboboxfieldbase',
							fieldLabel:HreRem.i18n('fieldlabel.tipo.inquilino'),
							cls: 'cabecera-info-field',
							bind :{ 
								value: '{expediente.tipoInquilino}',
								hidden: '{esOfertaVentaOrCarteraCaixa}',
                                store :'{comboTiposInquilino}'
							}
		                },

		                {
		                	xtype: 'comboboxfieldbase',
		                	bind: {
								store: '{comboEstadoExpediente}',
								value: '{expediente.codigoEstado}',
								readOnly: '{expediente.noEsOfertaFinalGencat}'
								
							},
							hidden: !$AU.userIsRol("HAYASUPER"),
		                	fieldLabel:  HreRem.i18n('fieldlabel.estado')
		                },
						{
							fieldLabel:  HreRem.i18n('fieldlabel.subestado'),
		                	xtype: 'comboboxfieldbase',
							readOnly: !$AU.userIsRol("HAYASUPER"),
		                	bind: {
								store: '{comboSubestadoExpediente}',
								value: '{expediente.codigoSubestado}',
								hidden: '{!expediente.esActivoHayaHome}'								
							}
						},
		                {
		                	xtype: 'comboboxfieldbase',
		                	bind: {
								store: '{comboEstadoExpedienteBc}',
								value: '{expediente.codigoEstadoBc}',
								readOnly: '{expediente.noEsOfertaFinalGencat}',
								hidden: '{!esBankia}'
							},
							
		                	fieldLabel:  HreRem.i18n('fieldlabel.estado.bc')
		                },
		                {
		                	xtype: 'comboboxfieldbase',
		                	readOnly: true,
		                	bind: {
								store: '{comboEstadoComunicacionC4C}',
								value: '{expediente.codigoEstadoComunicacionC4C}',
								hidden: '{!esBankia}'
							},
							
		                	fieldLabel:  HreRem.i18n('fieldlabel.estado.comunicacion.c4c')
		                },
		                {
		                	xtype: 'comboboxfieldbase',
		                	bind: {
								store: '{storeClasificacion}',
								value: '{expediente.clasificacionCodigo}',
								hidden: '{!esBankiaAlquilerOAlquilerNoComercial}'
							},
                            readOnly: true,
		                	fieldLabel:  HreRem.i18n('fieldlabel.detalle.oferta.alquiler.clasificacion')
		                },
		                {
		                	xtype: 'comboboxfieldbase',
		                	bind: {
								store: '{storeTipoOfertaAlquiler}',
								value: '{datosbasicosoferta.tipoOfertaAlquilerCodigo}',
								hidden: '{!esAlquilerNoComercial}'
							},
							readOnly: true,
		                	fieldLabel:  HreRem.i18n('fieldlabel.detalle.oferta.alquiler.subtipo.oferta')
		                }
						
					]
           },
           {    
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',				
				title: HreRem.i18n('title.titulo.alquiler'),
				bind: {
					hidden: '{esOfertaVentaFicha}',
					disabled: '{esOfertaVentaFicha}'
			    },
				items :
					[
		                {   
						xtype:'fieldsettable',
						collapsible: false,
						border: false,
						defaultType: 'displayfieldbase',				
						items : [
						
							{
				        		xtype:'datefieldbase',
								formatter: 'date("d/m/Y")',
					        	fieldLabel: HreRem.i18n('fieldlabel.fecha.inicio'),
					        	bind: {
					        		value:'{expediente.fechaInicioAlquiler}'
					        	},
					        	readOnly: true,
					        	maxValue: null
					        },
					        {
				        		xtype:'numberfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.meses.duracion.alquiler'),
					        	bind: {
					        		value:'{expediente.mesesDuracionCntAlquiler}',
					        		hidden: '{!esBankiaAlquilerOAlquilerNoComercial}'
					        	},
					        	readOnly: true
					        },
					        {
				        		xtype:'datefieldbase',
								formatter: 'date("d/m/Y")',
					        	fieldLabel: HreRem.i18n('fieldlabel.fecha.fin'),
					        	bind: '{expediente.fechaFinAlquiler}',
					        	readOnly: true,
					        	maxValue: null
					        },
					    	{ 
					        	xtype : 'currencyfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.importe.renta.oferta'),
								bind : {
									value:'{expediente.importeRentaAlquiler}',
									hidden: '{!esBankiaAlquilerOAlquilerNoComercial}'
								},
                                readOnly: true
					        },
							{ 
								xtype: 'textfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.numero.contrato.alquiler'),
					        	bind: '{expediente.numContratoAlquiler}',
					        	readOnly: true
					        }
					        
				        ]
					},
					{   
						xtype:'fieldsettable',
						collapsible: false,
						defaultType: 'displayfieldbase',
						bind: {
							hidden: '{!esAlquilerConOpcionCompra}',
							disabled: '{!esAlquilerConOpcionCompra}'
					    },
						title: HreRem.i18n('title.opcion.compra.alquiler'),
						items : [
					        {
				        		xtype:'datefieldbase',
								formatter: 'date("d/m/Y")',
					        	fieldLabel: HreRem.i18n('fieldlabel.plazo.opcion.compra.alquiler'),
					        	bind: '{expediente.fechaPlazoOpcionCompraAlquiler}'					        						        	
					        },
							{ 
								xtype: 'numberfieldbase',
								symbol: HreRem.i18n("symbol.euro"),
								fieldLabel: HreRem.i18n('fieldlabel.prima.opcion.compra.alquiler'),
				                bind: '{expediente.primaOpcionCompraAlquiler}'
							},
							{ 
								xtype: 'numberfieldbase',
								symbol: HreRem.i18n("symbol.euro"),
								fieldLabel: HreRem.i18n('fieldlabel.precio.opcion.compra.alquiler'),
				                bind: '{expediente.precioOpcionCompraAlquiler}'
							},
							
					       	{ 
			                	xtype: 'textareafieldbase',
			                	labelWidth: 200,
			                	height: 160,
			                	labelAlign: 'top',
			                	fieldLabel: HreRem.i18n('fieldlabel.condiciones.opcion.compra.alquiler'),
			                	bind:		'{expediente.condicionesOpcionCompraAlquiler}'
			                }    
					        
				        ]
					}
						
					]
           },
           {    
                xtype:'fieldsettable',
				defaultType: 'displayfield',
				title: HreRem.i18n('title.tramite.expediente'),
				items: [
					{ 
						xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('fieldlabel.fecha.alta.oferta'),
	                	bind:		'{expediente.fechaAltaOferta}'
	                	//,readOnly: true
	                },
	                { 	//PARA CAIXA
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('fieldlabel.fecha.reserva'),
						reference: 'fechaReservaRef',
	                	bind:		{
	                		value: '{expediente.fechaReservaDeposito}',
	                		hidden: '{!esOfertaVentaEsCaixa}',
	                		readOnly: true
	                	}
	                },
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.aceptacion'),
	                	bind:		'{expediente.fechaAlta}'
	                	//,readOnly: true
	                },
	                { //Fecha Scoring
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('fieldlabel.fecha.reserva'),
	                	bind:		{
	                		value: '{expediente.fechaReserva}',
	                		hidden: '{esBankia}'
	                	},
	                	listeners: {
							render: 'tareaDefinicionDeOferta'
						}
	                	//,readOnly: true
	                },
	                { 
						xtype: 'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.elevacion.comite'),
			        	bind: {
			        		value: '{expediente.fechaSancionComite}',
			        		hidden: '{esOfertaVenta}'	
			        	}
			        },
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.sancion'),
	                	bind:		'{expediente.fechaSancion}'
	                	//,readOnly: true
	                },
	                {   //PAra Caixa
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.reserva.arras'),
	                	colspan: 2,
	                	bind: {
	                		value: '{expediente.fechaReserva}',
	                		hidden: '{!esOfertaVentaEsCaixa}',
	                		readOnly: true
	                	}
	                },
	                
	                { 
						xtype: 'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.posicionamiento'),
			        	bind: {
			        		value: '{expediente.fechaPosicionamiento}',
			        		hidden: '{!esOfertaVenta}'	
			        	}
			        },
	                {//FechaFirmaContrato
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	bind:		{
	                		value: '{expediente.fechaVenta}',
	                		fieldLabel:'{fechaVentaEsAlquiler}'
	                		}
	                	//,readOnly: true
	                	//readOnly: !$AU.userIsRol("HAYASUPER")
	                },
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.ingreso.cheque'),
	                	bind: {
	                		value: '{expediente.fechaContabilizacionPropietario}',
	                		readOnly: '{fechaIngresoChequeReadOnly}',
	                		hidden: '{!esOfertaVenta}'
	                	}		
	                },
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.contabilizacion.reserva'),
	                	bind: {
	                		value: '{expediente.fechaContabilizacionReserva}',
	                		readOnly: '{fechaContabilizacionReservaReadOnly}',
	                		hidden: '{!esOfertaVentaEsCajamar}'
	                	}		
	                },
	                //PARA CAIXA
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.contabilizacion'),
	                	bind: {
	                		value: '{expediente.fechaContabilizacion}',
	                		hidden: '{!esOfertaVentaEsCaixa}',
	                		readOnly: true
	                	}		
	                },
	            	{ 
						xtype: 'textfieldbase',
	                	fieldLabel:  HreRem.i18n('fieldlabel.numero.contrato.alquiler'),
			        	bind: {
			        		value:'{expediente.numContratoAlquiler}',
			        		hidden: '{esOfertaVenta}'	
			        	}
	            	 },
				        {
				        	xtype: 'datefieldbase',
				        	formatter: 'date("d/m/Y")',
				        	fieldLabel: HreRem.i18n('fieldlabel.fecha.envio.advisory.note'),
				        	bind: {
				        		value: '{expediente.fechaEnvioAdvisoryNote}',
		                		readOnly: true,
				        		hidden: '{!esCarteraAppleOrArrowOrRemaining}'
				        	}
			        },
			        {
						xtype: 'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.recomendacion.ces'),
			        	bind: {
			        		value:'{expediente.fechaRecomendacionCes}',
			        		hidden: '{!esCarteraAppleOrArrowOrRemaining}'
			        	},
			        	readOnly: true
	            	 },
		             {
		               	xtype:'datefieldbase',
		               	fieldLabel:  HreRem.i18n('fieldlabel.fecha.aprobacion.pro.manzana'),
		               	bind:{
		               		value: '{expediente.fechaAprobacionProManzana}',
		               		hidden:'{!esCarteraAppleOrArrowOrRemaining}'
		              	},
		             	readOnly: true   
		             },
		             {
						xtype: 'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.contabilizacion.venta'),
			        	bind: {
			        		value:'{expediente.fechaContabilizacionVenta}',
			        		hidden: '{!esCarteraAppleoLiberbank}'
			        	},
			        	readOnly: true
	            	 }
				]	
           },
           {    
                xtype:'fieldsettable',
				defaultType: 'displayfield',
				title: HreRem.i18n('title.anulacion'),
				items: [
						{
							xtype:'datefieldbase',
							formatter: 'date("d/m/Y")',
							fieldLabel: HreRem.i18n('fieldlabel.fecha.anulacion'),
							bind: {
								value: '{expediente.fechaAnulacion}',
								readOnly: '{!esBankia}'
							},
							listeners: {
								change: 'onFechaAnulacionChange'
							}
						},
						{
							xtype: 'textfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.peticionario'),
							reference: 'textFieldPeticionario',
							editable: true,
							bind: '{expediente.peticionarioAnulacion}'
						},
						{ 
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.motivo.anulacion'),
		                	reference: 'comboMotivoAnulacion',
		                	readOnly: true,
				        	bind: {
				        		value: '{getMotivoAnulacionOrRechazo}',
				        		hidden: '{esBankia}'
				        	}
				        },
				        { 
							xtype: 'comboboxfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.motivo.anulacion'),
		                	reference: 'comboMotivoAnulacionEditable',
				        	bind: {
				        		store:  storeAnulacion,
			            		value: '{expediente.codMotivoAnulacion}',
			            		hidden: '{!esBankia}'
			            	}
				        },
				        { 
							xtype: 'comboboxfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.motivo.rechazo.antiguo.deudor'),
		                	reference: 'comboMotivoRechazoAntiguoDeudorRef',
				        	bind: {
				        		store: '{storeMotivoRechazoAntiguoDeudor}',
			            		value: '{expediente.motivoRechazoAntiguoDeudCod}',
			            		hidden: '{!esBankiaAlquilerOAlquilerNoComercial}'
			            	}
				        },
				        { 
							xtype: 'textareafieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.motivo.anulacion.detalle'),
		                	reference: 'detalleAnulacionRef',
		                	colspan: 3,
				        	bind: {
				        		value: '{expediente.detalleAnulacionCntAlquiler}',
				        		hidden: '{!esBankia}'
				        	}
				        },
						{    
				        	title: HreRem.i18n('title.arras'),
			                xtype:'fieldsettable',
			                fieldLabel:  HreRem.i18n('fieldlabel.motivo.anulacion'),
							defaultType: 'displayfield',
							colspan: 3,
							bind: {
								disabled: '{!expediente.tieneReserva}',
								hidden: '{!esOfertaVenta}'
							},
							items: [
									{
										xtype:'datefieldbase',
										formatter: 'date("d/m/Y")',
										reference: 'fechaDevolucionReservaRef',
										allowBlank: true,
										fieldLabel: HreRem.i18n('fieldlabel.fecha.devolucion.reserva'),
										bind: {
											disabled: '{!expediente.tieneReserva}',
											value: '{expediente.fechaDevolucionEntregas}',
											readOnly: '{esCarteraLiberbank}'
										}
									},
									{ 
										xtype: 'comboboxfieldbase',
					                	fieldLabel:  HreRem.i18n('fieldlabel.procede.devolucion'),
					                	reference: 'comboProcedeDevolucion',
					                	readOnly: true,
							        	bind: {
							        		store: '{storeProcedeDevolucion}',
						            		value: '{expediente.codDevolucionReserva}'
						            	}
							        },
									{ 
										xtype: 'comboboxfieldbase',
										reference: 'comboEstadoDevolucion',
					                	fieldLabel:  HreRem.i18n('fieldlabel.estado.devolucion'),
							        	bind: {
							        		disabled: '{!expediente.tieneReserva}',
							        		store: '{storeEstadosDevolucion}',
						            		value: '{expediente.estadoDevolucionCodigo}',
						            		readOnly: '{esReadOnly}'
						            	},
						            	listeners:{
						            		change: function(){
						            			if(me.up('expedientedetallemain').lookupReference('fechaDevolucionReservaRef')!=null&&(!Ext.isEmpty(this.value)||this.value!=null) ){
						            				if(this.value=='02'){//Devuelta
						            					me.up('expedientedetallemain').lookupReference('fechaDevolucionReservaRef').allowBlank=false;
						            				}else{
						            					me.up('expedientedetallemain').lookupReference('fechaDevolucionReservaRef').allowBlank=true;
						            				}
						            			}
						            		}
						            	}
							        }
								]
			           }
				]
           },
           {
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.responsabilidad.corporativa'),
				items :
					[
						{
		                	xtype: 'comboboxfieldbase',
							reference: 'comboConflictoIntereses',
		                	fieldLabel:  HreRem.i18n('fieldlabel.conflicto.intereses'),
				        	bind: {
			            		store: '{comboSiNoRem}',
			            		value: '{expediente.conflictoIntereses}'
			            	}
		                },
		                {
		                	xtype: 'comboboxfieldbase',
							reference: 'comboRiesgoReputacional',
							colspan:2,
		                	fieldLabel:  HreRem.i18n('fieldlabel.riesgo.reputacional'),
				        	bind: {
			            		store: '{comboSiNoRem}',
			            		value: '{expediente.riesgoReputacional}'
			            	}
						},
						{
		                	xtype: 'comboboxfieldbase',
							reference: 'comboEstadoPBCreserva',
							colspan:2,
		                	fieldLabel:  HreRem.i18n('fieldlabel.estado.pbc.reserva'),
				        	bind: {
			            		store: '{comboSiNoRem}',
								value: '{expediente.estadoPbcR}',
								hidden:'{!expediente.mostrarPbcReserva}'
			            	}
		                },
		                {
		                	fieldLabel:  HreRem.i18n('fieldlabel.estado.pbc.cn'),
		                	xtype: 'comboboxfieldbase',
		                	bind: {
		                		store: '{comboAceptadoRechazado}',
		                		hidden: '{!esBankiaVenta}',
		                		value: '{expediente.estadoPbcCn}'
		                	}
		                },
		                {
		                	fieldLabel:  HreRem.i18n('fieldlabel.estado.pbc.arras'),
		                	xtype: 'comboboxfieldbase',
		                	bind: {
		                		store: '{comboAceptadoRechazado}',
		                		hidden: '{!esOfertaVenta}',
		                		value: '{expediente.estadoPbcArras}'
		                	}
		                },
		                {
		                	xtype: 'comboboxfieldbase',
							reference: 'comboEstadoPbc',
		                	fieldLabel:  HreRem.i18n('fieldlabel.estado.pbc.venta'),

				        	bind: {
			            		store: '{comboAceptadoRechazado}',
			                    hidden: '{!esOfertaVenta}',
								value: '{expediente.estadoPbc}'
			            	}
		                },
                        {
                            xtype: 'comboboxfieldbase',
                            reference: 'comboEstadoPbcAlquiler',
                            fieldLabel:  HreRem.i18n('fieldlabel.estado.pbc.alquiler'),

                            bind: {
                                store: '{comboAceptadoRechazado}',
                                hidden: '{esOfertaVenta}',
                                value: '{expediente.estadoPbcAlquiler}'
                            },
                            readOnly: true
                        }
		        ]
            }
           
           
    	];
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;		
		me.lookupController().cargarTabData(me);
    	
    }
});