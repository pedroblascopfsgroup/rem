Ext.define('HreRem.view.expedientes.DatosBasicosExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'datosbasicosexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'datosbasicosexpediente',
    scrollable	: 'y',
	recordName: "expediente",
	
	recordClass: "HreRem.model.ExpedienteComercial",
    
    requires: ['HreRem.model.ExpedienteComercial'],
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.ficha'));
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
							xtype: 'displayfieldbase',
							fieldLabel:  HreRem.i18n('fiedlabel.numero.activo.agrupacion'),
		                	bind:		'{expediente.numEntidad}'
		                }
						
					]
           },
           {   
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',				
				title: HreRem.i18n('title.titulo.alquiler'),
				layout: {
					type: 'table',
					columns: 1
				},
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
					        	bind: '{expediente.fechaInicioAlquiler}',
					        	readOnly: true,
					        	maxValue: null
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
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.aceptacion'),
	                	bind:		'{expediente.fechaAlta}'
	                	//,readOnly: true
	                },
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.sancion'),
	                	bind:		'{expediente.fechaSancion}'
	                	//,readOnly: true
	                },
	                { 
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('fieldlabel.fecha.reserva'),
	                	bind:		'{expediente.fechaReserva}'
	                	//,readOnly: true
	                },
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.venta'),
	                	bind:		'{expediente.fechaVenta}'
	                	//,readOnly: true
	                	
	                },
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.ingreso.cheque'),
	                	bind: {
	                		value: '{expediente.fechaContabilizacionPropietario}',
	                		readOnly: '{fechaIngresoChequeReadOnly}'
	                	}		
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
							bind: '{expediente.fechaAnulacion}',
							readOnly: true,
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
							xtype: 'comboboxfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.motivo.anulacion'),
		                	reference: 'comboMotivoAnulacion',
		                	editable: true,
				        	bind: {
				        		store: '{storeMotivoAnulacion}',
			            		value: '{expediente.codMotivoAnulacion}'
			            	}
				        },
						{    
			                xtype:'fieldsettable',
							defaultType: 'displayfield',
							title: HreRem.i18n('title.devolucion.reserva'),
							colspan: 3,
							bind: {
								disabled: '{!expediente.tieneReserva}'
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
						            		readOnly: '{esCarteraLiberbank}'
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
		                	fieldLabel:  HreRem.i18n('fieldlabel.riesgo.reputacional'),
				        	bind: {
			            		store: '{comboSiNoRem}',
			            		value: '{expediente.riesgoReputacional}'
			            	}
		                },
		                {
		                	xtype: 'comboboxfieldbase',
							reference: 'comboEstadoPbc',
		                	fieldLabel:  HreRem.i18n('fieldlabel.estado.pbc'),
				        	bind: {
			            		store: '{comboAceptadoRechazado}',
			            		value: '{expediente.estadoPbc}'
			            	}
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