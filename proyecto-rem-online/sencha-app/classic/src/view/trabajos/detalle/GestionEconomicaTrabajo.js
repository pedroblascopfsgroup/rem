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
               		'HreRem.view.common.FieldSetTable','HreRem.model.PresupuestoTrabajo','HreRem.model.ProvisionSuplido', 'HreRem.view.trabajos.detalle.HistorificacionDeCamposGrid'],
    totalProv	: null,
    totalCli	: null,
    refreshaftersave: true,
    afterLoad: function () {
    	this.lookupController().desbloqueaCamposSegunEstadoTrabajo(this);
    },
    initComponent: function () {
    	var me = this;
    	me.setTitle(HreRem.i18n('title.gestion.economica'));

    	me.idTrabajo= me.lookupController().getViewModel().get('trabajo').get('idTrabajo');
    	me.items = [
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
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.nombre'),
						labelWidth: 150,
						width: 480,
						reference: 'comboProveedorGestionEconomica',
						chainedReference: 'proveedorContactoCombo',
						bind: {
							store: '{comboProveedorFiltradoManual}',
							value: '{gestionEconomica.idProveedor}',
							readOnly: '{!gestionEconomica.esProveedorEditable}'
						},
						displayField: 'nombreComercial',
						valueField: 'idProveedor',
						filtradoEspecial: true,
						listeners: {
		                	select: 'onChangeComboProveedorGE'
		            	}
					},
					{
						fieldLabel: HreRem.i18n('fieldlabel.email.contacto'),
						xtype: 'textfieldbase',
						width: 480,
						bind: {
							value: '{gestionEconomica.emailProveedorContacto}'
						},
						readOnly: true
					},
					{ 
						xtype: 'comboboxfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.proveedor.contacto'),
			        	reference: 'proveedorContactoCombo',
			        	labelWidth:	150,
			        	width: 		480,
			        	bind: {
		            		store: '{comboProveedorContacto}',
		            		value: '{gestionEconomica.idProveedorContacto}',
		            		disabled: '{!gestionEconomica.idProveedor}'
		            	},
		            	displayField: 'nombre',
						valueField: 'id',
						allowBlank: true,
						listeners: {
							change: 'onChangeProveedor',
							expand: 'onChangeProveedorGestionEconomica'
						}
			        },
					{
						fieldLabel: HreRem.i18n('fieldlabel.telefono.contacto'),
						width: 480,
						bind: {
							value: '{gestionEconomica.telefonoProveedorContacto}'
						},
						readOnly: true
					}
				]
			},
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
					bind: {
						disabled: '{!disableTarificacion}'
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
	    					cls	: 'panel-base shadow-panel',
	    					topBar: true,
	    					editOnSelect: true,
	    					//height: '100%',
	    					bind: {
	    						store: '{storeTarifasTrabajo}',
	    						editOnSelect: '{editableTarificacionProveedor}',
	    						topBar: '{editableTarificacionProveedor}'
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
	    				        		allowBlank: false,
	    				        		hideTrigger: true,
	    				        		keyNavEnable: false,
	    				        		mouseWheelEnable: false,
	    				        		reference: 'preciounitarioref',
	    				        		listeners:{
	    				        			change: function(x, y, z){
	    				        				var field = this;
	    				        				var precioUniCli = field.up().down("[reference='preciounitarioclienteref']");
	    				        				if(!precioUniCli.hidden){
	    				        					precioUniCli.setMinValue(field.value);
	    				        					precioUniCli.validate();
	    				        				}
	    				        			}
	    				        		}
	    				        	},
	    				        	flex: 1,
	    				        	bind: {
	    				            	hidden: '{!mostrarTotalProveedor}'
	    				            }
	    				        },
	    				        {   text: HreRem.i18n('header.precio.unitario.cliente'),
	    				        	dataIndex: 'precioUnitarioCliente',
	    				        	renderer: function(value) {
		            					return Ext.util.Format.currency(value)
		            				},
	    				        	editor: {
	    				        		xtype:'numberfield', 
	    				        		allowBlank: false,
	    				        		hideTrigger: true,
	    				        		keyNavEnable: false,
	    				        		mouseWheelEnable: false,
	    				        		reference: 'preciounitarioclienteref',
	    				        		listeners:{
	    				        			change: function(x, y, z){
	    				        				var field = this;
	    				        				field.setMinValue(field.up().down("[reference='preciounitarioref']").value);
	    				        			}
	    				        		}
		            				},
	    				        	flex: 1,
	    				        	bind: {
	    				            	hidden: '{!mostrarTotalCliente}'
	    				            }
	    				        },	
	    				        {   text: HreRem.i18n('header.medicion'),
	    				        	dataIndex: 'medicion',
	    				        	editor: {
	    				        		xtype:'numberfield',
	    				        		allowBlank: false,
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
		            					return Ext.util.Format.currency(value);
		            				},
	    				            flex: 1,
	    				            bind: {
	    				            	hidden: '{!mostrarTotalProveedor}'
	    				            }
	    						},	
	    						{
	    				        	text: HreRem.i18n('header.importe.total.cliente'),
	    				        	dataIndex: 'importeCliente',
	    				            renderer: function(value) {
		            					return Ext.util.Format.currency(value);
		            				},
	    				            flex: 1,
	    				            bind: {
	    				            	hidden: '{!mostrarTotalCliente}'
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
	    				    	subcarteraCodigo = me.up('gestioneconomicatrabajo').getBindRecord().get('subcarteraCodigo');
	    				    	// HREOS-1811 Errores modalwindow seleccion tarifas por esconder la ventana y abrir entre 2 trabajos distintos
	    				    	// me.up('formBase').fireEvent('openModalWindow',"HreRem.view.trabajos.detalle.SeleccionTarifasTrabajo",{idTrabajo: idTrabajo, carteraCodigo: carteraCodigo, tipoTrabajoCodigo: tipoTrabajoCodigo, subtipoTrabajoCodigo: subtipoTrabajoCodigo, parent: me.up('gestioneconomicatrabajo')});
	    				    	Ext.create("HreRem.view.trabajos.detalle.SeleccionTarifasTrabajo",{idTrabajo: idTrabajo, carteraCodigo: carteraCodigo, tipoTrabajoCodigo: tipoTrabajoCodigo, subtipoTrabajoCodigo: subtipoTrabajoCodigo, subcarteraCodigo: subcarteraCodigo, parent: me.up('gestioneconomicatrabajo')}).show();
		    					
	    					},		    					
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
	    					bind: {
	    						disabled: '{!disablePresupuesto}'
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
			    					reference: 'gridpresupuestostrabajo',
			    					bind: {
			    						store: '{storePresupuestosTrabajo}',
			    						topBar: '{disableTopBarPresupuesto}'
			    					},
			    					
			    					secFunToEdit: 'EDITAR_LIST_PRESUPUESTOS_TRABAJO',
	    					
			    					secButtons: {
			    						secFunPermToEnable : 'EDITAR_LIST_PRESUPUESTOS_TRABAJO'
			    					},	
			    					
			    					columns: [
//			    					    {   text: HreRem.i18n('header.documento'),
//			    				        	dataIndex: '',
//			    				        	flex: 1
//			    				        },
			    					    {   text: HreRem.i18n('header.id.presupuesto'),
			    				        	dataIndex: 'id',
			    				        	flex: 1
			    				        },
			    				        {   text: HreRem.i18n('fieldlabel.referencia.presupuesto.proveedor'),
			    				        	dataIndex: 'refPresupuestoProveedor',
			    				        	flex: 1
			    				        },
			    				        {   text: HreRem.i18n('header.proveedor'),
			    				        	reference: 'proveedorDescripcionRef',
			    				        	dataIndex: 'proveedorDescripcion',
			    				        	flex: 1 
			    				        },	
			    				        {   text: HreRem.i18n('header.fecha'),
			    				        	dataIndex: 'fecha',
			    				        	flex: 1
			    				        },		
//			    						{
//			    				        	text: HreRem.i18n('header.estado'),
//			    				            dataIndex: 'estadoPresupuestoDescripcion',
//			    				            flex: 1
//			    				        },
			    				        {   text: HreRem.i18n('header.importe'),
			    				        	dataIndex: 'importe',
			    				        	renderer: function(value) {
				            					return Ext.util.Format.currency(value)
				            				},
				            				bind: {
												hidden: '{!mostrarTotalProveedor}'
											},
			    				        	flex: 1
			    				        },
			    				        {   text: HreRem.i18n('header.importe.cliente'),
			    				        	dataIndex: 'importeCliente',
			    				        	renderer: function(value) {
				            					return Ext.util.Format.currency(value)
				            				},
				            				bind: {
												hidden: '{!mostrarTotalCliente}'
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
			    						codigoTipoProveedor = parent.getBindRecord().get('codigoTipoProveedor');
			    						idProveedor = parent.getBindRecord().get('idProveedor');
			    				    	idProveedorContacto = parent.getBindRecord().get('idProveedorContacto');
			    				    	emailProveedorContacto = parent.getBindRecord().get('emailProveedorContacto');
			    				    	nombreProveedorContacto = parent.getBindRecord().get('nombreProveedorContacto');
			    				    	usuarioProveedorContacto = parent.getBindRecord().get('usuarioProveedorContacto');
			    						presupuesto = Ext.create('HreRem.model.PresupuestosTrabajo', {tipoTrabajoDescripcion: tipoTrabajoDescripcion, subtipoTrabajoDescripcion: subtipoTrabajoDescripcion, codigoTipoProveedor: codigoTipoProveedor, idProveedor: idProveedor, idProveedorContacto: idProveedorContacto, emailProveedorContacto: emailProveedorContacto, nombreProveedorContacto: nombreProveedorContacto, usuarioProveedorContacto: usuarioProveedorContacto});
			    						
			    				    	var window=Ext.create("HreRem.view.trabajos.detalle.AnyadirNuevoPresupuesto", {presupuesto: presupuesto, idTrabajo: idTrabajo, parent: parent, modoEdicion: modoEdicion}).show();
			    				    	window.getViewModel().set('trabajo',me.lookupController().getViewModel().get('trabajo'));
			    					},
	
			    				    listeners : [
			    				    	{rowdblclick: 'onPresupuestosListDobleClick'
			    				    	 //rowclick: 'onPresupuestosListClick'
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
	    					}
	    	            ]
	            	},
	            	{
						//Bloque de penalizacion
					
		            	xtype: 'fieldsettable',
		            	defaultType: 'textfieldbase',
		            	title: HreRem.i18n('title.penalizacion.retraso'),
						bind: {
							disabled: '{disablePorCierreEconomico}'
						},
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
					//Bloque de base imponible
					{
						xtype:'fieldset',
						height: 100,
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
								fieldLabel:  HreRem.i18n('header.importe.total'),
								width: 		350,
								bind: {
									hidden: '{!mostrarTotalProveedor}',
									value: '{gestionEconomica.importePresupuesto}'
								},
								reference: 'importetotalref'
							},
							{
								xtype: 'currencyfieldbase',
								margin: '10 0 10 0',
								cls: 'txt-importe-total',
								readOnly: true,
								fieldLabel:  HreRem.i18n('header.importe.total.cliente'),
								width: 		350,
								bind: {
									hidden: '{!mostrarTotalCliente}',
									value: '{gestionEconomica.importeTotal}'
								},
								reference: 'importetotalcliref'
							}
						]
					},
					//Bloque de provisiones y suplidos
					{
		            	xtype:'fieldsettable',
						defaultType: 'textfieldbase',
		            	title: HreRem.i18n('title.provisiones.suplidos'),		            	
						bind: {
							disabled: '{disablePorCierreEconomicoSuplidos}'
						},	
		            	items: [
		    	            {
		    				    xtype		: 'gridBaseEditableRow',
		    				    idPrincipal: 'trabajo.id',
		    					layout:'fit',
		    					minHeight: 150,
		    					colspan:	3,
		    					topBar: true,
		    					reference:'gridSuplidos',
		    					cls	: 'panel-base shadow-panel',
		    					secFunToEdit: 'EDITAR_LIST_PROVSUPLI_TRABAJO',		    					
		    					secButtons: {
		    						secFunPermToEnable : 'EDITAR_LIST_PROVSUPLI_TRABAJO'
		    					},	
		    					bind: {
		    						store: '{storeProvisionesSuplidos}',
		    						topBar:'{!gestionEconomica.esGridSuplidosEditable}',
		    						editOnSelect: '{!gestionEconomica.esGridSuplidosEditable}'
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
		            },
		            {
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							colspan: 3,
							reference:'historificacionCampos',
							hidden: false, 
							title: HreRem.i18n("title.historificacion.campos"),
							
							items :
							[
								{
									xtype: "historificacioncamposgrid", 
									reference: "historificacioncamposgrid",
									idTrabajo: this.lookupController().getViewModel().get('trabajo').get('id'),
									codigoPestanya: CONST.PES_PESTANYAS['DETALLE_ECONOMICO'],
									colspan: 3
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