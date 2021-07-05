Ext.define('HreRem.view.trabajos.detalle.CrearPeticionTrabajo', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'crearpeticiontrabajowin',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /1.8,    
    height	: Ext.Element.getViewportHeight() > 700 ? 700 : Ext.Element.getViewportHeight() - 50,
	reference: 'crearpeticiontrabajowinref',
    controller: 'trabajodetalle',
    viewModel: {
        type: 'trabajodetalle'
    },
    requires: ['HreRem.model.FichaTrabajo','HreRem.view.trabajos.detalle.ActivosAgrupacionTrabajoList',
				'HreRem.view.trabajos.detalle.VentanaTarifasTrabajo','HreRem.view.trabajos.detalle.listaActivosAgrupacionGrid','HreRem.model.TarifasGridModel', 'HreRem.view.common.ComboBoxFieldBaseDD'],
    
	listeners: {

		boxready: function(window) {
			var me = this;
			
			me.lookupReference('checkMultiActivo').fireEvent('change');
			me.lookupController().validaGrid();
			Ext.Array.each(window.down('form').query('field[isReadOnlyEdit]'),
				function (field, index) 
					{ 							
						field.fireEvent('edit');
						if(index == 0) field.focus();
					}
			);
			
		},
		
		show: function() {	
			var me = this;
			me.resetWindow();			
		}

	},
    
	datos: [],
	
    idActivo: null,
    
    idAgrupacion: null,
    
    idProceso: null,
    
    codCartera: null,
    
    codSubcartera: null,
    
    logadoGestorMantenimiento: null,
    
    gestorActivo: null,
    
    trabajoDesdeActivo: false,
	
    initComponent: function() {
    	var me = this;
    	var emptyStoreTarifas = new Ext.data.ArrayStore({
	        model: 'HreRem.model.TarifasGridModel',
	        idIndex: 0,
	        autoLoad: false
	    });
    	var disableCampoTomaPosesion = me.lookupController().checkDisableCampoTomaPosesion();

    	me.setTitle(HreRem.i18n("title.peticion.trabajo.nuevo"));
    	
    	me.buttonAlign = 'left'; 
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Crear', handler: 'onClickBotonCrearPeticionTrabajo'},{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'hideWindowCrearPeticionTrabajo'}];

    	me.items = [
    				{
	    				xtype: 'formBase', 
	    				collapsed: false,
	   			 		scrollable	: 'y',
	    				cls:'',
						reference: 'formBaseCrearTrabajo',
					    recordName: "trabajo",
						recordClass: "HreRem.model.FichaTrabajo",
					    
    					items: [
        							{    
				                
										xtype:'fieldsettable',
										collapsible: false,
										defaultType: 'textfieldbase',
										
										items :
											[
											{    
				                
												xtype:'fieldsettable',
												collapsible: false,
												border:0,
												colspan:2,
												defaultType: 'textfieldbase',												
										    	defaults: {
										    		addUxReadOnlyEditFieldPlugin: false
										    	},
												items :
													[
													 {
													        xtype: 'textfieldbase',
													        readOnly: true,
													        fieldLabel: HreRem.i18n('fieldlabel.gestor.logado.nuevo.trabajo'),
													        reference:'gestorActivo',
															colspan: 3,
															padding:'2 2 2 2',
															addUxReadOnlyEditFieldPlugin: true,
													        bind: 
													        	{
													            	value: me.gestorActivo
												            	}
												       },
	       												{
															xtype: 'datefieldbase',
															readOnly: true,
															fieldLabel: HreRem.i18n('fieldlabel.fecha.alta.nuevo.trabajo'),
															minValue: $AC.getCurrentDate(),
															maxValue: null,
															value:  $AC.getCurrentDate(),
															addUxReadOnlyEditFieldPlugin: true,
															colspan: 3,
															allowBlank: false
														},
														{ 
												        	xtype: 'comboboxfieldbase',
												        	editable: false,
												        	fieldLabel: HreRem.i18n('fieldlabel.tipo.trabajo'),
															reference: 'tipoTrabajo',
												        	chainedStore: 'comboSubtipoTrabajo',
															chainedReference: 'subtipoTrabajoCombo',
															disabled: true,
															colspan: 3,
												        	bind: 
												        		{
											            			store: '{storeTipoTrabajoCreaFiltered}',
											            			value: '{trabajo.tipoTrabajoCodigo}'
										            			},
								    						listeners: 
								    							{
											                		select: 'onChangeChainedCombo'
											                		
											            		},
											            	allowBlank: false,
															validator: function(){
																var me = this;
																
																if((me.up('formBase').down('[reference=listaActivosSubidaRef]').getStore().getData() == null 
    																|| me.up('formBase').down('[reference=listaActivosSubidaRef]').getStore().getData().length < 1)
																	&& (me.up('formBase').down('[reference=activosagrupaciontrabajo]').getStore().getData() == null 
    																|| me.up('formBase').down('[reference=activosagrupaciontrabajo]').getStore().getData().length < 1)){
																	return 'Es necesario cargar el listado de activos para poder seleccionar el tipo de trabajo';
																}																
																return true;
															}
												        },
												        { 
															xtype: 'comboboxfieldbase',
												        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.trabajo'),
												        	reference: 'subtipoTrabajoCombo',
												        	chainedReference: 'comboTipoProveedorGestionEconomica2',
												        	colspan: 3,
												        	editable: false,
												        	bind: 
												        		{
										            				store: '{comboSubtipoTrabajo}',
											            			value: '{trabajo.subtipoTrabajoCodigo}',
											            			disabled: '{!trabajo.tipoTrabajoCodigo}'
											            		},
								    						listeners: 
								    							{
											                		select: 'onChangeSubtipoTrabajoCombo',
											                		change: 'valorComboSubtipo'
											            		},
															allowBlank: false
												        },
									    				{ 
												        	xtype: 'comboboxfieldbasedd',
												        	fieldLabel: HreRem.i18n('fieldlabel.proveedor'),
															flex: 		1,
															colspan: 3,
															reference: 'comboProveedorGestionEconomica2',
															chainedReference: 'proveedorContactoCombo2',
											            	listConfig: {
																loadingHeight: 200,
											            		loadingText: 'Buscando proveedores...'
											            	},
															disabled: true,
											            	displayField: 'nombreComercial',
								    						valueField: 'idProveedor',
															filtradoEspecial2: true,
							    						    listeners: {
																select: 'onChangeProveedorCombo'							    						     	
							    						    },
															tpl: Ext.create('Ext.XTemplate',
																	'<tpl for=".">',
																		'<div class="x-boundlist-item">{codigo} - {nombre} - {descripcionTipoProveedor} - {estadoProveedorDescripcion}</div>',
																	'</tpl>'
															),
															displayTpl:  Ext.create('Ext.XTemplate',
																	'<tpl for=".">',
																		'{codigo} - {nombre} - {descripcionTipoProveedor} - {estadoProveedorDescripcion}',
																	'</tpl>'
															),
															validator: function(){
																var me = this;
																
																if(me.up('window').codCartera == null 
																	|| (me.up('formBase').down('[reference=listaActivosSubidaRef]').getStore().getData() == null 
    																|| me.up('formBase').down('[reference=listaActivosSubidaRef]').getStore().getData().length < 1)
																	&& (me.up('formBase').down('[reference=activosagrupaciontrabajo]').getStore().getData() == null 
    																|| me.up('formBase').down('[reference=activosagrupaciontrabajo]').getStore().getData().length < 1)){
																	return 'Es necesario cargar el listado de activos para poder seleccionar el proveedor del trabajo';
																}
																if(Ext.isEmpty(me.getValue())){
																	return 'Este campo es obligatorio';
																}
																return true;
															}
												        },
												        { 
															xtype: 'comboboxfieldbase',
												        	fieldLabel:  HreRem.i18n('fieldlabel.proveedor.contacto'),
												        	reference: 'proveedorContactoCombo2',
															listConfig: {
																loadingHeight: 200,
											            		loadingText: 'Buscando proveedores contacto...',
																emptyText: 'No se han encontrado proveedores contacto'
											            	},					
															flex: 		1,
															colspan: 3,
															disabled: true,
											            	displayField: 'fullName',
								    						valueField: 'id',
								    						allowBlank: false
												        }
													]
												},
												{    
				                
													xtype:'fieldsettable',
													collapsible: false,
													defaultType: 'textfieldbase',
													border:0,
													colspan:1,
											    	defaults: {
											    		addUxReadOnlyEditFieldPlugin: false
											    	},
													items :
														[
															{
																xtype: 'checkboxfieldbase',
																boxLabel: HreRem.i18n('fieldlabel.aplica.comite.trabajo'),
																colspan: 3,
																reference: 'checkAplicaComite',
																listeners: {
													                change: 'onCheckChangeAplicaComite'
													            },
																checked: false
															},
															{ 
																xtype: 'comboboxfieldbase',
													        	fieldLabel:  HreRem.i18n('fieldlabel.resolucion.comite'),
													        	colspan: 3,
													        	editable: false,
													        	disabled: true,
													        	reference: 'comboResolucionComite',
													        	listeners: {
													        		change : 'requiredDateResolucionComite'
													        	},
													        	bind : {
													        		store: '{comboAprobacionComite}'
													        	}
										        			},

															{
																xtype: 'datefieldbase',
																fieldLabel: HreRem.i18n('fieldlabel.fecha.resolucion.comite.trabajo'),
																minValue: $AC.getCurrentDate(),
																maxValue: null,
																reference: 'fechaResolComite',
																colspan: 3,
																disabled: true
															},
										        			{
														        xtype: 'textfieldbase',
														        fieldLabel: HreRem.i18n('fieldlabel.id.resolucion.comite'),
																colspan: 3,
																reference: 'resolComiteId',
																disabled: true,
																maxLength: 10
													       }
														]
												},
								                
												{    
				                
													xtype:'fieldsettable',
													collapsible: false,
													defaultType: 'textfieldbase',
													colspan:3,
													border:0,
											    	defaults: {
											    		addUxReadOnlyEditFieldPlugin: false
											    	},
													items :
														[
													        {
													            reference:'idTarea',
													            fieldLabel : HreRem.i18n('fieldlabel.id.tarea.trabajo'),
													            allowBlank: true,
													            maxLength:10
				        									},
				        									{ 
						        								xtype: 'comboboxfieldbase',
						        								fieldLabel: HreRem.i18n('fieldlabel.primera.actuacion.toma.posesion'),
						        								collapsible: false,
						        								padding: '0 10 0 10',
																border:0, 
																reference: 'tomaDePosesion',
						        								bind: {
					            										store: '{comboSiNoRem}',
					            	    								value: '{trabajo.tomaPosesion}'
					            									},
					            								disabled: disableCampoTomaPosesion,
					            								displayField: 'descripcion',
							    								valueField: 'codigo'
			            									
				        									}
													]
												},
												{
													xtype:'fieldsettable',
													collapsible: false,
													defaultType: 'textfieldbase',
													colspan:3,
													border:0,
													defaults: {
											    		addUxReadOnlyEditFieldPlugin: false
											    	},
													items :
														[
				        									{ 
				        										xtype: 'comboboxfieldbase',
						        								fieldLabel: HreRem.i18n('fieldlabel.trabajo.area.peticionaria'),
						        								collapsible: false,
						        								allowBlank: false,
																border:0,
																reference: 'identificadorReamRef',
						        								bind: {
					            										store: '{comboIdentificadorReam}',
					            	    								value: '{trabajo.identificadorReamCodigo}'
					            									},
					            								//disabled: disableCampoTomaPosesion,
					            								displayField: 'descripcion',
							    								valueField: 'codigo'
			            									
				        									}
													]
	        										
	        									},
										        {
								                	xtype: 'label',
								                	reference: 'textAdvertenciaCrearTrabajo',
								                	style: 'color: red; font-weight: bolder;',
								                	width: 		'100%',
								                	colspan: 3
						                		},
												{
									              	xtype: 'fieldset',
									        	    title: HreRem.i18n('title.subirfichero'),
									        	    reference: 'fieldSetSubirFichero',
									        	    hidden: false,
									        	    cls	: 'panel-base shadow-panel',
									        	    colspan:3,
									        	    items : [
									        	    	
									        	        {
									        	            xtype: 'formBase',
								        	              	cls:'',
								        	   				url: $AC.getRemoteUrl('trabajo/subeListaActivos'),		
								        	   				buttons: [{	
								        	   				 	       itemId: 'btnSubirFichero', 
								        	   						   text: 'Subir fichero',
								        	   						   handler: 'onClickUploadListaActivos'
								        	   						 },
								        	   						{	itemId: 'btnDownload', 
								        	   							text: 'Descargar plantilla', 
								        	   							handler: 'onClickBotonDescargarPlantilla'
								        	   						}],
								        	   				reference: 'formSubirListaActivos',
								        	   				items:[{
								        	   						xtype: 'filefield',
								        	   						reference: 'filefieldActivosRef',
								        	   						fieldLabel:   HreRem.i18n('fieldlabel.archivo'),
								        	   						name: 'fileUpload',
								        	   						allowBlank: true,					        
								        	   						anchor: '100%',
								        	   						width: '100%',
								        	   						msgTarget: 'side',
								        	   						buttonConfig: {
								        	   						     	iconCls: 'ico-search-white',
								        	   						      	text: ''
								        	   						},
								        	   						align: 'right',
								        	   						listeners: {
								        	   						        change: function(fld, value) {
									        	   						       	var lastIndex = null,
									        	   								fileName = null;
									        	   								if(!Ext.isEmpty(value)) {
									        	   									lastIndex = value.lastIndexOf('\\');
									        	   								if (lastIndex == -1) return;
									        	   									fileName = value.substring(lastIndex + 1);
										        	   								fld.setRawValue(fileName);
									        	   								}		                            	
								        	   						        }
								        	   						},
									        	   						width: '50%',
									        	   						regex: /(.)+((\.xls)(\w)?)$/i,
									        	   						regexText: HreRem.i18n("msg.validacion.archivos.xls")
									        	   					}]
									        	   			}]
									        	},
										        //GRID LISTADO ACTIVOS
												{    
												xtype:'fieldsettable',
												collapsible: false,
												title: HreRem.i18n('title.publicaciones.activos.grid'),
												defaultType: 'textfieldbase',
												colspan:3,
												defaults: {
											    	addUxReadOnlyEditFieldPlugin: false
											    },
												items :
													[
														{
															xtype: 'checkboxfieldbase',
															boxLabel: HreRem.i18n('fieldlabel.check.multiactivo'),
															checked: true,
															reference: 'checkMultiActivo',
															listeners: {
												                change: 'onCheckChangeMultiActivo'
												            },
												            bind: {
												            	disabled: '{deshabilitarCheckMultiactivo}'
												            },
															colspan: 1
														},
														{
															xtype: 'checkboxfieldbase',
															boxLabel: HreRem.i18n('title.ejecutar.trabajo.por.agrupacion'),
															checked: true,
															reference: 'checkEnglobaTodosActivosRef',
															colspan: 2
														},
										    			{
														    xtype: 'gridBase',
															cls	: 'panel-base shadow-panel',
															reference: 'listaActivosSubidaRef',
															loadAfterBind: false,
															colspan:3,
															bind: {
				        	   									store: '{listaActivosSubida}'
															},
															columns: [
				        	   									{
				        	   										dataIndex: 'numActivoHaya',
				        	   										text: HreRem.i18n('header.numero.activo.haya'),
				        	   										flex: 1										
				        	   									},
				        	   									{
				        	   										dataIndex: 'numFincaRegistral',
				        	   										text: HreRem.i18n('header.finca.registral'),
				        	   										flex: 1										
				        	   									},
				        	   									{
				        	   									     dataIndex: 'tipoActivo',
				        	   									     text: HreRem.i18n('header.tipo'),
				        	   									     flex: 1
				        	   									},
				        	   									{
				        	   									     dataIndex: 'subtipoActivo',
				        	   									     text: HreRem.i18n('header.subtipo'),
				        	   										 flex: 1													            
				        	   									},
				        	   									{
				        	   										dataIndex: 'cartera',
				        	   										text: HreRem.i18n('header.cartera'),
				        	   										flex: 1	 	
				        	   									},
				        	   									{
				        	   									    dataIndex: 'situacionComercial',
				        	   									    text: HreRem.i18n('header.situacion.comercial'),
				        	   									    flex: 1
				        	   									},
				        	   									{
				        	   									    dataIndex: 'situacionPosesoria',
				        	   									    text: HreRem.i18n('header.situacion.posesoria'),
				        	   									    flex: 1													            
				        	   									},
														        {
														        	dataIndex: 'activoEnPropuestaEnTramitacion',
														        	text: HreRem.i18n("header.incluido.en.propuesta.tramite"),
														        	hidden: true,
														        	renderer: Utils.rendererBooleanToSiNo,
														        	flex: 1
														        },
														        {
														        	dataIndex: 'activoTramite',
														        	text: HreRem.i18n("header.en.tramite"),
														        	hidden: true,
														        	renderer: Utils.rendererBooleanToSiNo,
														        	flex: 1
														        }
				        	   										         	        
				        	   									],
				        	   							dockedItems : [
				        	   									       {
				        	   											xtype: 'pagingtoolbar',
				        	   										    dock: 'bottom',
				        	   										    inputItemWidth: 50,
				        	   											displayInfo: true,
				        	   											bind: {
				        	   											       store: '{listaActivosSubida}'
				        	   											      }
				        	   											}
				        	   									      ]	
														},
														//NUEVO GRID DUPLOCADP
														{
															xtype: 'listaactivosagrupaciongrid',
															reference : 'activosagrupaciontrabajo',
															colspan:3,
															cls	: 'panel-base shadow-panel'
															
														}
														
														
													]
												},
												//GRID LISTADO TARIFAS
												{    
				                
													xtype:'fieldsettable',
													collapsible: false,
													title: HreRem.i18n('title.publicaciones.tarifas.grid'),
													defaultType: 'textfieldbase',
													colspan:3,
													
													items :
														[
													
															{
															    xtype: 'gridBase',
																cls	: 'panel-base shadow-panel',
																reference: 'gridListaTarifas',
																topBar: true,
																colspan:2,
																store: emptyStoreTarifas,
																columns: [
														  				{
															            	text	 : HreRem.i18n('header.codigo.tarifa'),
															            	dataIndex: 'codigoTarifa',
															                flex	 : 1
															            },
															            {
															            	text	 : HreRem.i18n('fieldlabel.calificacion.descripcion'),
															            	dataIndex: 'descripcion',
															                flex	 : 3
															            },
															            {
																            text: HreRem.i18n('header.unidad.medicion'),
																            dataIndex: 'unidadMedida',
																			flex	: 1
																            
																        },
															            {
															         		text	 : HreRem.i18n('header.precio.unitario'),
															         		dataIndex: 'precioUnitario',
															                flex	 : 1
															            }
															    ],
												
															    dockedItems : [
															        {
															            xtype: 'pagingtoolbar',
															            dock: 'bottom',
															            displayInfo: true,
															            store: emptyStoreTarifas
															        }
														    	],
														    onClickAdd: function (btn) {
														 		var me = this;
														 		var ventana = Ext.create("HreRem.view.trabajos.detalle.VentanaTarifasTrabajo", {
														 			carteraCodigo: me.lookupViewModel().getView().codCartera,
														 			subcarteraCodigo: me.lookupViewModel().getView().codSubcartera,
														 			tipoTrabajoCodigo: me.lookupViewModel().getView().lookupReference('tipoTrabajo').getValue(),
														 			subtipoTrabajoCodigo: me.lookupViewModel().getView().lookupReference('subtipoTrabajoCombo').getValue()
														 			});
														 		me.lookupViewModel().getView().add(ventana);
																ventana.show();
														 	},
														 	onClickRemove: function (btn) {		
														 		var me = this;
														 		if(me.selection != null){
														 			me.getStore().remove(me.selection);
														 		}else{
														 			Ext.MessageBox.alert('Error','Se debe seleccionar un registro primero');
														 		}
														 		
														 	}
														}
													]
												},

								                //PLAZOS
							                	{
								                	xtype:'fieldsettable',
													collapsible: false,
													colspan:3,
													title: HreRem.i18n('title.plazos.trabajo.nuevo'),
													defaultType: 'textfieldbase',
													items :
														[
															{
																xtype: 'datefieldbase',
																fieldLabel: HreRem.i18n('fieldlabel.fecha.concreta.trabajo'),
																reference: 'fechaConcretaTrabajo',
																minValue: $AC.getCurrentDate(),
																maxValue: null,
																colspan:1
															},
															{
																xtype: 'timefieldbase',
																colspan:2,
																reference: 'horaConcretaTrabajo',
																fieldLabel: HreRem.i18n('fieldlabel.hora.concreta.trabajo'),
																format: 'H:i',
																increment: 30
															},	
															{
																xtype: 'datefieldbase',
																reference: 'fechaTopeTrabajo',
																fieldLabel: HreRem.i18n('fieldlabel.fecha.tope.trabajo'),
																minValue: $AC.getCurrentDate(),
																maxValue: null,
																colspan:1,
																allowBlank: false
															}
														]
														
												},
												//PRESUPUESTO
							                	{
								                	xtype:'fieldsettable',
													collapsible: false,
													colspan: 3,
													title: HreRem.i18n('title.peticion.presupuesto.trabajo'),
													defaultType: 'displayfieldbase',
													items :
														[
															{ 
																xtype: 'currencyfieldbase',
																reference: 'importePresupuesto',
																fieldLabel: HreRem.i18n('fieldlabel.precio.presupuesto')
											                },
											                { 
																xtype: 'textfieldbase',
																reference: 'referenciaImportePresupuesto',
																fieldLabel: HreRem.i18n('fieldlabel.referencia.presupuesto')
											                }
														]
														
												},
												//PARTE CHECKBOX
												{    
													xtype:'fieldsettable',
													collapsible: false,
													defaultType: 'textfieldbase',
													colspan:3,
													border:0,
													
													items :
														[
															{
																xtype: 'checkboxfieldbase',
																reference:'tarifaPlana',
																boxLabel: HreRem.i18n('fieldlabel.check.tarifaplana'),
																colspan:2,
																checked: false
															},
															{
																xtype: 'checkboxfieldbase',
																reference: 'riesgosTerceros',
																boxLabel: HreRem.i18n('fieldlabel.check.riesgo.terceros'),
																colspan:1,
																checked: false
															},
															{
																xtype: 'checkboxfieldbase',
																reference: 'urgente',
																boxLabel: HreRem.i18n('fieldlabel.check.riesgo.urgente'),
																colspan:2,
																checked: false
															},
															{
																xtype: 'checkboxfieldbase',
																reference: 'siniestro',
																boxLabel: HreRem.i18n('fieldlabel.check.riesgo.siniestro'),
																colspan:1,
																checked: false
															}
														]
												
												},
												//PARTE DE DESCRIPCIÓN
												{    
				                
													xtype:'fieldsettable',
													collapsible: false,
													title: HreRem.i18n('fieldlabel.descripcion'),
													defaultType: 'textfieldbase',
													colspan:3,
													border:0,
													items :
														[
											     		   {
											                	xtype: 'textareafieldbase',
											                	bind:		'{trabajo.descripcion}',
											                	maxLength: 256
							                				}
					                					]
			                					}
											]
						           }
        				]
    			}
    	]
    	me.callParent();
    },
    
    resetWindow: function() {
    	var me = this,    	
    	form = me.down('formBase');     	

		form.setBindRecord(form.getModelInstance());
		form.reset();
		me.idProceso = null;
		me.getViewModel().set('idActivo', me.idActivo);
    	me.getViewModel().set('idAgrupacion', me.idAgrupacion);
		//PARA CARGAR EL GESTOR DEL ACTIVO AL ABRIR LA VENTANA, DENTRO DE LA FICHA DEL ACTIVO
    	me.lookupReference('gestorActivo').setValue(me.gestorActivo);
    	if(me.idActivo != null){
    		var grid = me.lookupReference('activosagrupaciontrabajo');
    		grid.getStore().load();
    		
    	}
    },
    
    cerrar: function(){
    	var me = this;
    	me.unmask();
    	me.close();
    	me.destroy();
    }


});