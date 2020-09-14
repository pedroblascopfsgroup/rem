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
    requires: ['HreRem.model.FichaTrabajo','HreRem.view.trabajos.detalle.ActivosAgrupacionTrabajoList','HreRem.view.trabajos.detalle.VentanaTarifasTrabajo'],
   
    

    
	listeners: {

		boxready: function(window) {
			
			var me = this;
			
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
	
	    
    
    idActivo: null,
    
    idAgrupacion: null,
    
    idProceso: null,
    
    codCartera: null,
    
    codSubcartera: null,
    
    logadoGestorMantenimiento: null,
    
    gestorActivo: null,
	
    initComponent: function() {
    	
    	var me = this;

    	me.setTitle(HreRem.i18n("title.peticion.trabajo.nuevo"));
    	
    	me.buttonAlign = 'left'; 
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Crear', handler: 'onClickBotonCrearPeticionTrabajo'},{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'hideWindowCrearPeticionTrabajo'}];

    	me.items = [
    				{
	    				xtype: 'formBase', 
	    				collapsed: false,
	   			 		scrollable	: 'y',
	    				cls:'',	    				
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
												
												items :
													[
													 {
													        xtype: 'textfieldbase',
													        readOnly: true,
													        fieldLabel: HreRem.i18n('fieldlabel.gestor.logado.nuevo.trabajo'),
													        reference:'gestorActivo',
															colspan: 3,
															padding:'2 2 2 2',
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
											            	allowBlank: false
												        },
												        { 
															xtype: 'comboboxfieldbase',
												        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.trabajo'),
												        	reference: 'subtipoTrabajoCombo',
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
											                		select: 'onChangeSubtipoTrabajoCombo'
											            		},
															allowBlank: false
												        },
												        { 
															xtype: 'comboboxfieldbase',
												        	fieldLabel:  HreRem.i18n('fieldlabel.proveedor.trabajo'),
												        	colspan: 3,
												        	editable: false,
												        	bind: 
												        		{
												        		store: '{comboApiPrimario}'
//											            		store: '{comboGestorActivoResponsable}'
//											            		value: '{fieldlabel.proveedor.trabajo}'
											            		},
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
													        	bind : {
													        		store: '{comboAprobacionComite}'
													        	},
																allowBlank: false
										        			},

															{
																xtype: 'datefieldbase',
																fieldLabel: HreRem.i18n('fieldlabel.fecha.resolucion.comite.trabajo'),
																minValue: $AC.getCurrentDate(),
																maxValue: null,
																reference: 'fechaResolComite',
																colspan: 3,
																disabled: true,
																allowBlank: false
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
													items :
														[
													        {
													            xtype : 'numberfieldbase',
													            fieldLabel : HreRem.i18n('fieldlabel.id.tarea.trabajo'),
													            allowBlank: false,
													            maxLength:10
				        									}
													]
												},
												//datos de un solo activo;
												{
													xtype:'fieldsettable',
													reference: 'fieldActivo',
													collapsible: false,
//													hidden: '{mostrarVentanaTrabajoGridActivo}',
													title: HreRem.i18n('title.tarifas.activo.detalle'),
													defaultType: 'textfieldbase',
													colspan:3,
													items :[
														{
													        xtype: 'comboboxfieldbase',
													        readOnly: true,
													        fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
													        reference:'cartera',
															colspan: 1,
															padding:'2 2 2 2',
													        bind:{
													        	store: '{comboEntidadPropietaria}',
													            value: me.codCartera
												            },
												            displayField: 'descripcion',
								    						valueField: 'codigo'
												       },
												       {
													        xtype: 'textfieldbase',
													        readOnly: true,
													        fieldLabel: HreRem.i18n('header.descripcion'),
													        reference:'descripcionActivo',
															colspan: 2,
															padding:'2 2 2 2'
												       },
												       {
													        xtype: 'comboboxfieldbase',
													        readOnly: true,
													        fieldLabel: HreRem.i18n('header.subcartera'),
													        reference:'subCartera',
															colspan: 1,
															padding:'2 2 2 2',
													        bind:{
													        	store: '{comboSubentidadPropietaria}',
											            		value: me.codSubcartera
												            },
												            displayField: 'descripcion',
								    						valueField: 'codigo'
												       },
												       {
													        xtype: 'textfieldbase',
													        readOnly: true,
//													        fieldLabel: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.idActivo'),
													        fieldLabel: "Numero Activo",
													        reference:'numHaya',
															colspan: 2,
															padding:'2 2 2 2'
												       },
												       {
													        xtype: 'textfieldbase',
													        readOnly: true,
//													        fieldLabel: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.idActivo'),
													        fieldLabel: "Tipo Activo",
													        reference:'tipoActivo',
															colspan: 1,
															padding:'2 2 2 2'
												       },
												       {
													        xtype: 'textfieldbase',
													        readOnly: true,
//													        fieldLabel: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.idActivo'),
													        fieldLabel: "Subtipo Activo",
													        reference:'subTipoActivo',
															colspan: 2,
															padding:'2 2 2 2'
												       },
													]
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
								        	   				url: $AC.getRemoteUrl('process/subeListaActivos'),		
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
															colspan: 3
														},
										    			{
														    xtype		: 'gridBase',
															cls	: 'panel-base shadow-panel',
															reference: 'listaActivosSubidaRef',
															colspan:2,
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
																bind: {
																	store: '{comboGridTarifa}'
																},
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
															            bind: 
															            {
															                //store: '{storeAgrupacionesActivo}'
															            }
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
																minValue: $AC.getCurrentDate(),
																maxValue: null,
																colspan:1,
																allowBlank: false
															},
															{
																xtype: 'timefieldbase',
																colspan:2,
																fieldLabel: HreRem.i18n('fieldlabel.hora.concreta.trabajo'),
																format: 'H:i',
																increment: 30,
																allowBlank: false
															},	
															{
																xtype: 'datefieldbase',
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
													defaultType: 'textfieldbase',
													items :
														[
															{ 
																xtype: 'currencyfieldbase',
																fieldLabel: HreRem.i18n('fieldlabel.precio.presupuesto')
											                },
											                { 
																xtype: 'currencyfieldbase',
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
																boxLabel: HreRem.i18n('fieldlabel.check.tarifaplana'),
																colspan:2,
																checked: false
															},
															{
																xtype: 'checkboxfieldbase',
																boxLabel: HreRem.i18n('fieldlabel.check.riesgo.terceros'),
																colspan:1,
																checked: false
															},
															{
																xtype: 'checkboxfieldbase',
																boxLabel: HreRem.i18n('fieldlabel.check.riesgo.urgente'),
																colspan:2,
																checked: false
															},
															{
																xtype: 'checkboxfieldbase',
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
    		var url = $AC.getRemoteUrl('activo/getActivoParaCrearPeticionTrabajo');
		    Ext.Ajax.request({
			  url:url,
			  params:  {idActivo : me.idActivo},
			  success: function(response,opts){
				  var separador;
				  var res = response.responseText.replace(/[{}"]/g,"");
				  res = res.replace(/data:/,"");
				  res = res.split(',');
				  for(var i = 0; i < res.length; i++) {
					separador = null;  
					if(res[i].includes('numActivo')){
						separador = res[i].split(':');
						me.lookupReference('numHaya').setValue(separador[1]);
					}else{
						if(res[i].includes('descripcion')){
							separador = res[i].split(':');
							me.lookupReference('descripcionActivo').setValue(separador[1]);
						}else{
							if(res[i].includes('subtipoActivo:')){
								separador = res[i].split(':');
								me.lookupReference('subTipoActivo').setValue(separador[1]);
							}else{
								if(res[i].includes('tipoActivo:')){
									separador = res[i].split(':');
									me.lookupReference('tipoActivo').setValue(separador[1]);
								}
							}
						}
					}
				}
			  }
		    });
    	}else{
    		me.lookupReference('numHaya').setValue(null);
    		me.lookupReference('descripcionActivo').setValue(null);
    		me.lookupReference('subTipoActivo').setValue(null);
    		me.lookupReference('tipoActivo').setValue(null);
    	}
    },
    
    cerrar: function(){
    	var me = this;
    	me.close();
    	me.destroy();
    }


});