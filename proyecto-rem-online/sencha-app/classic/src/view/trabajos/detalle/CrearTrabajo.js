Ext.define('HreRem.view.trabajos.detalle.CrearTrabajo', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'creartrabajowindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /1.2,    
    height	: Ext.Element.getViewportHeight() > 700 ? 700 : Ext.Element.getViewportHeight() - 50,
	reference: 'creartrabajowindowref',
    controller: 'trabajodetalle',
    viewModel: {
        type: 'trabajodetalle'
    },
    
    requires: ['HreRem.model.FichaTrabajo'],
    
    idActivo: null,
    
    idAgrupacion: null,
    
    idProceso: null,
    
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
	
    initComponent: function() {
    	
    	var me = this;

    	me.setTitle(HreRem.i18n("title.peticion.trabajo"));
    	
    	me.buttonAlign = 'left';    	
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Crear', handler: 'onClickBotonCrearTrabajo'},{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'hideWindow', scope: this}];

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
										title: HreRem.i18n('title.que.se.solicita'),
										items :
											[
												{ 
										        	xtype: 'comboboxfieldbase',
										        	editable: false,
										        	fieldLabel: HreRem.i18n('fieldlabel.tipo.trabajo'),
													reference: 'tipoTrabajo',
										        	chainedStore: 'comboSubtipoTrabajo',
													chainedReference: 'subtipoTrabajoCombo',
													width: 		'100%',
													colspan: 1,
										        	bind: {
									            		store: '{comboTipoTrabajoCreaFiltered}',
									            		value: '{trabajo.tipoTrabajoCodigo}'
									            	},
						    						listeners: {
									                	select: 'onChangeChainedCombo'
									            	},
									            	allowBlank: false
										        },
												{ 
													xtype: 'comboboxfieldbase',
										        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.trabajo'),
										        	reference: 'subtipoTrabajoCombo',
										        	colspan: 2,
										        	editable: false,
										        	width: 		'100%',
										        	bind: {
									            		store: '{comboSubtipoTrabajo}',
									            		value: '{trabajo.subtipoTrabajoCodigo}',
									            		disabled: '{!trabajo.tipoTrabajoCodigo}'
									            	},
						    						listeners: {
									                	select: 'onChangeSubtipoTrabajoCombo'
									            	},
													colspan: 2,
													allowBlank: false
										        },
										        {
								                	xtype: 'textareafieldbase',
								                	fieldLabel: HreRem.i18n('fieldlabel.descripcion'),
								                	width: 		'100%',
								                	colspan: 3,
								                	bind:		'{trabajo.descripcion}',
								                	maxLength: 256
						                		},
										        {
								                	xtype: 'label',
								                	reference: 'textAdvertenciaCrearTrabajo',
								                	style: 'color: red; font-weight: bolder;',
								                	width: 		'100%'
						                		}

											]
						           },
						           {
						              	xtype: 'fieldset',
						        	    title: HreRem.i18n('title.subirfichero'),
						        	    reference: 'fieldSetSubirFichero',
						        	    cls	: 'panel-base shadow-panel',
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
						        	   			{
						        	   				xtype:'fieldset',					
						        	   				title: HreRem.i18n('title.activos'),
						        	   				reference: 'fieldsetListaActivosSubida',
						        	   				layout: {
						        	   							type: 'vbox',
						        	   							align: 'stretch'
						        	   				},
						        	   				items : [
						        	   						{										           
						        	   							html: HreRem.i18n("txt.aviso.genera.trabajo.independiente"),
						        	   							cls: 'texto-info',
						        	   							margin: '10 0 0 0'
						        	   						},
						        	   						{									    
						        	   							xtype: 'gridBase',
						        	   							cls: "",
						        	   							margin: '20 0 20 0',
						        	   							reference: 'listaActivosSubidaRef',
						        	   							loadAfterBind: false,
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
						        	   									}
						        	   										         	        
						        	   									],
						        	   							dockedItems : [
						        	   									       {
						        	   											xtype: 'pagingtoolbar',
						        	   										    dock: 'bottom',
						        	   											displayInfo: true,
						        	   											bind: {
						        	   											       store: '{listaActivosSubida}'
						        	   											      }
						        	   											}
						        	   									      ]						           
						        	   						},
						        	   						{
		        	   											xtype: 'checkboxfieldbase',
		        	   											reference: 'checkEnglobaTodosActivosRef',
						        	   							margin: '20 0 10 0',
						        	   							boxLabel: HreRem.i18n('title.ejecutar.trabajo.por.agrupacion'),
						        	   							bind: '{trabajo.esSolicitudConjunta}'
						        	   						},
						        	   						{
						        	   							html: HreRem.i18n("txt.condiciones.trabajo.agrupacion.title"),
						        	   							cls: 'texto-info'
						        	   						},
						        	   						{
						        	   							html: HreRem.i18n("txt.condiciones.trabajo.agrupacion.uno"),
						        	   							cls: 'texto-info'
						        	   						},
						        	   						{
						        	   							html: HreRem.i18n("txt.condiciones.trabajo.agrupacion.dos"),
						        	   							cls: 'texto-info'
						        	   						},
						        	   						{
						        	   							html: HreRem.i18n("txt.condiciones.trabajo.agrupacion.tres"),
						        	   							cls: 'texto-info'
						        	   						},
						        	   						{
						        	   							html: HreRem.i18n("txt.condiciones.trabajo.agrupacion.cuatro"),
						        	   							cls: 'texto-info',
						        	   							margin: '0 0 20 0'
						        	   						}
						        	   						    
						        	   						]
						        	},
						           {
						           		xtype:'fieldset',					
										title: HreRem.i18n('title.activos'),
										reference: 'fieldsetListaActivos',
										layout: {
											type: 'vbox',
											align: 'stretch'
										},
										items : [
													{										           
										           		html: HreRem.i18n("txt.aviso.genera.trabajo.independiente"),
										           		cls: 'texto-info',
										           		margin: '10 0 0 0'
										           	},
										           	{									    
											           	
													    xtype: 'gridBase',
													    cls: "",
													    margin: '20 0 20 0',
													    reference: 'listaActivosRef',
													    loadAfterBind: false,
														bind: {
															store: '{activosAgrupacion}'														
														},
														/*
														features: [{
													            id: 'summary',
													            ftype: 'summary',
													            hideGroupedHeader: true,
													            enableGroupingMenu: false,
													            dock: 'bottom'
														}],*/
														
														columns: [
														   
														    {
													            dataIndex: 'numActivo',
													            text: HreRem.i18n('header.numero.activo.haya'),
													            flex: 1										
													        },
													        {
													            dataIndex: 'tipoActivoDescripcion',
													            text: HreRem.i18n('header.tipo'),
													            flex: 1
													        },
													        {
													            dataIndex: 'subtipoActivoDescripcion',
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
													        }
													         	        
													    ],
													    dockedItems : [
													        {
													            xtype: 'pagingtoolbar',
													            dock: 'bottom',
													            displayInfo: true,
													            bind: {
													                store: '{activosAgrupacion}'
													            }
													        }
													    ]						           
										           },
										           {
										           		xtype: 'checkboxfieldbase',
										           		reference: 'checkEnglobaTodosActivosAgrRef',
										           		margin: '20 0 10 0',
														boxLabel: HreRem.i18n('title.ejecutar.trabajo.por.agrupacion'),
														bind: '{trabajo.esSolicitudConjunta}'
										           },
										           {
										           		html: HreRem.i18n("txt.condiciones.trabajo.agrupacion.title"),
										           		cls: 'texto-info'
										           },
										           {
										           		html: HreRem.i18n("txt.condiciones.trabajo.agrupacion.uno"),
										           		cls: 'texto-info'
										           },
										           {
										           		html: HreRem.i18n("txt.condiciones.trabajo.agrupacion.dos"),
										           		cls: 'texto-info'
										           },
										           {
										           		html: HreRem.i18n("txt.condiciones.trabajo.agrupacion.tres"),
										           		cls: 'texto-info'
										           },
										           {
										           		html: HreRem.i18n("txt.condiciones.trabajo.agrupacion.cuatro"),
										           		cls: 'texto-info',
										           		margin: '0 0 20 0'
										           }
										           
							           ]
						           },
				           
						           {    
						                
										xtype:'fieldset',
										collapsible: false,
										layout: {
									        type: 'hbox',
									        align: 'stretch'
										},
										 defaults:{
									        xtype: 'fieldset',
									        flex: 1
									        
									    }, 
										title: HreRem.i18n('title.momento.realizacion'),
									    collapsible: true,
									    collapsed: false,
									    reference: 'fieldSetMomentoRealizacionRef',
										items :
											[
												{	
													defaultType: 'textfieldbase',
													items: [
													
															
															{
																xtype: 'checkboxfieldbase',
																boxLabel: HreRem.i18n('title.fecha.concreta'),
																checked: false,
																reference: 'checkFechaConcreta',
																listeners: {
																	change: function(check, checked) {
																		var form = check.up("form");
																		if(checked) {
																			var me =this;
																			form.down("[reference=checkFechaTope]").setValue(false);
																			form.down("[reference=checkFechaContinuado]").setValue(false);
																		} else {
																			Ext.Array.each(check.up("fieldset").query("field"), function(field, index) {
																				field.setValue("");
																			});
																		}
																	}
																	
																}
															},
															{
																xtype: 'datefieldbase',
																fieldLabel: HreRem.i18n('fieldlabel.fecha.debe.realizarse.trabajo'),
																minValue: $AC.getCurrentDate(),
																maxValue: null,
																bind: {
																		value:  '{trabajo.fechaConcreta}',
																		disabled: '{!checkFechaConcreta.checked}'
																},
																allowBlank: false
															},
															{
																xtype: 'timefieldbase',
																plugins		: {ptype: 'UxReadOnlyEditField'},
																labelWidth	: 150,
																fieldLabel: HreRem.i18n('fieldlabel.hora.debe.realizarse.trabajo'),
																bind: {
																	value: '{trabajo.horaConcreta}',																
																	disabled: '{!checkFechaConcreta.checked}'
																},
																format: 'H:i',
																increment: 30,
																allowBlank: false
															}										
													
													]
												},
												{
													defaultType: 'textfieldbase',
													items: [									
															
															{
																xtype: 'checkboxfieldbase',
																boxLabel:  HreRem.i18n('title.fecha.tope'),												
																checked: false,
																reference: 'checkFechaTope',
																listeners: {
																	change: function(check, checked) {																		
																		var form = check.up("form");
																		if(checked) {
																			var me =this;
																			form.down("[reference=checkFechaConcreta]").setValue(false);
																			form.down("[reference=checkFechaContinuado]").setValue(false);
																		} else {
																			Ext.Array.each(check.up("fieldset").query("field"), function(field, index) {
																				field.setValue("");
																			});
																		}
																	}
																	
																}
															},	
															{
																xtype: 'datefieldbase',
																reference: 'datefieldFechaTope',
																minValue: $AC.getCurrentDate(),
																maxValue: null,
																fieldLabel: HreRem.i18n('fieldlabel.fecha.debe.finalizar.trabajo'),
																bind: {
																	value: '{trabajo.fechaTope}',																
																	disabled: '{!checkFechaTope.checked}'
																},
																allowBlank: false,
																listeners: {
																	select: function(datefield, newValue) {
																		var form = datefield.up("form");
																		form.down("[reference=checkboxUrgente]").setValue(false);
																		form.down("[reference=checkboxRiesgoInminente]").setValue(false);
																	}
																}
																
															},
															{
																xtype: 'checkboxfieldbase',
																reference: 'checkboxUrgente',
																fieldLabel: HreRem.i18n('fieldlabel.urgente.respuesta.tres.horas'),
																bind: {
																	value: '{trabajo.urgente}',																
																	disabled: '{!checkFechaTope.checked}'																
																},
																allowBlank: false,
																listeners: {
																	change: function(check, checked) {
																		var form = check.up("form");
																		if(checked) {
																			var fechaTope = $AC.getCurrentDate();
																			form.down("[reference=checkboxRiesgoInminente]").setValue(false);
																			form.down("[reference=datefieldFechaTope]").setValue(fechaTope);																			
																		}
																	}
																}
															},
															{
																xtype: 'checkboxfieldbase',
																reference: 'checkboxRiesgoInminente',
																fieldLabel: HreRem.i18n('fieldlabel.riesgo.inminente.terceros'),
																bind: {
																	value: '{trabajo.riesgoInminenteTerceros}',																
																	disabled: '{!checkFechaTope.checked}'	
																},
																allowBlank: false,
																listeners: {
																	change: function(check, checked) {
																		var form = check.up("form");
																		if(checked) {
																			var fechaTope =  Ext.Date.add($AC.getCurrentDate(), Ext.Date.DAY, 2);
																			form.down("[reference=checkboxUrgente]").setValue(false);
																			form.down("[reference=datefieldFechaTope]").setValue(fechaTope);																			
																		}
																	}
																}
															}
															
													
													]	
												},
												{
													defaultType: 'textfieldbase',
													disabled: true,
													//title: HreRem.i18n('title.trabajo.continuado'),
													items: [									
															
															{
																xtype: 'checkboxfieldbase',
																boxLabel:  HreRem.i18n('title.trabajo.continuado'),
																checked: false,
																reference: 'checkFechaContinuado',
																listeners: {
																	change: function(check, checked) {
																		var form = check.up("form");
																		if(checked) {
																			var me =this;
																			form.down("[reference=checkFechaConcreta]").setValue(false);
																			form.down("[reference=checkFechaTope]").setValue(false);
																		} else {
																			Ext.Array.each(check.up("fieldset").query("field"), function(field, index) {
																				field.setValue("");
																			});
																		}
																	}
																	
																}
															},		
															{
																xtype: 'datefieldbase',
																fieldLabel: HreRem.i18n('fieldlabel.fecha.inicio'),
																minValue: $AC.getCurrentDate(),
																maxValue: null,
																bind: {
																	value: '{trabajo.fechaInicio}',																
																	disabled: '{!checkFechaContinuado.checked}'	
																},
																allowBlank: false
															},
															{
																xtype: 'datefieldbase',
																fieldLabel: HreRem.i18n('fieldlabel.fecha.fin'),
																minValue: $AC.getCurrentDate(),
																maxValue: null,
																bind: {
																	value: '{trabajo.fechaFin}',																
																	disabled: '{!checkFechaContinuado.checked}'		
																},
																allowBlank: false
															},															
															{
											                	xtype: 'textareafieldbase',
											                	fieldLabel: HreRem.i18n('fieldlabel.observaciones'),
											                	bind: {
																	value: '{trabajo.continuoObservaciones}',																
																	disabled: '{!checkFechaContinuado.checked}'		
																},
											                	allowBlank: false,
											                	width: '100%', 
											                	maxLength: 256
									                		}

													
													]
												}
				
											]               
						
						           },						           
						           {     
										xtype:'fieldsettable',
										collapsible: false,
										title: HreRem.i18n('title.trabajo.requerido.tercero'),
										defaultType: 'textfieldbase',				
										items : [																								
												{
													fieldLabel: HreRem.i18n('fieldlabel.requirente'),
													bind:'{trabajo.terceroNombre}',
													colspan: 2,
													width: 		'100%'
												},
												{
													fieldLabel: HreRem.i18n('fieldlabel.persona.contacto'),
													bind:'{trabajo.terceroContacto}',
													width: 		'100%'
												},
												{
													fieldLabel: HreRem.i18n('fieldlabel.email'),
													bind:'{trabajo.terceroEmail}',
													vtype: 'email',
													width: 		'100%'
												},
												{
													fieldLabel: HreRem.i18n('fieldlabel.telefono1'),
													bind:'{trabajo.terceroTel1}',
													vtype: 'telefono',
													width: 		'100%'
												},
												{
													fieldLabel: HreRem.i18n('fieldlabel.telefono2'),
													bind:'{trabajo.terceroTel2}',
													vtype: 'telefono',
													width: 		'100%'
												},
												{ 
								                	xtype: 'textareafieldbase',
								                	width: 		'100%',
								                	colspan: 2,
								                	fieldLabel: HreRem.i18n('fieldlabel.direccion'),
								                	bind:		'{trabajo.terceroDireccion}'
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

		me.getViewModel().set('idActivo', me.idActivo);
		    	
    	me.down("[reference=checkFechaConcreta]").setValue(false);
    	me.down("[reference=checkFechaTope]").setValue(false);
    	me.down("[reference=checkFechaContinuado]").setValue(false);
    	
    	me.lookupReference('listaActivosSubidaRef').getStore().getProxy().extraParams = {'idProceso':null};
    	me.lookupReference('listaActivosSubidaRef').getStore().loadPage(1);

    	if(!Ext.isEmpty(me.idAgrupacion)) {
    		me.getViewModel().get("activosAgrupacion").load();
    		me.down('[reference=fieldsetListaActivos]').setVisible(true);
     	} else {
     		me.down('[reference=fieldsetListaActivos]').setVisible(false);
     		me.down('[reference=fieldsetListaActivosSubida]').setVisible(false);
     	}
     	
    	if(Ext.isEmpty(me.idAgrupacion) && Ext.isEmpty(me.idActivo)){
    		me.down('[reference=filefieldActivosRef]').allowBlank=false;
     		me.down('[reference=fieldSetSubirFichero]').setVisible(true);
     		me.down('[reference=fieldsetListaActivosSubida]').setVisible(true);
     	} else {
     		me.down('[reference=filefieldActivosRef]').allowBlank=true;
     		me.down('[reference=fieldSetSubirFichero]').setVisible(false);
     		me.down('[reference=fieldsetListaActivosSubida]').setVisible(false);
     	}
    	
    	if(!Ext.isEmpty(me.down("[reference=textAdvertenciaCrearTrabajo]"))) {
    		me.down("[reference=textAdvertenciaCrearTrabajo]").setText("");	
    	}
    }


});