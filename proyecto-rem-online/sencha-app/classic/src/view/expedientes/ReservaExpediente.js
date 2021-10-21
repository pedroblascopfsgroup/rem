Ext.define('HreRem.view.expedientes.ReservaExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'reservaexpediente',    
    disableValidation: true,
    reference: 'reservaExpediente',
    scrollable	: 'y',
    saveMultiple: true,
	records: ['expediente','reserva'],	
	recordsClass: ['HreRem.model.ExpedienteComercial','HreRem.model.Reserva'],    
    requires: ['HreRem.model.ExpedienteComercial','HreRem.model.Reserva'],

    
    listeners: {
			boxready:'cargarTabData'
	},
    
    initComponent: function () {
        var me = this;
        
		
		var dataExpediente = me.lookupController().getView().getViewModel().getData().expediente.getData();
		var tieneReserva = true;
		var esBk = dataExpediente.esBankia;
		var botonesEdicion = me.up().down("[itemId=botoneditar]");
		var estadoArras;
		
		if(esBk){
			estadoArras = 'fieldlabel.estado.arras';
			me.setTitle(HreRem.i18n('title.arras'));
		}else{
			estadoArras = 'fieldlabel.estado.reserva';
			me.setTitle(HreRem.i18n('title.reserva'));
		}
		
		
        var items= [

			{   
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.detalle.reserva'),
				items :
					[
		                {
		                	fieldLabel:  HreRem.i18n('fieldlabel.num.reserva'),
		                	bind:		'{reserva.numReserva}'
		                },
		                { 
							xtype: 'comboboxfieldbase',
							reference: 'comboTiposArras',
		                	fieldLabel:  HreRem.i18n('fieldlabel.tipo.arras'),
				        	bind: {
			            		store: '{storeTiposArras}',
			            		value: '{reserva.tipoArrasCodigo}',
			            		readOnly:'{esCarteraGaleonOZeusOBk}'
			            	}
				        },		                
		                {
		                	xtype:'datefieldbase',
		                	reference:'fechaEnvioRef',
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.envio'),
		                	bind:{
		                		value: '{reserva.fechaEnvio}',
		                		readOnly:'{readOnlyGestBoarding}'
	                		}
		                },
		                {
		                	fieldLabel:  HreRem.i18n('fieldlabel.importe'),
		                	bind:		'{reserva.importe}'
		                },
		                /*{
		                	fieldLabel:  HreRem.i18n('fieldlabel.estado.reserva'),
		                	bind:		'{reserva.estadoReservaDescripcion}'
		                },*/
		                
						{
							xtype: 'container',
							layout: {
								type: 'table',
								columns: 2
							},
							padding: '5px',
							items: [
					                {
					                	xtype: 'comboboxfieldbase',
					                	bind: {
											store: '{comboEstadoReserva}',
											value: '{reserva.estadoReservaCodigo}'
										},
										readOnly: !$AU.userIsRol("HAYASUPER"),
					                	fieldLabel:  HreRem.i18n(estadoArras)
					                },
					                {
					                	
										xtype: 'button',
										handler: 'onClickBtnDevolverReserva',
										bind: {
											hidden: '{ocultarBtnDevolverReserva}'
										},
										reference: 'btnDevolverReserva',
										text: 'Devolver Reserva'
										
					                }]
						},
		                {
		                	xtype:'datefieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.firma'),
		                	bind: {
		                		value: '{reserva.fechaFirma}',
		                		readOnly: '{fechaIngresoChequeReadOnly}'
	                		}
		                },
		                		                
		               
		                
						//FIN ARRAS		                
		                
		                {		                
		                	xtype: 'checkboxfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.reserva.con.impuesto'),
		                	readOnly: true,
		                	bind:		'{reserva.conImpuesto}',
		                	colspan: 2
		                },
		                {
		                	fieldLabel:  HreRem.i18n('fieldlabel.dias.transcurridos'),
							bind: 		'{reserva.diasFirma}'
		                },
		                {
		                	xtype:'datefieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.contabilizacion'),
		                	reference: 'fechacontabilizacionarrasref',
							readOnly: !$AU.userIsRol("HAYASUPER"),
		                	bind: 		
		                		{
		                			value:'{reserva.fechaContabilizacionArras}',
		                			hidden: '{!esCarteraBankia}' 
		                		}
		                },
		                {
		                	xtype:'datefieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.vencimiento'),
		                	minValue: $AC.getCurrentDate(),
							maxValue: null,
		                	bind: 		'{reserva.fechaVencimiento}',		                	
							colspan: 2
		                },

		                {
							xtype: 'textfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.codigo.sucursalreserva'),
							name: 'buscadorSucursales',
							maskRe: /^\d{1,4}$/,
							maxLength: 4,
							//disabled: true,
							bind: {
								value: '{reserva.codigoSucursal}',
								hidden: '{esCarteraBankia}'
							},
							allowBlank: true,
							triggers: {
								
									buscarEmisor: {
							            cls: Ext.baseCSSPrefix + 'form-search-trigger',
							            handler: 'buscarSucursal'
							        }
							},
							cls: 'searchfield-input sf-con-borde',
							emptyText:  'Introduce el código de la Sucursal',
							enableKeyEvents: true,
					        listeners: {
					        	specialKey: function(field, e) {
					        		if (e.getKey() === e.ENTER) {
					        			field.lookupController().buscarSucursal(field);											        			
					        		}
					        	}/*,
					        	
					        	blur: function(field, e) {											        		
					        		if(!Ext.isEmpty(field.getValue())) {
					        			field.lookupController().buscarPrescriptor(field);
					        		}
					        	}*/
					        	
					        	
					        }
	                	},
	                	{
							xtype: 'textfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.sucursalreserva'),
							name: 'nombreSucursal',
							bind: {
								value:'{reserva.sucursal}',
								hidden: '{esCarteraBankia}'
							},
							//disabled: true,
							readOnly: true,
							allowBlank: true
						},
						{
							xtype:'fieldsettable',
							defaultType: 'displayfieldbase',				
							title: HreRem.i18n('fieldlabel.condiciones.arras'),
							colspan:3,
							bind:{
								hidden:'{!esCarteraBankia}'
							},
							items :[
								{		                
			                		xtype: 'checkboxfieldbase',
			                		fieldLabel:  HreRem.i18n('fieldlabel.inscripcion.titulo.arras'),
			                		//readOnly: true,
			                		bind:		'{reserva.inscripcionTitulo}'		                
		                		},
		                		{		                
			                		xtype: 'checkboxfieldbase',
			                		fieldLabel:  HreRem.i18n('fieldlabel.cargas.arras'),
			                		//readOnly: true,
			                		bind:		'{reserva.cargas}'		                
		                		},
		                		{		                
			                		xtype: 'checkboxfieldbase',
			                		fieldLabel:  HreRem.i18n('fieldlabel.posesion.arras'),
			                		//readOnly: true,
			                		bind:		'{reserva.posesion}'		                
		                		},
		                		{		                
			                		xtype: 'checkboxfieldbase',
			                		fieldLabel:  HreRem.i18n('fieldlabel.tanteo.dl.arras'),
			                		//readOnly: true,
			                		bind:		'{reserva.tanteoDL}'		                
		                		},

		                		{		                
			                		xtype: 'checkboxfieldbase',
			                		fieldLabel:  HreRem.i18n('fieldlabel.temas.tecnicos'),
			                		//readOnly: true,
			                		bind:		'{reserva.temasTecnicos}'		                
		                		},

		                		{		                
			                		xtype: 'checkboxfieldbase',
			                		fieldLabel:  HreRem.i18n('fieldlabel.temas.catastrales'),
			                		//readOnly: true,
			                		bind:		'{reserva.temasCatastrales}'		                
		                		},
		                		{		                
			                		xtype: 'checkboxfieldbase',
			                		fieldLabel:  HreRem.i18n('fieldlabel.autorizacion.vpo'),
			                		//readOnly: true,
			                		bind:		'{reserva.autorizacionVpo}'		                
		                		}		                				                				                								
							]
						},
						{
							xtype:'fieldsettable',
							defaultType: 'displayfieldbase',				
							title: HreRem.i18n('fieldlabel.prorroga.arras'),
							colspan:3,
							bind:{
								hidden:'{!esCarteraBankia}'
							},
							items :[
														
								{
									xtype:'datefieldbase',
							        fieldLabel: HreRem.i18n('fieldlabel.prorroga.arras.propuesta'),
							        bind: {
				                		value: '{reserva.fechaPropuestaProrrogaArras}'
							        },
									minValue: $AC.getCurrentDate(),
									maxValue: null
								},
								{
							        xtype: 'comboboxfieldbase',
							        fieldLabel:  HreRem.i18n('fieldlabel.motivo.ampliacion.arras'),					        
							        bind: {
							        	store: '{comboMotivoAmpliacionArras}',
										value: '{reserva.motivoAmpliacionArrasCodigo}'
									}											                	
							    },
							    { 
									xtype: 'textareafieldbase',
									fieldLabel:  HreRem.i18n('fieldlabel.motivo.solicitud.ampliacion.arras'),						        	
									bind: {
										value: '{reserva.solicitudAmpliacionArras}'
									},
									maxLength: 200,
									rowspan: 2,
									height: 80
								},
								{
				                	xtype:'datefieldbase',
							        fieldLabel: HreRem.i18n('fieldlabel.fecha.comunicacion.a.cliente'),
							        bind: {
				                		value: '{reserva.fechaComunicacionCliente}'
							        },
									minValue: $AC.getCurrentDate(),
									maxValue: null
								},
								{
				                	xtype:'datefieldbase',
							        fieldLabel: HreRem.i18n('fieldlabel.fecha.vigencia.arras'),
							        bind: {
				                		value: '{reserva.fechaVigenciaArras}'
							        },
									minValue: $AC.getCurrentDate(),
									maxValue: null
								}
							]
						},
						{
							xtype:'fieldsettable',
							defaultType: 'displayfieldbase',				
							title: HreRem.i18n('fieldlabel.rescision.arras'),
							colspan:3,
							bind:{
								hidden:'{!esCarteraBankia}'
							},
							items :[
														
								{
									xtype:'datefieldbase',
							        fieldLabel: HreRem.i18n('fieldlabel.fecha.comunicacion.a.cliente'),
							        bind: {
				                		value: '{reserva.fechaComunicacionClienteRescision}'
							        }
								},
								{
							        xtype: 'datefieldbase',
							        fieldLabel:  HreRem.i18n('fieldlabel.rescision.arras.fecha'),					        
							        bind: {
										value: '{reserva.fechaFirmaRescision}'
									}											                	
							    },
							    {
							        xtype: 'comboboxfieldbase',
							        fieldLabel:  HreRem.i18n('fieldlabel.rescision.arras.motivo'),
							        //multiSelect: true,
							        bind: {
							        	store: '{comboMotivoRescisionArras}'
									}
							    },
	    						{
									xtype:'fieldsettable',
									defaultType: 'displayfieldbase',				
									title: HreRem.i18n('fieldlabel.arras.motivo'),
									colspan:3,
									bind:{
										hidden:'{!esCarteraBankia}'
									},
									items :[
										{		                
					                		xtype: 'checkboxfieldbase',
					                		fieldLabel:  HreRem.i18n('fieldlabel.inscripcion.titulo.arras'),
					                		reference: 'inscripcionTituloMotivoRef',
					                		//readOnly: true,
					                		bind:	
					                			{
					                				value:'{reserva.inscripcionTituloMotivo}'					                		
					                			}
				                		},
				                		{		                
					                		xtype: 'checkboxfieldbase',
					                		fieldLabel:  HreRem.i18n('fieldlabel.cargas.arras'),
					                		reference: 'cargasArrasMotivoRef',
					                		//readOnly: true,
					                		bind:	
					                			{
					                				value:'{reserva.cargasMotivo}'					                		
					                			}
				                		},
				                		{		                
					                		xtype: 'checkboxfieldbase',
					                		fieldLabel:  HreRem.i18n('fieldlabel.posesion.arras'),
					                		reference: 'posesionArrasMotivoRef',
					                		//readOnly: true,
					                		bind:		
						                		{
						                			value: '{reserva.posesionMotivo}'		                
						                		}
				                		},
				                		{		                
					                		xtype: 'checkboxfieldbase',
					                		fieldLabel:  HreRem.i18n('fieldlabel.tanteo.dl.arras'),
					                		reference: 'tanteoDlMotivoRef',
					                		//readOnly: true,
					                		bind:		
					                			{
					                				value:'{reserva.tanteoDLMotivo}'
					                			}
				                		},
		
				                		{		                
					                		xtype: 'checkboxfieldbase',
					                		fieldLabel:  HreRem.i18n('fieldlabel.temas.tecnicos'),
					                		reference: 'temasTecnicosMotivoRef',
					                		//readOnly: true,
					                		bind:		
						                		{
						                			value:'{reserva.temasTecnicosMotivo}'
						                		}				                					               
				                		},
		
				                		{		                
					                		xtype: 'checkboxfieldbase',
					                		fieldLabel:  HreRem.i18n('fieldlabel.temas.catastrales'),
					                		reference: 'temasCatastralesMotivoRef',
					                		//readOnly: true, 
					                		bind:
					                			{
					                				value:'{reserva.temasCatastralesMotivo}'
					                			}
					                				                
				                		},
				                		{		                
					                		xtype: 'checkboxfieldbase',
					                		fieldLabel:  HreRem.i18n('fieldlabel.autorizacion.vpo'),
					                		reference: 'autoVpoMotivoRef',
					                		//readOnly: true,
					                		bind:		
					                			{
					                				value: '{reserva.autorizacionVpoMotivo}'
					                			}
				                		}		                				                				                								
									]
								}
							    
							]
						}
		                		               
		        ]
			},
			{
			    xtype: 'fieldset',
                title:  HreRem.i18n('title.grid.fecha.arras'),
                bind: {
                	hidden: '{!esCarteraBankia}'	
                },
                items : [
                    {
                        xtype: 'fechaArrasGrid',
                        reference: 'fechaArrasGridRef'
                    }
                ]
			},
			{
				
            	xtype: 'fieldset',
            	title:  HreRem.i18n('title.historico.entregas.a.cuenta'),
            	items : [
                	{
					    xtype		: 'gridBaseEditableRow',
					    topBar		: false,
					    tbar : {
				    		xtype: 'toolbar',
				    		dock: 'top',
				    		tipo: 'toolbaredicion',
				    		items: [{iconCls:'x-fa fa-plus', itemId:'addButton', handler: 'onAddClickThis', scope: this, bind: {disabled: '{esCarteraBankia}'} }]
			    		},
					    idPrincipal : 'expediente.id',
					    reference: 'listadoEntregasCuenta',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeEntregasACuenta}'
						},									
						
						columns: [
						   {    text: HreRem.i18n('header.importe'),
					        	dataIndex: 'importe',
					        	flex: 1,
					        	editor: {
					        		xtype:'numberfield'
					        	}
					       },
						   {
					            text: HreRem.i18n('header.fecha.cobro'),
					            dataIndex: 'fechaCobro',
					            formatter: 'date("d/m/Y")',
					            flex: 1,
					            editor: {
					            	xtype: 'datefield',
					            	allowBlank: false
					            }
						   },
						   {
						   		text: HreRem.i18n('header.comprador'),
					            dataIndex: 'titular',
					            flex: 1,
					            editor: {
					            	xtype: 'textfield'
					            }
						   },						   
						   {
						   		text: HreRem.i18n('header.observacion'),
					            dataIndex: 'observaciones',
					            flex: 1,
					            editor: {
					            	xtype:'textarea'
					            }
						   }	
					    ]					    
					}
            	]
            }
    	];
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    
    onAddClickThis: function() {
    	var me = this;
    	me.down('grid[reference=listadoEntregasCuenta]').onAddClick();
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