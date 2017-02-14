Ext.define('HreRem.view.trabajos.detalle.GestionEconomicaTrabajo', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'gestioneconomicatrabajo',
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    reference	: 'gestioneconomicatrabajoref',
    scrollable	: 'y',
    listeners	: {
		beforerender:'cargarTabData'
    },
    recordName	: "gestionEconomica",
	recordClass	: "HreRem.model.GestionEconomicaTrabajo",
    requires	: ['HreRem.model.GestionEconomicaTrabajo','HreRem.view.trabajos.detalle.SeleccionTarifasTrabajo','HreRem.model.RecargoProveedor',
               		'HreRem.view.trabajos.detalle.AnyadirNuevoPresupuesto','HreRem.view.trabajos.detalle.ModificarPresupuesto',
               		'HreRem.view.common.FieldSetTable','HreRem.model.PresupuestoTrabajo','HreRem.model.ProvisionSuplido'],

    initComponent: function () {
    	var me = this;
    	me.setTitle(HreRem.i18n('title.gestion.economica'));

    	me.items = [
	            {
	            	xtype:'fieldset',
					cls	: 'panel-base shadow-panel',
					layout: {
				        type: 'table',
				        // The total column count must be specified here
				        columns: 2,
				        trAttrs: {height: '45px', width: '100%'},
				        tdAttrs: {width: '100%', verticalAlign: 'top'},
				        tableAttrs: {
				            style: {
				                width: '100%'
								}
				        }
					},
				    collapsible: true,
				    collapsed: false,
					hidden: true,
					bind: {
						hidden: '{!showTarificacion}',
						disabled: '{disableTarificacion}'
					},	
					reference: 'fieldsettarifasref',
					defaultType: 'textfieldbase',
	            	title: HreRem.i18n('title.listado.tarifas.aplican.trabajo'),
				    
	            	items: [
	    	            {
	    				    xtype		: 'gridBaseEditableRow',
	    					layout:'fit',
	    					minHeight: 250,
	    					colspan:	2,
	    					topBar: true,
	    					cls	: 'panel-base shadow-panel',
	    					//height: '100%',
	    					bind: {
	    						store: '{storeTarifasTrabajo}'
	    					},
	    					reference: 'gridtarifastrabajo',
							features: [{
							            id: 'summary',
							            ftype: 'summary',
							            hideGroupedHeader: true,
							            enableGroupingMenu: false,
							            dock: 'bottom'
							}],
	    					secFunToEdit: 'EDITAR_LIST_TARIFAS_TRABAJO',
	    					
	    					secButtons: {
	    						secFunPermToEnable : 'EDITAR_LIST_TARIFAS_TRABAJO'
	    					},	
	    					columns: [
	    					    {   text: HreRem.i18n('header.subtipo.trabajo'),
	    				        	dataIndex: 'subtipoTrabajoDescripcion',
	    				        	flex: 1
	    				        },		    					          
	    					    {   text: HreRem.i18n('header.codigo.tarifa'),
	    				        	dataIndex: 'codigoTarifa',
	    				        	flex: 1
	    				        },
	    					    {   text: HreRem.i18n('header.descripcion'),
	    				        	dataIndex: 'descripcion',
	    				        	flex: 1
	    				        },
	    				        {   text: HreRem.i18n('header.precio.unitario'),
	    				        	dataIndex: 'precioUnitario',
	    				        	renderer: function(value) {
		            					return Ext.util.Format.currency(value)
		            				},
	    				        	editor: {
	    				        		xtype:'numberfield', 
	    				        		hideTrigger: true,
	    				        		keyNavEnable: false,
	    				        		mouseWheelEnable: false},
	    				        	flex: 1 
	    				        },	
	    				        {   text: HreRem.i18n('header.medicion'),
	    				        	dataIndex: 'medicion',
	    				        	editor: {
	    				        		xtype:'numberfield',
	    				        		hideTrigger: true,
	    				        		keyNavEnable: false,
	    				        		mouseWheelEnable: false},
	    				        	flex: 1
	    				        },
	    				        {   text: HreRem.i18n('header.unidad.medicion'),
	    				        	dataIndex: 'unidadMedida',
	    				        	flex: 1
	    				        },	
	    						{
	    				        	text: HreRem.i18n('header.importe.total'),
	    				            dataIndex: 'importeTotal',
	    				            renderer: function(value) {
		            					return Ext.util.Format.currency(value)
		            				},
	    				            flex: 1,
	    				            summaryType: 'sum',
	    				            summaryRenderer: function(value, summaryData, dataIndex) {
	    				            	
	    				            	return "<span>"+Ext.util.Format.currency(value)+"</span>"
	    				            }
	    						}
	    				    ],
	    				    dockedItems : [
						        {
						            xtype: 'pagingtoolbar',
						            dock: 'bottom',
						            displayInfo: true,
						            bind: {
						                store: '{storeTarifasTrabajo}'
						            }
						        }
						    ],
	    				    
	    					onAddClick: function () {
	    				    	var me = this,
	    				    	idTrabajo = me.up('gestioneconomicatrabajo').getBindRecord().get('idTrabajo'),
	    				    	carteraCodigo = me.up('gestioneconomicatrabajo').getBindRecord().get('carteraCodigo'),
	    				    	tipoTrabajoCodigo = me.up('gestioneconomicatrabajo').getBindRecord().get('tipoTrabajoCodigo'),
	    				    	subtipoTrabajoCodigo = me.up('gestioneconomicatrabajo').getBindRecord().get('subtipoTrabajoCodigo');
	    				    	me.up('formBase').fireEvent('openModalWindow',"HreRem.view.trabajos.detalle.SeleccionTarifasTrabajo",{idTrabajo: idTrabajo, carteraCodigo: carteraCodigo, tipoTrabajoCodigo: tipoTrabajoCodigo, subtipoTrabajoCodigo: subtipoTrabajoCodigo, parent: me.up('gestioneconomicatrabajo')});
		    					
	    					},		    					
	    					saveSuccessFn: function () {
	    						var me = this;
	    						me.up('gestioneconomicatrabajo').funcionRecargar();
	    					},
	    					deleteSuccessFn: function () {
	    						var me = this;
	    						me.up('gestioneconomicatrabajo').funcionRecargar();
	    					}
	    				},
	    				{
	    					xtype:'fieldset',
	    					title: HreRem.i18n('title.proveedor'),
	    					cls	: 'panel-base shadow-panel',
	    					reference: 'fieldsetProveedorGestionEconomica',
	    					layout: {
	    				        type: 'table',
	    				        // The total column count must be specified here
	    				        columns: 2,
	    				        tableAttrs: {
	    				            style: {
	    				                width: '100%'
	    								}
	    				        }
	    					},
	    					defaultType: 'textfieldbase',
		    				collapsed: false,
		   			 		scrollable	: 'y',
		    				cls:'',	    				
						    
	    					items: [
	
			    				{
			    					//Tocar el vertical align del label
			    					xtype: 'comboboxfieldbase',
						        	fieldLabel:  HreRem.i18n('fieldlabel.nombre'),
						        	rowspan:	3,
						        	labelWidth:	150,
						        	width: 		480,
						        	bind: {
					            		store: '{comboProveedor}',
					            		value: '{gestionEconomica.idProveedor}'
					            	},
					            	displayField: 'nombreComercial',
		    						valueField: 'idProveedor',
		    						listeners: {
		    							change: 'onChangeProveedor'
		    						}
			    				},
								{
									fieldLabel: HreRem.i18n('fieldlabel.usuario.contacto'),
									width: 		480,
									bind:		'{proveedor.nombreContacto}',
									readOnly: true
								},
								{
									fieldLabel: HreRem.i18n('fieldlabel.email.contacto'),
									width: 		480,
									bind:		'{proveedor.emailContacto}',
									readOnly: true
								},
								{
									fieldLabel: HreRem.i18n('fieldlabel.telefono.contacto'),
									width: 		480,
									bind:		'{proveedor.telefono1Contacto}',
									readOnly: true
								}
							]
	    				}
	    	            
	    	        ]
	            },
	            {
					xtype: 'formBase',
					cls	: 'panel-base shadow-panel',
				    collapsed: false,
				    colspan: 3,
	
					recordName: "presupuesto",
					
					recordClass: "HreRem.model.PresupuestoTrabajo",       		
				    
				    items: [
	            
	    	            {
	    	            	xtype:'fieldset',
	    					cls	: 'panel-base shadow-panel',
	    				    collapsible: true,
	    				    collapsed: false,
	    					layout: {
	    				        type: 'table',
	    				        // The total column count must be specified here
	    				        columns: 2,
	    				        trAttrs: {height: '45px', width: '100%'},
	    				        tdAttrs: {width: '100%', verticalAlign: 'top'},
	    				        tableAttrs: {
	    				            style: {
	    				                width: '100%'
	    								}
	    				        }
	    					},
	    					defaultType: 'textfieldbase',
	    					hidden: true,
	    					bind: {
	    						hidden: '{!showPresupuesto}',
	    						disabled: '{disablePresupuestos}'
	    					},	
	    					reference: 'fieldsetpresupuestoref',
	    	            	title: HreRem.i18n('title.listado.presupuestos.presentados.proveedores'),
	    				    
	    	            	items: [
			    	            {
			    				    xtype		: 'gridBaseEditableRow',
			    					layout:'fit',
			    					minHeight: 150,
			    					colspan:	2,
			    					topBar: true,
			    					cls	: 'panel-base shadow-panel',
			    					//height: '100%',
			    					reference: 'gridpresupuestostrabajo',
			    					bind: {
			    						store: '{storePresupuestosTrabajo}',
			    						topBar: '{enableAddPresupuesto}'
			    					},
			    					
			    					secFunToEdit: 'EDITAR_LIST_PRESUPUESTOS_TRABAJO',
	    					
			    					secButtons: {
			    						secFunPermToEnable : 'EDITAR_LIST_PRESUPUESTOS_TRABAJO'
			    					},	
			    					
			    					columns: [
			    					    {   text: HreRem.i18n('header.documento'),
			    				        	dataIndex: '',
			    				        	flex: 1
			    				        },
			    					    {   text: HreRem.i18n('header.id.presupuesto'),
			    				        	dataIndex: 'id',
			    				        	flex: 1
			    				        },
			    				        {   text: HreRem.i18n('header.proveedor'),
			    				        	dataIndex: 'proveedorDescripcion',
			    				        	flex: 1 
			    				        },	
			    				        {   text: HreRem.i18n('header.fecha'),
			    				        	dataIndex: 'fecha',
			    				        	flex: 1
			    				        },		
			    						{
			    				        	text: HreRem.i18n('header.estado'),
			    				            dataIndex: 'estadoPresupuestoDescripcion',
			    				            flex: 1
			    				        },
			    				        {   text: HreRem.i18n('header.importe'),
			    				        	dataIndex: 'importe',
			    				        	renderer: function(value) {
				            					return Ext.util.Format.currency(value)
				            				},
			    				        	flex: 1
			    				        }
			    				    ],
			    				    dockedItems : [
	   							        {
	   							            xtype: 'pagingtoolbar',
	   							            dock: 'bottom',
	   							            displayInfo: true,
	   							            bind: {
	   							                store: '{storePresupuestosTrabajo}'
	   							            }
	   							        }
	   							    ],		    				    
			    				    
			    					onAddClick: function (btn) {
			    						var me = this,
			    				    	idTrabajo = me.up('gestioneconomicatrabajo').getBindRecord().get('idTrabajo'),
			    				    	tipoTrabajoDescripcion = me.up('gestioneconomicatrabajo').getBindRecord().get('tipoTrabajoDescripcion'),
			    				    	subtipoTrabajoDescripcion = me.up('gestioneconomicatrabajo').getBindRecord().get('subtipoTrabajoDescripcion'),
			    				    	parent = me.up('gestioneconomicatrabajo'),
			    				    	modoEdicion = false;
			    						presupuesto = Ext.create('HreRem.model.PresupuestosTrabajo', {tipoTrabajoDescripcion: tipoTrabajoDescripcion, subtipoTrabajoDescripcion: subtipoTrabajoDescripcion});
			    						
			    				    	Ext.create("HreRem.view.trabajos.detalle.AnyadirNuevoPresupuesto", {presupuesto: presupuesto, idTrabajo: idTrabajo, parent: parent, modoEdicion: modoEdicion}).show();
			    					},
	
			    				    listeners : [
			    				    	{rowdblclick: 'onPresupuestosListDobleClick',
			    				    	 rowclick: 'onPresupuestosListClick'
			    				    	}
			    				    ],
			    				    saveSuccessFn: function () {
			    						var me = this;
			    						me.up('gestioneconomicatrabajo').funcionRecargar();
			    					},
			    					deleteSuccessFn: function () {
			    						var me = this;
			    						me.up('gestioneconomicatrabajo').funcionRecargar();
			    					}
			    				},
			    				{
			    					xtype:'fieldset',
			    					title: HreRem.i18n('title.detalle.presupuesto.presentado.proveedor'),
			    					reference: 'detallepresupuesto',
			    					cls	: 'panel-base shadow-panel',
			    					layout: {
			    				        type: 'table',
			    				        // The total column count must be specified here
			    				        columns: 2,
			    				        tableAttrs: {
			    				            style: {
			    				                width: '100%'
			    								}
			    				        }
			    					},
			    					defaultType: 'textfieldbase',
				    				collapsed: false,
				   			 		scrollable	: 'y',
				    				cls:'',	    				
								    
			    					items: [
										{
											fieldLabel: HreRem.i18n('fieldlabel.tipo.trabajo'),
											readOnly: true,
											flex: 1,
											bind:		'{presupuesto.tipoTrabajoDescripcion}'
										},
										{
											fieldLabel: HreRem.i18n('fieldlabel.subtipo.trabajo'),
											readOnly: true,
											flex: 1,
											bind:		'{presupuesto.subtipoTrabajoDescripcion}'
										},
										{
											fieldLabel: HreRem.i18n('fieldlabel.id.presupuesto.rem'),
											readOnly: true,
											flex: 1,
											bind:		'{presupuesto.id}'
										},
										{
					    					xtype:'fieldset',
					    					title: HreRem.i18n('title.proveedor'),
					    					cls	: 'panel-base shadow-panel',
					    					rowspan: 5,
					    					layout: {
					    				        type: 'table',
					    				        // The total column count must be specified here
					    				        columns: 1,
					    				        trAttrs: {height: '45px', width: '100%'},
					    				        tdAttrs: {width: '100%'},
					    				        tableAttrs: {
					    				            style: {
					    				                width: '100%'
					    							}
					    				        }
					    					},
					    					defaultType: 'textfieldbase',
						    				collapsed: false,
						   			 		scrollable	: 'y',
						    				cls:'',	    				
										    
						    				items: [
													{
														fieldLabel: HreRem.i18n('fieldlabel.nombre'),
														width: 		280,
														readOnly: true,
														bind: 		'{presupuesto.nombreProveedor}'
													},
													{
														fieldLabel: HreRem.i18n('fieldlabel.usuario'),
														width: 		280,
														readOnly: true,
														bind:		'{presupuesto.usuarioProveedor}'
													},
													{
														fieldLabel: HreRem.i18n('fieldlabel.email'),
														width: 		280,
														readOnly: true,
														bind:		'{presupuesto.emailProveedor}'
													},
													{
														fieldLabel: HreRem.i18n('fieldlabel.telefono'),
														width: 		280,
														readOnly: true,
														bind:		'{presupuesto.telefonoProveedor}'
													}
											]
										},	
										{
											fieldLabel: HreRem.i18n('fieldlabel.referencia.presupuesto.proveedor'),
											readOnly: true,
											bind:		'{presupuesto.refPresupuestoProveedor}'
										},
										{
											fieldLabel: HreRem.i18n('fieldlabel.fecha'),
											readOnly: true,
											bind:		'{presupuesto.fecha}'
										},
										{
											xtype: 'currencyfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.importe'),
											readOnly: true,
											bind:		'{presupuesto.importe}'
										},
										{
											fieldLabel: HreRem.i18n('fieldlabel.comentarios'),
											readOnly: true,
											bind:		'{presupuesto.comentarios}'
										},
										{
											fieldLabel: HreRem.i18n('fieldlabel.estado'),
											readOnly: true,
											bind:		'{presupuesto.estadoPresupuestoDescripcion}'
										},
										{
					    					xtype:'fieldset',
					    					title: HreRem.i18n('title.contabilidad'),
					    					cls	: 'panel-base shadow-panel',
					    					layout: {
					    				        type: 'table',
					    				        // The total column count must be specified here
					    				        columns: 1,
					    				        trAttrs: {height: '45px', width: '100%'},
					    				        tdAttrs: {width: '100%'},
					    				        tableAttrs: {
					    				            style: {
					    				                width: '100%'
					    							}
					    				        }
					    					},
					    					defaultType: 'comboboxfieldbase',
						    				collapsed: false,
						   			 		scrollable	: 'y',
						    				cls:'',	    				
										    
						    				items: [
													{
														fieldLabel: HreRem.i18n('fieldlabel.cuenta.contable'),
														width: 		280,
														readOnly: true,
														bind:		''
													},
													{
														fieldLabel: HreRem.i18n('fieldlabel.partida.presupuestaria'),
														width: 		280,
														readOnly: true,
														bind:		''
													}
											]
										}
									]
			    				}
	    	            	  ]
	    					}
	    	            ]
	            	},
					{
						//Bloque de penalizaci�n
					
		            	xtype: 'fieldsettable',
		            	defaultType: 'textfieldbase',
		            	title: HreRem.i18n('title.penalizacion.retraso'),
		            	items: [
							{
								xtype: 'datefieldbase',
								maxValue: null,
								readOnly: true,
								fieldLabel:  HreRem.i18n('fieldlabel.fecha.compromiso.ejecucion'),
								//width: 		260,
								bind: '{gestionEconomica.fechaCompromisoEjecucion}'
							},
							{
								xtype: 'displayfieldbase',
								fieldLabel:  HreRem.i18n('fieldlabel.dias.retraso.origen'),
								//width: 		260,
								bind: '{gestionEconomica.diasRetrasoOrigen}'
							},
							{
								xtype: 'currencyfieldbase',
								readOnly: true,
								fieldLabel:  HreRem.i18n('fieldlabel.importe.penalizacion.total'),
								//width: 		260,
								bind: '{gestionEconomica.importePenalizacionTotal}',
	        	            	reference: 'importepenalizaciontotalref'
							},
							{
								xtype: 'datefieldbase',
								maxValue: null,
								readOnly: true,
								fieldLabel:  HreRem.i18n('fieldlabel.fecha.ejecucion.real'),
								//width: 		260,
								bind: '{gestionEconomica.fechaEjecucionReal}'
							},
							{
								xtype: 'displayfieldbase',
								fieldLabel:  HreRem.i18n('fieldlabel.dias.retraso.mes.curso'),
								//width: 		260,
								bind: '{gestionEconomica.diasRetrasoMesCurso}'
							},
							{
								xtype: 'currencyfieldbase',
								readOnly: true,
								fieldLabel:  HreRem.i18n('fieldlabel.importe.penalizacion.mes.curso'),
								//width: 		260,
								bind: '{gestionEconomica.importePenalizacionMesCurso}'
							},
							{
								xtype: 'currencyfieldbase',
								fieldLabel:  HreRem.i18n('fieldlabel.importe.penalizacion.diario'),
								//width: 		260,
								bind: '{gestionEconomica.importePenalizacionDiario}'
							}
		            	]
	    	          
					},
					//Bloque de recargos
					{
						xtype: 'fieldsettable',
		            	defaultType: 'textfieldbase',
		            	title: HreRem.i18n('title.recargos.favor.proveedor'),
		            	items: [
							{
							    xtype		: 'gridBaseEditableRow',
							    idPrincipal: 'trabajo.id',
								layout:'fit',
								minHeight: 150,
								colspan:	3,
								topBar: true,
								cls	: 'panel-base shadow-panel',
								bind: {
									store: '{storeRecargosProveedor}'
								},
												
		    					secFunToEdit: 'EDITAR_LIST_RECARGOS_TRABAJO',
		    					
		    					secButtons: {
		    						secFunPermToEnable : 'EDITAR_LIST_RECARGOS_TRABAJO'
		    					},	
								columns: [
								    {   text: HreRem.i18n('header.tipo'),
							        	dataIndex: 'tipoRecargoCodigo',
							        	editor: {
							        		xtype: 'combobox',								        		
							            	store: new Ext.data.Store({
								    			model: 'HreRem.model.ComboBase',
												proxy: {
													type: 'uxproxy',
													remoteUrl: 'generic/getDiccionario',
													extraParams: {diccionario: 'tiposRecargo'}
												},
												autoLoad: true
											}),
											displayField: 'descripcion',
											valueField: 'codigo'
							        	},								        							        	
							        	renderer: function(value) {								        		
							        		var me = this,
							        		comboEditor = me.columns  && me.columns[0].getEditor ? me.columns[0].getEditor() : me.getEditor ? me.getEditor() : null,
							        		store, record;
							        		
							        		if(!Ext.isEmpty(comboEditor)) {
								        		store = comboEditor.getStore(),							        		
								        		record = store.findRecord("codigo", value);
							        		
								        		if(!Ext.isEmpty(record)) {								        			
								        			return record.get("descripcion");								        		
								        		} else {
								        			comboEditor.setValue(value);								        			
								        		}
							        		}
							        	},
							        	flex: 1
							        },
							        {   text: HreRem.i18n('header.tipo.calculo'),
							        	dataIndex: 'tipoCalculoCodigo',
							        	editor: {
							        		xtype: 'combobox',								        		
							            	store: new Ext.data.Store({
								    			model: 'HreRem.model.ComboBase',
												proxy: {
													type: 'uxproxy',
													remoteUrl: 'generic/getDiccionario',
													extraParams: {diccionario: 'tiposCalculo'}
												},
												autoLoad: true
											}),
											displayField: 'descripcion',
											valueField: 'codigo'
										},		        							        	
							        	renderer: function(value) {								        		
							        		var me = this,
							        		comboEditor = me.columns  && me.columns[1].getEditor ? me.columns[1].getEditor() : me.getEditor ? me.getEditor() : null,
							        		store,record;
							        		
							        		if(!Ext.isEmpty(comboEditor)) {
								        		store = comboEditor.getStore(),							        		
								        		record = store.findRecord("codigo", value);							        		
								        		if(!Ext.isEmpty(record)) {								        			
								        			return record.get("descripcion");								        		
								        		} else {
								        			comboEditor.setValue(value);								        			
								        		}
							        		}
							        	},
							        	flex: 1
							        },
							        {   text: HreRem.i18n('header.importe.calculo'),
							        	dataIndex: 'importeCalculo',
		        						editor: {
		        							xtype:'numberfield', 
		        							hideTrigger: true,
		        							keyNavEnable: false,
		        							mouseWheelEnable: false
		        						},
							        	flex: 1
							        },
							        {   text: HreRem.i18n('header.importe.final'),
							        	dataIndex: 'importeFinal',
							        	renderer: function(value) {
		       								return Ext.util.Format.currency(value);
		        						},
							        	flex: 1
							        }
							    ],
							   	saveSuccessFn: function () {
			    					var me = this;
			    					me.up('gestioneconomicatrabajo').funcionRecargar();
		    					},
		    					deleteSuccessFn: function () {
		    						var me = this;
		    						me.up('gestioneconomicatrabajo').funcionRecargar();
		    					}
							}
		            	]
					},
					//Bloque de base imponible
					{
						xtype:'fieldset',
						height: 50,
						layout: {
					        type: 'vbox',
					        align: 'end'
			        	},
					    items: [
							{
								xtype: 'currencyfieldbase',
								margin: '10 0 10 0',
								cls: 'txt-importe-total',
								readOnly: true,
								fieldLabel:  HreRem.i18n('fieldlabel.base.imponible.a.b.c'),
								width: 		350,
								bind: '{gestionEconomica.importeTotal}',
								reference: 'importetotalref'
							}
						]
					},
					//Bloque de provisiones y suplidos
					{
		            	xtype:'fieldsettable',
						defaultType: 'textfieldbase',
		            	title: HreRem.i18n('title.provisiones.suplidos'),
					    
		            	items: [
		    	            {
		    				    xtype		: 'gridBaseEditableRow',
		    				    idPrincipal: 'trabajo.id',
		    					layout:'fit',
		    					minHeight: 150,
		    					colspan:	3,
		    					topBar: true,
		    					cls	: 'panel-base shadow-panel',
		    					secFunToEdit: 'EDITAR_LIST_PROVSUPLI_TRABAJO',
		    					
		    					secButtons: {
		    						secFunPermToEnable : 'EDITAR_LIST_PROVSUPLI_TRABAJO'
		    					},	
		    					bind: {
		    						store: '{storeProvisionesSuplidos}'
		    					},
		    					columns: [
		    					    {   text: HreRem.i18n('header.tipo'),
		    				        	dataIndex: 'tipoCodigo',
		    				        	editor: {
							        		xtype: 'combobox',								        		
							            	store: new Ext.data.Store({
								    			model: 'HreRem.model.ComboBase',
												proxy: {
													type: 'uxproxy',
													remoteUrl: 'generic/getDiccionario',
													extraParams: {diccionario: 'tiposAdelanto'}
												},
												autoLoad: true
											}),
											displayField: 'descripcion',
											valueField: 'codigo'
							        	},								        							        	
							        	renderer: function(value) {								        		
							        		var me = this,
							        		comboEditor = me.columns  && me.columns[0].getEditor ? me.columns[0].getEditor() : me.getEditor ? me.getEditor() : null,
							        		store,record;
							        		
							        		if(!Ext.isEmpty(comboEditor)) {
								        		store = comboEditor.getStore(),							        		
								        		record = store.findRecord("codigo", value);
								        		if(!Ext.isEmpty(record)) {								        			
								        			return record.get("descripcion");								        		
								        		} else {
								        			comboEditor.setValue(value);								        			
								        		}	
							        		}
							        	},			    				        	
		    				        	flex: 1
		    				        },
		    				        {   text: HreRem.i18n('header.concepto'),
		    				        	dataIndex: 'concepto',
		    				        	editor: {
		    				        		xtype: 'textfield'
		    				        	},
		    				        	flex: 4
		    				        },
		    				        {
		    				        	text: HreRem.i18n('header.fecha'),
		    				            dataIndex: 'fecha',
		    				            editor: {
		    				        		xtype: 'datefield'
		    				        	},
		    				            flex: 1
		    				            
		    				        },
		    				        {   text: HreRem.i18n('header.importe'),
		    				        	dataIndex: 'importe',
		    				        	editor: {
		        							xtype:'numberfield', 
		        							hideTrigger: true,
		        							keyNavEnable: false,
		        							mouseWheelEnable: false
		        						},
		    				        	flex: 1,
		    				        	renderer: function (value, column, record) {
		    				        		if(!Ext.isEmpty(value)){
		    				        			if(record.get("tipoCodigo")== "01") {
		    				        				return "<span class='numero-negativo'> - "+ Ext.util.Format.currency(value) +"</span>"	
		    				        			}else {
		    				        				return Ext.util.Format.currency(value);	
		    				        			}
		    				        			
		    				        				  
		    				        		} else {
		    				        			return "";
		    				        		}  		  				        		
		    				        		
		    				        	}
		    				        }
		    				    ]
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